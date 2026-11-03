#include "model.h"

Model::Model(QObject *parent)
    : QAbstractListModel{parent}
{
    m_roles.insert( Qt::UserRole + 1, "_id" );
    m_roles.insert( Qt::UserRole + 2, "name" );

    connect(this, &Model::countChanged, this, &Model::namesChanged);
}


Model::Model(const QHash<int, QByteArray> &roles, QObject *parent)
    : Model{parent}
{
    for (auto it = roles.cbegin(); it != roles.cend(); ++it)
        m_roles.insert(it.key(), it.value());
}


void Model::append(const QVariantMap &item)
{
    const int index = static_cast<int>( m_items.size());
    beginInsertRows(QModelIndex(), index, index );
    m_items.append(item);
    endInsertRows();

    emit countChanged();
}

void Model::remove(int index)
{
    beginRemoveRows(QModelIndex(), index, index);
    m_items.remove(index);
    endRemoveRows();
    emit countChanged();
}

QVariantMap Model::get(int index) const
{
    if ( index < 0 || index >= m_items.size() )
        return {};

    return m_items.at( index ).toMap();
}

void Model::setProperty(int index, const QString &property, const QVariant &value)
{
    if ( index < 0 || index >= m_items.size() )
        return;

    const auto role = roleNames().key(property.toUtf8(), -1);
    if ( role == -1 )
        return;

    auto item = m_items[index].toMap();
    if ( item.value( property ) == value )
        return;

    item.insert(property, value);
    m_items[index] = item;

    const auto modelIndex = this->index(index);
    emit dataChanged(modelIndex, modelIndex, {role});

    if ( property == "name" )
        emit namesChanged();
}

bool Model::containsName(const QString &name, int excludeIndex)
{
    auto list = names();
    // excludeIndex nimmt beim Umbenennen den eigenen Eintrag aus dem Vergleich.
    if ( excludeIndex >= 0 && excludeIndex < list.size() )
        list.removeAt(excludeIndex);

    return list.contains(name);
}

void Model::rename(int index, const QString &newName) { setProperty(index, "name", newName); }

int Model::count() const { return static_cast<int>(m_items.size()); }

QStringList Model::names() const
{
    QStringList list;
    for ( int i = 0; i < m_items.size(); ++i ) {
        list.append(get(i).value("name").toString());
    }
    return list;
}

int Model::rowCount(const QModelIndex &parent) const { return parent.isValid() ? 0 : static_cast<int>(m_items.size()); }

QVariant Model::data(const QModelIndex &index, int role) const
{
    if ( !index.isValid() || index.row() < 0 || index.row() >= m_items.size() )
        return {};

    const auto it = m_roles.constFind( role );
    if ( it == m_roles.cend() )
        return {};

    const auto item = m_items.at(index.row()).toMap();
    return item.value(QString::fromUtf8(it.value()));
}

QHash<int, QByteArray> Model::roleNames() const { return m_roles; }



void Model::setItems(const QVariantList &items)
{
    beginResetModel();
    m_items = items;
    endResetModel();

    emit countChanged();
}