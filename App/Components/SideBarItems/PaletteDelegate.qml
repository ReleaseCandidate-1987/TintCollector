import QtQuick
import QtQuick.Controls.Material
import QtQuick.Layouts
import "../../Controls"

TintItemDelegate {
    id: paletteDelegate

    required property string name
    required property int index
    required property int _id
    required property int colorCount
    required property var previewColors
    property bool buttonVisible: true

    text: name
    rightPadding: ControlStyle.spacing.small
    Material.background: Theme.transparent
    Material.primary: Theme.rgba(Theme.accent, 0.1)
    highlighted: ListView.view.currentIndex === index
    borderWidth: 0

    signal removeRequested()
    signal renameRequested()

    onClicked: {
        ListView.view.currentIndex = index;
    }

    onRightClicked: function ( px, py ) {
        ListView.view.currentIndex = index;
        moreBtn.menuRef = paletteDelegateMenuComponent.createObject(this);
        moreBtn.menuRef.x = px;
        moreBtn.menuRef.y = py;
        moreBtn.menuRef.open();
        moreBtn.menuRef.onClosed.connect( function() {
            if ( moreBtn )
                moreBtn.menuRef = null;
        } );
    }
    
    contentItem: Item {
        implicitHeight: glayout.implicitHeight
        ColumnLayout {
            id: glayout
            anchors.fill: parent
            anchors.rightMargin: moreBtn.visible ? moreBtn.width : 0
            spacing: 0
            TintLabel {
                text: paletteDelegate.text
                elide: "ElideRight"
                Layout.fillWidth: true
                Material.foreground: paletteDelegate.Material.foreground
                font.bold: paletteDelegate.highlighted
            }

            TintLabel {
                visible: colorCount === 0
                text: "Keine Farben"
                font: Fonts.small
                Material.foreground: Theme.foregroundColor.secondary
            }

            RowLayout {
                visible: colorCount > 0
                spacing: 0
                Repeater {
                    model: previewColors

                    Rectangle {
                        Layout.preferredWidth: 12
                        Layout.preferredHeight: 12
                        color: modelData
                        border.color: Theme.border
                    }
                }
            }
        }
        TintFlatButton {
            id: moreBtn
            visible: paletteDelegate.buttonVisible && (paletteDelegate.hovered || hovered)
            x: parent.width - width
            y: (parent.height - height) / 2
            icon.source: Icons.more_vert
            Material.foreground: paletteDelegate.Material.foreground
            onClicked: {
                paletteDelegate.ListView.view.currentIndex = index;
                if ( moreBtn.menuRef )
                    return;
                moreBtn.menuRef = paletteDelegateMenuComponent.createObject(this);
                moreBtn.menuRef.x = width + 4
                moreBtn.menuRef.y = -8
                moreBtn.menuRef.open();
                moreBtn.menuRef.onClosed.connect( function() {
                    if ( moreBtn )
                        moreBtn.menuRef = null;
                } );
            }
        }
    }

    Component { id: paletteDelegateMenuComponent; PaletteDelegateMoreMenu { } }
}
