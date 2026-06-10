import QtQuick
import Quickshell.Hyprland
Rectangle{
          color:"#ffffff"
          implicitWidth: Math.min(textItem.implicitWidth + 20, 600)
          Behavior on implicitWidth {
            NumberAnimation {
              duration: 300
              easing.type: Easing.OutCubic
            }
          }
          Text {
            anchors.left: parent.left
            anchors.verticalCenter: parent.verticalCenter
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
