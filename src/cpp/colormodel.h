
#ifndef COLORMODEL_H
#define COLORMODEL_H

#include "model.h"

#include <QPersistentModelIndex>
#include <QSortFilterProxyModel>

class PaletteModel;

class ColorModel : public Model
{
    Q_OBJECT

    Q_PROPERTY(QVariantMap colorModels READ colorModels CONSTANT)
    Q_PROPERTY(int maxColorCount READ maxColorCount NOTIFY maxColorCountChanged FINAL)

public:
    explicit ColorModel(QObject *parent = nullptr);

    void loadColors(const QVariantList &items);

    /*! Lädt die Farben der ausgewählten Palette. */
    Q_INVOKABLE void loadColors(qint64 paletteID);

    Q_INVOKABLE void addColor(qint64 paletteID, const QString &name,
                              const QString &colorCode, int category);

    /*! Entfernt eine vorhandene Farbe aus dem Model und der Datenbank. */
    Q_INVOKABLE void removeColor(int index);

    Q_INVOKABLE void renameColor(int index, const QString &newName);
    Q_INVOKABLE void changeColor(int index, const QString &newColorCode);

    /*! Verschiebt eine Farbe innerhalb oder zwischen Kategorien. */
    Q_INVOKABLE bool moveColor(int sourceCategory, int fromIndex,
                               int targetCategory, int toIndex);

    Q_INVOKABLE void clearColors(qint64 paletteID);

    QStringList colorCodes() const;
    QVariantMap colorModels() const;
    int maxColorCount() const;
    QStringList categoryNames() const;

signals:
    void maxColorCountChanged();

private:
    /*! Erstellt die Filteransichten für die fünf Kategorien. */
    void createColorModels();

    /*! NEU: Lädt das nächste Paket aus der Datenbank. */
    void loadColorBatch(qint64 paletteID, int offset, quint64 generation);

    /*! Aktualisiert die Farbanzahl der betroffenen Palette und die Gesamtanzahl. */
    void updateColorCount(const QPersistentModelIndex &paletteIndex, int change);

    QList<qint64> categoryColorIDs(const QSortFilterProxyModel *model) const;

    void applyColorMove(int sourceRow, int targetRow, int targetCategory);

    PaletteModel *m_paletteModel = nullptr;
    QPersistentModelIndex m_paletteIndex;
    qint64 m_paletteID = -1;

    QVariantMap m_colorModels;
    QStringList m_categoryNames = {
        "backgrounds", "textColors", "borders", "accents", "signalColors"
    };

    int m_maxColorCount = 32;

    quint64 m_loadGeneration = 0;

};

#endif // COLORMODEL_H
