import QtQuick 2.9
import QtQuick.Window 2.2
import QtQuick.Controls 2.3

import "./views/menu"

ApplicationWindow {
    id: window

    visible: true
    visibility: "Maximized"
    title: qsTr("V-GA-Lize")

    minimumWidth: 800
    minimumHeight: 600

    palette: gaviz.palette

    StackView {
        id: pages
        anchors.fill: parent

        initialItem: menuPage

        Component {
            id: menuPage
            MenuPage {}
        }

        Component {
            id: vizPage
            Visualization {}
        }

    }

}
