import QtQuick
import QtQuick.Controls.Material

ScrollView {
    id: control
    padding: ControlStyle.spacing.none
    rightPadding: __verticalScrollBar.contentItem.visible && __verticalScrollBar.contentItem.opacity > 0
                  ? ControlStyle.spacing.small * 2 : ControlStyle.spacing.small
    font: control.font
    Material.foreground: Theme.foregroundColor.primary
    contentWidth: availableWidth
    // contentHeight: contentChildren.implicitHeight

    ScrollBar.vertical: TintScrollBar {
        id: __verticalScrollBar
        anchors {
            top: parent.top; bottom: parent.bottom; right: parent.right
        }
    }

    background: Rectangle {  color: control.Material.backgroundColor }
}
