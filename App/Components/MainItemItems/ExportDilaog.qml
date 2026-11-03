
import QtQuick
import QtQuick.Controls.Material
import QtQuick.Layouts
import "../../Controls"
import App.Core

/*!
    ExportDilaog.qml

    Ermöglicht die Auswahl des Exportformats.
    Beim Bestätigen wird der Exporter mit dem gewählten FileType aufgerufen.
*/
TintDialog {
    id: exportDilaog

    title: "Palette exportieren"
    subTitle: "Exportiert die Palette nach <b>Auswahl</b> des Formats."
    preferredWidth: 360

    property int fileType: [
        Exporter.Qml,
        Exporter.Css,
        Exporter.Text
    ][formatSelector.currentIndex]

    extraContent: TintFlickSelector {
        id: formatSelector
        model: ["QML", "CSS", "Text"]
        currentIndex: 0
    }

    onAccepted: Exporter.exportColors(fileType)
    onClosed: destroy()

    footer: DialogButtonBox {
        visible: count > 0
        Material.background: Theme.transparent
        spacing: ControlStyle.spacing.smallest
        bottomPadding: ControlStyle.spacing.medium
        rightPadding: ControlStyle.spacing.medium

        delegate: TintButton {
            display: AbstractButton.TextOnly
            flat: true
            Material.foreground: Theme.accent

            text: DialogButtonBox.buttonRole !== DialogButtonBox.AcceptRole
                  ? "Abbrechen" : "Exportieren"
        }
    }
}
