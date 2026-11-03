
#include "exporter.h"

#include "notification.h"

#include <QFileDialog>
#include <QRegularExpression>
#include <QSaveFile>
#include <QSet>
#include <QSortFilterProxyModel>

Exporter::Exporter(QObject *parent)
    : QObject{parent}
{}

Exporter *Exporter::instance()
{
    static Exporter exporter;
    return &exporter;
}

void Exporter::setColorModel(ColorModel *newColorModel)
{
    m_colorModel = newColorModel;
}


void Exporter::exportColors(FileType fileType)
{
    if (!m_colorModel || m_colorModel->count() <= 0)
        return;

    QString output;
    QString fileName;

    switch (fileType) {
    case Qml:
        fileName = "TintColors.qml";
        output = "import QtQuick\n\nQtObject {\n";
        break;

    case Css:
        fileName = "TintColors.css";
        output = ":root {\n";
        break;

    case Text:
        fileName = "TintColors.txt";
        break;

    default:
        return;
    }

    fromMappedModels([&](const QString &category, const QVariantList &colors) {
        switch (fileType) {
        case Qml:
            output += toQml(category, colors);
            break;

        case Css:
            output += toCss(category, colors);
            break;

        case Text:
            output += toText(category, colors);
            break;

        default:
            break;
        }
    });

    if (fileType == Qml || fileType == Css) {
        output = output.trimmed();
        output += "\n}\n";
    }


    saveColors(output, fileName);
}

/*!
    Speichert die generierten Farben.

    Auf Desktop-Systemen wird der Speichervorgang einschließlich
    Benutzerabbruch und Schreibfehler überwacht.

    Unter WebAssembly übernimmt der Browser den Dateiexport.
*/
void Exporter::saveColors(const QString &output, const QString &fileName)
{
#ifdef Q_OS_WASM
    QFileDialog::saveFileContent(output.toUtf8(), fileName);
#else
    const QString selectedFile = QFileDialog::getSaveFileName(
        nullptr, "Farben exportieren", fileName
        );

    if (selectedFile.isEmpty()) {
        Notification::instance()->setMessage(
            "Exportvorgang abgebrochen", Notification::Information
            );
        return;
    }

    QSaveFile file(selectedFile);

    if (!file.open(QIODevice::WriteOnly)) {
        Notification::instance()->setMessage(
            "Export fehlgeschlagen: " + file.errorString(),
            Notification::Error
            );
        return;
    }

    const QByteArray content = output.toUtf8();

    if (file.write(content) != content.size() || !file.commit()) {
        Notification::instance()->setMessage(
            "Export fehlgeschlagen: " + file.errorString(),
            Notification::Error
            );
        return;
    }

    Notification::instance()->setMessage(
        "Exportvorgang erfolgreich abgeschlossen",
        Notification::Success
        );
#endif
}


void Exporter::fromMappedModels(
    std::function<void(const QString &, const QVariantList &)> cb)
{
    const auto colorModels = m_colorModel->colorModels();
    const auto roles = m_colorModel->roleNames();

    const int nameRole = roles.key("name");
    const int colorCodeRole = roles.key("colorCode");

    static const QRegularExpression invalidCharacters("[^A-Za-z0-9_]");

    for (auto it = colorModels.cbegin(); it != colorModels.cend(); ++it) {
        const auto *model = it.value().value<QSortFilterProxyModel *>();

        if (!model)
            continue;

        const QString category = it.key();

        QVariantList colors;
        colors.reserve(model->rowCount());

        QSet<QString> usedNames;

        for (int row = 0; row < model->rowCount(); ++row) {
            const QModelIndex index = model->index(row, 0);

            const QString name = index.data(nameRole).toString();
            QString identifier = name.trimmed();

            // Bezeichner für QML und CSS vorbereiten.
            identifier.replace(invalidCharacters, "_");

            if (identifier.isEmpty() || !identifier.front().isLower())
                identifier.prepend("color_");

            const QString baseIdentifier = identifier;

            for (int suffix = 2; usedNames.contains(identifier); ++suffix)
                identifier = baseIdentifier + "_" + QString::number(suffix);

            usedNames.insert(identifier);

            colors.append(QVariantMap{
                {"name", name},
                {"identifier", identifier},
                {"colorCode", index.data(colorCodeRole)}
            });
        }

        cb(category, colors);
    }
}

QString Exporter::toQml(const QString &category, const QVariantList &colors)
{
    if ( colors.isEmpty() )
        return {};
    QString qml = QString("    property QtObject %1: QtObject {\n").arg(category);

    for (const auto &color : colors) {
        const auto row = color.toMap();

        qml += QString("        property color %1: \"%2\"\n")
                   .arg(row.value("identifier").toString(),
                        row.value("colorCode").toString());
    }

    qml += "    }\n\n";
    return qml;
}

QString Exporter::toCss(const QString &category, const QVariantList &colors)
{
    QString css;

    for (const auto &color : colors) {
        const auto row = color.toMap();

        css += QString("    --%1-%2: %3;\n")
                   .arg(category,
                        row.value("identifier").toString(),
                        row.value("colorCode").toString());
    }

    return css;
}

QString Exporter::toText(const QString &category, const QVariantList &colors)
{
    if ( colors.isEmpty() )
        return {};

    QString output = category + "\n";

    for (const auto &color : colors) {
        const auto row = color.toMap();

        output += QString("  %1: %2\n")
                      .arg(row.value("name").toString(),
                           row.value("colorCode").toString());
    }

    output += "\n";
    return output;
}


