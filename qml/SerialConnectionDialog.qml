import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Dialog {
    id: dialog
    required property var testSerialManager
    title: "Connect to Arduino"
    modal: true
    
    ColumnLayout {
        spacing: 10
        
        Label { text: "Port:" }
        ComboBox {
            id: portCombo
            model: ["COM1", "COM3", "COM4"]
        }
        
        Label { text: "Baud Rate:" }
        ComboBox {
            id: baudCombo
            model: [9600, 115200]
            currentIndex: 1
        }
    }
    
    standardButtons: Dialog.Ok | Dialog.Cancel
    
    onAccepted: {
        console.log("Connecting to:", portCombo.currentText)
        serialManager.connectToPort(portCombo.currentText, baudCombo.currentValue)
    }
}
