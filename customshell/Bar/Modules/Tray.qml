import QtQuick
import Quickshell
import Quickshell.Services.SystemTray
import "./Tray"

Row {
  property var activePopup: null

    id: root

    spacing: 6

    function dumpEntry(entry, depth) {

        let indent = ""

        for (let i = 0; i < depth; ++i)
            indent += "  "

        console.log(indent + "==========")
        console.log(indent + "ENTRY")

        let keys = [
            "text",
            "enabled",
            "visible",
            "isSeparator",
            "hasChildren",
            "checkState",
            "buttonType",
            "icon"
        ]

        for (let key of keys) {

            try {

                console.log(
                    indent + key + ":",
                    entry[key]
                )

            } catch (e) {

                console.log(
                    indent + key + ": <error>"
                )
            }
        }

        if (entry.hasChildren) {

            console.log(indent + "SUBMENU FOUND")

            let opener = submenuComponent.createObject(
                root,
                {
                    "menuHandle": entry,
                    "depth": depth + 1
                }
            )

            opener.dump()
            opener.destroy()
        }
    }

    Component {

        id: submenuComponent

        QtObject {

            required property var menuHandle
            required property int depth

            property var opener: QsMenuOpener {
                menu: menuHandle
            }

            function dump() {

              console.log("==========")
              console.log("DUMP START")

              console.log(
                "MENU HANDLE:",
                menuHandle
              )

              console.log(
                "CHILDREN MODEL:",
                opener.children
              )

              console.log(
                "VALUES BEFORE:",
                opener.children.values
              )

              if (menuHandle.updateLayout) {

                console.log(
                  "CALLING updateLayout()"
                )

                menuHandle.updateLayout()
              }

              Qt.callLater(() => {

                console.log(
                  "VALUES AFTER:",
                  opener.children.values
                )

                console.log(
                  "COUNT:",
                  opener.children.values.length
                )

                for (
                  let i = 0;
                  i < opener.children.values.length;
                  ++i
                ) {

                  let child =
                  opener.children.values[i]

                  console.log("==========")
                  console.log("ENTRY", i)

                  for (let key in child) {

                    try {

                      console.log(
                        key,
                        ":",
                        child[key]
                      )

                    } catch (e) {

                      console.log(
                        key,
                        ": <error>"
                      )
                    }
                  }
                }
              })
            }
 
        }
    }

    Repeater {

        model: SystemTray.items

        delegate: Rectangle {
          color:"transparent" 
          border.color:"#aaffffff"
          radius:5
          Timer {
            id: closeTimer

            interval: 250

            onTriggered: {
              if (!mouse.containsMouse &&
              !popup.menuHovered)
              {
                popup.visible = false
              }
              console.log("here is closeTimer event")
            }
          }
          MenuPopup {

            id: popup

            menuHandle: modelData.menu

            anchorItem: trayRect
          }

          QsMenuOpener {

            id: opener

            menu: modelData.menu
          }

          Repeater {

            model: opener.children

            delegate: Item {

              required property var modelData
              required property int index

            }
          }


          id: trayRect

          required property var modelData

          width: 20
          height: 20



          Image {
            id: trayIcon
            anchors.centerIn: parent
            source: {
              let iconPath = modelData.iconName || modelData.icon || "";

              if (iconPath.startsWith("image://")) {
                return iconPath;
              }

              if (iconPath !== "") {
                return "image://icon/" + iconPath;
              }

              return "image://icon/application-x-executable";
            }

            sourceSize.width: 20
            sourceSize.height: 20
          }

          MouseArea {

            id: mouse

            anchors.fill: parent

            hoverEnabled: true

            acceptedButtons:
            Qt.LeftButton
            | Qt.RightButton

            onClicked: event => {

              switch (event.button) {

                case Qt.LeftButton:

                console.log(
                  "LEFT CLICK:",
                  modelData.title
                )

                modelData.activate()

                break

                case Qt.RightButton:


                break
              }
            }
            onEntered: {

              if (
                activePopup &&
                activePopup !== popup
              ) {
                activePopup.closeMenu()
              }

              activePopup = popup

              popup.visible = true
            }            
            onExited: {
              console.log("exited.")
              popup.closeMenu()
            }
          }
        }
    }
}
