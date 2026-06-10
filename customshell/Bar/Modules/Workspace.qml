import QtQuick
import Quickshell
import Quickshell.Hyprland
import Quickshell.Widgets
Rectangle{
  property var win: Hyprland.activeToplevel?.title ?? "~"
  property string activeWorkspace: Hyprland.focusedWorkspace?.id ?? 0
  property var windowactiveWorkspace: Hyprland.activeToplevel?.workspace.id
  color: "#ffffff"
  anchors.verticalCenter:parent.verticalCenter
  anchors.left:parent.left
  width:20
  height:20
  radius:5
  Text {
    anchors.centerIn:parent
    color: "#000000"
    text: activeWorkspace 
    font.pixelSize: 15
  }
  MouseArea {
    anchors.fill: parent
    onWheel: (event) => {
      if (event.angleDelta.y < 0) {
        if (activeWorkspace<9) {
          Hyprland.dispatch("workspace +1")}
        } 
        else {
          Hyprland.dispatch("workspace -1")
        }
      }
    } 
  }
