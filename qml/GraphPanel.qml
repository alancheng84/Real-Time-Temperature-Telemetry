import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtGraphs
import "." as Local

Item {
    id: root
    property string title: "Series name"

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

        for (var i = 1; i < allPoints.length; i += 1) {
            var p = allPoints[i]
            if (p.x < minX) minX = p.x
            if (p.x > maxX) maxX = p.x
            if (p.y < minY) minY = p.y
            if (p.y > maxY) maxY = p.y
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
        spacing: 8

        Label {
            text: root.title
            font.bold: true
            Layout.fillWidth: true
        }

        GraphsView {
            id: graph
            Layout.fillWidth: true
            Layout.fillHeight: true

            axisX: ValueAxis {
                id: axisX
                min: 0
                max: 10
            }

            axisY: ValueAxis {
                id: axisY
                min: -1
                max: 1
            }
            seriesList: [
                ScatterSeries {
                    id: series1
                    name: root.title
                    pointDelegate: Rectangle {
                        height: 8
                        width: 8
                        radius: 4
                    }
                },
                ScatterSeries {
                    id: series2
                    name: root.title
                    visible: false
                    pointDelegate: Rectangle {
                        height: 8
                        width: 8
                        radius: 4
                    }
                }
            ]
        }
    }
}
