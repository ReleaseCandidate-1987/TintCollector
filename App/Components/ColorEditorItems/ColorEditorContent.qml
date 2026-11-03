import QtQuick
import QtQuick.Controls.Material
import QtQuick.Layouts
import QtQuick.Dialogs
import "../../Controls"

StackLayout {
    id: colorEditorContent
    currentIndex: appSettings.currentEditorIndex

    ColorEditorImageColorGenerator { id: colorEditorImageColorGenerator }

}






















