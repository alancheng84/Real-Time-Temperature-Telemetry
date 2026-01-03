import QtQuick
import QtQuick.Controls
import QtQuick.Window
import "." as Local


Item {
    id: root
    required property ApplicationWindow window
    height: 32
    anchors.left: parent.left
    anchors.right: parent.right
    Rectangle {
        anchors.fill: parent
        color: Local.Colors.surface1
        WindowDragHandler {
            dragWindow: root.window
        }
    }

    Row {
        anchors.right: parent.right
        anchors.verticalCenter: parent.verticalCenter
        spacing: 6

        Button {
            id: minimize
            width: 24
            height: 24
            padding: 0
            flat: true

            background: Rectangle {
                anchors.fill: parent
                radius: 6
                color: minimize.hovered ? Local.Colors.background : Local.Colors.surface1
            }

            icon.source: "../icons/remove_24dp_E3E3E3_FILL0_wght400_GRAD0_opsz24.svg"
            icon.color: minimize.hovered ? Local.Colors.iconIndicator : Local.Colors.icon

            onClicked: root.window.showMinimized()
        }

        Button {
            id: fullscreen
            width: 24
            height: 24
            flat: true

            background: Rectangle {
                anchors.fill: parent
                radius: 6
                color: fullscreen.hovered ? Local.Colors.background : Local.Colors.surface1
            }

            icon.source: "../icons/square_24dp_E3E3E3_FILL0_wght400_GRAD0_opsz24.svg"
            icon.color: fullscreen.hovered ? Local.Colors.iconIndicator : Local.Colors.icon

            onClicked: root.window.showFullScreen()
        }

        Button {
            id: close
            width: 24
            height: 24
            flat: true

            background: Rectangle {
                anchors.fill: parent
                radius: 6
                color: close.hovered ? Local.Colors.background : Local.Colors.surface1
            }

            icon.source: "../icons/close_24dp_E3E3E3_FILL0_wght400_GRAD0_opsz24.svg"
            icon.color: close.hovered ? Local.Colors.iconIndicator : Local.Colors.icon

            onClicked: root.window.close()
        }
    }
}
