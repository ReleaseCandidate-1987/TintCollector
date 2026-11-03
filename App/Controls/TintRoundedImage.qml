import QtQuick
import QtQuick.Controls.Material
import QtQuick.Layouts
import QtQuick.Effects

Item {
    id: control
    Material.roundedScale: ControlStyle.radius.small
    property url source: "../../assets/b1.png"
    property bool hasSource: source.toString().length > 0

    signal clicked

    scale: __img.status !== Image.Ready ? 0 : 1
    opacity: scale
    Behavior on scale { NumberAnimation { duration: 200; easing.type: Easing.InOutQuad } }

    Rectangle {
        id: sourceRectangle
        visible: false
        layer.enabled: true
        anchors.fill: parent
        radius: control.Material.roundedScale
    }
    
    Image {
        id: __img
        anchors.fill: parent
        source: control.source
        fillMode: Image.PreserveAspectFit

        layer.enabled: true

        layer.effect: MultiEffect {
            maskSource: sourceRectangle
            maskEnabled: true
            maskThresholdMin: 0.5
            maskSpreadAtMin: 1.0
        }
    }
    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        onClicked: control.clicked()
    }
}
