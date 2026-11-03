import QtQuick
import QtQuick.Controls.Material
import QtQuick.Layouts
import "../../Controls"
import App.Core

/*!
    ColorEditorColorGenerator.qml

    - Eine Farbe kann über das TintColorPickerItem gewählt werden.
    - Die Rolle bestimmt welchen Kategorien die Farben zugeordnet werden.
        - zb. Hintergründe. Bei dieser Auswahl werden alle generierten Farben
            den Hintergründen zugeordnet.
    - Über den Farbmodus lassen sich verschiedene Farbkombinationen erstellem.
    - Die Anzahl der Farben kann in einer range von 1-10 festgelegt werden.
    - Mit dem Slider "Abstand" wird die Stufung der Farbunterschieder festgelegt.

    Über die "hinzufügen" Schaltfläche, werden alle generierten Farben in die jeweilig Rolle gespeichert.
*/
TintScrollView {
    id: colorEditorColorGenerator

    property int currentCategoryIndex: categoryFlick.currentIndex

    ColumnLayout {
        width: parent.width
        spacing: ControlStyle.spacing.smallest
        TintColorPickerItem {
            id: colorPickerItem
            Layout.fillWidth: true
        }

        GridLayout {
            columnSpacing: ControlStyle.spacing.medium
            columns: 2
            TintLabel {
                text: "Kategorie"
            }
            TintFlickSelector {
                id: categoryFlick
                Layout.fillWidth: true
                model: [ "Hintergründe", "Schriftfarben", "Rahmen", "Akzente", "Signale" ]
            }

            TintLabel {
                text: "Modus"
            }

            TintFlickSelector {
                id: modeFlick
                Layout.fillWidth: true
                // QStringList ColorGenerator::modes aus colorgenerator.h/cpp
                model: ColorGenerator.modes
            }

            TintLabel {
                text: "Farben"
            }
            TintSpinBox {
                id: colorCountSb
                Layout.fillWidth: true
                from: 1

                to: {
                    if ( ColorModel.count > ColorModel.maxColorCount - 6 ) {
                        return Math.max(1, ColorModel.maxColorCount - ColorModel.count)
                    }

                    return 6
                }

                value: 5
            }

            // Model ColorGenerator::generatedColors aus colorgenerator.h/cpp
            TintColorColumn {
                Layout.fillWidth: true
                Layout.columnSpan: 2
                model: ColorGenerator.generatedColors(
                                    modeFlick.currentIndex, colorPickerItem.selectedColor,
                                    colorCountSb.value, valueSlider.value, colorPickerItem.__hue)}

            TintLabel {
                text: "Abstand"
            }
            Slider {
                id: valueSlider
                from: 0.001
                to: 1
                stepSize: 0.001
                value: 0.5
                wheelEnabled: true
                Layout.fillWidth: true
            }
        }

        Item {
            Layout.fillHeight: true
        }
    }
}
