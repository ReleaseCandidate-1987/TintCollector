
import QtQuick
import QtQuick.Controls.Material
import QtQuick.Layouts
import "../../Controls"
import App.Core

/*!
    MainItemFooter.qml

    Bietet den Export der ausgewählten Palette.
    Die Formatauswahl erfolgt über ExportDilaog.
*/
TintFooter {
    id: mainItemFooter

    visible: PaletteModel.count > 0
    title: ""

    TintButton {
        text: "exportieren"
        enabled: ColorModel.count > 0
        Material.background: Theme.accent
        Material.foreground: Theme.foregroundColor.dark

        onClicked: {
            exportDilaogComponent.createObject().open();
        }

        Component {
            id: exportDilaogComponent

            ExportDilaog {}
        }
    }
}
