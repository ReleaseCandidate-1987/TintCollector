
import QtQuick
import QtQuick.Controls.Material

Item {
    id: control
    width: 1920
    height: 1080
    Material.background: Theme.backgroundColor.primary
    Material.accent: Theme.accent
    Material.foreground: Theme.foregroundColor.primary
    property alias header: __header.contentItem
    property alias footer: __footer.contentItem
    property alias sideBar: __sideBar.contentItem
    property alias contentItem: __content.contentItem
    property alias colorEditor: __colorEditor.contentItem

    property font font: Fonts.control

    Control {
        id: __content
        anchors.left: __sideBar.right
        anchors.right: __colorEditor.left
        anchors.top: __header.bottom
        anchors.bottom: __footer.top
        padding: ControlStyle.spacing.none
        font: control.font
        Material.foreground: control.Material.foreground
        background: Rectangle { color: Theme.backgroundColor.secondary }
    }

    Control {
        id: __sideBar
        anchors.left: parent.left
        anchors.top: __header.bottom
        anchors.bottom: __footer.top
        padding: ControlStyle.spacing.none
        width: 300
        font: control.font
        Material.foreground: control.Material.foreground
        background: Rectangle {
            color: Theme.backgroundColor.secondary
            TintBorderItem { drawRight: true }
        }

        states: [
            State {
                when: !appSettings.sideBarVisible
                PropertyChanges {
                    target: __sideBar
                    anchors.leftMargin: -__sideBar.width
                }
            },
            State {
                when: app.width < 1200
                PropertyChanges {
                    target: __sideBar
                    width: 200
                }
            }
        ]
        transitions: [
            Transition {
                NumberAnimation {
                    properties: "anchors.leftMargin,width"
                    duration: 200
                    easing.type: Easing.InOutQuad
                }
            }
        ]
    }

    Control {
        id: __colorEditor
        visible: PaletteModel.count > 0
        width: PaletteModel.count <= 0 ? 0: control.width < 700 ? control.width
                                   : control.width < 1200 ? 300 : 400

        property real visibilityProgress: appSettings.colorEditorVisible ? 1 : 0

        Behavior on visibilityProgress { NumberAnimation { duration: 200; easing.type: Easing.InOutQuad } }

        z: control.width < 700 ? __sideBar.z + 1 : 0
        anchors.right: parent.right
        anchors.top: __header.bottom
        anchors.bottom: __footer.top

        anchors.rightMargin: -(1 - visibilityProgress) * width
        anchors.left: undefined

        padding: ControlStyle.spacing.none
        font: control.font
        Material.foreground: control.Material.foreground
        background: Rectangle {
            color: Theme.backgroundColor.secondary
            TintBorderItem { drawLeft: true }
        }

        states: [
            State {
                when: PaletteModel.count > 0 && appSettings.colorEditorVisible && control.width < 700
                AnchorChanges { target: __colorEditor ; anchors.left: control.left }
            }
        ]
        transitions: [ Transition { AnchorAnimation { duration: 200; easing.type: Easing.InOutQuad } } ]

        Behavior on width {
            enabled: appSettings.colorEditorVisible && control.width >= 700
            NumberAnimation { duration: 200; easing.type: Easing.InOutQuad }
        }

        Behavior on anchors.leftMargin { NumberAnimation { duration: 200; easing.type: Easing.InOutQuad } }
    }

    Control {
        id: __footer
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        padding: ControlStyle.spacing.small
        font: control.font
        Material.foreground: control.Material.foreground
        background: Rectangle {
            color: Theme.backgroundColor.secondary
            TintBorderItem { drawTop: true; }
        }
    }

    Control {
        id: __header
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        padding: ControlStyle.spacing.small
        font: control.font
        Material.foreground: control.Material.foreground
        background: Rectangle {
            color: Theme.backgroundColor.secondary
            TintBorderItem { drawBottom: true; }
        }
    }
}
