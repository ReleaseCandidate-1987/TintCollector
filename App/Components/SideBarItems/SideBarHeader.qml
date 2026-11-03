import QtQuick
import QtQuick.Controls.Material
import QtQuick.Layouts
import App.Core
import "../../Controls"

/*!
    SideBarHeader-Komponente.

    Hinzufügen neuer Paletten, sowie deren Sortierung nach Namen.
*/
TintHeader {
    id: sideBarHeader
    drawBorderRight: true

    signal newPaletteCreated(int index)

    // Sortierung der Paletten über SortMenu.
    TintFlatButton {
        id: sortBtn
        visible: PaletteModel.count > 3
        icon.source: Icons.sort
        toolTipText: "Einträge <b>sortieren</b>."
        onClicked: {
            if ( menuRef )
                return;
            menuRef = sortMenuComponent.createObject( this )
            menuRef.open();
        }
        Component { id: sortMenuComponent; SortMenu { } }
    }

    // Neue Palette hinzufügen über AddPaletteDialog.
    TintFlatButton {
        id: addPaletteBtn
        icon.source: Icons.add
        toolTipText: "Neue Palette <b>hinzufügen</b>."
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
                    const previousCount = PaletteModel.count;

                    PaletteModel.addPalette(name);

                    if ( PaletteModel.count === previousCount )
                        return;

                    const sourceIndex = PaletteModel.index(previousCount, 0);
                    const proxyIndex = PaletteProxyModel.mapFromSource(sourceIndex);

                    if ( proxyIndex.valid )
                        sideBarHeader.newPaletteCreated(proxyIndex.row);
                }
            }
        }
    }
}













