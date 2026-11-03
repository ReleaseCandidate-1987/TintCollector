import QtQuick
import QtQuick.Controls.Material
import QtQuick.Layouts
import "../../Controls"

TintDialog {
    id: renameColorDialog
    property int sourceIndex: __listView.currentItem?.sourceIndex ?? -1
    title: `${__listView.currentItem?.name ?? ''} umbenennen`
    
    isValid: sourceIndex >= 0 && __tf.isValid

    onAboutToShow: {
        __tf.forceActiveFocus();
        __tf.selectAll();
    }
    
    extraContent: TintValidationField {
        id: __tf
        text: __listView.currentItem?.name ?? ''
        validator: RegularExpressionValidator {
            regularExpression: /^[a-zA-Z][a-zA-Z0-9_-]{2,}(?:[a-zA-Z0-9_-]+)*$/
        }
        
        tipp: {
            if ( text.trim().length < 3 ) {
                isValid = false;
                return "Gebe mindestens <b>drei</b> Zeichen ein."
            } else if ( ColorModel.containsName(__tf.text )) {
                isValid = false;
                return "Der Name ist bereits vorhanden."
            }
            
            isValid = true;
            return "Eingabe kann mit <b>[Enter]</b> bestätigt werden."
        }
        
        onAccepted: {
            if ( !acceptableInput || !renameColorDialog.isValid )
                return;
            
            ColorModel.renameColor(sourceIndex, __tf.text )
            renameColorDialog.close()
            
        }
        
    }
    onAccepted: ColorModel.renameColor(sourceIndex, __tf.text )
    onClosed: destroy()
}
