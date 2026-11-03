import QtQuick
import QtQuick.Controls.Material
import QtQuick.Layouts
import App.Core
import "../Controls"
// import "AppFooterItems"


RowLayout {
    id: appFooter
    // TintHighlightLabel {
    //     text: "Zuletzt hinzugefügt: Palette 25"
    // }
    TintHighlightLabel {
        text: `${PaletteModel.count} ${PaletteModel.count === 1 ? 'Palette' : 'Paletten'}`
    }
    TintHighlightLabel {
        readonly property int count: PaletteModel.totalColorCount
        text: `${count} ${count === 1 ? "Farbe" : "Farben"}`
    }

    TintHighlightLabel {
        visible: sideBar.paletteName.length > 0 && PaletteModel.count > 0
        text: `${sideBar.paletteName} ausgewählt`
    }
    Item {
        Layout.fillWidth: true
    }


}
