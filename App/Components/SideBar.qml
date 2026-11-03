import QtQuick
import QtQuick.Controls.Material
import QtQuick.Layouts
import "../Controls"
import "SideBarItems"

TintPage {
    id: sideBar
    title: "Paletten"
    readonly property var colorModels: ColorModel.colorModels
    readonly property var paletteID: palettesListView.currentItem?._id ?? -1
    readonly property var paletteColorCount: palettesListView.currentItem?.colorCount ?? 0
    readonly property string paletteName: palettesListView.currentItem?.name ?? ''
    property alias palettesListView: palettesListView

    function applyPaletteSelection() {
        ColorModel.loadColors(paletteID);
    }

    onPaletteIDChanged: Qt.callLater(applyPaletteSelection)

    header: SideBarHeader {
        id: sideBarHeader
        onNewPaletteCreated: function(index) {
            palettesListView.currentIndex = index;
        }
    }
    contentItem: PalettesListView { id: palettesListView }
}
