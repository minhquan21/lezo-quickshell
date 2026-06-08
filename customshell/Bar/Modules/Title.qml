import QtQuick
import Quickshell.Hyprland
Rectangle{
          color:"#ffffff"
          width: Math.min(textItem.implicitWidth + 20, 500)
          Behavior on width {
            NumberAnimation {
              duration: 300
              easing.type: Easing.OutCubic
            }
          }
          Text {
            anchors.centerIn: parent
            anchors.leftMargin: 10
            anchors.rightMargin: 10
            id:textItem
            property string win: Hyprland.activeToplevel ? Hyprland.activeToplevel.title : "~"
            property var activeWorkspace: Hyprland.focusedWorkspace?.id
            property var windowactiveWorkspace: Hyprland.activeToplevel?.workspace?.id ?? 0
            text: (windowactiveWorkspace === activeWorkspace) ? win : "~"
            font.pixelSize:15
            color: "#000000"
          }
        }
