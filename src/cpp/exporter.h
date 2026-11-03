
#ifndef EXPORTER_H
#define EXPORTER_H

#include "colormodel.h"

#include <QObject>
#include <functional>

class Exporter : public QObject
{
    Q_OBJECT

public:
    /*! Unterstützte Dateiformate für den Farbexport. */
    enum FileType { Qml, Css, Text };
    Q_ENUM(FileType)

    /*! Gibt die Singleton-Instanz zurück. */
    static Exporter *instance();

    /*! Übergibt das ColorModel, dessen Farben exportiert werden. */
    void setColorModel(ColorModel *newColorModel);

    /*! Exportiert die Farben im gewählten Format über einen Speicherdialog. */
    Q_INVOKABLE void exportColors(FileType fileType);

private:
    explicit Exporter(QObject *parent = nullptr);
    Q_DISABLE_COPY_MOVE(Exporter)

    /*! Durchläuft die gefilterten Kategorien und übergibt deren Farben an den Callback. */
    void fromMappedModels(std::function<void(const QString &, const QVariantList &)> cb);

    /*! Erstellt die QML-Eigenschaften einer Kategorie. */
    QString toQml(const QString &category, const QVariantList &colors);

    /*! Erstellt CSS-Variablen für eine Kategorie. */
    QString toCss(const QString &category, const QVariantList &colors);

    /*! Erstellt die Textdarstellung einer Kategorie. */
    QString toText(const QString &category, const QVariantList &colors);

    /*! Öffnet den Speicherdialog und meldet das Ergebnis des Exports. */
    void saveColors(const QString &output, const QString &fileName);


    ColorModel *m_colorModel = nullptr;
};

#endif // EXPORTER_H
