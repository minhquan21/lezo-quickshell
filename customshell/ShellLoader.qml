//@ pragma UseQApplication

import QtQuick
import Quickshell
import "Bar"
import "OSD"
import "Compontent/PowerMenu"
import "Compontent/Wallpaper"

ShellRoot {
    Bar {}
    OSDController {}
    Wallpaper {}
    PowerMenu {}
}
