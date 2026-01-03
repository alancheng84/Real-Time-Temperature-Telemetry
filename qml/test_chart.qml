import QtQuick 
import QtQuick.Window
import QtCharts 

Window {
    visible: true
    width: 640
    height: 480
    title: "Chart Test"

    ChartView {}
    // ChartView {
    //     anchors.fill: parent
    //     title: "IT WORKS!"
        
    //     LineSeries {
    //         XYPoint { x: 0; y: 0 }
    //         XYPoint { x: 1; y: 1 }
    //         XYPoint { x: 2; y: 0 }
    //     }
    // }
}
