import QtQuick
import QtQuick.Controls.Material
import QtQuick.Layouts
import "../../Controls"
import App.Core

TintFooter {
    id: colorEditorFooter
    title: ""
    drawBorderLeft: true
    TintButton {
        flat: true
        text: "hinzufügen"
        Layout.fillWidth: true
        onClicked: {
            addColorsDialog.createObject().open()
        }
        Component {
            id: addColorsDialog
            TintDialog {
                title: ColorGenerator.count > 1 ? 'Farben hinzufügen' : "Farbe hinzufügen"
                text: ColorGenerator.count > 1
                      ? `Sollen <b>alle</b> Farben in die Palette <b>${sideBar.paletteName}</b> aufgenommen werden?`
                      : `Soll die Farbe in die Palette <b>${sideBar.paletteName}</b> aufgenommen werden?`
                onAccepted: ColorGenerator.addColors( sideBar.paletteID, colorEditorColorGenerator.currentCategoryIndex );
            }
        }
    }

}
