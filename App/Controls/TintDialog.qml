import QtQuick
import QtQuick.Controls.Material
import QtQuick.Controls.Material.impl
import QtQuick.Effects
import QtQuick.Layouts

Dialog {
    id: control
    parent: app
    height: implicitHeight
    width: Math.min( preferredWidth, parent.width * 0.9)
    title: "Dialog"
    visible: false
    modal: true

    x: (parent.width - width) / 2
    y: (parent.height - height) / 2
    padding: ControlStyle.radius.large
    bottomPadding: ControlStyle.radius.medium
    
    Material.roundedScale: ControlStyle.radius.medium
    Material.foreground: Theme.foregroundColor.primary
    Material.background: Theme.backgroundColor.tertiary
    Material.accent: Theme.accent
    Material.elevation: ControlStyle.elevation.dialogs
    font: Fonts.control
    standardButtons: Dialog.Cancel | Dialog.Ok

    property bool isValid: true
    property string text: ""
    property string tipp: ""
    property string subTitle: ""
    property alias extraContent: __extraContent.contentItem
    property int preferredWidth: 420

    onVisibleChanged: app.anyDialogOpen = visible;
    onClosed: destroy()

    header: TintDialogHeader {
        id: __titleRow
        topPadding: ControlStyle.spacing.medium
        leftPadding: control.leftPadding
        rightPadding: control.rightPadding
        title: control.title
        titleFont: Fonts.header
        subTitle: control.subTitle
        visible: control.title.trim().length > 0
        onButtonClicked: control.close()
        
    }
    
    contentItem: ColumnLayout {
        spacing: ControlStyle.spacing.medium
        TintLabel {
            visible: text.trim().length > 0
            text: control.text
            Layout.fillWidth: true
            wrapMode: "WordWrap"
        }
        Control {
            id: __extraContent
            Layout.fillWidth: true
            visible: !!contentItem
        }
        Label {
            Layout.topMargin: -ControlStyle.spacing.small
            visible: text.trim().length > 0
            text: control.tipp
            Layout.fillWidth: true
            wrapMode: "WordWrap"
            font: Fonts.small
            topPadding: 0
            Material.foreground: Theme.foregroundColor.secondary
        }
    }
    
    Overlay.modal: Item {
        MultiEffect {
            anchors.fill: parent
            source: app
            blurEnabled: true
            blur: 0.75
            autoPaddingEnabled: false
        }

        Rectangle {
            anchors.fill: parent
            color: Theme.rgba(Theme.backgroundColor.tertiary, 0.75)
        }

        MouseArea {
            anchors.fill: parent
            acceptedButtons: Qt.AllButtons
            preventStealing: true
        }

        Behavior on opacity { NumberAnimation { duration: 150 } }
    }

    background: Rectangle {
        radius: ControlStyle.radius.small
        color: control.Material.dialogColor
        border.color: Theme.border
        layer.enabled: control.Material.elevation > 0
        layer.effect: RoundedElevationEffect {
            elevation: control.Material.elevation
            roundedScale: control.background.radius
        }
    }

    footer: DialogButtonBox {
        visible: count > 0
        Material.background: Theme.transparent
        spacing: ControlStyle.spacing.smallest
        bottomPadding: ControlStyle.spacing.medium
        rightPadding: ControlStyle.spacing.medium
        delegate: TintButton {
            display: AbstractButton.TextOnly
            flat: true
            Material.foreground: !control.isValid ? Theme.red : Theme.accent
            enabled: DialogButtonBox.buttonRole !== DialogButtonBox.AcceptRole || control.isValid
        }
    }
    
}
