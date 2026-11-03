import QtQuick
import QtQuick.Controls.Material

/*!
  TintColorColumn.qml
*/
Item {
    id: control
    implicitWidth: 200
    implicitHeight: listView.contentHeight
    visible: model.count > 0

    property var model: []
    property int controlHeight: ControlStyle.controlSize.normal
    property int spacing: 2

    signal colorDropped(int sourceIndex, real sceneX, real sceneY)

    ListView {
        id: listView
        anchors.fill: parent
        model: control.model

        /*! Behält Position und Größe des Listeneintrags während des Ziehens bei. */
        delegate: Item {
            id: delegateSlot

            required property int index
            required property string colorCode

            width: control.width
            height: control.controlHeight

            Rectangle {
                id: tintColorColumnDelegate

                property int index: delegateSlot.index
                property string colorCode: delegateSlot.colorCode
                property int dragStartIndex: -1
                property bool isDragging: false

                border.color: Theme.border
                color: colorCode
                width: control.width
                height: control.controlHeight
                z: isDragging ? 1000 : 0

                Drag.source: tintColorColumnDelegate
                Drag.keys: ["generatedColor"]
                Drag.supportedActions: Qt.CopyAction
                Drag.proposedAction: Qt.CopyAction
                Drag.hotSpot.x: width / 2
                Drag.hotSpot.y: height / 2

                /*!
                    Verschiebt ausschließlich das Farbrechteck über die Anwendung.
                    Der Listeneintrag bleibt dabei an seinem Platz.
                */
                states: State {
                    when: tintColorColumnDelegate.isDragging

                    ParentChange {
                        target: tintColorColumnDelegate
                        parent: app
                    }
                }

                DragHandler {
                    id: dragHandler
                    target: tintColorColumnDelegate

                    /*!
                        Startet den Drag und sendet beim Loslassen das Drop-Ereignis.
                        Anschließend kehrt das Rechteck in seinen Listeneintrag zurück.
                    */
                    onActiveChanged: {
                        if (active) {
                            tintColorColumnDelegate.dragStartIndex = tintColorColumnDelegate.index;
                            tintColorColumnDelegate.isDragging = true;
                            tintColorColumnDelegate.Drag.active = true;
                            return;
                        }

                        tintColorColumnDelegate.Drag.drop();
                        tintColorColumnDelegate.isDragging = false;
                        tintColorColumnDelegate.dragStartIndex = -1;
                    }
                }

                TintLabel {
                    anchors.centerIn: parent
                    text: parent.color.toString()
                    font: Fonts.controlUpper
                    Material.foreground: Theme.isDarkColor(parent.color) ? "#abb2bf" : "#101517"
                }
            }
        }
    }
}