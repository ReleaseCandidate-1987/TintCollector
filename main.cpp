#include "src/cpp/clipboard.h"
#include "src/cpp/colorgenerator.h"
#include "src/cpp/exporter.h"
#include "src/cpp/imagecolorgenerator.h"
#include "src/cpp/notification.h"
#include "src/cpp/palettemodel.h"
#include "src/cpp/paletteproxymodel.h"
#include "src/cpp/colormodel.h"

#include <QApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>

int main(int argc, char *argv[])
{
    QApplication app(argc, argv);

    qmlRegisterSingletonInstance<ImageColorGenerator>("App.Core", 1, 0, "ImageColorGenerator", ImageColorGenerator::instance());
    qmlRegisterSingletonInstance<Clipboard>("App.Core", 1, 0, "Clipboard", Clipboard::instance());
    qmlRegisterSingletonInstance<ColorGenerator>("App.Core", 1, 0, "ColorGenerator", ColorGenerator::instance());
    qmlRegisterSingletonInstance<Notification>("App.Core", 1, 0, "Notification", Notification::instance());
    qmlRegisterSingletonInstance<Exporter>("App.Core", 1, 0, "Exporter", Exporter::instance());

    PaletteModel pm;
    PaletteProxyModel paletteProxy;
    paletteProxy.setSourceModel(&pm);

    PaletteProxyModel paletteSearch;
    paletteSearch.setSourceModel(&paletteProxy);
    paletteSearch.setFilterRole(Qt::UserRole + 2);
    paletteSearch.setFilterCaseSensitivity(Qt::CaseInsensitive);

    ColorModel cm(&pm);
    ColorGenerator::instance()->setColorModel(&cm);
    ImageColorGenerator::instance()->setColorModel(&cm);
    Exporter::instance()->setColorModel(&cm);

    QQmlApplicationEngine engine;
    engine.addImportPath(":/");
    engine.rootContext()->setContextProperty("PaletteModel", &pm);
    engine.rootContext()->setContextProperty("PaletteProxyModel", &paletteProxy);
    engine.rootContext()->setContextProperty("PaletteSearchModel", &paletteSearch);
    engine.rootContext()->setContextProperty("ColorModel", &cm);

    const QUrl url(QStringLiteral("qrc:/main.qml"));

    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated, &app, [url](QObject *obj, const QUrl &objUrl) {
        if (!obj && url == objUrl)
            QCoreApplication::exit(-1);
    }, Qt::QueuedConnection);

    engine.load(url);

    return QGuiApplication::exec();
}