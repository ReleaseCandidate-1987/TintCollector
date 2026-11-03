import QtQuick
import QtQuick.Controls.Material
import App.Core
import "../../Controls"

TintMenu {
    id: colorContainerMoreMenu
    parent: moreBtn
    y: -ControlStyle.spacing.small
    x: -width - 4
    TintMenuItem {
        text: "Farbe kopieren"
        icon.source: Icons.content_copy
        onTriggered: Clipboard.setText( btn.Material.backgroundColor.toString() )
    }
    TintMenuItem {
        text: "Farbe umbenennen"
        icon.source: Icons.edit_note
        onTriggered: { colorContainerDelegate.renameRequested() }
    }
    TintMenuItem {
        Material.foreground: Theme.red
        icon.source: Icons.delete_x
        text: "Farbe entfernen"
        onTriggered: { colorContainerDelegate.removeRequested() }
    }
    
    onClosed: {
        destroy()
    }
}
