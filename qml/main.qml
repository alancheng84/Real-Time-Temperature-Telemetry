import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import "." as Local

pragma ComponentBehavior: Bound

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
        // backEnd.append("> " + inputField.text)
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
        function onDataReceived(data) {
            console.log(data)
            serialmonitor.append(data)
        }
        function onConnectionError(error) {
            console.error("Error", error)
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

                    LabeledSwitch { text: "Enable H2" }
                    LabeledSwitch { text: "Enable Ar" }
                    LabeledSwitch { text: "Enable CO2" }
                    LabeledSwitch { text: "Enable Power" }

                    Text {
                        text: qsTr("Serial Monitor")
                        font.pixelSize: 16
                        color: Local.Colors.text
                        Layout.topMargin: 16
                    }

                    Rectangle {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        color: Local.Colors.background
                        border.color: 'grey'
                        border.width: 1
                        radius: 4

                        ScrollView {
                            anchors.fill: parent
                            anchors.margins: 4

                            TextArea {
                                id: serialmonitor
                                readOnly: true
                                color: Local.Colors.text
                                font.family: "Courier New"
                                font.pixelSize: 12
                                wrapMode: TextArea.WrapAnywhere
                                background: Item{}

                                function append(text) {
                                    serialmonitor.text += text + "\n"
                                    serialmonitor.cursorPosition = serialmonitor.length
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
                                anchors.fill: parent
                                radius: 6
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
                    ChartComponent {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        title: "Pre-Heater Temperature"
                        accentColor: "#ff6b6b"
                        showControls: false
                        showStatusBar: false
                    }
                    
                    // Top-Right: Power Percent
                    ChartComponent {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        title: "Power Percent"
                        accentColor: "#4ecdc4"
                        showControls: false
                        showStatusBar: false
                    }
                    
                    // Bottom-Left: Reactor Temperature
                    ChartComponent {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        title: "Reactor Temperature"
                        accentColor: "#ffbe0b"
                        showControls: false
                        showStatusBar: false
                    }
                    
                    // Bottom-Right: Average Temperature
                    ChartComponent {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        title: "Average Temperature"
                        accentColor: "#fb5607"
                        showControls: false
                        showStatusBar: false
                    }
                }
            }
        }
    }
}