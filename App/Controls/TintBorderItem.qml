import QtQuick
import QtQuick.Shapes

Shape {
    id: root
    anchors.fill: parent
    property bool drawTop: false
    property bool drawBottom: false
    property bool drawLeft: false
    property bool drawRight: false
    property color strokeColor: Theme.border
    property real strokeWidth: 1

    ShapePath {
        strokeColor: root.strokeColor
        strokeWidth: root.drawTop && root.strokeWidth > 0 ? root.strokeWidth : -1
        fillColor: "transparent"
        capStyle: ShapePath.FlatCap
        startX: 0
        startY: root.strokeWidth / 2

        PathLine { x: root.width; y: root.strokeWidth / 2 }
    }

    ShapePath {
        strokeColor: root.strokeColor
        strokeWidth: root.drawBottom && root.strokeWidth > 0 ? root.strokeWidth : -1
        fillColor: "transparent"
        capStyle: ShapePath.FlatCap
        startX: 0
        startY: root.height - root.strokeWidth / 2

        PathLine { x: root.width; y: root.height - root.strokeWidth / 2 }
    }

    ShapePath {
        strokeColor: root.strokeColor
        strokeWidth: root.drawLeft && root.strokeWidth > 0 ? root.strokeWidth : -1
        fillColor: "transparent"
        capStyle: ShapePath.FlatCap
        startX: root.strokeWidth / 2
        startY: root.drawTop ? root.strokeWidth : 0

        PathLine { x: root.strokeWidth / 2; y: root.height - (root.drawBottom ? root.strokeWidth : 0) }
    }

    ShapePath {
        strokeColor: root.strokeColor
        strokeWidth: root.drawRight && root.strokeWidth > 0 ? root.strokeWidth : -1
        fillColor: "transparent"
        capStyle: ShapePath.FlatCap
        startX: root.width - root.strokeWidth / 2
        startY: root.drawTop ? root.strokeWidth : 0

        PathLine { x: root.width - root.strokeWidth / 2; y: root.height - (root.drawBottom ? root.strokeWidth : 0) }
    }
}
