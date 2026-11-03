import QtQuick
import QtQuick.Templates as T
import QtQuick.Controls.impl
import QtQuick.Controls.Material
import QtQuick.Controls.Material.impl

T.TextField {
    id: control

    implicitWidth: implicitBackgroundWidth + leftInset + rightInset
                   || Math.max(contentWidth, placeholder.implicitWidth) + leftPadding + rightPadding
    implicitHeight: ControlStyle.controlSize.normal + topInset + bottomInset
    maximumLength: 24
    Material.background: Theme.backgroundColor.primary
    Material.foreground: Theme.foregroundColor.primary
    Material.accent: Theme.accent
    selectedTextColor: Theme.foregroundColor.dark
    font: Fonts.control
    topInset: clip ? placeholder.largestHeight / 2 : 0

    leftPadding: ControlStyle.spacing.medium
    rightPadding: __lengthLbl.visible
    ? ControlStyle.spacing.medium * 2 + lengthLabelWidth : ControlStyle.spacing.medium

    topPadding: Material.containerStyle === Material.Filled
                ? placeholderText.length > 0 && (activeFocus || length > 0)
                  ? Material.textFieldVerticalPadding + placeholder.largestHeight
                  : Material.textFieldVerticalPadding

    : Material.textFieldVerticalPadding + topInset
    bottomPadding: Material.textFieldVerticalPadding

    color: enabled ? Material.foreground : Material.hintTextColor
    selectionColor: Material.accentColor
    placeholderTextColor: enabled && activeFocus ? Material.accentColor : Material.hintTextColor
    verticalAlignment: TextInput.AlignVCenter

    Material.containerStyle: Material.Outlined
    property bool lengthLabelVisible: true
    readonly property int lengthLabelWidth: __lengthLbl.implicitWidth
    property int lengthLabelRightMargin: ControlStyle.spacing.medium
    TintLabel {
        id: __lengthLbl
        visible: control.lengthLabelVisible
        y: (control.height - height ) / 2
        x: control.width - width - control.lengthLabelRightMargin
        text: `${control.length} / ${control.maximumLength}`
        font: Fonts.small
    }

    cursorDelegate: CursorDelegate { }

    FloatingPlaceholderText {
        id: placeholder
        width: control.width - (control.leftPadding + control.rightPadding)
        text: control.placeholderText
        font: control.font
        color: control.placeholderTextColor
        elide: Text.ElideRight
        renderType: control.renderType


        filled: control.Material.containerStyle === Material.Filled
        verticalPadding: control.Material.textFieldVerticalPadding
        controlHasActiveFocus: control.activeFocus
        controlHasText: control.length > 0
        controlImplicitBackgroundHeight: control.implicitBackgroundHeight
        controlHeight: control.height
        leftPadding: control.leftPadding
        floatingLeftPadding: control.Material.textFieldHorizontalPadding

        Behavior on color { ColorAnimation { duration: 200 } }
    }

    background: Rectangle {
        implicitWidth: 120
        implicitHeight: control.Material.textFieldHeight
        color: control.Material.backgroundColor
        radius: 4
        MaterialTextContainer {
            anchors.fill: parent
            filled: control.Material.containerStyle === Material.Filled
            fillColor: control.Material.backgroundColor
            outlineColor: !enabled
                          ? Theme.border : control.activeFocus
                            ? control.Material.accentColor : control.hovered
                            ? Theme.borderLighter : Theme.border

            focusedOutlineColor: control.Material.accentColor
            placeholderTextWidth: Math.min(placeholder.width, placeholder.implicitWidth) * placeholder.scale
            placeholderTextHAlign: control.effectiveHorizontalAlignment
            controlHasActiveFocus: control.activeFocus
            controlHasText: control.length > 0
            placeholderHasText: placeholder.text.length > 0
            horizontalPadding: control.Material.textFieldHorizontalPadding

            Behavior on outlineColor { ColorAnimation { duration: 200 } }

        }

    }
}




















