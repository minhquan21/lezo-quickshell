import QtQuick
import "../Services" as Services

Rectangle {
  radius:5
  id: root
property string brightnessVal:Services.Brightness.brightness >= 75 ? "brightness_7" : Services.Brightness.brightness ? "brightness_6" : "brightness_5"
property string volumeVal:Services.Volume.volumeMute ? "volume_off" : Services.Volume.volume >= 50 ? "volume_up" : Services.Volume.volume > 0 ? "volume_down" : "volume_mute"
  width: 220
  height:100 
  
  border.color:"#ffffff" 
  border.width: 0.5
  color: "#000000"

  Column {
    anchors.centerIn: parent

    spacing: 18

    // VOLUME
    Row {
      id:volume
      spacing: 6
     

      Rectangle {
        anchors.verticalCenter: volume.verticalCenter
        radius:5
        width: 180
        height: 20


        color: "#444444"
        Rectangle {
          radius: 5

          width:
          parent.width
          * (Services.Volume.volume / 100)

          height: parent.height


          color: Services.Volume.volumeMute ? "#949494" : "#e0e0e0"

          Behavior on width {
            NumberAnimation {
              duration: 120
              easing.type: Easing.OutCubic
            }
          }
          Rectangle{
            radius:5
            property int progressVal: Services.Volume.volume * 1.6
            anchors.left:parent.left
            anchors.leftMargin:progressVal 
            color:"#ffffff" 
            width: 20 
            height: 20
            Text {
              text:
              volumeVal 
              anchors.centerIn: parent
              color: "black"
              font.family:"Material Symbols Rounded"
              font.pixelSize: 18
            }
            Behavior on progressVal {
              NumberAnimation {
                duration: 120
                easing.type: Easing.OutCubic
              }
            }
          }
        }
      }
    }

    // BRIGHTNESS
    Row {
      id:brightness
      spacing: 6
      Rectangle {
        radius:5 

        width: 180
        height: 20
        anchors.verticalCenter: brightness.verticalCenter

        color: "#444444"

        Rectangle {
          radius:5
          width:
          parent.width
          * (Services.Brightness.brightness / 100)

          height: parent.height


          color: "#e0e0e0"

          Behavior on width {
            NumberAnimation {
              duration: 120
              easing.type: Easing.OutCubic
            }
          }
          Rectangle{
            radius:5
            property int progressVal: Services.Brightness.brightness * 1.6
            anchors.left:parent.left
            anchors.leftMargin:progressVal 
            color:"#ffffff" 
            width: 20 
            height: 20
            Text {
              text:
              brightnessVal 
              anchors.centerIn: parent
              color: "black"
              font.family:"Material Symbols Rounded"
              font.pixelSize: 18
            }
            Behavior on progressVal {
              NumberAnimation {
                duration: 120
                easing.type: Easing.OutCubic
              }
            }
          }
        }
      }
    }
  }
}
