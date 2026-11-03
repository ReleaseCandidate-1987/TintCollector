import QtQuick
import QtQuick.Controls.Material
import QtQuick.Layouts
import App.Core
import "../../Controls"

TintDialog {
    id: addPaletteDialog
    title: "Neue Palette"
    subTitle: "Gebe einen Namen für die Neue Palette ein."

    isValid: __tf.isValid

    enum InsertMode { Add, Rename }
    property int insertMode: AddPaletteDialog.Add
    
    onAboutToShow: __tf.forceActiveFocus()
    signal paletteAdded( name: string )
    signal paletteRenamed( newName: string )
    property alias inputText: __tf.text
    
    extraContent: TintValidationField {
        id: __tf
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
            if ( !acceptableInput || !addPaletteDialog.isValid )
                return;

            switch( addPaletteDialog.insertMode ) {
            case AddPaletteDialog.Add: addPaletteDialog.paletteAdded( text ); break;
            case AddPaletteDialog.Rename: addPaletteDialog.paletteRenamed( text ); break;
            }
            addPaletteDialog.close()

        }
    }

    onAccepted: {
        switch( addPaletteDialog.insertMode ) {
        case AddPaletteDialog.Add: addPaletteDialog.paletteAdded( __tf.text ); break;
        case AddPaletteDialog.Rename: addPaletteDialog.paletteRenamed( __tf.text ); break;
        }
    }

    onClosed:  { addPaletteDialog.destroy() }
}
