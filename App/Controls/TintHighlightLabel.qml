import QtQuick
import QtQuick.Controls.Material

TintLabel {
    id: control
    padding: ControlStyle.spacing.smallest
    leftPadding: ControlStyle.spacing.medium
    rightPadding: ControlStyle.spacing.medium
    font: Fonts.smallBold
    Material.roundedScale: ControlStyle.radius.small
    Material.foreground: Theme.accent
    property int borderWidth: 1
    background: Rectangle {
        color: Theme.rgba(control.Material.foreground, 0.1)
        border.color: Theme.rgba(control.Material.foreground, 0.25)
        border.width: control.borderWidth
        radius: control.Material.roundedScale
    }
}
