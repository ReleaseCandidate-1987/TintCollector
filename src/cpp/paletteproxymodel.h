#ifndef PALETTEPROXYMODEL_H
#define PALETTEPROXYMODEL_H

#include <QSortFilterProxyModel>

class PaletteProxyModel : public QSortFilterProxyModel
{
    Q_OBJECT
public:
    PaletteProxyModel(QObject *parent = nullptr);
    Q_INVOKABLE void sortBy(const QString &property, Qt::SortOrder order);
    Q_INVOKABLE int sourceIndex(int index) const;
};

#endif // PALETTEPROXYMODEL_H
