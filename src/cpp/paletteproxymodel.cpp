#include "paletteproxymodel.h"

PaletteProxyModel::PaletteProxyModel(QObject *parent) : QSortFilterProxyModel{parent}
{
    setDynamicSortFilter(true);
    setSortCaseSensitivity(Qt::CaseInsensitive);

#ifdef Q_OS_WASM
    setSortLocaleAware(false);
#else
    setSortLocaleAware(true);
#endif
    setSortRole(Qt::UserRole + 2);
    sort(0);
}

void PaletteProxyModel::sortBy(const QString &property, Qt::SortOrder order)
{
    if ( !sourceModel() )
        return;

    const int role = sourceModel()->roleNames().key(property.toUtf8(), -1);
    if ( role == -1 )
        return;

    if ( sortRole() == role && sortColumn() == 0 && sortOrder() == order)
        return;

    if ( sortRole() != role )
        setSortRole(role);

    if ( sortColumn() != 0 || sortOrder() != order )
        sort(0, order);
}

int PaletteProxyModel::sourceIndex(int index) const
{
    if ( index < 0 || index >= rowCount() )
        return -1;

    return mapToSource(this->index(index, 0)).row();
}




