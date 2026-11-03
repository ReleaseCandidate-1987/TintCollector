import QtQuick
import QtCore

Settings {
    id: appSettings

    property var initSettings: {
        Qt.application.name = "TintCollector"
        Qt.application.domain = "TintCollector.de"
        Qt.application.organization = "TintCollector_org"
    }

    property bool isDarkMode: true
    property bool sideBarVisible: true
    property bool colorEditorVisible: true
    property int currentEditorIndex: 0
    property bool showAboutDialogAtStart: true

    onIsDarkModeChanged: Theme.isDarkMode = isDarkMode;
}
