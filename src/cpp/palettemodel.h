#ifndef PALETTEMODEL_H
#define PALETTEMODEL_H

#include "model.h"

class PaletteModel : public Model
{
    Q_OBJECT
    Q_PROPERTY(int totalColorCount READ totalColorCount NOTIFY totalColorCountChanged FINAL)

public:
    explicit PaletteModel(QObject *parent = nullptr);

    /*! Überschreiben der append Methode aus Model */
    Q_INVOKABLE void addPalette(const QString &name);

    /*! Überschreiben der remove Methode aus Model */
    Q_INVOKABLE void removePalette(int index);

    /*! Ändert den Namen einer bestehenden Palette über den Index. */
    Q_INVOKABLE void renamePalette(int index, const QString &newName);

    /*! Lädt alle Paletten aus der Datenbank und fügt diese dem Model hinzu. */
    Q_INVOKABLE void loadPalettes();

    int totalColorCount() const;
    void incrementTotalColorCount();
    void decrementTotalColorCount();
    void decrementTotalColorCount(int amount );

private:
    int m_totalColorCount = 0;

signals:
    void totalColorCountChanged();
};

#endif // PALETTEMODEL_H