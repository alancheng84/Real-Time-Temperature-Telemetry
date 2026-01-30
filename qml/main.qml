import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import "." as Local

// pragma ComponentBehavior: Bound



ApplicationWindow {
    id: root
    visible: true
    width: 1100
    height: 600
    minimumWidth: 200
    minimumHeight: 100
    title: "Qt Quick Terminal"
    color: Local.Colors.background
    flags: Qt.Window

    property var backendSerialManager: serialManager
    property real currentAlpha: 1.0/2

    SerialConnectionDialog {
        id: myConnectionDialog 
        parent: Overlay.overlay
        anchors.centerIn: parent
        testSerialManager: serialManager
    }
        
    function sendCommand() {
        if (inputField.text.length === 0)
            return
        serialManager.sendData(inputField.text)
        inputField.clear()
    }

    Connections {
        target: serialManager
        function onConnected() {
            console.log("✓ Arduino connected!")
        }
        function onDisconnected() {
            console.log("✗ Arduino disconnected")
        }
        function onDataReceived(dtime, ddata) {
            console.log(ddata)
            serialmonitor.append({stime : dtime, sdata : ddata})
        }
        function onConnectionError(error) {
            console.error("Error", error)
        }
        function onTelemetryUpdated() {
            var data = serialManager.getTelemetrySeries()
            topleftPanel.updateSeries(data.adc, [])
            toprightPanel.updateSeries(data.temp_raw, data.temp_ema)
        }
    }


    ColumnLayout {
        anchors.fill: parent
        
        // TitleBar {
        //     id: titleBar
        //     serialManager: backendSerialManager
        //     window: root
        //     Layout.alignment: Qt.AlignTop | Qt.AlignLeft | Qt.AlignRight
        //     height: 32
        // }

        RowLayout {
            spacing: 8
            
            // Left Panel - Management
            Rectangle {
                Layout.preferredWidth: 400
                Layout.fillHeight: true
                color: Local.Colors.panel
                border.width: 1

                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: 8
                    spacing: 8

                    RowLayout {
                        Layout.preferredHeight: 28
                        Layout.alignment: Qt.AlignLeft | Qt.AlignVCenter
                        spacing: 10
                        Rectangle {
                            Layout.preferredWidth: 12
                            Layout.preferredHeight: 12
                            color: serialManager.isConnected ? "#3FB950" : "#E5533D"
                            radius: width/2
                            Layout.alignment: Qt.AlignVCenter
                        }

                        Text {
                            Layout.alignment: Qt.AlignVCenter
                            verticalAlignment: Text.AlignVCenter
                            color: Local.Colors.text_secondary
                            text: serialManager.isConnected ? qsTr("Connected") : qsTr("Disconnected")
                            font.family: "Inter"
                            font.pixelSize: 12
                            font.weight: Font.Medium
                        }

                        CustomButton {
                            Layout.preferredHeight: 20
                            Layout.alignment: Qt.AlignRight
                            Layout.preferredWidth: 50
                            labeledText: true
                            label: serialManager.isConnected ? "Disconnect" : "Connect"
                            outline: true
                            idleColor: Local.Colors.panel
                            radius: 6 

                            onClicked: {
                                if (serialManager.isConnected) {
                                    serialManager.disconnect()
                                } else {
                                    myConnectionDialog.open() 
                                }
                            }
                        }
                    }
                    
                    // Quick Buttons
                    Text {
                        text: qsTr("Quick Controls: (choose n where alpha = 1/n)")
                        font.family: "Inter"
                        font.pixelSize: 13
                        font.weight: Font.DemiBold
                        font.capitalization: Font.AllUppercase
                        font.letterSpacing: 0.8
                        color: Local.Colors.text_secondary
                    }

                    GridLayout {
                        Layout.fillWidth: true
                        columns: 3
                        rows: 1
                        columnSpacing: 8
                        rowSpacing: 8
                        Layout.preferredHeight: 60
                        CustomButton {
                            Layout.fillWidth: true
                            Layout.preferredWidth: 80
                            Layout.fillHeight: true
                            label: "2"
                            labeledText: true
                            onClicked: {
                                serialManager.sendData("2")
                                currentAlpha = 1.0/2
                            }
                        }
                        CustomButton {
                            Layout.fillWidth: true
                            Layout.preferredWidth: 80
                            Layout.fillHeight: true
                            label: "4"
                            labeledText: true
                            onClicked:  {
                                serialManager.sendData("4")
                                currentAlpha = 1.0/4
                            }
                        }
                        CustomButton {
                            Layout.fillWidth: true
                            Layout.preferredWidth: 80
                            Layout.fillHeight: true
                            label: "8"
                            labeledText: true
                            onClicked: {
                                serialManager.sendData("8")
                                currentAlpha = 1.0/8
                            }
                        }
                    }

                    Text {
                        text: qsTr("Serial Monitor")
                        font.family: "Inter"
                        font.pixelSize: 13
                        font.weight: Font.DemiBold
                        font.capitalization: Font.AllUppercase
                        font.letterSpacing: 0.8
                        color: Local.Colors.text_secondary
                        Layout.topMargin: 16
                    }

                    Rectangle {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        Layout.preferredHeight: 600
                        color: Local.Colors.background
                        border.color: 'grey'
                        border.width: 1
                        radius: 4

                        ListModel {
                            id: serialmonitor
                        }
                        ListView {
                            anchors.fill: parent
                            anchors.margins: 6
                            clip: true
                            model: serialmonitor
                            boundsBehavior: Flickable.StopAtBounds
                            property bool follow: true
                            ScrollBar.vertical: ScrollBar { }
                            onContentYChanged: {
                                if (contentHeight <= height) {
                                    follow = true
                                    return
                                }
                                follow = contentY >= contentHeight - height - 1
                            }
                            onCountChanged: {
                                if (follow || count === 1) {
                                    Qt.callLater(positionViewAtEnd)
                                }
                            }
                            delegate: Item {
                                width: ListView.view.width
                                height: line.implicitHeight
                                TextEdit {
                                    id: line
                                    anchors.left: parent.left
                                    anchors.right: parent.right
                                    text: stime + " | " + sdata
                                    color: Local.Colors.text
                                    readOnly: true
                                    selectByMouse: true
                                    wrapMode: TextEdit.WrapAnywhere
                                    textFormat: TextEdit.PlainText
                                }
                            }
                        }
                    }

                    RowLayout {
                        Layout.fillWidth: true
                        spacing: 6

                        Rectangle {
                            Layout.fillWidth: true
                            color: Local.Colors.inactive
                            border.color: "white"
                            radius: 4
                            Layout.preferredHeight: 25
                            
                            TextField {
                                id: inputField
                                anchors.left: parent.left
                                anchors.right: parent.right
                                anchors.verticalCenter: parent.verticalCenter

                                placeholderText: "Type Command..."
                                placeholderTextColor: Local.Colors.text
                                color: Local.Colors.text

                                // background: Item {}
                                onAccepted: sendCommand()
                            }
                        }

                        CustomButton {
                            id: serial_send
                            label: "Send"
                            radius: 6
                            onClicked: sendCommand()
                        }

                        // Button {
                        //     id: serial_send
                        //     text: "Send"
                        //     flat: true

                        //     background: Rectangle {
                        //         border.color: "white"
                        //         // anchors.fill: parent
                        //         // radius: 6
                        //         color: serial_send.hovered ? Local.Colors.background : "#2c2c2c"
                        //     }

                        //     contentItem: Text {
                        //         text: serial_send.text
                        //         color: serial_send.hovered ? Local.Colors.iconIndicator : Local.Colors.text
                        //     }

                        //     onClicked: sendCommand()
                        // }
                    }
                }
            }

            // Middle Panel - 4 CHARTS IN 2x2 GRID
            Rectangle {
                Layout.fillWidth: true
                Layout.fillHeight: true
                color: "#1e1e1e"
                
                

                // Quick Buttons
                GridLayout {
                    anchors.fill: parent
                    anchors.margins: 8
                    columns: 1
                    rows: 2
                    columnSpacing: 8
                    rowSpacing: 8
                    
                    // Top-Left: Pre-Heater Temperature
                    GraphPanel {
                        id: topleftPanel
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        title: "ADC Voltage"
                        yAuto: true
                        windowSize: 500
                        label1: "ADC Raw Voltage"
                    }
                    
                    // Top-Right: Power Percent
                    GraphPanel {
                        id: toprightPanel
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        title: "Temperature"
                        yAuto: true
                        windowSize: 500
                        label1: "Temperature (deg C)"
                        label2: "EMA (alpha=" + root.currentAlpha +")"
                    }
                }
            }
        }
    }
}
