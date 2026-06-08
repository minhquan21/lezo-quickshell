pragma Singleton

import QtQuick

QtObject {
    id: root

    property Timer hideTimer: Timer {

        interval: 1250
        repeat: false

        onTriggered: {

            Variables.visible = false

            /*console.log(
                "AYE, HIDING OSD"
              )*/
        }
    }

    function showVolume() {
        Variables.labelWidget = true
        Variables.visible = true
        /*console.log(
            "AYE, SHOWING OSD"
          )*/

        hideTimer.restart()
    }
    function showBrightness() {
        Variables.labelWidget = false 
        Variables.visible = true
        /*console.log(
            "AYE, SHOWING OSD"
          )*/

        hideTimer.restart()
    }
}
