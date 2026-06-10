import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Widgets
import Quickshell.Wayland
import ".."

PopupWindow {
  id: root
  required property var menuHandle
  property Item anchorItem
  property var anchorWindow

  implicitWidth: 240
  implicitHeight: contentColumn.implicitHeight + 12
  color: "transparent"

  anchor.item: anchorItem
  anchor.edges: Edges.None
  anchor.gravity: Edges.Top
  anchor.rect.y:-10 

 

  property bool isExpanded: false
  onVisibleChanged: {
    if (visible) {
      isExpanded = true;
    } else {
      isExpanded = false;
    }
  }

  Timer {
    id: closeTimer
    interval: 100 
    onTriggered: {
      root.visible = false
    }
  }
  function closeMenu() {
    closeTimer.restart()
  }

  QsMenuOpener {
    id: opener
    menu: root.menuHandle
  }

  Rectangle {
    id: contentRect
    anchors.fill: parent
    color: "#000000"
    border.width: 0
    border.color: "#ffffff"
    radius:5
       
    clip: true 
    transform: Translate {
      y: root.isExpanded ? 0 : 40 // Dịch xuống 40px khi ẩn
      Behavior on y {
        NumberAnimation { duration: 200; easing.type: Easing.OutCubic }
      }
    }

    opacity: root.isExpanded ? 1 : 0
    Behavior on opacity {
      NumberAnimation { duration: 100 }
    }
    Timer {
      id: hoverCloseTimer

      interval: 100

      onTriggered: {
        root.isExpanded = false
        closeTimer.start()
      }
    }

    HoverHandler {
      id: menuHover

      onHoveredChanged: {
        if (!hovered) {
          hoverCloseTimer.restart()
        }
        else {
          hoverCloseTimer.stop()
          closeTimer.stop()
        }
      }
    }


    Column {
      id: contentColumn
      anchors.fill: parent
      anchors.margins: 6
      spacing: 2

      Repeater {
        model: opener.children
        delegate: Item {
          required property var modelData
          implicitWidth: 220
          implicitHeight: modelData.isSeparator ? 8 : 30

          Component.onCompleted: {
            // console.log("Text:", modelData.text, "Icon Raw:", modelData.icon)
          }

          Rectangle {
            anchors.fill: parent
            color: mouse.containsMouse ? "#313244" : "transparent"
            visible: !modelData.isSeparator
          }

          Rectangle {
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.left
            anchors.right: parent.right
            height: 1
            color: "#45475a"
            visible: modelData.isSeparator
          }

          RowLayout {
            anchors.fill: parent
            anchors.leftMargin: 10
            anchors.rightMargin: 10
            spacing: 8

            Image {
              id: menuIcon
              sourceSize.width: 16
              sourceSize.height: 16
              fillMode: Image.PreserveAspectFit

              source: {
                let raw = modelData.icon || "";
                if (raw === "") return "";

                if (raw.startsWith("image://") || raw.startsWith("file://")) {
                  return raw;
                }

                if (raw.startsWith("/")) {
                  return "file://" + raw;
                }

                return "image://icon/" + raw;
              }

     
              visible: source !== "" && status === Image.Ready

              onStatusChanged: {
                if (status === Image.Error && source !== "") {
                 }
              }
            }

            Text {
              Layout.fillWidth: true
              text: modelData.text
              color: modelData.enabled ? "#cdd6f4" : "#6c7086"
              font.pixelSize: 13
            }

            Text {
              text: modelData.checkState === 2 ? "✓" : ""
              color: "#89b4fa"
              visible: modelData.buttonType !== 0
            }

            Text {
              text: modelData.hasChildren ? "▶" : ""
              color: "#a6adc8"
            }
          }

          MouseArea {
            id: mouse
            anchors.fill: parent
            hoverEnabled: true
            enabled: modelData.enabled
            onClicked: {
              console.log("CLICK:", modelData.text)
              modelData.triggered()
              root.isExpanded = false
              closeTimer.start()
            }
          }
        }
      }
    }
  }
}
