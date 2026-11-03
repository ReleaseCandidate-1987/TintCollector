import QtQuick
import QtQuick.Controls.Material

TintHighlightLabel {
    id: control
    Material.roundedScale: ControlStyle.radius.full
    padding: ControlStyle.spacing.smallest
    leftPadding: ControlStyle.spacing.small + __img.width
    rightPadding: ControlStyle.spacing.medium - 4
    borderWidth: 0
    Material.foreground: isValid ? Theme.accent : Theme.red
    property bool isValid: true
    text: isValid ? "Gültig" : "Ungültig"

    TintColorImage {
        id: __img
        height: control.height - control.topPadding - control.bottomPadding
        width: height
        y: (control.height - height) / 2
        x: ControlStyle.spacing.smallest
        color: control.Material.foreground
        source: Icons.circle_check
    }

}
