import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Hyprland
import "../Services" as Services
import "./Modules" as Modules
import "./Modules/Tray" as Tray
import Quickshell.Io
import "../OSD" as OSD


PanelWindow {
  color: "transparent"
  anchors.bottom: true
  margins.left: 5
  margins.bottom: 5
  margins.right: 5
  anchors.left: true
  anchors.right: true
  aboveWindows: true
  implicitWidth: 1900
  implicitHeight: 30
  Rectangle{
    radius:5
    border.color:"#aaffffff" 
    border.width:1
    clip:false
    color:"black"
    anchors.fill:parent
    Modules.Workspace{
      radius:5
      anchors.leftMargin: 5
      anchors.left:parent.left
    }
  Modules.Title {
    radius:5
    height:parent.height - 10
    anchors.centerIn:parent
  }
  RowLayout {
    anchors.right:parent.right
    anchors.verticalCenter: parent.verticalCenter
    spacing: 5
    Modules.Tray{}
    Row{
      spacing:5 
      Modules.BrightnessIndicator{
        radius:5
        Layout.preferredWidth: implicitWidth
        anchors.verticalCenter: parent.verticalCenter
      } 
      Modules.VolumeIndicator{
        radius:5
        Layout.preferredWidth: implicitWidth
        anchors.verticalCenter: parent.verticalCenter
      }
      Modules.BatteryIndicator{
        anchors.verticalCenter: parent.verticalCenter
      }

    }
    Modules.Clock{
      radius:5
      Layout.rightMargin: 5
      Layout.fillWidth:true
      Layout.maximumWidth: 200
      Layout.preferredWidth: implicitWidth
      implicitHeight: 20
    }
  }
}
}
