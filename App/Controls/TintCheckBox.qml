import QtQuick
import QtQuick.Templates as T
import QtQuick.Controls.Material
import QtQuick.Controls.Material.impl

T.CheckBox {
    id: control

    implicitWidth: Math.max(implicitBackgroundWidth + leftInset + rightInset,
                            implicitContentWidth + leftPadding + rightPadding)
    implicitHeight: Math.max(implicitBackgroundHeight + topInset + bottomInset,
                             implicitContentHeight + topPadding + bottomPadding,
                             implicitIndicatorHeight + topPadding + bottomPadding)
    HoverHandler { cursorShape: Qt.PointingHandCursor }

    spacing: ControlStyle.spacing.small
    padding: ControlStyle.spacing.none
    rightPadding: ControlStyle.spacing.none
    verticalPadding: padding + 7
    LayoutMirroring.enabled: true
    Material.accent: Theme.accent
    Material.foreground: checked ? Theme.accent : Theme.foregroundColor.secondary
    font: checked ? Fonts.controlBold : Fonts.control

    contentItem: Text {
        leftPadding: control.indicator && !control.mirrored ? control.indicator.width + control.spacing : 0
        rightPadding: control.indicator && control.mirrored ? control.indicator.width + control.spacing : 0

        text: control.text
        font: control.font
        color: control.enabled ? control.Material.foreground : control.Material.hintTextColor
        elide: Text.ElideRight
        verticalAlignment: Text.AlignVCenter
    }


    indicator: Rectangle {
        id: indicatorItem
        implicitWidth: 24
        implicitHeight: 24
        color: control.checked ? control.Material.accentColor : Theme.transparent
        border.color: !control.enabled ? control.Material.hintTextColor
            : checkState !== Qt.Unchecked ? control.Material.accentColor : Theme.foregroundColor.secondary
        border.width: 1
        radius: ControlStyle.radius.smallest
        x: control.text
           ? (control.mirrored ? control.width - 24 : control.leftPadding)
           : control.leftPadding + (control.availableWidth - width) / 2
        y: control.topPadding + (control.availableHeight - height) / 2
        control: parent

        Ripple {
            x: (parent.width - width) / 2
            y: (parent.height - height) / 2
            width: 28; height: 28

            z: -1
            anchor: control
            pressed: control.pressed
            active: enabled && (control.down || control.visualFocus || control.hovered)
            color: control.checked ? control.Material.highlightedRippleColor : control.Material.rippleColor
        }

        property Item control
        property int checkState: control.checkState


        Behavior on border.color {
            ColorAnimation {
                duration: 100
                easing.type: Easing.OutCubic
            }
        }
        Behavior on color {
            ColorAnimation {
                duration: 100
                easing.type: Easing.OutCubic
            }
        }
        TintColorImage {
            id: checkImage
            x: (parent.width - width) / 2
            y: (parent.height - height) / 2
            width: 14
            height: 14
            color: Theme.foregroundColor.dark
            source: "qrc:/qt-project.org/imports/QtQuick/Controls/Material/images/check.png"
            fillMode: Image.PreserveAspectFit

            scale: indicatorItem.checkState === Qt.Checked ? 1 : 0
            Behavior on scale { NumberAnimation { duration: 100 } }
        }

        Rectangle {
            x: (parent.width - width) / 2
            y: (parent.height - height) / 2
            width: 12
            height: 3

            scale: indicatorItem.checkState === Qt.PartiallyChecked ? 1 : 0
            Behavior on scale { NumberAnimation { duration: 100 } }
        }

        states: [
            State {
                name: "checked"
                when: indicatorItem.checkState === Qt.Checked
            },
            State {
                name: "partiallychecked"
                when: indicatorItem.checkState === Qt.PartiallyChecked
            }
        ]

        transitions: Transition {
            SequentialAnimation {
                NumberAnimation {
                    target: indicatorItem
                    property: "scale"
                    // Go down 2 pixels in size.
                    to: 1 - 2 / indicatorItem.width
                    duration: 120
                }
                NumberAnimation {
                    target: indicatorItem
                    property: "scale"
                    to: 1
                    duration: 120
                }
            }
        }
    }
}
