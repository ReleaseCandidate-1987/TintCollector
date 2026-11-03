
import QtQuick
import QtQuick.Controls.Material
import QtQuick.Layouts
import App.Core
import "../../Controls"

TintItemDelegate {
    id: colorContainerDelegate
    width: ListView.view.width

    required property int index
    required property string name
    required property string colorCode
    required property int _id


    function sourceIndex() {
        const proxyModel = colorContainerDelegate.ListView.view.model;
        return proxyModel.mapToSource(proxyModel.index(index, 0)).row;
    }

    signal removeRequested()
    signal renameRequested()

    text: index
    onClicked: __listView.currentIndex = index;

    Rectangle {
        width: parent.width
        height: 1
        color: Theme.border
    }

    onRightClicked: function(px, py) {
        __listView.currentIndex = index;
        moreBtn.menuRef = moreMenuContainer.createObject(colorContainerDelegate);
        moreBtn.menuRef.parent = colorContainerDelegate;
        moreBtn.menuRef.x = px;
        moreBtn.menuRef.y = py;
        moreBtn.menuRef.open();
        moreBtn.menuRef.onClosed.connect(() => {
            if (moreBtn)
                moreBtn.menuRef = null;
        });
    }

    contentItem: RowLayout {
        spacing: ControlStyle.spacing.smallest

        TintButton {
            id: btn
            Layout.preferredHeight: 42
            Layout.preferredWidth: 42
            Material.background: colorCode

            onClicked: {
                __listView.currentIndex = index;

                if (menuRef)
                    return;

                menuRef = colorPickerComponent.createObject();
                menuRef.selectColorOnly = true;
                menuRef.subTitle = "Wähle ein Farbe aus.";
                menuRef.currentColor = colorCode;
                menuRef.open();

                menuRef.onClosed.connect(() => {
                    if (btn)
                        menuRef = null;
                });
            }
        }

        ColumnLayout {
            Layout.leftMargin: ControlStyle.spacing.medium
            spacing: 0

            TintLabel {
                Layout.fillWidth: true
                elide: Text.ElideRight
                font: Fonts.controlBold
                text: name
            }

            TintLabel {
                font: Fonts.small
                text: colorCode.toUpperCase()
            }
        }

        TintFlatButton {
            icon.source: Icons.content_copy

            onClicked: {
                __listView.currentIndex = index;
                Clipboard.setText(btn.Material.backgroundColor.toString());
            }
        }

        TintFlatButton {
            id: moreBtn
            icon.source: Icons.more_vert

            onClicked: {
                __listView.currentIndex = index;

                if (menuRef)
                    return;

                menuRef = moreMenuContainer.createObject(this);
                menuRef.open();

                menuRef.onClosed.connect(() => {
                    if (moreBtn)
                        moreBtn.menuRef = null;
                });
            }

            Component {
                id: moreMenuContainer
                ColorContainerMoreMenu {
                    id: colorContainerMoreMenu
                }
            }
        }
    }
}
