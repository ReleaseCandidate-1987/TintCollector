#include "palettemodel.h"
#include "database.h"
#include "notification.h"

#include <QJsonDocument>
#include <QVariant>

PaletteModel::PaletteModel(QObject *parent)
    : Model{parent}
{
    m_roles.insert(Qt::UserRole + 3, "colorCount");
    m_roles.insert(Qt::UserRole + 4, "previewColors");

    loadPalettes();
}

void PaletteModel::addPalette(const QString &name)
{
    qint64 _id = Database::addPalette(name);
    if (_id < 0)
        return;

    QVariantMap palette;
    palette.insert("_id", _id);
    palette.insert("name", name);
    palette.insert("colorCount", 0);
    palette.insert("previewColors", {});

    append(palette);

    Notification::instance()->setMessage("Die Palette wurde erfolgreich hinzugefügt.", Notification::Success);
}

void PaletteModel::removePalette(int index)
{
    if (index < 0 || index >= m_items.size())
        return;

    const auto item = get(index);

    if (!Database::removePalette(item.value("_id").toLongLong()))
        return;

    const int colorCount = item.value("colorCount").toInt();
    m_totalColorCount -= colorCount;

    remove(index);

    if (colorCount > 0)
        emit totalColorCountChanged();

    Notification::instance()->setMessage("Die Palette wurde erfolgreich entfernt.", Notification::Information);
}

void PaletteModel::renamePalette(int index, const QString &newName)
{
    if (index < 0 || index >= m_items.size())
        return;

    const auto item = get(index);

    if (!Database::renamePalette(item.value("_id").toLongLong(), newName))
        return;

    rename(index, newName);

    Notification::instance()->setMessage("Die Palette wurde erfolgreich umbenannt.", Notification::Information);
}

void PaletteModel::loadPalettes()
{
    auto rows = Database::loadPalettes();

    beginResetModel();

    m_totalColorCount = 0;

    for (auto &row : rows) {
        QVariantMap palette = row.toMap();

        palette["previewColors"] = QJsonDocument::fromJson(
                palette.value("previewColors").toByteArray()
            ).toVariant().toList();

        m_totalColorCount += palette.value("colorCount").toInt();

        row = palette;
    }

    m_items = rows;
    endResetModel();

    emit countChanged();
    emit totalColorCountChanged();
}

int PaletteModel::totalColorCount() const
{
    return m_totalColorCount;
}

void PaletteModel::incrementTotalColorCount()
{
    ++m_totalColorCount;
    emit totalColorCountChanged();
}

void PaletteModel::decrementTotalColorCount()
{
    m_totalColorCount = qMax(0, m_totalColorCount - 1);
    emit totalColorCountChanged();
}

void PaletteModel::decrementTotalColorCount(int amount)
{
    m_totalColorCount = qMax(0, m_totalColorCount - amount);
    emit totalColorCountChanged();
}