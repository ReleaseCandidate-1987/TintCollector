import QtQuick
import QtQuick.Controls.Material
import QtQuick.Controls.Material.impl

Menu {
    id: control
    leftPadding: ControlStyle.spacing.small
    rightPadding: ControlStyle.spacing.small
    bottomPadding: ControlStyle.spacing.small
    topPadding: ControlStyle.spacing.small
    width: 200
    Material.background: Theme.backgroundColor.tertiary
    Material.roundedScale: ControlStyle.radius.small
    Material.elevation: ControlStyle.elevation.dialogs

    delegate: TintMenuItem {}

    background: Rectangle {
        implicitWidth: 200
        implicitHeight: control.Material.menuItemHeight
        radius: control.Material.roundedScale
        color: control.Material.dialogColor
        border.color: Theme.border
        layer.enabled: control.Material.elevation > 0
        layer.effect: RoundedElevationEffect {
            elevation: control.Material.elevation
            roundedScale: control.background.radius
        }
    }
}
