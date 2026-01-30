import QtQuick
import QtQuick.Controls
import "." as Local

Item {
    id: buttonRoot

    property string label: "Button Text"
    property bool labeledText: true
    property int padding: 3
    property bool outline: true
    property int outlineWidth: 1
    property int radius: 0
    property color idleColor: Local.Colors.panel
    // Layout.fillWidth: true
    // Layout.fillHeight: true

    signal clicked()

    implicitWidth: textItem.implicitWidth + padding * 2
    implicitHeight: textItem.implicitHeight + padding * 2

    Rectangle {
        anchors.fill: parent
        radius: buttonRoot.radius

        color: mouse.containsMouse ? Local.Colors.background : idleColor

        border.width: outline ? outlineWidth : 0
        border.color: outline ? Local.Colors.text : "transparent"

        Text {
            id: textItem
            text: buttonRoot.label
            font.family: "Inter"
            font.pixelSize: Math.round(parent.height * 0.42)
            visible: buttonRoot.labeledText
            anchors.centerIn: parent
            color: mouse.containsMouse ? Local.Colors.text_secondary : Local.Colors.text
        }

        MouseArea {
            id: mouse
            anchors.fill: parent
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            onClicked: buttonRoot.clicked()
        }
    }
}
