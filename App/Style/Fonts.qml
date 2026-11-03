pragma Singleton
import QtQuick

QtObject {
    id: qtObject


    readonly property string family: "DM Sans"

    readonly property font small: Qt.font({ family: family, pointSize: 10 })
    readonly property font smallBold: Qt.font({ family: family, pointSize: 10, bold: true })

    readonly property font control: Qt.font({ family: family, pointSize: 12 })
    readonly property font controlUpper: Qt.font({ family: family, pointSize: 12, capitalization: Font.AllUppercase })
    readonly property font controlBold: Qt.font({ family: family, pointSize: 12, bold: true})

    readonly property font label: Qt.font({ family: family, pointSize: 14 })
    readonly property font labelBold: Qt.font({ family: family, pointSize: 14, bold: true })

    readonly property font header: Qt.font({ family: family, pointSize: 16, bold: true })


}
