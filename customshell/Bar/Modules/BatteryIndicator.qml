import QtQuick
import Quickshell
import Quickshell.Io

Item {
  id: root
  property bool isVisible: false
  implicitWidth:  isVisible ? 57 : 22 
  Behavior on implicitWidth {
    NumberAnimation{
      duration:200
      easing.type:Easing.OutCubic
    }
  }
  height:20
  property int batteryPercent: 0
  property string batteryStatus: "Unknown"

  Process {
    id: batteryProc

    command: [
      "sh",
      "-c",
      "cat /sys/class/power_supply/BAT1/capacity && echo '|' && cat /sys/class/power_supply/BAT1/status"
    ]

    stdout: StdioCollector {
      onStreamFinished: {
        let parts = text.trim().split("|")

        if (parts.length >= 2) {
          root.batteryPercent = parseInt(parts[0].trim())
          root.batteryStatus = parts[1].trim()

          /*console.log("Battery:", root.batteryPercent)
           console.log("Status:", root.batteryStatus)*/
        }
      }
    }
  }

  function updateBattery() {
    batteryProc.running = true
  }

  Component.onCompleted: updateBattery()

  Timer {
    interval: 5000
    running: true
    repeat: true
    onTriggered: updateBattery()
  }

  Rectangle {
    radius:5
    id: box

    anchors.fill: parent
    border.color: "white"
    border.width: 2
    color: "#ffffff"

    property bool expanded: false

    property string batteryIcon: {
      if (root.batteryStatus === "Charging")
      return "battery_android_frame_bolt" // battery_android_bolt

      if (root.batteryPercent >= 90)
      return "battery_android_frame_full" // battery_android_full

      if (root.batteryPercent >= 70)
      return "battery_android_frame_6" // battery_android_6

      if (root.batteryPercent >= 50)
      return "battery_android_frame_5" // battery_android_4

      if (root.batteryPercent >= 30)
      return "battery_android_frame_4" // battery_android_2

      if (root.batteryPercent >= 15)
      return "battery_android_frame_1" // battery_android_1

      return "battery_android_frame_0" // battery_android_0
    }
    Row{
      anchors.centerIn: parent
      spacing: 5
      Rectangle{
        radius:5
        width:20
        height:20
        Text {
          anchors.left:parent.left
          anchors.verticalCenter: parent.verticalCenter
          anchors.leftMargin: 1

          text:box.batteryIcon

          color: "black"

          font.family: "Material Symbols Rounded"
          font.pixelSize: box.expanded ? 12 : 18
        }
      }
      Rectangle{
        radius: 5
        height:20
        width: root.isVisible ? 30 : 0
        color:"#ffffff"
        Text{
          anchors.centerIn: parent
          id:batteryBoxText
          text:batteryPercent
          font.pixelSize:15
        }
      }
    }

    MouseArea {
      anchors.fill: parent
      hoverEnabled: true
      onClicked:root.isVisible = !root.isVisible
      onExited:root.isVisible = false
    }
  }
}
