import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Widgets

PopupWindow {
  id: root
  required property var menuHandle
  property Item anchorItem
  property var anchorWindow

  implicitWidth: 240
  implicitHeight: contentColumn.implicitHeight + 12
  color: "transparent"

  // Sử dụng anchor.window và anchor.item để đồng bộ hệ tọa độ
  anchor.item: anchorItem
  anchor.edges: Edges.None
  anchor.gravity: Edges.Top
  anchor.rect.y:-0 

  // Tạo hiệu ứng trượt cho nội dung bên trong dựa trên trạng thái hiển thị
  property bool isExpanded: false
  onVisibleChanged: {
    if (visible) {
      isExpanded = true;
    } else {
      isExpanded = false;
    }
  }

  ClickCatcher { 
    id: catcher 
    visible: root.visible 
    onClickedOutside: { 
      // Trước tiên thu nhỏ/trượt menu xuống, sau đó mới ẩn hẳn
      root.isExpanded = false
      closeTimer.start()
    }
  }

  Timer {
    id: closeTimer
    interval: 200 // Trùng khớp với thời gian animation trượt
    onTriggered: {
      root.visible = false
    }
  }

  QsMenuOpener {
    id: opener
    menu: root.menuHandle
  }

  Rectangle {
    id: contentRect
    anchors.fill: parent
    color: "#000000"
    border.width: 1
    border.color: "#ffffff"
    clip: true // Đảm bảo nội dung khi trượt xuống không bị lộ ra ngoài ranh giới popup

    // Hiệu ứng dịch chuyển trượt mượt mà cho phần nội dung bên trong
    transform: Translate {
      y: root.isExpanded ? 0 : 40 // Dịch xuống 40px khi ẩn
      Behavior on y {
        NumberAnimation { duration: 200; easing.type: Easing.OutCubic }
      }
    }

    // Kết hợp hiệu ứng mờ dần (opacity) để menu trông thanh lịch hơn
    opacity: root.isExpanded ? 1 : 0
    Behavior on opacity {
      NumberAnimation { duration: 150 }
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

          // Debug để kiểm tra cấu trúc dữ liệu menu nếu cần thiết
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

                // Nếu đã có sẵn tiền tố như image:// hoặc file:// thì giữ nguyên
                if (raw.startsWith("image://") || raw.startsWith("file://")) {
                  return raw;
                }

                // Nếu là đường dẫn tuyệt đối cục bộ
                if (raw.startsWith("/")) {
                  return "file://" + raw;
                }

                // Nếu chỉ là tên icon thuần túy
                return "image://icon/" + raw;
              }

              // PHẦN QUAN TRỌNG NHẤT: Triệt tiêu ô vuông hồng
              // Chỉ hiển thị icon khi nó đã sẵn sàng (Image.Ready) và nguồn không trống.
              // Nếu gặp Image.Error (không tìm thấy icon trong theme), nó sẽ lập tức bị ẩn đi
              visible: source !== "" && status === Image.Ready

              // Bạn có thể tùy chọn fallback sang một dấu tròn nhỏ hoặc icon mặc định của Papirus
              onStatusChanged: {
                if (status === Image.Error && source !== "") {
                  // Fallback sang một icon tối giản nếu muốn, ví dụ: "image://icon/system-run"
                  // Ở đây chúng ta tạm thời để ẩn (visible: false) để giao diện trông cực kỳ sạch sẽ
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
