import QtQuick
import QtQuick.Controls.Material
import QtQuick.Layouts
import "../../Controls"

TintDialog {
    id: colorPickerDialog
    title: "Colorpicker"
    subTitle: "Wähle eine Farbe und Namen aus."
    preferredWidth: 450
    isValid: __tf.isValid || selectColorOnly

    signal colorSelected( name: string, clr: color )
    signal onlyColorSelected( clr: color )
    property bool selectColorOnly: false
    property alias currentColor: colorPicker.currentColor


    extraContent: ColumnLayout {
        spacing: ControlStyle.spacing.medium
        TintColorPickerItem {
            id: colorPicker
            Layout.fillWidth: true
        }
        TintValidationField {
            id: __tf
            visible: !colorPickerDialog.selectColorOnly
            Layout.fillWidth: true

            validator: RegularExpressionValidator {
                regularExpression: /^[a-zA-Z][a-zA-Z0-9_-]{2,}(?: [a-zA-Z0-9_-]+)*$/
            }

            tipp: {
                if ( text.trim().length < 3 ) {
                    isValid = false;
                    return "Gebe mindestens <b>drei</b> Zeichen ein."
                } else if ( PaletteModel.containsName( __tf.text ) ) {
                    isValid = false;
                    return "Der Name ist bereits vorhanden."
                }

                isValid = true;
                return "Eingabe kann mit <b>[Enter]</b> bestätigt werden."
            }

            onAccepted: {
                if ( !acceptableInput || !isValid )
                    return;
                 colorPickerDialog.colorSelected( __tf.text, colorPicker.selectedColor );
                colorPickerDialog.close();
            }
        }
    }
    onClosed: { destroy(); }
    
    onAccepted: {
        if ( colorPickerDialog.selectColorOnly ) {
            colorPickerDialog.onlyColorSelected( colorPicker.selectedColor );
        }
        else {
            colorPickerDialog.colorSelected( __tf.text, colorPicker.selectedColor );
        }

    }
}
