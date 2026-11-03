import QtQuick
import QtQuick.Controls.Material
import QtQuick.Layouts
import "Controls"
import "Components"

/*!
    App.qml

    Hauptkomponente für die Darstellung von:
        - Header        🠒 Titel der Anwendung.
        - Footer        🠒 Statusleiste / Aufzählungen.
        - SideBar       🠒 Palettenübersicht.
        - ColorEditor   🠒 Hinzufügen / Editieren weiterer Farben.
        - MainItem      🠒 Darstellung der Farben.
*/
TintAppPage {
    id: app
    width: Theme.width
    height: Theme.height
    anchors.fill: parent

    property bool anyDialogOpen: false

    AppSettings { id: appSettings }

    header: AppHeader { id: appHeader }
    footer: AppFooter { id: appFooter }
    sideBar: SideBar { id: sideBar }
    colorEditor: ColorEditor { id: colorEditor }
    contentItem: MainItem { id: mainItem }


    function todo( whatTODO: string ) {
        console.log( "TODO:", whatTODO )
        console.trace()
        console.log( "=".repeat(100) )
    }

    TintToast { }

    Component { id: aboutDialogComponent; AboutDialog { } }
    Component.onCompleted: {
        if ( appSettings.showAboutDialogAtStart )
            aboutDialogComponent.createObject(app).open()
    }
}















