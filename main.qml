import QtQuick
import QtQuick.Controls.Material
import App

Window {
    id: window
    width: Theme.width
    height: Theme.height

    visible: true
    title: Theme.title
    color: Theme.backgroundColor.primary
    Material.theme: Theme.isDarkMode ? Material.Dark : Material.Light
    App { id: app;  }

}

