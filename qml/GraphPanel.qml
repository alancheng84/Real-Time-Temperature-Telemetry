import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtGraphs
import "." as Local

Item {
    id: root
    property string title: "Series name"
    property int yMin: 0
    property int yMax: 5
    property bool yAuto: true
    property int windowSize: 100
    property string label1: "label 1"
    property string label2: "label 2"

    function _setSeries(seriesObj, points) {
        seriesObj.clear()
        if (!points || points.length === 0) {
            return
        }
        for (var i = 0; i < points.length; i += 1) {
            seriesObj.append(points[i].x, points[i].y)
        }
    }

    function updateSeries(series1Points, series2Points) {
        _setSeries(series1, series1Points)
        _setSeries(series2, series2Points)

        var hasSeries2 = series2Points && series2Points.length > 0
        series2.visible = hasSeries2

        var allPoints = []
        if (series1Points && series1Points.length > 0) {
            allPoints = allPoints.concat(series1Points)
        }
        if (hasSeries2) {
            allPoints = allPoints.concat(series2Points)
        }
        if (allPoints.length === 0) {
            return
        }

        var minX = allPoints[0].x
        var maxX = allPoints[0].x
        var minY = allPoints[0].y
        var maxY = allPoints[0].y

        if (root.yAuto) {
            for (var i = 1; i < allPoints.length; i += 1) {
                var p = allPoints[i]
                if (p.x < minX) minX = p.x
                if (p.x > maxX) maxX = p.x
                if (p.y < minY) minY = p.y
                if (p.y > maxY) maxY = p.y * 1.1
            }
        } else {
            for (var j = 1; j < allPoints.length; j += 1) {
                var q = allPoints[j]
                if (q.x < minX) minX = q.x
                if (q.x > maxX) maxX = q.x
            }
            minY = root.yMin
            maxY = root.yMax
        }

        if (minX === maxX) {
            minX -= 1
            maxX += 1
        }
        if (minY === maxY) {
            minY -= 1
            maxY += 1
        }

        axisX.min = minX
        axisX.max = maxX
        axisY.min = minY
        axisY.max = maxY
    }

    ColumnLayout {
        anchors.fill: parent
        spacing: 4

        Label {
            text: root.title
            font.bold: true
            color: Local.Colors.text_secondary
            Layout.fillWidth: true
        }

        RowLayout {
            Layout.fillWidth: true
            spacing: 12

            Rectangle {
                width: 10
                height: 10
                radius: 5
                color: series1.color
                Layout.alignment: Qt.AlignVCenter
            }
            Label {
                text: root.label1
                color: Local.Colors.text_secondary
                font.pixelSize: 11
                Layout.alignment: Qt.AlignVCenter
            }

            Rectangle {
                width: 10
                height: 10
                radius: 5
                color: series2.color
                visible: series2.visible
                Layout.alignment: Qt.AlignVCenter
            }
            Label {
                text: root.label2
                color: Local.Colors.text_secondary
                font.pixelSize: 11
                visible: series2.visible
                Layout.alignment: Qt.AlignVCenter
            }
        }

        GraphsView {
            id: graph
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.margins: 0

            axisX: ValueAxis {
                id: axisX
                min: 0
                max: 10
                labelFormat: "%.2f"
            }

            axisY: ValueAxis {
                id: axisY
                min: -1
                max: 1
                labelFormat: "%.2f"
            }
            seriesList: [
                LineSeries {
                    id: series1
                    name: root.title
                    color: Local.Colors.secondary
                },
                LineSeries {
                    id: series2
                    name: root.title
                    visible: false
                    color: "#D84A4A"
                }
            ]
            theme: GraphsTheme {
                grid.mainColor: "#2A323C"
                grid.subColor: "#232A33"
                axisX.mainColor: "#3A424C"
                axisX.subColor: "#2A323C"
                axisX.labelTextColor: Local.Colors.text_secondary
                axisY.mainColor: "#3A424C"
                axisY.subColor: "#2A323C"
                axisY.labelTextColor: Local.Colors.text_secondary
            }
        }
        Label {
            text: "Time (s)"
            Layout.alignment: Qt.AlignHCenter
            color: Local.Colors.text_secondary
        }
    }
}
