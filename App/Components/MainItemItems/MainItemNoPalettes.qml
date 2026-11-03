import QtQuick
import "../../Controls"
import "../SideBarItems"

Column {
    id: mainItemNoPalttes
    visible: PaletteModel.count === 0
    x: (mainItemContent.width - width) / 2
    y: (mainItemContent.height - height) / 2
    spacing: ControlStyle.spacing.medium

    TintFlatButton {
        id: addPaletteBtn

        height: ControlStyle.controlSize.large
        anchors.horizontalCenter: parent.horizontalCenter
        icon.source: Icons.add
        onClicked: {
            if ( menuRef )
                return;

            menuRef = addPaletteDialogComponent.createObject();
            menuRef.open();
            menuRef.onClosed.connect( function() {
                if( addPaletteBtn )
                    menuRef = null;
            });
        }

        Component { id: addPaletteDialogComponent;
            AddPaletteDialog {
                onPaletteAdded: function( name ) {
                    PaletteModel.addPalette(name);
                }
            }
        }
    }

    TintLabel {
        text: "Erstelle eine Palette."
    }
}