import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Hyprland
import Quickshell.Widgets
  Rectangle {
          id: clockContainer
          color: "#ffffff"
          property bool expanded: false
          implicitWidth: Math.min(clockbox.implicitWidth + 20, 500)
          Behavior on implicitWidth {
            NumberAnimation {
              duration: 200
              easing.type: Easing.OutCubic
            }
          }
          SystemClock {
            id: clock
            precision: SystemClock.Seconds
          }
          Text {
            id: clockbox
            anchors.centerIn: parent
            color: "#000000"
            font.pixelSize:15

            text: clockContainer.expanded
            ? Qt.formatDateTime(clock.date, "hh:mm:ss - yyyy-MM-dd")
            : Qt.formatDateTime(clock.date, "hh:mm:ss")
          }
          MouseArea {
            anchors.fill: parent
            hoverEnabled: true   
            onClicked: clockContainer.expanded = !clockContainer.expanded
            onExited: clockContainer.expanded = false
          }
}       
