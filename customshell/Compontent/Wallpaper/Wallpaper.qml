import Quickshell
import QtQuick
import Quickshell.Wayland

PanelWindow {
    id: root

    exclusiveZone: -1
    color: "transparent"
    implicitWidth:Screen.width 
    implicitHeight:Screen.height
    WlrLayershell.layer: WlrLayer.Bottom

    Rectangle {
        anchors.fill: parent
        color: "transparent"
        clip:true

        Image {
            anchors.fill: parent
            source: "file:///home/lezo/Pictures/background"
            fillMode: Image.PreserveAspectCrop
            smooth: true
            cache: true
        }
    }
}
