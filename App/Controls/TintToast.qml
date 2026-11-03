import QtQuick
import QtQuick.Controls.Material
import QtQuick.Controls.Material.impl
import QtQuick.Layouts
import App.Core

Popup {
    id: control
    closePolicy: Popup.CloseOnEscape

    y: Math.max(ControlStyle.spacing.medium, (parent.height - height -ControlStyle.spacing.medium) )
    width: Math.min(implicitContentWidth + leftPadding + rightPadding, parent.width * 0.6)
    modal: false
    dim: false
    x: Math.max(ControlStyle.spacing.medium, (parent.width - width ) / 2 ) + offsetX
    rightPadding: ControlStyle.spacing.medium
    leftPadding: ControlStyle.spacing.large + 4
    bottomPadding: ControlStyle.spacing.large
    topPadding: ControlStyle.spacing.large
    Material.background: Theme.backgroundColor.tertiary
    Material.roundedScale: ControlStyle.radius.medium
    Material.elevation: ControlStyle.elevation.dialogs

    Connections {
        target: Notification
        function onRequested(text, type) {
            control.setMessage(text, type)
        }
    }

    enum ToastType {
        Success,
        Information,
        Error
    }
    property int offsetX: 0
    property int toastType: TintToast.Error

    property string text: "Lorem ipsum dolor sit amet, consetetur sadipscing sad  asd asas dasd asd asdsa"

    property string title:  {
        switch ( toastType ) {
        case TintToast.Success: return "Erfolgreich";
        case TintToast.Information: return "Hinweis";
        case TintToast.Error: return "Fehlschlag";
        default: return Theme.accent;
        }
    }

    property color highlightColor: {
        switch ( toastType ) {
        case TintToast.Success: return Theme.green;
        case TintToast.Information: return Theme.yellow;
        case TintToast.Error: return Theme.red;
        default: return Theme.accent;
        }
    }

    property url source: {
        switch ( toastType ) {
        case TintToast.Success: return Icons.circle_check;
        case TintToast.Information: return Icons.cicle_info;
        case TintToast.Error: return Icons.circle_error;
        default: return Icons.circle_notifications2;
        }
    }

    function setMessage( _text, _toastType ) {
        text = _text;
        toastType = _toastType;
        control.open();
        timer.restart();
    }

    Timer {
        id: timer
        running: control.visible
        repeat: false
        interval: 5000
        onTriggered: control.close()
    }

    //onClosed: destroy();
    onAboutToShow: forceActiveFocus();

    enter: Transition {
        NumberAnimation { property: "offsetX"; from: 100; to: 0; easing.type: Easing.OutCubic; duration: 230 }
        NumberAnimation { property: "opacity"; from: 0.0; to: 1.0; easing.type: Easing.OutCubic; duration: 150 }
    }

    exit: Transition {
        NumberAnimation { property: "offsetX"; to: -100; from: 0; easing.type: Easing.OutCubic; duration: 230 }
        NumberAnimation { property: "opacity"; from: 1.0; to: 0.0; easing.type: Easing.OutCubic; duration: 150 }
    }

    background: Rectangle {
        anchors.fill: parent
        radius: control.Material.roundedScale + 4
        color: control.highlightColor

        layer.enabled: control.Material.elevation > 0
        layer.effect: RoundedElevationEffect {
            elevation: control.Material.elevation
            roundedScale: control.Material.roundedScale + 4
        }
        Rectangle {
            anchors.fill: parent
            anchors.leftMargin: ControlStyle.spacing.smallest
            radius: control.Material.roundedScale
            color: control.Material.backgroundColor
        }
    }

    contentItem: ColumnLayout {
        spacing: ControlStyle.spacing.smallest
        RowLayout {
            spacing: ControlStyle.spacing.smallest

            TintColorImage {
                source: control.source
                color: control.highlightColor
                Layout.rightMargin: ControlStyle.spacing.small
            }

            TintLabel {
                Material.foreground: control.highlightColor
                Layout.fillWidth: true
                text: control.title
                font: Fonts.header
                elide: Text.ElideRight
            }
            TintFlatButton {
                flat: true
                Layout.topMargin: -ControlStyle.spacing.small
                Layout.alignment: Qt.AlignTop
                icon.source: Icons.close
                Material.foreground: control.highlightColor
                onClicked: {
                    control.close()
                }
            }
        }

        TintLabel {
            Material.foreground: control.highlightColor
            Layout.fillWidth: true
            text: control.text
            wrapMode: Text.WordWrap
            rightPadding: ControlStyle.spacing.small
            opacity: 0.75
        }
    }

}





















