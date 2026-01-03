import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import "." as Local
import QtCharts 

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

    function sendCommand() {
        if (inputField.text.length === 0)
            return
        // backEnd.append("> " + inputField.text)
        inputField.clear()
    }


    ColumnLayout {
        anchors.fill: parent
        TitleBar {
            id: titleBar
            window: root
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
            height: 32
            // background: Local.Colors.background
        }

        RowLayout {
            spacing: 8
            Rectangle {
                Layout.preferredWidth: 300
                Layout.fillHeight: true
                color: "#2c2c2c"

                // Quick Controls
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
                        color: "#1e1e1e"  // Darker than parent for contrast
                        border.color: "#404040"
                        border.width: 1
                        radius: 4

                        ScrollView {
                            anchors.fill: parent
                            anchors.margins: 4

                            TextArea {
                                readOnly: true
                                text: backend.logText
                                color: "#00ff00"  // Classic green terminal text
                                font.family: "Courier New"
                                font.pixelSize: 12
                                wrapMode: TextArea.Wrap
                                background: Item {}  // Transparent, use Rectangle's color
                            }
                        }
                    }

                    RowLayout {
                        Layout.fillWidth: true
                        spacing: 6
                        id: rowroot

                        Rectangle {
                            Layout.fillWidth: true
                            color:Local.Colors.inactive
                            border.color: "white"
                            radius: 4
                            Layout.preferredHeight: 25
                            TextField {
                                id: inputField
                                anchors.left: parent.left
                                anchors.right: parent.right
                                anchors.verticalCenter: parent.verticalCenter

                                placeholderText: "Type Command..."
                                placeholderTextColor:Local.Colors.text
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
                                Layout.preferredHeight: 20
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

            Rectangle {
                Layout.fillWidth: true
                Layout.fillHeight: true
                Layout.preferredHeight: 300
                color: "#1e1e1e"
                border.color: "red"
                border.width: 2

                ChartView {
                    anchors.fill: parent  // ← ADD THIS!        
                    antialiasing: true
                }

            }

            Rectangle {
                Layout.preferredWidth: 250
                Layout.fillHeight: true
                color: "#2c2c2c"
            }
        }
    }
}
