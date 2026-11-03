import QtQuick
import QtQuick.Controls.Material
import QtQuick.Controls.Material.impl
import QtQuick.Layouts
import QtQuick.Effects
Popup {
    id: control
    leftPadding: ControlStyle.spacing.medium
    rightPadding: ControlStyle.spacing.medium
    bottomPadding: ControlStyle.spacing.medium
    topPadding: __titleRow.visible
                ? __titleRow.implicitHeight + __titleRow.y + ControlStyle.spacing.medium
                : ControlStyle.spacing.medium
    width: 300
    Material.background: Theme.backgroundColor.tertiary
    Material.roundedScale: ControlStyle.radius.medium
    Material.elevation: ControlStyle.elevation.dialogs

    property string title: ""
    property font titleFont: Fonts.controlBold
    property string subTitle: ""

    readonly property Item header: TintDialogHeader {
        id: __titleRow
        z: 1
        parent: control.contentItem ? control.contentItem.parent : null
        title: control.title
        titleFont: control.titleFont
        subTitle: control.subTitle
        x: control.leftPadding
        y: ControlStyle.spacing.small
        width: control.availableWidth + ControlStyle.spacing.small
        visible: control.title.trim().length > 0
        onButtonClicked: control.close()
    }

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
