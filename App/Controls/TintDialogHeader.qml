import QtQuick
import QtQuick.Controls.Material
import QtQuick.Layouts

Control {
    id: control
    property string title: "Title"
    property string subTitle: "subTitle"
    property font titleFont: Fonts.labelBold
    property url iconSource: Icons.close

    signal buttonClicked()

    contentItem: ColumnLayout {
        spacing: ControlStyle.spacing.none
        RowLayout {
            spacing: ControlStyle.spacing.small
            TintLabel {
                font: control.titleFont
                Layout.fillWidth: true
                text: control.title
                elide: Text.ElideRight
            }

            TintFlatButton{
                flat: true
                Layout.preferredHeight: ControlStyle.controlSize.small
                Layout.preferredWidth: ControlStyle.controlSize.small
                icon.source: control.iconSource
                onClicked: control.buttonClicked()
            }
        }
        TintLabel {
            visible: text.trim().length > 0
            font: Fonts.small
            Material.foreground: Theme.foregroundColor.secondary
            Layout.fillWidth: true
            text: control.subTitle
            wrapMode: Text.WordWrap
        }
    }
}
