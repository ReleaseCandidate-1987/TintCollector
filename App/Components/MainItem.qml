import QtQuick
import QtQuick.Controls.Material
import QtQuick.Layouts
import App.Core
import "../Controls"
import "MainItemItems"
import "SideBarItems"

TintPage {
    id: mainItem
    implicitWidth: 0
    topPadding: ControlStyle.spacing.small
    title: sideBar.paletteName

    header: MainItemHeader { id: mainItemHeader;  }
    footer: MainItemFooter { id: mainItemFooter }
    contentItem: MainItemContent { id: mainItemContent }

    MainItemNoPalettes { }
}
