// import QtQuick 6.6
// import QtQuick.Controls 6.6
// import QtQuick.Layouts 6.6
// import QtCharts 6.6

// ApplicationWindow {
//     id: root
//     visible: true
//     width: 1200
//     height: 700
//     title: "Real-Time Chart - Working"
    
//     color: "#1e1e1e"
    
//     ColumnLayout {
//         anchors.fill: parent
//         anchors.margins: 16
//         spacing: 12
        
//         // Header with Controls
//         Rectangle {
//             Layout.fillWidth: true
//             Layout.preferredHeight: 60
//             color: "#2d2d2d"
//             radius: 8
            
//             RowLayout {
//                 anchors.fill: parent
//                 anchors.margins: 12
//                 spacing: 16
                
//                 Text {
//                     text: "📊 Real-Time Data Monitor"
//                     font.pixelSize: 22
//                     font.bold: true
//                     color: "#00ff88"
//                 }
                
//                 Item { Layout.fillWidth: true }
                
//                 Text {
//                     text: "Points: " + (chartDataProvider ? chartDataProvider.pointCount : 0)
//                     font.pixelSize: 16
//                     color: "#888888"
//                 }
                
//                 Button {
//                     text: (chartDataProvider && chartDataProvider.isPaused) ? "▶ Resume" : "⏸ Pause"
                    
//                     background: Rectangle {
//                         color: parent.hovered ? "#4a4a4a" : "#3a3a3a"
//                         radius: 6
//                         implicitWidth: 100
//                         implicitHeight: 35
//                     }
                    
//                     contentItem: Text {
//                         text: parent.text
//                         color: "#00ff88"
//                         horizontalAlignment: Text.AlignHCenter
//                         verticalAlignment: Text.AlignVCenter
//                         font.pixelSize: 14
//                     }
                    
//                     onClicked: {
//                         if (chartDataProvider) {
//                             chartDataProvider.togglePause()
//                             console.log("Pause toggled")
//                         }
//                     }
//                 }
                
//                 Button {
//                     text: "🗑 Clear"
                    
//                     background: Rectangle {
//                         color: parent.hovered ? "#5a2a2a" : "#4a2a2a"
//                         radius: 6
//                         implicitWidth: 80
//                         implicitHeight: 35
//                     }
                    
//                     contentItem: Text {
//                         text: parent.text
//                         color: "#ff4444"
//                         horizontalAlignment: Text.AlignHCenter
//                         verticalAlignment: Text.AlignVCenter
//                         font.pixelSize: 14
//                     }
                    
//                     onClicked: {
//                         if (chartDataProvider) {
//                             chartDataProvider.clearData()
//                             lineSeries.clear()
//                             console.log("Data cleared")
//                         }
//                     }
//                 }
//             }
//         }
        
//         // Chart Container
//         Rectangle {
//             Layout.fillWidth: true
//             Layout.fillHeight: true
//             color: "#252525"
//             radius: 8
//             border.color: "#3a3a3a"
//             border.width: 1
            
//             ChartView {
//                 id: chartView
//                 anchors.fill: parent
//                 anchors.margins: 10
                
//                 antialiasing: true
//                 backgroundColor: "#252525"
//                 theme: ChartView.ChartThemeDark
//                 legend.visible: true
//                 legend.alignment: Qt.AlignTop
                
//                 animationOptions: ChartView.NoAnimation
                
//                 ValueAxis {
//                     id: axisX
//                     min: 0
//                     max: 100
//                     titleText: "Time (samples)"
//                     labelFormat: "%.0f"
//                     color: "#888888"
//                     labelsColor: "#888888"
//                     gridLineColor: "#3a3a3a"
//                     minorGridLineColor: "#2a2a2a"
//                 }
                
//                 ValueAxis {
//                     id: axisY
//                     min: 0
//                     max: 100
//                     titleText: "Sensor Value"
//                     labelFormat: "%.1f"
//                     color: "#888888"
//                     labelsColor: "#888888"
//                     gridLineColor: "#3a3a3a"
//                     minorGridLineColor: "#2a2a2a"
//                 }
                
//                 LineSeries {
//                     id: lineSeries
//                     name: "Real-Time Data"
//                     axisX: axisX
//                     axisY: axisY
//                     color: "#00ff88"
//                     width: 2.5
//                 }
//             }
//         }
        
//         // Status Bar
//         Rectangle {
//             Layout.fillWidth: true
//             Layout.preferredHeight: 35
//             color: "#2d2d2d"
//             radius: 6
            
//             RowLayout {
//                 anchors.fill: parent
//                 anchors.margins: 8
//                 spacing: 10
                
//                 Rectangle {
//                     width: 10
//                     height: 10
//                     radius: 5
//                     color: (chartDataProvider && chartDataProvider.isPaused) ? "#ff4444" : "#00ff88"
                    
//                     SequentialAnimation on opacity {
//                         running: chartDataProvider && !chartDataProvider.isPaused
//                         loops: Animation.Infinite
//                         NumberAnimation { to: 0.3; duration: 500 }
//                         NumberAnimation { to: 1.0; duration: 500 }
//                     }
//                 }
                
//                 Text {
//                     text: (chartDataProvider && chartDataProvider.isPaused) ? "⏸ Paused" : "● Recording"
//                     font.pixelSize: 13
//                     color: (chartDataProvider && chartDataProvider.isPaused) ? "#ff4444" : "#00ff88"
//                 }
                
//                 Item { Layout.fillWidth: true }
                
//                 Text {
//                     text: "📁 Logging to: logs/chart_data.xml"
//                     font.pixelSize: 12
//                     color: "#888888"
//                 }
//             }
//         }
//     }
    
//     Connections {
//         target: chartDataProvider
        
//         function onSeriesDataChanged(points) {
//             lineSeries.clear()
            
//             for (var i = 0; i < points.length; i++) {
//                 lineSeries.append(points[i].x, points[i].y)
//             }
            
//             // Auto-scale X axis
//             if (points.length > 0) {
//                 var lastPoint = points[points.length - 1]
//                 if (lastPoint.x > axisX.max - 10) {
//                     axisX.max = lastPoint.x + 10
//                     axisX.min = Math.max(0, lastPoint.x - 90)
//                 }
//             }
//         }
//     }
    
//     Component.onCompleted: {
//         console.log("===== CHART VIEW LOADED =====")
//         console.log("ChartDataProvider available:", chartDataProvider !== null)
//         if (chartDataProvider) {
//             console.log("Initial points:", chartDataProvider.pointCount)
//             console.log("Is paused:", chartDataProvider.isPaused)
//         }
//     }
// }
