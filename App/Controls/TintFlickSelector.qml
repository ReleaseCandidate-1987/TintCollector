import QtQuick
import QtQuick.Controls.Material
import QtQuick.Layouts

Item {
    id: control
    implicitHeight: ControlStyle.controlSize.normal
    implicitWidth: 200
    
    property var model: ["Entry 1", "Entry 2"]
    property alias currentIndex: __view.currentIndex
    property alias highlightMoveDuration: __view.highlightMoveDuration
    
    signal selected( index: int )
    property bool menuEnabled: true

    onCurrentIndexChanged: {
        if (menu.visible)
            menu.currentIndex = control.currentIndex;
    }

    WheelHandler {
        onWheel: function( ev ) {
            const dy = ev.angleDelta.y
            if ( dy < 0 )
                __view.decrementCurrentIndex();
            else
                __view.incrementCurrentIndex();
            control.selected(__view.currentIndex)
        }
    }
    
    HoverHandler { id: __hh; cursorShape: Qt.PointingHandCursor }
    Rectangle {
        anchors.fill: parent
        radius: ControlStyle.radius.small
        color: Theme.backgroundColor.primary
        border.color: menu.__menuVisible ? Theme.accent : __hh.hovered ? Theme.borderLighter : Theme.border
        Behavior on border.color { ColorAnimation { duration: 200 } }
    }
    
    MouseArea {
        id: area
        enabled: control.menuEnabled
        anchors.fill: parent
        parent: __view
        onClicked: { menu.open() }
    }

    TintMenu {
        id: menu
        y: control.height + 4
        width: control.width
        Material.background: Theme.backgroundColor.primary
        property bool __menuVisible: false
        transformOrigin: Item.Top
        onAboutToHide: __menuVisible = false;
        onAboutToShow: {__menuVisible = true; currentIndex = control.currentIndex}

        Repeater {
            model: control.model
            TintMenuItem {
                text: modelData
                alignment: Qt.AlignCenter

                onTriggered: {
                    control.currentIndex = index
                    control.selected( index )
                }
            }
        }

    }

    RowLayout {
        anchors.fill: parent
        TintFlatButton {
            flat: true
            Layout.margins: 4
            Layout.fillHeight: true
            Layout.preferredWidth: height
            icon.source: Icons.keyboard_arrow_left
            enabled: __view.currentIndex > 0
            onClicked: {
                __view.decrementCurrentIndex();
                control.selected(__view.currentIndex);
            }
        }
        
        ListView {
            id: __view
            highlightRangeMode: ListView.StrictlyEnforceRange
            snapMode: ListView.SnapToItem
            orientation: ListView.Horizontal
            Layout.fillHeight: true
            Layout.fillWidth: true
            model: control.model
            clip: true
            highlightMoveDuration: 100

            delegate: TintLabel {
                width: ListView.view.width
                height: ListView.view.height
                font: Fonts.controlBold
                verticalAlignment: Qt.AlignVCenter
                horizontalAlignment: Qt.AlignHCenter
                text: modelData
            }
        }
        
        TintFlatButton {
            flat: true
            Layout.margins: 4
            Layout.fillHeight: true
            Layout.preferredWidth: height
            enabled: __view.currentIndex < __view.count - 1
            icon.source: Icons.keyboard_arrow_right
            onClicked: {
                __view.incrementCurrentIndex();
                control.selected(__view.currentIndex);
            }
        }
    }
    

}

























