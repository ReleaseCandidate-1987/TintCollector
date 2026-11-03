#include "colormodel.h"
#include "database.h"
#include "notification.h"
#include "palettemodel.h"

#include <QSortFilterProxyModel>
#include <QTimer>
ColorModel::ColorModel(QObject *parent)
    : Model{parent}
{
    m_roles.insert(Qt::UserRole + 3, "colorCode");
    m_roles.insert(Qt::UserRole + 4, "paletteID");
    m_roles.insert(Qt::UserRole + 5, "category");

    m_paletteModel = qobject_cast<PaletteModel *>(parent);
    createColorModels();

    if (m_paletteModel) {
        connect(m_paletteModel, &Model::rowsRemoved, this, [this] {
            if (m_paletteID >= 0 && !m_paletteIndex.isValid())
                loadColors(-1);
        });

        connect(m_paletteModel, &Model::modelReset, this, [this] {
            loadColors(m_paletteID);
        });
    }
}

void ColorModel::createColorModels()
{
    for (int category = 0; category < m_categoryNames.size(); ++category) {
        auto *model = new QSortFilterProxyModel(this);
        model->setSourceModel(this);
        model->setFilterRole(Qt::UserRole + 5);
        model->setFilterRegularExpression(QStringLiteral("^%1$").arg(category));
        model->setDynamicSortFilter(true);

        m_colorModels.insert(m_categoryNames.at(category), QVariant::fromValue(model));
    }
}


/*!
    Lädt die ausgewählte Palette einzeln aus der Datenbank.
    Ein Palettenwechsel beendet vorherige Ladevorgänge.
*/
void ColorModel::loadColors(qint64 paletteID)
{
    if (paletteID == m_paletteID && m_paletteIndex.isValid())
        return;

    QModelIndex paletteIndex;

    if (m_paletteModel && paletteID >= 0) {
        const auto matches = m_paletteModel->match(
            m_paletteModel->index(0, 0),
            Qt::UserRole + 1,
            paletteID,
            1,
            Qt::MatchExactly
            );

        paletteIndex = matches.value(0);
    }

    m_paletteIndex = paletteIndex;
    m_paletteID = paletteIndex.isValid() ? paletteID : -1;

    loadColors(QVariantList{});

    if (m_paletteID < 0)
        return;

    const quint64 generation = m_loadGeneration;
    const qint64 requestedPaletteID = m_paletteID;

    QTimer::singleShot(10, this, [this, requestedPaletteID, generation] {
        loadColorBatch(requestedPaletteID, 0, generation);
    });
}

/*!
    Lädt genau eine Farbe aus der Datenbank.
    Bereits vorhandene Farben werden anhand ihrer _id übersprungen.
*/
void ColorModel::loadColorBatch(qint64 paletteID, int offset, quint64 generation)
{
    if (generation != m_loadGeneration || paletteID != m_paletteID)
        return;

    constexpr int batchSize = 1;

    const QVariantList items = Database::loadColors(paletteID, batchSize, offset);

    if (items.isEmpty())
        return;

    const QVariant &color = items.first();
    const qint64 colorID = color.toMap().value("_id").toLongLong();

    bool alreadyLoaded = false;

    for (const auto &existingColor : std::as_const(m_items)) {
        if (existingColor.toMap().value("_id").toLongLong() == colorID) {
            alreadyLoaded = true;
            break;
        }
    }

    if (!alreadyLoaded) {
        const int row = m_items.size();

        beginInsertRows({}, row, row);
        m_items.append(color);
        endInsertRows();

        emit countChanged();
    }

    QTimer::singleShot(10, this, [this, paletteID, offset, generation] {
        loadColorBatch(paletteID, offset + 1, generation);
    });
}

/*!
    Setzt den Modellinhalt vollständig zurück.
    Bricht zugleich alle noch ausstehenden Ladepakete ab.
*/
void ColorModel::loadColors(const QVariantList &items)
{
    ++m_loadGeneration;

    beginResetModel();
    m_items = items;
    endResetModel();

    emit countChanged();
}


void ColorModel::addColor(qint64 paletteID, const QString &name, const QString &colorCode, int category)
{
    if ( count() >= m_maxColorCount )
        return;

    if (!m_paletteIndex.isValid() || paletteID != m_paletteID || category < 0 || category > 4)
        return;

    qint64 _id = Database::addColor(paletteID, name, colorCode, category);
    if (_id < 0)
        return;

    QVariantMap color;
    color.insert("_id", _id);
    color.insert("name", name);
    color.insert("colorCode", colorCode);
    color.insert("paletteID", paletteID);
    color.insert("category", category);

    const QPersistentModelIndex paletteIndex = m_paletteIndex;

    append(color);
    updateColorCount(paletteIndex, 1);
    Notification::instance()->setMessage("Die Farbe wurde erfolgreich hinzugefügt.", Notification::Success);
}

void ColorModel::removeColor(int index)
{
    if (index < 0 || index >= m_items.size())
        return;

    const auto item = get(index);

    if (!Database::removeColor(item.value("_id").toLongLong()))
        return;

    const QPersistentModelIndex paletteIndex = m_paletteIndex;

    remove(index);
    updateColorCount(paletteIndex, -1);
    Notification::instance()->setMessage("Die Farbe wurde entfernt.", Notification::Information);
}

void ColorModel::renameColor(int index, const QString &newName)
{
    if (index < 0 || index >= m_items.size())
        return;

    const auto item = get(index);

    if ( item.value("name").toString() == newName )
        return;

    if (!Database::renameColor( item.value("_id").toLongLong(), newName ))
        return;

    rename(index, newName);
    Notification::instance()->setMessage("Der Name der Farbe wurde geändert.", Notification::Information);
}

void ColorModel::changeColor(int index, const QString &newColorCode)
{
    if (index < 0 || index >= m_items.size())
        return;

    const auto item = get(index);

    if ( item.value("colorCode").toString().toLower() == newColorCode.toLower() ){
        Notification::instance()->setMessage("Die Farbe wurde nicht geändert.", Notification::Information);
        return;
    }

    if (!Database::changeColor( item.value("_id").toLongLong(), newColorCode ))
        return;

    setProperty(index, "colorCode", newColorCode);

    Notification::instance()->setMessage("Die Farbe wurde erfolgreich geändert.", Notification::Information);
}


bool ColorModel::moveColor(int sourceCategory, int fromIndex,
                           int targetCategory, int toIndex)
{
    if (!m_paletteIndex.isValid() ||
        sourceCategory < 0 || sourceCategory >= m_categoryNames.size() ||
        targetCategory < 0 || targetCategory >= m_categoryNames.size())
        return false;

    auto *sourceProxy = qvariant_cast<QSortFilterProxyModel *>(
        m_colorModels.value(m_categoryNames.at(sourceCategory)));

    auto *targetProxy = qvariant_cast<QSortFilterProxyModel *>(
        m_colorModels.value(m_categoryNames.at(targetCategory)));

    if (!sourceProxy || !targetProxy ||
        fromIndex < 0 || fromIndex >= sourceProxy->rowCount() ||
        toIndex < 0 || toIndex > targetProxy->rowCount())
        return false;

    const bool sameCategory = sourceCategory == targetCategory;

    if (sameCategory) {
        toIndex = qMin(toIndex, targetProxy->rowCount() - 1);

        if (fromIndex == toIndex)
            return false;
    }

    const QModelIndex sourceIndex = sourceProxy->mapToSource(
        sourceProxy->index(fromIndex, 0));

    if (!sourceIndex.isValid())
        return false;

    const qint64 colorID = sourceIndex.data(Qt::UserRole + 1).toLongLong();
    const int sourceRow = sourceIndex.row();

    QList<qint64> sourceColorIDs;

    if (!sameCategory) {
        sourceColorIDs = categoryColorIDs(sourceProxy);
        sourceColorIDs.removeAt(fromIndex);
    }

    QList<qint64> targetColorIDs = categoryColorIDs(targetProxy);

    if (sameCategory)
        targetColorIDs.move(fromIndex, toIndex);
    else
        targetColorIDs.insert(toIndex, colorID);

    int targetRow = m_items.size();

    if (toIndex < targetProxy->rowCount()) {
        targetRow = targetProxy->mapToSource(targetProxy->index(toIndex, 0)).row();
    } else if (targetProxy->rowCount() > 0) {
        targetRow = targetProxy->mapToSource(
                                   targetProxy->index(targetProxy->rowCount() - 1, 0)).row() + 1;
    } else {
        for (int row = 0; row < m_items.size(); ++row) {
            if (m_items.at(row).toMap().value("category").toInt() > targetCategory) {
                targetRow = row;
                break;
            }
        }
    }

    if (!Database::saveColorOrder(m_paletteID, colorID, targetCategory,
                                  sourceColorIDs, targetColorIDs))
        return false;

    applyColorMove(sourceRow, targetRow, targetCategory);

    m_paletteModel->setProperty(m_paletteIndex.row(), "previewColors", colorCodes().mid(0, 5));

    return true;
}

void ColorModel::clearColors(qint64 paletteID)
{
    if ( !m_paletteIndex.isValid() || paletteID != m_paletteID || count() == 0 )
        return;

    if ( !Database::clearColors(paletteID) )
        return;

    const int removedCount = count();

    loadColors(QVariantList{});

    m_paletteModel->setProperty(m_paletteIndex.row(), "colorCount", 0);
    m_paletteModel->setProperty(m_paletteIndex.row(), "previewColors", QVariantList{});
    m_paletteModel->decrementTotalColorCount(removedCount);

    Notification::instance()->setMessage(
        "Alle Farben wurden erfolgreich entfernt.",
        Notification::Success
        );

}

void ColorModel::updateColorCount(const QPersistentModelIndex &paletteIndex, int change)
{
    if (!paletteIndex.isValid())
        return;

    const int colorCount = paletteIndex.data(Qt::UserRole + 3).toInt();
    m_paletteModel->setProperty(paletteIndex.row(), "colorCount", colorCount + change);
    if ( colorCount + change <= 5)
        m_paletteModel->setProperty(paletteIndex.row(), "previewColors", colorCodes());

    if (change > 0)
        m_paletteModel->incrementTotalColorCount();
    else
        m_paletteModel->decrementTotalColorCount();
}


// NEU: Farb-IDs in der Reihenfolge einer gefilterten Kategorie.
QList<qint64> ColorModel::categoryColorIDs(const QSortFilterProxyModel *model) const
{
    QList<qint64> colorIDs;
    colorIDs.reserve(model->rowCount());

    for (int row = 0; row < model->rowCount(); ++row)
        colorIDs.append(model->index(row, 0).data(Qt::UserRole + 1).toLongLong());

    return colorIDs;
}

// NEU: Unterscheidet zwischen Sortierung und Kategorienwechsel.
void ColorModel::applyColorMove(int sourceRow, int targetRow, int targetCategory)
{
    const QVariantMap currentColor = m_items.at(sourceRow).toMap();

    if (currentColor.value("category").toInt() == targetCategory) {
        const int destinationChild = targetRow + (sourceRow < targetRow ? 1 : 0);

        if (!beginMoveRows({}, sourceRow, sourceRow, {}, destinationChild)) {
            loadColors(Database::loadColors(m_paletteID));
            return;
        }

        m_items.move(sourceRow, targetRow);
        endMoveRows();
        return;
    }

    // Kategorienwechsel: Aus der alten Kategorie entfernen.
    beginRemoveRows({}, sourceRow, sourceRow);
    m_items.removeAt(sourceRow);
    endRemoveRows();

    if (sourceRow < targetRow)
        --targetRow;

    // In die neue Kategorie einfügen.
    QVariantMap movedColor = currentColor;
    movedColor["category"] = targetCategory;

    beginInsertRows({}, targetRow, targetRow);
    m_items.insert(targetRow, movedColor);
    endInsertRows();
}

QStringList ColorModel::categoryNames() const { return m_categoryNames; }

int ColorModel::maxColorCount() const { return m_maxColorCount; }
QStringList ColorModel::colorCodes() const
{
    QStringList list;
    list.reserve(m_items.size());

    for (int i = 0; i < m_items.size(); ++i)
        list.append(get(i).value("colorCode").toString());

    return list;
}

QVariantMap ColorModel::colorModels() const { return m_colorModels; }