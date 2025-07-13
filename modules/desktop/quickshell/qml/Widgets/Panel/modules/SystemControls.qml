import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

RowLayout {
    id: root
    required property var shell

    spacing: 8
    signal systemActionRequested(string action)
    signal mouseChanged(bool containsMouse)

    readonly property bool containsMouse: lockButton.containsMouse || rebootButton.containsMouse || shutdownButton.containsMouse

    onContainsMouseChanged: root.mouseChanged(containsMouse)

    opacity: visible ? 1 : 0

    Behavior on opacity {
        NumberAnimation {
            duration: 300
            easing.type: Easing.OutCubic
        }
    }

    // Reboot Button
    SystemButton {
        id: rebootButton
        Layout.fillHeight: true
        Layout.fillWidth: true

        shell: root.shell
        iconText: "restart_alt"

        onClicked: root.systemActionRequested("reboot")
        onMouseChanged: function (containsMouse) {
            if (!containsMouse && !root.containsMouse) {
                root.mouseChanged(false);
            }
        }
    }

    // Shutdown Button
    SystemButton {
        id: shutdownButton
        Layout.fillHeight: true
        Layout.fillWidth: true

        shell: root.shell
        iconText: "power_settings_new"

        onClicked: root.systemActionRequested("shutdown")
        onMouseChanged: function (containsMouse) {
            if (!containsMouse && !root.containsMouse) {
                root.mouseChanged(false);
            }
        }
    }
}
