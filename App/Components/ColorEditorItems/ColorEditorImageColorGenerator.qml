import QtQuick
import QtQuick.Controls.Material
import QtQuick.Layouts
import "../../Controls"
import App.Core

TintScrollView {
    id: colorEditorImageColorGenerator

    ColumnLayout {
        width: parent.width
        spacing: ControlStyle.spacing.smallest

        TintHighlightLabel {
            Layout.preferredHeight: 300
            Layout.fillWidth: true
            horizontalAlignment: Qt.AlignHCenter
            verticalAlignment: Qt.AlignVCenter
            Material.foreground: Theme.foregroundColor.primary

            text: ImageColorGenerator.imageSource.toString().length === 0
                  ? "Bild auswählen" : ""

            TintRoundedImage {
                id: img
                anchors.fill: parent
                anchors.margins: 1
                source: ImageColorGenerator.imageSource

                // NEU: während Dateiauswahl und Verarbeitung keine weitere Auswahl
                enabled: !ImageColorGenerator.busy

                // HIER wird die Anzahl der gewünschten Farben übergeben.
                onClicked: ImageColorGenerator.openImage(5)
            }

            BusyIndicator {
                anchors.centerIn: parent
                running: ImageColorGenerator.busy
                visible: running
            }
        }

        TintLabel {
            Layout.fillWidth: true
            visible: text.length > 0
            text: ImageColorGenerator.error
            wrapMode: Text.WordWrap
        }

        TintColorColumn {
            Layout.fillWidth: true
            enabled: !ImageColorGenerator.busy
            model: ImageColorGenerator.colors
        }
    }
}