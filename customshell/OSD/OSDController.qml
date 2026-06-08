import QtQuick
import Quickshell
import Quickshell.Wayland
import "../Variables" as Variables

Item {
    id: root

    
    PanelWindow {
      id: osdWindow

      WlrLayershell.layer: WlrLayer.Overlay

      visible:true


      exclusiveZone: 0

      anchors.top:true
      implicitWidth: 220
      implicitHeight: 100

      color: "transparent"


      margins.top: Variables.Variables.visible ? 5 : -150
      Behavior on margins.top {
        NumberAnimation {
          duration: 260
          easing.type: Easing.OutCubic
        }
      }

      OSDContainer {
        anchors.fill: parent
      }
    }
}
