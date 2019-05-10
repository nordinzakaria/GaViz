import QtQuick 2.0
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3

/* The MenuButton Type is a custom type of Button
   It is used here only in the Menu bar for aesthetical reasons

   Contains an Image used as a custom icon property
*/
Button {
    Layout.preferredWidth: 60
    Layout.preferredHeight: 60
    Layout.topMargin: 1
    Layout.rightMargin: 1
    property alias trueIcon: trueIcon

    Image{
        id:trueIcon
        anchors.fill: parent
    }

    padding: 0
    opacity: 0.77
}
