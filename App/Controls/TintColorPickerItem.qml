import QtQuick
import QtQuick.Layouts
import QtQuick.Controls.Material

Item {
    id: colorPickerItem
    implicitWidth: 300
    implicitHeight: clayout.implicitHeight

    opacity: enabled ? 1 : 0.5
    property color currentColor: "blue"
    readonly property color selectedColor: Qt.hsva(__hue, __saturation, __value, __alpha)
    
    property real __hue: 0
    property real __saturation: 1
    property real __value: 1
    property real __alpha: 1
    
    signal colorSelected(color color)
    signal released(color color)
    
    function synchronizeColor() {
        if (Qt.colorEqual(currentColor, selectedColor))
            return;
        if (currentColor.hsvHue >= 0)
            __hue = currentColor.hsvHue;
        __saturation = currentColor.hsvSaturation;
        __value = currentColor.hsvValue;
        __alpha = currentColor.a;
    }
    
    function selectPosition(px: real, py: real) {
        if (field.width <= 0 || field.height <= 0)
            return;
        __saturation = Math.max(0, Math.min(1, px / field.width));
        __value = 1 - Math.max(0, Math.min(1, py / field.height));
        colorSelected(selectedColor);
    }
    
    onCurrentColorChanged: synchronizeColor()
    Component.onCompleted: synchronizeColor()
    
    ColumnLayout {
        id: clayout
        anchors.fill: parent
        spacing: ControlStyle.spacing.small
        
        Item {
            id: field
            Layout.fillWidth: true
            Layout.preferredHeight: 250
            Layout.margins: 8
            
            Rectangle {
                anchors.fill: parent
                color: Qt.hsva(colorPickerItem.__hue, 1, 1, 1)
            }
            
            Rectangle {
                anchors.fill: parent
                gradient: Gradient {
                    orientation: Gradient.Horizontal
                    GradientStop { position: 0; color: "#ffffffff" }
                    GradientStop { position: 1; color: "#00ffffff" }
                }
            }
            
            Rectangle {
                anchors.fill: parent
                gradient: Gradient {
                    orientation: Gradient.Vertical
                    GradientStop { position: 0; color: "#00000000" }
                    GradientStop { position: 1; color: "#ff000000" }
                }
            }
            
            Rectangle {
                id: picker
                x: colorPickerItem.__saturation * field.width - width / 2
                y: (1 - colorPickerItem.__value) * field.height - height / 2
                width: 20
                height: 20
                radius: height / 2
                color: "black"
                
                Rectangle {
                    id: pickerRect
                    anchors.fill: parent
                    anchors.margins: 2
                    radius: height / 2
                    color: Qt.hsva(colorPickerItem.__hue, colorPickerItem.__saturation, colorPickerItem.__value, 1)
                    border.width: 1
                    border.color: "white"
                }
            }
            
            MouseArea {
                id: area
                anchors.fill: parent
                acceptedButtons: Qt.LeftButton
                preventStealing: true
                cursorShape: Qt.CrossCursor
                
                onPressed: function(mouse) {
                    colorPickerItem.selectPosition(mouse.x, mouse.y);
                    colorPickerItem.forceActiveFocus();
                }
                onPositionChanged: function(mouse) {
                    if (pressed)
                        colorPickerItem.selectPosition(mouse.x, mouse.y);
                }
                onReleased: colorPickerItem.released( colorPickerItem.selectedColor )
            }
        }
        
        Slider {
            id: hueSlider
            Layout.fillWidth: true
            implicitWidth: 32
            from: 0
            to: 1
            value: colorPickerItem.__hue
            stepSize: 0
            live: true
            padding: 0
            leftPadding: 0
            rightPadding: 0

            onMoved: {
                colorPickerItem.__hue = value;
                colorPickerItem.colorSelected(colorPickerItem.selectedColor);
            }

            onPressedChanged: {
                if (!pressed) {
                    colorPickerItem.released(colorPickerItem.selectedColor);
                }

            }
            
            background: Rectangle {
                x: hueSlider.leftPadding + hueSlider.handle.width / 2
                y: hueSlider.topPadding + (hueSlider.availableHeight - height) / 2
                width: Math.max(0, hueSlider.availableWidth - hueSlider.handle.width)
                height: 16
                radius: height / 2
                scale: hueSlider.mirrored ? -1 : 1
                
                gradient: Gradient {
                    orientation: Gradient.Horizontal
                    GradientStop { position: 0; color: "#ff0000" }
                    GradientStop { position: 1 / 6; color: "#ffff00" }
                    GradientStop { position: 2 / 6; color: "#00ff00" }
                    GradientStop { position: 3 / 6; color: "#00ffff" }
                    GradientStop { position: 4 / 6; color: "#0000ff" }
                    GradientStop { position: 5 / 6; color: "#ff00ff" }
                    GradientStop { position: 1; color: "#ff0000" }
                }
            }
            
            handle: Rectangle {
                x: hueSlider.leftPadding + hueSlider.visualPosition * (hueSlider.availableWidth - width)
                y: hueSlider.topPadding + (hueSlider.availableHeight - height) / 2
                implicitWidth: 24
                implicitHeight: 24
                radius: height / 2
                color: "black"
                
                Rectangle {
                    anchors.fill: parent
                    anchors.margins: 2
                    radius: height / 2
                    color: Qt.hsva(hueSlider.value, 1, 1, 1)
                    border.width: 2
                    border.color: "white"
                }
            }
        }

        RowLayout {
            TintTextField {
                id: hexField
                Layout.fillWidth: true
                lengthLabelVisible: false
                Binding {
                    target: hexField
                    property: "text"
                    value: colorPickerItem.selectedColor.toString()
                    when: !hexField.activeFocus
                    restoreMode: Binding.RestoreNone
                }

                validator: RegularExpressionValidator {
                    regularExpression: /^#(?:[a-fA-F0-9]{3}|[a-fA-F0-9]{6})$/
                }

                onTextEdited: {
                    if ( !acceptableInput )
                        return;
                    colorPickerItem.currentColor = text;
                    colorPickerItem.colorSelected(colorPickerItem.selectedColor)
                }
            }

            Rectangle {
                Layout.preferredHeight: ControlStyle.controlSize.normal
                Layout.preferredWidth: ControlStyle.controlSize.normal
                color: colorPickerItem.selectedColor
                border.color: "black"
                radius: ControlStyle.spacing.smallest
            }
        }
    }
}
