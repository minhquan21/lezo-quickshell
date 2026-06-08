pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Services.Pipewire
import "../Variables" as Variables

Item {
    id: root

    property var sink:
        Pipewire.defaultAudioSink

    property int volume: 0
    property bool volumeMute: sink?.audio?.muted ?? false 
    PwObjectTracker {
        objects: [
            Pipewire.defaultAudioSink
        ]
    }

    function syncVolume() {

        if (!root.sink)
            return

        let val = Math.round(
            root.sink.audio.volume * 100
        )

        if (root.volume === val)
            return

        root.volume = val

        /*console.log(
            "Volume updated:",
            val
          )*/


        Variables.Functions.showVolume()
      }
      function syncVolumeMuted() {
        Variables.Functions.showVolume()
      }

    Connections {
        target: root.sink ? root.sink.audio : null
        
        enabled: target !== null

        function onMutedChanged() {
            root.volumeMute = root.sink?.audio?.muted ?? false
            root.syncVolumeMuted()
        }

        function onVolumeChanged() {
            root.syncVolume()
        }
    }
       
    Component.onCompleted: {
        syncVolume()
    }
}
