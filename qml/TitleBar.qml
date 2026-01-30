import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Window
import "." as Local

Item {
    id: root
    required property ApplicationWindow window
    required property var serialManager
    height: 32
    Layout.fillWidth: true
    Layout.preferredHeight: 32
    Layout.alignment: Qt.AlignTop

    
    // // TEMPORARY PLEASE REMOVE 
    // Component.onCompleted: {
    //     console.log("serialManager =", serialManager)
    // }


    Rectangle {
        anchors.fill: parent
        color: Local.Colors.header
        WindowDragHandler {
            dragWindow: root.window
        }
    }
    
    Row {
        anchors.left: parent.left
        anchors.verticalCenter: parent.verticalCenter
        height: parent.height
        // anchors.top: parent.top
        // anchors.bottom: parent.bottom
        // Text {
        //     text: serialManager ? "SM OK" : "SM UNDEFINED"
        // }


        CustomButton {
            labeledText: true
            label: serialManager.isConnected ? "Disconnect" : "Connect"
            height: parent.height
            outline: false
            idleColor: Local.Colors.header
            radius: 2
            // anchors.left: parent.left
            // anchors.top: parent.top
            // anchors.bottom: parent.bottom
            onClicked: {
                if (serialManager.isConnected) {
                    serialManager.disconnect()
                } else {
                    myConnectionDialog.open() 
                }
            }
        }
    }

    Row {
        anchors.right: parent.right
        anchors.verticalCenter: parent.verticalCenter
        height: parent.height
        Button {
            id: minimize
            width:  parent.height
            height: parent.height
            padding: 0
            flat: true
            background: Rectangle {
                anchors.fill: parent
                color: minimize.hovered ? Local.Colors.background : Local.Colors.header
            }

            icon.width: 14
            icon.height: 14
            icon.source: "../icons/remove_24dp_E3E3E3_FILL0_wght400_GRAD0_opsz24.svg"
            icon.color: minimize.hovered ? Local.Colors.text : Local.Colors.text_secondary

            onClicked: root.window.showMinimized()
        }

        Button {
            id: fullscreen
            width:  parent.height
            height: parent.height
            flat: true
            padding: 0
            background: Rectangle {
                anchors.fill: parent
                color: fullscreen.hovered ? Local.Colors.background : Local.Colors.header
            }

            icon.width: 14
            icon.height: 14
            icon.source: "../icons/square_24dp_E3E3E3_FILL0_wght400_GRAD0_opsz24.svg"
            icon.color: fullscreen.hovered ? Local.Colors.text : Local.Colors.text_secondary

            onClicked: root.window.showFullScreen()
        }

        Button {
            id: close
            width:  parent.height
            height: parent.height
            flat: true
            padding: 0

            background: Rectangle {
                anchors.fill: parent
                color: close.hovered ? Local.Colors.primary : Local.Colors.header
            }

            icon.width: 14
            icon.height: 14
            icon.source: "../icons/close_24dp_E3E3E3_FILL0_wght400_GRAD0_opsz24.svg"
            icon.color: close.hovered ? Local.Colors.text : Local.Colors.text_secondary 

            onClicked: root.window.close()
        }
    }
    
    SerialConnectionDialog {
        id: myConnectionDialog 
        parent: Overlay.overlay
        anchors.centerIn: parent
        testSerialManager: serialManager
    }
}
