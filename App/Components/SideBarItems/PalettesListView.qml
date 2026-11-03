import QtQuick
import QtQuick.Controls.Material
import QtQuick.Layouts
import App.Core
import "../../Controls"

ListView {
    id: palettesListView

    boundsMovement: Flickable.StopAtBounds
    Layout.fillHeight: true
    spacing: ControlStyle.spacing.smallest
    model: PaletteProxyModel
    clip: true

    ScrollBar.vertical: TintScrollBar {
        id: verticalScrollBar
        policy: ScrollBar.AsNeeded
    }

    delegate: PaletteDelegate {
        id: paletteDelegate
        width: ListView.view.width - ( verticalScrollBar.contentItem.visible && verticalScrollBar.contentItem.opacity > 0
            ? verticalScrollBar.contentItem.width + ControlStyle.spacing.small : ControlStyle.spacing.small )
        onRenameRequested: { renamePaletteDialogComponent.createObject().open(); }
        onRemoveRequested: { removePaletteDialogComponent.createObject().open(); }
    }

    Component {
        id: removePaletteDialogComponent

        TintDialog {
            preferredWidth: 360
            title: "Palette entfernen"
            text: `Möchtest du die Palette <b>${currentItem?.name ?? ''}</b> wirklich entfernen? <b>Alle</b> Farben gehen dabei verloren.`

            onAccepted: {
                const index = PaletteProxyModel.sourceIndex(currentItem?.index ?? -1);
                if (index >= 0)
                    PaletteModel.removePalette( index );
            }

            onClosed: destroy()
        }
    }

    Component {
        id: renamePaletteDialogComponent

        AddPaletteDialog {
            insertMode: AddPaletteDialog.Rename
            inputText: currentItem.name
            title: "Palette Umbenennen"
            subTitle: `Gebe einen Neuen Namen für die Palette <b>${currentItem.name}</b> ein.`

            onPaletteRenamed: function(newName) {
                const index = PaletteProxyModel.sourceIndex(currentItem?.index ?? -1);
                if (index >= 0)
                    PaletteModel.renamePalette(index, newName);
            }
        }
    }
}