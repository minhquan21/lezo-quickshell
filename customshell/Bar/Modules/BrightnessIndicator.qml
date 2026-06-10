import QtQuick
import Quickshell.Io
import "../../Services" as Services
Rectangle{
  height: 20
  implicitWidth: Math.min(brightnessbox.implicitWidth + 5, 500)
  Process {
    id: brightnessProc
  }
  property string brightnessVal:Services.Brightness.brightness >= 75 ? "brightness_7" : Services.Brightness.brightness ? "brightness_6" : "brightness_5"    
  MouseArea {
    anchors.fill:parent
    onClicked: console.log("button clicked.")
    onWheel: (event) => {
      if (event.angleDelta.y > 0) {
        brightnessProc.exec(["bash","-c","brightnessctl -e4 -n2 set 5%+ && hyprctl dispatch event brightness"])
      } 
      else {
        brightnessProc.exec([
          "bash","-c","brightnessctl -e4 -n2 set 5%- && hyprctl dispatch event brightness"        ]) 
        }
      }
    }

    Text {
      id: brightnessbox
      anchors.centerIn: parent
      text:brightnessVal 
      color:"black"
      font.family: "Material Symbols Rounded"
      font.pixelSize:15
    }
  }
