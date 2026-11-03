
import QtQuick
import QtQuick.Controls.Material
import QtQuick.Layouts
import "../../Controls"
import App.Core

Control {
    id: control
    Layout.fillWidth: true
    implicitHeight: open ? __listView.contentHeight : __listView.headerItem.implicitHeight - 1

    property bool open: true
    property string name: "Category-Name"
    property var model: []
    Behavior on implicitHeight { NumberAnimation { duration: 150; easing.type: Easing.InOutQuad } }
    signal colorSelected(n: string, clr: color)

    property bool isDragging: false
    property int categoryIndex: -1
    z: isDragging ? 2 : 0

    signal colorDropped(int sourceIndex, real sceneX, real sceneY)


    Drag.active: isDragging
    Drag.source: control

    property bool highlighted: dropArea.containsDrag
                               && dropArea.drag.source !== control

    function dropIndex(sceneX, sceneY) {
        const position = __listView.contentItem.mapFromItem(null, sceneX, sceneY);
        const targetIndex = __listView.indexAt(position.x, position.y);

        if (targetIndex >= 0)
            return targetIndex;

        return position.y < __listView.headerItem.height ? 0 : __listView.count;
    }

    background: Rectangle {
        radius: ControlStyle.radius.small

        border.color: control.highlighted ? Theme.accent : Theme.border
        color: control.highlighted ? Theme.accentDark : Theme.backgroundColor.secondary
        Behavior on border.color { ColorAnimation { duration: 200; easing.type: Easing.InOutQuad } }
        Behavior on color { ColorAnimation { duration: 200; easing.type: Easing.InOutQuad } }

        DropArea {
            id: dropArea
            anchors.fill: parent

            /*!
                Übernimmt die Vorschaufarbe in diese Kategorie.
                Die Speicherung erfolgt nach Abschluss des Drop-Ereignisses,
                damit eine Aktualisierung des Vorschaumodells den Drag nicht unterbricht.
            */
            onDropped: function(drop) {
                if (!drop.keys.includes("generatedColor") || !drop.source || sideBar.paletteID < 0)
                    return;

                const paletteID = sideBar.paletteID;
                const sourceIndex = drop.source.dragStartIndex;
                const category = control.categoryIndex;

                if (sourceIndex < 0)
                    return;

                drop.accept(Qt.CopyAction);
                Qt.callLater(ColorGenerator.addColor, paletteID, category, sourceIndex);
            }
        }
    }

    contentItem: ListView {
        id: __listView
        interactive: false
        implicitHeight: contentHeight
        // clip: true
        headerPositioning: ListView.OverlayHeader
        header: ColorContainerHeader {}
        model: control.model

        delegate: ColorContainerDelegate {
            id: colorContainerDelegate

            opacity: control.open ? 1 : dragHandler.active ? 0.9 : 0
            visible: opacity > 0
            Behavior on opacity { NumberAnimation { duration: 200; easing.type: Easing.InOutQuad } }

            property int dragStartIndex: -1
            z: dragHandler.active ? 2 : 0

            transform: Translate {
                y: dragHandler.active ? dragHandler.activeTranslation.y : 0
            }

            DragHandler {
                id: dragHandler
                enabled: !app.anyDialogOpen
                target: null
                xAxis.enabled: false

                onActiveTranslationChanged: {
                    if (active) {
                        control.Drag.hotSpot = colorContainerDelegate.mapToItem(
                            control,
                            colorContainerDelegate.width / 2,
                            colorContainerDelegate.height / 2
                        );
                    }
                }

                onActiveChanged: {
                    control.isDragging = active;

                    if (!control.enabled) {
                        colorContainerDelegate.dragStartIndex = -1;
                        return;
                    }

                    if (active) {
                        colorContainerDelegate.dragStartIndex = index;
                        return;
                    }

                    if (colorContainerDelegate.dragStartIndex < 0)
                        return;

                    const position = colorContainerDelegate.mapToItem(
                        null,
                        colorContainerDelegate.width / 2,
                        colorContainerDelegate.height / 2 + activeTranslation.y
                    );

                    const sourceIndex = colorContainerDelegate.dragStartIndex;
                    colorContainerDelegate.dragStartIndex = -1;
                    colorContainerDelegate.down = false;
                    control.colorDropped(sourceIndex, position.x, position.y);
                }
            }

            onRemoveRequested: {
                ColorModel.removeColor(sourceIndex());
            }

            onRenameRequested: {
                renameColorDialogComponent.createObject(app, {
                    sourceIndex: sourceIndex()
                }).open();
            }
        }
    }

    Component {
        id: colorPickerComponent
        ColorPickerDialog {
            id: colorPickerDialog



            onColorSelected: function(newName, clr) {
                if (sideBar.paletteID < 0)
                    return;

                ColorModel.addColor(sideBar.paletteID, newName, clr, categoryIndex);
            }

            onOnlyColorSelected: function(clr) {
                ColorModel.changeColor(__listView.currentItem.sourceIndex(), clr);
            }
        }
    }

    Component {
        id: renameColorDialogComponent
        RenameColorDialog {

        }
    }
}
