import QtQuick
import QtQuick.Controls.Material

SpinBox {
    id: control
    implicitHeight: ControlStyle.controlSize.normal
    wheelEnabled: true

    Material.accent: Theme.accent
    Material.foreground: Theme.foregroundColor.primary
    font: Fonts.control

    background: Rectangle {
        radius: ControlStyle.radius.small
        color: Theme.backgroundColor.primary
        border.color: control.activeFocus ? Theme.accent : control.hovered ? Theme.borderLighter : Theme.border
        Behavior on border.color { ColorAnimation { duration: 200 } }
    }

    up.indicator: TintFlatButton {
        z: 1
        x: control.mirrored ? 0 : control.width - width - 4
        y: (control.height - height) / 2
        height: control.height - 8
        icon.source: Icons.add
        onClicked: control.increase()
    }

    down.indicator: TintFlatButton {
        x: control.mirrored ? control.width - width -4 : 4
        y: (control.height - height) / 2
        height: control.height - 8
        icon.source: Icons.remove
        onClicked: control.decrease()
    }
}
