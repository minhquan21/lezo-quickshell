pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io
import "../Variables" as Variables

Item {
    id: root
    property int brightness: 0
    Process {
      id:syncWorker
      command: [
        "bash",
        "-c",
        "udevadm monitor --subsystem=backlight"
      ] 
      running: true
      stdout: SplitParser{
        onRead: (data) => {
          if (!brightnessProc.running)
          brightnessProc.running = true
        }
      }
    }

    Process {
        id: brightnessProc
        running: false

        command: [
            "bash",
            "-c",
            "brightnessctl g"
        ]

        stdout: SplitParser {
            onRead: (data) => {
                let val = parseInt(
                    data.trim()
                )

                if (isNaN(val))
                    return

                if (root.brightness === val)
                    return

                root.brightness = val


                Variables.Functions.showBrightness()
            }
        }
    }
    Component.onCompleted: {
    }
}
