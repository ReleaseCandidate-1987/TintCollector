import QtQuick
import QtQuick.Controls.Material

TintButton {
    id: control
    flat: true
    implicitHeight: ControlStyle.controlSize.small
    padding: ControlStyle.spacing.smallest
    topPadding: padding >= 0 ? padding : ControlStyle.spacing.smallest
    bottomPadding: padding >= 0 ? padding : ControlStyle.spacing.smallest
    leftPadding: padding >= 0 ? padding : ControlStyle.spacing.smallest
    rightPadding: padding >= 0 ? padding : ControlStyle.spacing.smallest
    display: AbstractButton.IconOnly
    icon.source: Icons.more_vert

    icon.width: height * 0.75
    icon.height: height * 0.75
}
