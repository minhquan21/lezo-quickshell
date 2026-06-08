import QtQuick
import Quickshell 
import Quickshell.Io
import Quickshell.Hyprland

PanelWindow {
    id: powermenu
    
    // --- TIẾN TRÌNH HỆ THỐNG ---
    Process {
        id: poweroffProc
        command: ["systemctl", "poweroff"]
    }
    Process {
        id: rebootProc
        command: ["systemctl", "reboot"]
    }
    Process {
        id: suspendProc
        command: ["systemctl", "suspend"]
    }
    Process {
        id: logoutHyprland
        command: ["hyprctl", "dispatch", "exit"]
    }
    
    // --- THUỘC TÍNH ĐIỀU KHIỂN & HIỆU ỨNG ANIMATION ---
    property bool powerMenuVisible: false 
    
    anchors.right: true
    margins.right: powerMenuVisible ? 15 : -width - 20
    
    Behavior on margins.right {
        NumberAnimation {
            duration: 250
            easing.type: Easing.OutCubic
        }
    }
    
    exclusiveZone: 0
    implicitWidth: 120
    implicitHeight: 450
    color: "transparent"
    visible: true

    // --- BỘ ĐỒ CHƠI HYPRLAND FOCUS GRAB ---
    HyprlandFocusGrab {
      id: focusGrab
      windows: [ powermenu ]
      active: powermenu.powerMenuVisible

      onCleared: {
        powermenu.powerMenuVisible = false
      }

      // Khi Hyprland vừa khóa focus vào cửa sổ, ép Rectangle con nhận bàn phím ngay
      onActiveChanged: {
        if (active) {
          rect.forceActiveFocus()
        }
      }
    }

    // --- IPC HANDLER ---
    IpcHandler {
        target: "powermenu"

        function toggle() {
            powermenu.powerMenuVisible = !powermenu.powerMenuVisible
            if (powermenu.powerMenuVisible) {
                rect.forceActiveFocus() // Ép Rectangle nhận focus khi gọi phím tắt
            }
        }

        function show() {
            powermenu.powerMenuVisible = true
            rect.forceActiveFocus()
        }

        function hide() {
            powermenu.powerMenuVisible = false
        }
    }



    // --- COMPONENT NÚT BẤM (MATERIAL SYMBOLS ROUNDED) ---
    component PowerButton: Rectangle {
        id: btnRoot
        property string label: ""
        property var proc: null 
        
        color: "#ffffff"
        radius: 5
        width: 100 
        height: 100

        Text {
            anchors.centerIn: parent
            text: btnRoot.label
            color: "black"
            font.bold: true
            font.pixelSize: 24
            font.family: "Material Symbols Rounded"
        }

        MouseArea {
            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor
            
            hoverEnabled: true
            onEntered: btnRoot.opacity = 0.8
            onExited: btnRoot.opacity = 1.0

            onClicked: {
                console.log("Bam nut roi nhe!")
                if (btnRoot.proc !== null) {
                    btnRoot.proc.exec(btnRoot.proc.command) 
                }
                powermenu.powerMenuVisible = false
            }
        }
    }

    // --- KHUNG NỀN PANEL MONOCHROME ---
    Rectangle {
        id: rect
        anchors.fill: parent
        border.color: "#aaffffff" 
        border.width: 1
        radius: 5
        color: "black"
        focus: true
        Keys.onPressed: (event) => {
            if (event.key === Qt.Key_Escape) {
                console.log("[Arthur Morgan]: 'Escaping out...'")
                powermenu.powerMenuVisible = false
                event.accepted = true
            }
        }

        Column {
            padding: 10 
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: 10
            
            PowerButton { label: "power_settings_new"; proc: poweroffProc }
            PowerButton { label: "restart_alt"; proc: rebootProc }
            PowerButton { label: "bedtime"; proc: suspendProc }
            PowerButton { label: "exit_to_app"; proc: logoutHyprland } 
        }
    }
}
