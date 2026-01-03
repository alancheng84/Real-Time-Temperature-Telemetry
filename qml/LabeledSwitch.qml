import QtQuick
import QtQuick.Controls
import "." as Local

Item {
    id: root

    property string text: "Label"
    property int size: 16
    property bool checked: false

    implicitHeight: size
    implicitWidth: column.implicitWidth

    Row {
        id: column
        spacing: size * 0.4
        height: root.implicitHeight

        Switch {
            id: control
            checked: root.checked
            onToggled: root.checked = checked


            indicator: Rectangle {
                implicitWidth: root.size * 2
                implicitHeight: root.size
                x: control.leftPadding
                y: parent.height / 2 - height / 2
                radius: root.size / 2
                color: control.checked ? "#17a81a" : Local.Colors.text
                border.color: control.checked ? "#17a81a" : Local.Colors.text

                Rectangle {
                    x: control.checked ? parent.width - width : 0
                    width: root.size
                    height: root.size
                    radius: root.size / 2
                    color: control.down ? "#cccccc" : "#ffffff"
                    border.color: control.checked ? (control.down ? "#17a81a" : "#21be2b") : "#999999"
                }
            }

            contentItem: Text {
                text: qsTr(" " + root.text)
                font.pixelSize: root.size
                opacity: enabled ? 1.0 : 0.3
                color: control.down ? "#17a81a" : "#21be2b"
                verticalAlignment: Text.AlignVCenter
                leftPadding: control.indicator.width + control.spacing
            }
        }
    }
}
