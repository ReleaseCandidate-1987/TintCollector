import QtQuick
import "../../Controls"

TintMenu {
    id: sortMenu
    x: (parent.width - width) / 2
    y: parent.height + 4

    TintMenuItem {
        text: "A-Z"
        onTriggered: PaletteProxyModel.sortBy("name", Qt.AscendingOrder)
    }

    TintMenuItem {
        text: "Z-A"
        onTriggered: PaletteProxyModel.sortBy("name", Qt.DescendingOrder)
    }

    TintMenuItem {
        text: "Wenigste Farben zuerst"
        onTriggered: PaletteProxyModel.sortBy("colorCount", Qt.AscendingOrder)
    }

    TintMenuItem {
        text: "Meiste Farben zuerst"
        onTriggered: PaletteProxyModel.sortBy("colorCount", Qt.DescendingOrder)
    }

    onClosed: {
        sortBtn.menuRef = null;
        sortMenu.destroy();
    }
}