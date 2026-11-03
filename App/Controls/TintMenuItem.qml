import QtQuick
import QtQuick.Controls.Material
import QtQuick.Controls.impl

MenuItem {
    id: control
    Material.foreground: Theme.foregroundColor.primary
    Material.accent: Theme.accent
    implicitHeight: ControlStyle.controlSize.small
    icon.color: Material.foreground
    font: Fonts.small
    padding: ControlStyle.spacing.small
    topPadding: ControlStyle.spacing.small - 2
    bottomPadding: ControlStyle.spacing.small - 2
    spacing: ControlStyle.spacing.small
    property int alignment: Qt.AlignLeft


    contentItem: IconLabel {
        readonly property real arrowPadding: control.subMenu && control.arrow ? control.arrow.width + control.spacing : 0
        readonly property real indicatorPadding: control.checkable && control.indicator ? control.indicator.width + control.spacing : 0
        leftPadding: !control.mirrored ? indicatorPadding : arrowPadding
        rightPadding: control.mirrored ? indicatorPadding : arrowPadding

        spacing: control.spacing
        mirrored: control.mirrored
        display: control.display
        alignment: control.alignment

        icon: control.icon
        text: control.text
        font: control.font
        color: control.Material.foreground
    }

}
