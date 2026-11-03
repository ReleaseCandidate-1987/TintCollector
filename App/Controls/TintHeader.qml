import QtQuick
import QtQuick.Controls.Material
import QtQuick.Layouts

Control {
    id: control
    padding: ControlStyle.spacing.small
    property string title: parent.title ?? "Title" // "Title"
    default property alias contentItems: rlayout.children
    property bool drawBorderRight: false
    property bool drawBorderLeft: false
    property bool fillWidth: true
    contentItem: RowLayout {
        spacing: ControlStyle.spacing.smallest
        TintLabel {
            visible: text.trim().length > 0
                     && control.width - rlayout.implicitWidth - ControlStyle.spacing.medium > implicitWidth
            Layout.fillWidth: control.fillWidth
            text: control.title
            font: Fonts.controlBold
            Material.foreground: Theme.accent
            Layout.preferredHeight: ControlStyle.controlSize.small
            verticalAlignment: Qt.AlignVCenter
        }
        RowLayout {
            id: rlayout
            Layout.alignment: Qt.AlignRight
            spacing: ControlStyle.spacing.smallest
        }
    }

    background: Rectangle {
        anchors.fill: parent
        color: Theme.backgroundColor.tertiary
        TintBorderItem {
            drawBottom: true;
            drawRight: control.drawBorderRight
            drawLeft: control.drawBorderLeft
        }
    }

}

