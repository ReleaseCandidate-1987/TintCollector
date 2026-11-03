import QtQuick
import QtQuick.Templates as T
import QtQuick.Controls.Material

T.ToolTip {
    id: control

    x: parent ? (parent.width - implicitWidth) / 2 : 0
    y: -implicitHeight - 4

    implicitWidth: Math.max(implicitBackgroundWidth + leftInset + rightInset,
                            contentWidth + leftPadding + rightPadding)
    implicitHeight: Math.max(implicitBackgroundHeight + topInset + bottomInset,
                             contentHeight + topPadding + bottomPadding)

    delay: 300
    timeout: 4000
    margins: 12
    padding: ControlStyle.spacing.small
    horizontalPadding: padding + ControlStyle.spacing.small
    Material.roundedScale: ControlStyle.spacing.small
    Material.background: Theme.backgroundColor.primary
    font: Fonts.control
    Material.foreground: Theme.foregroundColor.primary

    closePolicy: T.Popup.CloseOnEscape | T.Popup.CloseOnPressOutsideParent | T.Popup.CloseOnReleaseOutsideParent

    Material.theme: Material.Dark

    enter: Transition {
        NumberAnimation { property: "opacity"; from: 0.0; to: 1.0; easing.type: Easing.OutQuad; duration: 500 }
    }

    exit: Transition {
        NumberAnimation { property: "opacity"; from: 1.0; to: 0.0; easing.type: Easing.InQuad; duration: 500 }
    }

    contentItem: TintLabel {
        text: control.text
        font: control.font
        wrapMode: Text.Wrap
        color: control.Material.foreground
    }

    background: Rectangle {
        implicitHeight: control.Material.tooltipHeight
        color: control.Material.backgroundColor
        opacity: 1
        border.color: Theme.border
        radius: control.Material.roundedScale
    }
}
