import QtQuick
import QtQuick.Controls.Material
import QtQuick.Layouts
import "../../Controls"

TintHeader {
    id: mainItemHeader
    visible: PaletteModel.count > 0

    TintHighlightLabel {
        Material.foreground: Theme.accent
        text: `${sideBar.paletteColorCount}/${ColorModel.maxColorCount}`
    }

    TintFlatButton {
        icon.source: Icons.delete_x
        toolTipText: "<b>Alle</b> Farben entfernen."
        enabled: ColorModel.count > 0
        Material.foreground: Theme.red
        onClicked: {
            removeAllColorsDialogComponent.createObject().open()

        }

        Component {
            id: removeAllColorsDialogComponent
            TintDialog {
                visible: true
                title: "Alle Farben entfernen"
                text: "Möchtest du wirklich alle Farben aus dieser Palette entfernen?"
                onAccepted: {
                    if ( sideBar.paletteID < 0 )
                        return;
                    ColorModel.clearColors(sideBar.paletteID)
                }
            }
        }
    }

    TintFlatButton {
        icon.source: Icons.keyboard_arrow_left
        iconRotation: 90
        toolTipText: "<b>Alle</b> Kategorien einklappen."
        enabled: mainItemContent.anyOpen
        onClicked: mainItemContent.expand(false)
    }
    TintFlatButton {
        icon.source: Icons.keyboard_arrow_left
        enabled: !mainItemContent.allOpen
        toolTipText: "<b>Alle</b> Kategorien ausklappen."
        iconRotation: -90
        onClicked: mainItemContent.expand()
    }
    


}
