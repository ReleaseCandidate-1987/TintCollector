pragma Singleton
import QtQuick

QtObject {
    id: qtObject
    property string title: "TintCollector"
    property int width: 1920
    property int height: 1080

    // COLORPALETTE ------------------------------------------------------

    property bool isDarkMode: true

    property QtObject backgroundColor: QtObject {
        property color primary: isDarkMode ? "#101517" : "#fafafa"
        property color secondary: isDarkMode ? Qt.lighter(primary, 1.25) : Qt.darker(primary, 1.05)
        property color tertiary: isDarkMode ? Qt.lighter(primary, 1.35) : Qt.darker(primary, 1.075)
        property color hovered: isDarkMode ? Qt.lighter(primary, 1.5) : Qt.darker(primary, 1.15)
        property color pressed: isDarkMode ? Qt.lighter(primary, 2.0) : Qt.darker(primary, 1.15)
    }

    property QtObject foregroundColor: QtObject {
        property color dark: "#1f292d"
        property color primary: isDarkMode ? "#abb2bf" : "#28353a"
        property color secondary: isDarkMode ? Qt.darker(primary, 1.3) : Qt.lighter(primary, 1.3)
    }

    property color border: isDarkMode ? Qt.lighter(backgroundColor.primary, 1.75) : Qt.darker(backgroundColor.primary, 1.25)
    property color borderLighter: isDarkMode ? Qt.lighter(border, 1.5) : Qt.darker(border, 1.25)

    property color red: isDarkMode ? "#fa9292" :  Qt.darker("#fa9292", 1.25)
    property color yellow: isDarkMode ? "#faf592" : Qt.darker("#faf592", 1.75)
    property color green:  isDarkMode ? "#92fac9" : Qt.darker("#92fac9", 1.75)

    property color accent: green
    property color accentDark: Qt.darker(accent, 3)
    property color accentHovered: isDarkMode ? Qt.darker(accent, 1.25) : Qt.lighter(accent, 1.1)
    property color accentPressed: isDarkMode ? Qt.darker(accent, 1.5) : Qt.lighter(accent, 1.2)

    property color transparent: "transparent"

    function rgba( clr, alpha = 1.0 ) {
        return Qt.rgba( clr.r, clr.g, clr.b, alpha );
    }

    /*!
      https://www.w3.org/Graphics/Color/srgb

        1. Inverting the color component transfer function
        Note: Starting from sRGB values in the range 0 to 1, which are obtained by dividing integer values by 2bit depth – 1.
        It is common practice (but not required) to use black and white normalized colorimetry when
        making ICC v2 display profiles. When this is done, the inversion of the color component transfer
        function is accomplished using 1D LUTs created using the inverse color component transfer
        function without inverse black normalization (scaling), which is provided in IEC 61966-2-1 as
        follows:

        If R, G, B are less than or equal to 0.04045
        RL = R/12.92
        GL = G/12.92
        BL = B/12.02

        If R, G, B are greater than 0.04045
        RL = ((R + 0.055)/1.055)2.4
        GL = ((R + 0.055)/1.055)2.4
        BL = ((R + 0.055)/1.055)2.4
    */
    function __linearizeChannel( channel: real ) : real {
        return channel <= 0.04045
                ? channel / 12.92
                : Math.pow( (channel + 0.055 ) / 1.055, 2.4 )
    }

    /*!
      https://www.w3.org/WAI/WCAG21/Understanding/relative-luminance.html

      For the sRGB colorspace, the relative luminance of a color is defined as
        L = 0.2126 × R + 0.7152 × G + 0.0722 × B ...
    */
    function isDarkColor( clr: color ) : bool {
        const luminance = 0.2126 * __linearizeChannel( clr.r )
                        + 0.7152 * __linearizeChannel( clr.g )
                        + 0.0722 * __linearizeChannel( clr.b );
        return luminance < 0.1791287847
    }

    property var palettesTestModel: [
        { name: "Palette 1", colors: ["red", "green", "blue", "yellow", "cyan"] },
        { name: "Palette 2", colors: ["cyan", "red", "blue", "yellow", "green"] },
        { name: "Palette 2", colors: ["cyan", "red", "blue", "yellow", "green"] },
        { name: "Palette 2", colors: ["cyan", "red", "blue", "yellow", "green"] },
        { name: "Palette 2", colors: ["cyan", "red", "blue", "yellow", "green"] },
        { name: "Palette 2", colors: ["cyan", "red", "blue", "yellow", "green"] },
        { name: "Palette 2", colors: ["cyan", "red", "blue", "yellow", "green"] },
        { name: "Palette 2", colors: ["cyan", "red", "blue", "yellow", "green"] },
        { name: "Palette 2", colors: ["cyan", "red", "blue", "yellow", "green"] },
        { name: "Palette 2", colors: ["cyan", "red", "blue", "yellow", "green"] },
        { name: "Palette 2", colors: ["cyan", "red", "blue", "yellow", "green"] },
        { name: "Palette 2", colors: ["cyan", "red", "blue", "yellow", "green"] },
        { name: "Palette 2", colors: ["cyan", "red", "blue", "yellow", "green"] },
    ]

}





































