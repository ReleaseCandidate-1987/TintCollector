import QtQuick
import QtQuick.Templates as T
import QtQuick.Controls.impl
import QtQuick.Controls.Material
import QtQuick.Controls.Material.impl

T.Button {
    id: control

    implicitWidth: display === AbstractButton.IconOnly
                   ? height : Math.max(implicitBackgroundWidth + leftInset + rightInset,
                            implicitContentWidth + leftPadding + rightPadding)
    implicitHeight: ControlStyle.controlSize.normal
    HoverHandler { cursorShape: Qt.PointingHandCursor }

    topInset: 0
    bottomInset: 0
    topPadding: 0
    bottomPadding: 0

    leftPadding: display === AbstractButton.IconOnly
                 ? ControlStyle.spacing.smallest : Material.buttonLeftPadding(flat, hasIcon && (display !== AbstractButton.TextOnly))
    rightPadding: display === AbstractButton.IconOnly
                  ? ControlStyle.spacing.smallest : Material.buttonRightPadding(flat, hasIcon && (display !== AbstractButton.TextOnly),
                                              (text !== "") && (display !== AbstractButton.IconOnly))

    spacing: ControlStyle.spacing.small

    icon.width: 24
    icon.height: 24
    icon.color: !enabled ? Material.hintTextColor :
        (control.flat && control.highlighted) || (control.checked && !control.highlighted) ? Material.accentColor :
        highlighted ? Material.primaryHighlightedTextColor : Material.foreground

    readonly property bool hasIcon: icon.name.length > 0 || icon.source.toString().length > 0

    Material.background: flat ? Theme.transparent : Theme.backgroundColor.primary
    Material.elevation: control.down ? 8 : 2
    Material.roundedScale: ControlStyle.radius.small
    Material.foreground: Theme.foregroundColor.primary
    font: Fonts.control

    property string toolTipText: ""
    property int iconRotation: 0
    property var menuRef: null

    TintToolTip {
        visible: control.enabled && control.hovered && control.toolTipText.trim().length > 0
        text: control.toolTipText
    }

    contentItem: IconLabel {
        spacing: control.spacing
        mirrored: control.mirrored
        display: control.display
        rotation: control.iconRotation
        Behavior on rotation { NumberAnimation { duration: 150; easing.type: Easing.InOutQuad } }
        icon: control.icon
        text: control.text
        font: control.font
        color: !control.enabled ? control.Material.hintTextColor :
            (control.flat && control.highlighted) || (control.checked && !control.highlighted) ? control.Material.accentColor :
            control.highlighted ? control.Material.primaryHighlightedTextColor : control.Material.foreground
    }

    background: Rectangle {
        implicitWidth: 64
        implicitHeight: control.Material.buttonHeight

        radius: control.Material.roundedScale === Material.FullScale ? height / 2 : control.Material.roundedScale
        color: control.Material.buttonColor(control.Material.theme, control.Material.background,
            control.Material.accent, control.enabled, control.flat, control.highlighted, control.checked)

        border.color: Theme.border
        border.width: control.flat ? 0 : 1
        layer.enabled: control.enabled && color.a > 0 && !control.flat
        layer.effect: RoundedElevationEffect {
            elevation: control.Material.elevation
            roundedScale: control.background.radius
        }

        Ripple {
            clip: true
            clipRadius: parent.radius
            width: parent.width
            height: parent.height
            pressed: control.pressed
            anchor: control
            active: enabled && (control.down || control.visualFocus || control.hovered)
            color: control.flat && control.highlighted ? control.Material.highlightedRippleColor : control.Material.rippleColor
        }
    }
}
