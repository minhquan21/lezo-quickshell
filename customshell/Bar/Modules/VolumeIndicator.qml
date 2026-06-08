import QtQuick
import Quickshell.Io
import Quickshell.Services.Pipewire
import "../../Services" as Services

Rectangle {
      color:"#ffffff" 
      height:20
      implicitWidth:Math.min(volumebox.implicitWidth + 10, 500)
      Text {
        property string volumeVal:Services.Volume.volumeMute ? "volume_off":Services.Volume.volume >= 50 ? "volume_up" : Services.Volume.volume > 0 ? "volume_down" : "volume_mute"
        id: volumebox
        text: volumeVal 
        anchors.centerIn:parent
        color:"black"
        font.family: "Material Symbols Rounded"
        font.pixelSize:15
      }
      function volumeToggle(){
        volumeProc.exec(["bash",
        "-c",
        " wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"])
      }

      Process {
        id: volumeProc
      }
      MouseArea {
        anchors.fill:parent
        onClicked:volumeToggle()
        onWheel: (event) => {
          if (event.angleDelta.y > 0) {
            volumeProc.exec(["bash",
            "-c",
            "wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+ && hyprctl dispatch event volume"])
          } 
          else {
            volumeProc.exec([
              "bash",
              "-c",
              "wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%- && hyprctl dispatch event volume"
            ]) 
          }
        }
      }
    }
