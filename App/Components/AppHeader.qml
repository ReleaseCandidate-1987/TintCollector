import QtQuick
import QtQuick.Controls.Material
import QtQuick.Layouts
import "../Controls"
import "SideBarItems"
/*!
    AppHeader.qml

    Zeigt den Titel der Anwendung...
*/
Item {
    id: appHeader
    implicitHeight: ControlStyle.controlSize.normal



    property alias searchFieldOpen: searchField.popup.visible
    RowLayout {
        id: __titleLayout
        spacing: ControlStyle.spacing.small
        anchors.verticalCenter: parent.verticalCenter

        // Blendet die SideBar ein / aus
        TintFlatButton {
            icon.source: Icons.menu
            checkable: true
            checked: appSettings.sideBarVisible
            toolTipText: `Blendet die <b>Seitenleiste</b> ${checked ? 'aus':'ein'}`
            onCheckedChanged: appSettings.sideBarVisible = checked;
        }
        
        // Zeigt den Titel der Anwendung
        TintLabel {
            visible: appHeader.width > 580
            textFormat: Text.RichText
            text: `<span style="color: ${Theme.accent}; font-weight: 900;">TINT</span>COLLECTOR`
        }
    }

    TintSearchField {
        id: searchField
        suggestionModel: PaletteSearchModel
        textRole: "name"

        x: Math.max(__titleLayout.width + ControlStyle.spacing.medium,
                    (parent.width - width) / 2
                    )
        width: Math.max(180, Math.min(400, appHeader.width * 0.6))
        anchors.verticalCenter: parent.verticalCenter
        onTextEdited: PaletteSearchModel.setFilterFixedString(text)
                onClearButtonPressed: PaletteSearchModel.setFilterFixedString("")
        onActivated: function(idx) {
            const targetIndex = PaletteSearchModel.sourceIndex(idx);
            if ( targetIndex < 0 )
                return;

            sideBar.palettesListView.currentIndex = targetIndex;
            text = "";
            searchField.focus = false;
        }

        delegate: PaletteDelegate {
            width: searchField.popup.availableWidth
            buttonVisible: false
        }
    }

    RowLayout {
        id: buttons
        x: parent.width - width
        anchors.verticalCenter: parent.verticalCenter

        TintFlatButton {
            icon.source: Icons.circle_help
            toolTipText: `Über.`
            onClicked: aboutDialogComponent.createObject(app).open()
        }

        TintFlatButton {
            icon.source: appSettings.isDarkMode ? Icons.light_mode : Icons.dark_mode
            toolTipText: `Wechselt zwischen hellem und dunklem Modus.`
            onClicked: appSettings.isDarkMode = !appSettings.isDarkMode;
        }

        TintFlatButton {
            visible: PaletteModel.count > 0
            icon.source: Icons.accents
            checkable: true
            checked: appSettings.colorEditorVisible
            toolTipText: `Blendet den <b>Farbeditor</b> ${checked ? 'aus':'ein'}`
            onCheckedChanged: appSettings.colorEditorVisible = checked;
        }
    }


}
