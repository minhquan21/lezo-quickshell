import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import Quickshell.Hyprland
import Quickshell.Io
import "../Appearence"
import "../Services" as Services
import "./Modules" as Modules
import "./Modules/Tray" as Tray
import "../OSD" as OSD


PanelWindow {
  WlrLayershell.layer: WlrLayer.Top
  color: "transparent"
  anchors.bottom: true
  anchors.left: true
  anchors.right: true
  aboveWindows: true
  implicitWidth: 1900
  implicitHeight: 30
  Rectangle{
    clip:false
    color:"#000000"
    anchors.fill:parent
    RowLayout{
      spacing: 10
      anchors.left: parent.left
      anchors.verticalCenter: parent.verticalCenter
      Modules.Workspace{
        anchors.leftMargin:5
      }
      Modules.Title {
        Layout.preferredWidth:implicitWidth
        radius:5
        height:20
      }
      PanelBox{}
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
          Layout.preferredWidth: implicitWidth
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
