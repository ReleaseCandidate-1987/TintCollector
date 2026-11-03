
import QtQuick
import QtQuick.Controls.Material
import QtQuick.Layouts
import "../../Controls"

/*!
    MainItemContent.qml
*/
TintScrollView {
    id: mainItemContent

    property var colorModels: sideBar.colorModels
    property var __reapterItems: Array.from({ length: repeater.count }, (_, i) => repeater.itemAt(i))
    property bool anyOpen: __reapterItems.some(item => item.open)
    property bool allOpen: __reapterItems.every(item => item.open)

    function expand(show = true) {
        __reapterItems.forEach(item => item.open = show)
    }

    function dropColor(sourceCategory, sourceIndex, sceneX, sceneY) {
        for (let index = 0; index < repeater.count; ++index) {
            const container = repeater.itemAt(index);
            if (!container)
                continue;

            const position = container.mapFromItem(null, sceneX, sceneY);

            if (!container.contains(position))
                continue;

            ColorModel.moveColor(sourceCategory, sourceIndex,
                                 container.categoryIndex,
                                 container.dropIndex(sceneX, sceneY));
            return;
        }
    }

    ColumnLayout {
        id: contentLayout
        width: parent.width
        spacing: ControlStyle.spacing.smallest
        visible: PaletteModel.count > 0
        Repeater {
            id: repeater
            model: [
                { name: "Hintergründe", model: mainItemContent.colorModels.backgrounds },
                { name: "Schriftfarben", model: mainItemContent.colorModels.textColors },
                { name: "Rahmen", model: mainItemContent.colorModels.borders },
                { name: "Akzente", model: mainItemContent.colorModels.accents },
                { name: "Signale", model: mainItemContent.colorModels.signalColors }
            ]

            ColorContainer {
                name: modelData.name
                model: modelData.model ?? null
                categoryIndex: index

                onColorDropped: function(sourceIndex, sceneX, sceneY) {
                    mainItemContent.dropColor(categoryIndex, sourceIndex, sceneX, sceneY);
                }
            }
        }
    }
}
