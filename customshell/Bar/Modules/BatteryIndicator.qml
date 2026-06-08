import QtQuick
import Quickshell
import Quickshell.Io

Item {
  id: root

  implicitWidth: Math.min(box.implicitWidth + 22, 500)
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

    Text {
      anchors.centerIn: parent

      text: box.expanded ? batteryPercent : box.batteryIcon

      color: "black"

      font.family: box.expanded ? " " : "Material Symbols Rounded"
      font.pixelSize: box.expanded ? 12 : 18
    }

    MouseArea {
      anchors.fill: parent
      hoverEnabled: true

      onClicked: box.expanded = !box.expanded
      onExited: box.expanded = false
    }
  }
}
