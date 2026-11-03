pragma Singleton
import QtQuick
import QtQuick.Controls.Material

QtObject {
    property int __baseControlSize: 42

    property QtObject elevation: QtObject {
        property int none: 0
        property int controls: 6
        property int dialogs: 12
    }

    property QtObject controlSize: QtObject {
        property int smallest: __baseControlSize * 0.6
        property int small: __baseControlSize * 0.75
        property int normal: __baseControlSize
        property int large: __baseControlSize * 1.25
    }

    property QtObject radius: QtObject {
        property int none: Material.NotRounded
        property int smallest: Material.ExtraSmallScale
        property int small: Material.SmallScale
        property int medium: Material.MediumScale
        property int large: Material.LargeScale
        property int full: Material.FullScale
    }

    property QtObject spacing: QtObject {
        property int none: 0
        property int smallest: 4
        property int small: 8
        property int medium: 16
        property int large: 24
        property int largest: 32
    }
}
