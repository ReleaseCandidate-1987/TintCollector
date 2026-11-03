import QtQuick
import QtQuick.Controls.Material
import QtQuick.Layouts
import "../../Controls"

Control {
    width: ListView.view.width
    padding:  ControlStyle.spacing.small

    contentItem: RowLayout {
        spacing: ControlStyle.spacing.small
        TintFlatButton {
            iconRotation: control.open ? 90 : 0
            icon.source: Icons.keyboard_arrow_right
            onClicked: control.open = !control.open
        }

        TintHighlightLabel {
            text: `${__listView.count}`
            leftPadding: ControlStyle.spacing.small
            rightPadding: ControlStyle.spacing.small
        }
        TintLabel {
            text: control.name
            font: Fonts.controlBold
            elide: Text.ElideRight
            Layout.fillWidth: true
            MouseArea {
                cursorShape: Qt.PointingHandCursor
                anchors.fill: parent; onDoubleClicked: control.open = !control.open
            }
        }

        TintFlatButton {
            id: colorPickerBtn
            icon.source: Icons.add
            toolTipText: `<font color="${Theme.accent}"><b>${control.name}</b></font><br>Dieser Kategorie eine Farbe <b>hinzufügen</b>`
            onClicked: {
                if ( menuRef )
                    return;

                menuRef = colorPickerComponent.createObject();
                menuRef.open();
                menuRef.onClosed.connect( () => {
                                             if ( colorPickerBtn )
                                             menuRef = null
                                         } );
            }
        }
    }
}