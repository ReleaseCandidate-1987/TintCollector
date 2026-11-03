import QtQuick
import QtQuick.Templates as T
import QtQuick.Controls.impl
import QtQuick.Controls.Material
import QtQuick.Controls.Material.impl

T.ItemDelegate {
    id: control

    implicitWidth: Math.max(implicitBackgroundWidth + leftInset + rightInset,
                            implicitContentWidth + leftPadding + rightPadding)
    implicitHeight: Math.max(implicitBackgroundHeight + topInset + bottomInset,
                             implicitContentHeight + topPadding + bottomPadding,
                             implicitIndicatorHeight + topPadding + bottomPadding)

    HoverHandler { cursorShape: Qt.PointingHandCursor }
    signal rightClicked( px: int, py: int )

    TapHandler {
        acceptedButtons: Qt.RightButton
        onTapped: function( ev ) {
            control.rightClicked( ev.position.x, ev.position.y )
        }
    }

    padding: ControlStyle.spacing.medium
    verticalPadding: 8
    spacing: ControlStyle.spacing.medium
    rightPadding: ControlStyle.spacing.small
    leftPadding: ControlStyle.spacing.small

    icon.width: 24
    icon.height: 24
    icon.color: enabled ? Material.foreground : Material.hintTextColor

    Material.background: Theme.transparent
    Material.foreground:  Theme.foregroundColor.primary
    Material.roundedScale: ControlStyle.radius.small
    Material.primary: Material.listHighlightColor
    font: Fonts.control
    property int borderWidth: 0
    property color borderColor: Theme.border

    contentItem: IconLabel {
        spacing: control.spacing
        mirrored: control.mirrored
        display: control.display
        alignment: control.display === IconLabel.IconOnly || control.display === IconLabel.TextUnderIcon ? Qt.AlignCenter : Qt.AlignLeft

        icon: control.icon
        text: control.text
        font: control.font
        color: control.enabled ? control.Material.foreground : control.Material.hintTextColor
    }

    background: Rectangle {
        implicitHeight: control.Material.delegateHeight
        radius: control.Material.roundedScale
        color: control.highlighted ? control.Material.primary : control.Material.backgroundColor

        border.color: control.borderColor
        border.width: control.borderWidth

        Behavior on color { ColorAnimation { duration: 150 } }

        Ripple {
            width: parent.width
            height: parent.height
            clipRadius: parent.radius
            clip: visible
            pressed: control.pressed
            anchor: control
            active: enabled && (control.down  || control.hovered)
            color: control.Material.rippleColor
        }
    }
}
