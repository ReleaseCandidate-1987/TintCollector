import QtQuick
import QtQuick.Controls.Material
import QtQuick.Layouts

Control {
    id: control
    padding: ControlStyle.spacing.medium
    property color __clr: isValid ? Theme.accent : Theme.red
    Material.accent: __clr
    Behavior on __clr { ColorAnimation { duration: 150 } }

    property string placeholderText: "Name"
    property string tipp: "This is a Tip."
    property bool isValid: false
    
    property alias validator: __tf.validator
    property alias text: __tf.text
    readonly property bool acceptableInput : __tf.acceptableInput
    signal accepted

    function selectAll() {
        __tf.selectAll();
    }
    
    onFocusChanged: {
        if ( focus )
            __tf.forceActiveFocus()
    }
    
    background: Rectangle {
        color: Theme.rgba(control.Material.accent, 0.05)
        border.color: Theme.rgba(control.Material.accent, 0.75)
        radius: ControlStyle.radius.small
    }
    
    contentItem: ColumnLayout {
        spacing: ControlStyle.spacing.none
        RowLayout {
            TintLabel {
                font: Fonts.smallBold
                text: control.placeholderText
                Layout.fillWidth: true
                Material.foreground: control.Material.accent
            }
            TintValidLabel {
                isValid: control.isValid
            }
        }
        
        TintTextField {
            id: __tf
            leftPadding: ControlStyle.spacing.none
            lengthLabelRightMargin: ControlStyle.spacing.none
            Layout.fillWidth: true
            selectionColor: control.Material.accentColor
            background: Item {
                TintBorderItem {
                    strokeColor: control.Material.accent
                    drawBottom: true
                }
            }
            onAccepted: control.accepted()
        }
        
        TintLabel {
            Layout.topMargin: ControlStyle.spacing.smallest
            visible: text.trim().length > 0
            text: control.tipp
            Layout.fillWidth: true
            wrapMode: "WordWrap"
            font: Fonts.small
            topPadding: 0
            Material.foreground: control.Material.accent
        }
    }
}
