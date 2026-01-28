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
    flags: Qt.Window | Qt.FramelessWindowHint

    property var backendSerialManager: serialManager

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
            topleftPanel.updateSeries(data.ph1, data.ph2)
            toprightPanel.updateSeries(data.pwr, [])
            bottomleftPanel.updateSeries(data.rs, data.rg)
            bottomrightPanel.updateSeries(data.avg, [])
        }
    }


    ColumnLayout {
        anchors.fill: parent
        
        TitleBar {
            id: titleBar
            serialManager: backendSerialManager
            window: root
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
            height: 32
        }

        RowLayout {
            spacing: 8
            
            // Left Panel - Serial Monitor
            Rectangle {
                Layout.preferredWidth: 400
                Layout.fillHeight: true
                color: "#2c2c2c"

                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: 8
                    spacing: 8

                    Text {
                        text: qsTr("Quick Controls:")
                        font.pixelSize: 16
                        color: Local.Colors.text
                    }

                    GridLayout {
                        Layout.fillWidth: true
                        columns: 2
                        rows: 3
                        columnSpacing: 8
                        rowSpacing: 8
                        Layout.preferredHeight: 400
                        CustomButton {
                            Layout.fillWidth: true
                            Layout.preferredWidth: 100
                            Layout.fillHeight: true
                            label: "H2 ON"
                            labeledText: true
                        }
                        CustomButton {
                            Layout.fillWidth: true
                            Layout.preferredWidth: 100
                            Layout.fillHeight: true
                            label: "H2 OFF"
                            labeledText: true
                        }
                        CustomButton {
                            Layout.fillWidth: true
                            Layout.preferredWidth: 100
                            Layout.fillHeight: true
                            label: "AR ON"
                            labeledText: true
                        }
                        CustomButton {
                            Layout.fillWidth: true
                            Layout.preferredWidth: 100
                            Layout.fillHeight: true
                            label: "AR OFF"
                            labeledText: true
                        }
                        CustomButton {
                            Layout.fillWidth: true
                            Layout.preferredWidth: 100
                            Layout.fillHeight: true
                            label: "CO2 ON"
                            labeledText: true
                        }
                        CustomButton {
                            Layout.fillWidth: true
                            Layout.preferredWidth: 100
                            Layout.fillHeight: true
                            label: "CO2 OFF"
                            labeledText: true
                        }
                    }

                    Text {
                        text: qsTr("Serial Monitor")
                        font.pixelSize: 16
                        color: Local.Colors.text
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
                            model: serialmonitor
                            delegate: Text { 
                                text: stime + " | " + sdata
                                color: Local.Colors.text
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

                                background: Item {}
                                onAccepted: sendCommand()
                            }
                        }

                        Button {
                            id: serial_send
                            text: "Send"
                            flat: true

                            background: Rectangle {
                                border.color: "white"
                                // anchors.fill: parent
                                // radius: 6
                                color: serial_send.hovered ? Local.Colors.background : "#2c2c2c"
                            }

                            contentItem: Text {
                                text: serial_send.text
                                color: serial_send.hovered ? Local.Colors.iconIndicator : Local.Colors.text
                            }

                            onClicked: sendCommand()
                        }
                    }
                }
            }

            // Middle Panel - 4 CHARTS IN 2x2 GRID
            Rectangle {
                Layout.fillWidth: true
                Layout.fillHeight: true
                color: "#1e1e1e"
                
                GridLayout {
                    anchors.fill: parent
                    anchors.margins: 8
                    columns: 2
                    rows: 2
                    columnSpacing: 8
                    rowSpacing: 8
                    
                    // Top-Left: Pre-Heater Temperature
                    GraphPanel {
                        id: topleftPanel
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        title: "top left"
                    }
                    
                    // Top-Right: Power Percent
                    GraphPanel {
                        id: toprightPanel
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        title: "top right"
                    }
                    
                    // Bottom-Left: Reactor Temperature
                    GraphPanel {
                        id: bottomleftPanel
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        title: "bottom left"
                    }
                    
                    // Bottom-Right: Average Temperature
                    GraphPanel {
                        id: bottomrightPanel
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        title: "bottom right"
                    }
                }
            }
        }
    }
}