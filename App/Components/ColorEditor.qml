import QtQuick
import QtQuick.Controls.Material
import QtQuick.Layouts
import "../Controls"
import "ColorEditorItems"

TintPage {
    id: colorEditor
    enabled: ColorModel.count < ColorModel.maxColorCount
    header: ColorEditorHeader { id: colorEditorHeader }
    contentItem: ColorEditorColorGenerator { id: colorEditorColorGenerator }
    footer: ColorEditorFooter { id: colorEditorFooter }
}
