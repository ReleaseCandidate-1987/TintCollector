import QtQuick
import QtQuick.Controls.Material
import QtQuick.Layouts
import "../../Controls"

TintMenu {
    id: paletteDelegateMoreMenu
    TintMenuItem {
        text: "umbenennen"
        icon.source: Icons.edit_note
        onClicked: {
            paletteDelegate.renameRequested()
        }
    }
    
    TintMenuItem {
        text: "entfernen"
        Material.foreground: Theme.red
        icon.source: Icons.delete_x
        onClicked: {
            paletteDelegate.removeRequested()
        }
    }
    
    onClosed: { destroy() }
}
