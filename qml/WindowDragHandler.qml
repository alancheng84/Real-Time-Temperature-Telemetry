import QtQuick
import QtQuick.Controls
import "." as Local

DragHandler {
    required property Window dragWindow

    target: null

    onActiveChanged: {
        if (active) dragWindow.startSystemMove()
    }
}
