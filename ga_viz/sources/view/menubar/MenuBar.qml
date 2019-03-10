import QtQuick 2.0
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3

RowLayout {

    spacing: 0

    Label {
        Layout.preferredWidth: 150
        Layout.fillHeight: true

        text: "GA-Viz"
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
    }

    MenuBarButton {
        text: "New Viz"
        onClicked: pages.pop()
    }

    MenuBarButton {
        text: "Quit"
        onClicked: Qt.quit()
    }

    Item {
        Layout.fillWidth: true
    }
}
