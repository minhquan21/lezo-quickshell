import QtQuick

import Quickshell
import Quickshell.Wayland

PanelWindow {

    id: root

    anchors {

        top: true
        left: true
        right: true
        bottom: true
    }

    color: "transparent"

    visible: false

    signal clickedOutside()

    Rectangle {

        anchors.fill: parent

        color: "transparent"

        MouseArea {

            anchors.fill: parent

            onClicked: {

                root.clickedOutside()
            }
        }
    }
}
