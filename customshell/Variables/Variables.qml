pragma Singleton

import QtQuick
import "../Services" as Services

QtObject {

  property bool visible: false
  property string label: ""
  property bool labelWidget
  property int value
}
