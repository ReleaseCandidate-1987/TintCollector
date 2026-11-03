#include "database.h"

#include <QCoreApplication>
#include <QFile>
#include <QFileInfo>
#include <QSqlDatabase>
#include <QSqlError>
#include <QSqlQuery>
#include <QSqlRecord>

/*!
    Öffnet die SQLite-Datenbank.

    Desktop:
        Verwendet die Datenbank im Anwendungsverzeichnis.

    WebAssembly:
        Verwendet die persistente Datenbank unter /database.
        Beim ersten Start wird die eingebettete Startdatenbank kopiert.
*/
Database::Database()
{
#ifdef Q_OS_WASM
    const QString filePath = "/database/TintCollector.sqlite";


    qDebug() << "Startdatenbank vorhanden:"
             << QFile::exists("/seed/TintCollector.sqlite");

    qDebug() << "Startdatenbank Größe:"
             << QFileInfo("/seed/TintCollector.sqlite").size();

    qDebug() << "Browserdatenbank bereits vorhanden:"
             << QFile::exists(filePath);

    qDebug() << "Browserdatenbank Größe:"
             << QFileInfo(filePath).size();

    if (!QFile::exists(filePath)) {
        if (!QFile::copy("/TintCollector.sqlite", filePath))
            qFatal("SQLite-Startdatenbank konnte nicht kopiert werden.");
    }
#else
    const QString filePath = QCoreApplication::applicationDirPath() + "/TintCollector.sqlite";
#endif

    QSqlDatabase db = QSqlDatabase::addDatabase("QSQLITE");
    db.setDatabaseName(filePath);

    if (!db.open()) {
        qFatal("Datenbank konnte nicht geöffnet werden: %s",
               qPrintable(db.lastError().text()));
    }

    QSqlQuery query(db);

    if (!query.exec("PRAGMA foreign_keys = ON")) {
        qFatal("Fremdschlüssel konnten nicht aktiviert werden: %s",
               qPrintable(query.lastError().text()));
    }

    qDebug() << "Datenbank wurde erfolgreich geöffnet";
    qDebug() << "Pfad:" << db.databaseName();
    qDebug() << "Tabellen:" << db.tables();
}

Database *Database::instance()
{
    static Database db;
    return &db;
}

QVariantList Database::loadPalettes()
{
    return execute("SELECT * FROM palettes_view").toList();
}

QVariantList Database::loadColors(qint64 paletteID, int limit, int offset)
{
    return execute(
               "SELECT colors_view.* FROM colors_view "
               "JOIN colors ON colors._id = colors_view._id "
               "WHERE colors_view.paletteID = ? "
               "ORDER BY colors.category, colors.sortOrder, colors._id "
               "LIMIT ? OFFSET ?",
               {paletteID, limit, offset}
               ).toList();
}

qint64 Database::addPalette(const QString &name)
{
    const auto result = execute("INSERT INTO palettes (name) VALUES (?) RETURNING _id", {name}).toList();
    return result.value(0).toMap().value("_id", -1).toLongLong();
}

bool Database::removePalette(qint64 _id)
{
    const auto result = execute("DELETE FROM palettes WHERE _id = ?", {_id});
    return result.isValid();
}

bool Database::renamePalette(qint64 _id, const QString &newName)
{
    const QVariant result = execute("UPDATE palettes SET name = ? WHERE _id = ?", {newName, _id});
    return result.isValid();
}

qint64 Database::addColor(qint64 paletteID, const QString &name, const QString &colorCode, int category)
{
    const auto result = execute("INSERT INTO colors (name, colorCode, paletteID, category) VALUES (?,?,?,?) RETURNING _id", {name, colorCode, paletteID, category}).toList();
    return result.value(0).toMap().value("_id", -1).toLongLong();
}

bool Database::removeColor(qint64 _id)
{
    const auto result = execute("DELETE FROM colors WHERE _id = ?", {_id});
    return result.isValid();
}



bool Database::saveColorOrder(qint64 paletteID, qint64 colorID,
                              int targetCategory,
                              const QList<qint64> &sourceColorIDs,
                              const QList<qint64> &targetColorIDs)
{
    return transaction([&](QSqlDatabase &db) {
        QSqlQuery query(db);

        if (!query.prepare(
                "UPDATE colors SET category = ? "
                "WHERE _id = ? AND paletteID = ?"))
            return false;

        query.addBindValue(targetCategory);
        query.addBindValue(colorID);
        query.addBindValue(paletteID);

        if (!query.exec() || query.numRowsAffected() != 1)
            return false;

        if (!query.prepare(
                "UPDATE colors SET sortOrder = ? "
                "WHERE _id = ? AND paletteID = ?"))
            return false;

        for (int group = 0; group < 2; ++group) {
            const auto &colorIDs = group == 0 ? sourceColorIDs : targetColorIDs;

            for (int position = 0; position < colorIDs.size(); ++position) {
                query.bindValue(0, position);
                query.bindValue(1, colorIDs.at(position));
                query.bindValue(2, paletteID);

                if (!query.exec() || query.numRowsAffected() != 1) {
                    qWarning() << "Farb-Reihenfolge konnte nicht gespeichert werden:"
                               << query.lastError().text();
                    return false;
                }
            }
        }

        return true;
    });
}



bool Database::transaction(std::function<bool (QSqlDatabase &)> cb)
{

    instance();
    QSqlDatabase db = QSqlDatabase::database();

    if (!db.transaction())
        return false;

    if (!cb(db)) {
        db.rollback();
        return false;
    }

    if (!db.commit()) {
        db.rollback();
        return false;
    }

    return true;
}

bool Database::renameColor(qint64 _id, const QString &newName)
{
    const QVariant result = execute("UPDATE colors SET name = ? WHERE _id = ?", {newName, _id});
    return result.isValid();
}

bool Database::changeColor(qint64 _id, const QString &newColorCode)
{
    const QVariant result = execute("UPDATE colors SET colorCode = ? WHERE _id = ?", {newColorCode, _id});
    return result.isValid();
}

bool Database::clearColors(qint64 paletteID)
{
    return execute(
               "DELETE FROM colors WHERE paletteID = ?",
               {paletteID}
               ).isValid();
}

QVariant Database::execute(const QString &sql, const QVariantList &values)
{
    instance();

    QSqlQuery query;

    if (!query.prepare(sql)) {
        qWarning() << "query.prepare fehlgeschlagen:" << query.lastError().text();
        return {};
    }

    for (const auto &value : values)
        query.addBindValue(value);

    if (!query.exec()) {
        qWarning() << "query.exec fehlgeschlagen:" << query.lastError().text();
        return {};
    }

    if (!query.isSelect())
        return query.numRowsAffected();

    // Select verwalten.
    QVariantList rows;
    const QSqlRecord record = query.record();

    while (query.next()) {
        QVariantMap row;
        for (int i = 0; i < record.count(); ++i) {
            row.insert(record.fieldName(i), query.value(i));
        }
        rows.append(row);
    }

    if (query.lastError().isValid()) {
        qWarning() << "Abrufen fehlgeschlagen" << query.lastError().text();
        return {};
    }

    return rows;
}

