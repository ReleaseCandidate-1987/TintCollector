#ifndef DATABASE_H
#define DATABASE_H

#include <QObject>
#include <QSqlDatabase>
#include <QVariant>

/*!

*/
class Database
{

public:
    /*! Erzeugt eine Singleton-Instanz. */
    static Database *instance();

    /*! Lädt alle Paletten aus der Datenbank. */
    static QVariantList loadPalettes();

    /*! Lädt alle Farben aus der Datenbank. */
    static QVariantList loadColors(qint64 paletteID, int limit = -1, int offset = 0);

    /*! Fügt eine Neue Palette in die Datenbank hinzu. */
    static qint64 addPalette(const QString &name);

    /*! Entfernt über die _id die jeweilige Palette. */
    static bool removePalette(qint64 _id);

    /*! Entfernt über die _id die jeweilige Palette. */
    static bool renamePalette(qint64 _id, const QString &newName);

    /*! Fügt eine Neue Farbe in die Datenbank hinzu. */
    static qint64 addColor(qint64 paletteID, const QString &name, const QString &colorCode, int category);

    /*! Entfernt über die _id die jeweilige Farbe. */
    static bool removeColor(qint64 _id);

    /*! Speichert die Reihenfolge innerhalb einer Kategorie. */
    static bool saveColorOrder(qint64 paletteID, qint64 colorID,
                               int targetCategory,
                               const QList<qint64> &sourceColorIDs,
                               const QList<qint64> &targetColorIDs);


    static bool renameColor(qint64 _id, const QString &newName);
    static bool changeColor(qint64 _id, const QString &newColorCode);
    static bool clearColors(qint64 paletteID);
private:
    Database();
    Q_DISABLE_COPY_MOVE(Database)

    /*! Führt einen Datenbankbefehl aus und gibt das Ergebnis wieder */
    static QVariant execute(const QString &sql, const QVariantList &values = {});
    static bool transaction( std::function<bool(QSqlDatabase &db)> cb );
};

#endif // DATABASE_H