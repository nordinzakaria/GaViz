import QtQuick 2.0
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3

/* The Menu at the top of the screen
   Contains :
      - A Logo
      - A "Help" Button, opening a PopUp Window the contains
           two pages : "Help" and "About"
      - A "Parameters" Button, opening a PopUp Window
      - A "New" Button, allowing to return to the MenuPage
           in order to load a different File
      - A "Quit" Button, in order to leave the program
*/
RowLayout{
    spacing: 0
    Layout.bottomMargin: -5
    Layout.topMargin: 3

    // Just an Image used as a logo/title for the window
    Image {
        source : "../../images/Logo2.png"

        opacity: 0.77
        Layout.topMargin: 1
        Layout.rightMargin: 1
    }

    /* A MenuButton with a "Question Mark" icon
       When clicked, opens a PopUp Window containing
       two pages :
          - An "Help" page that will provide indication about
                all the different Buttons and ToolSeparator
          - An "About" page that will give information about
                the origin of the program, contact, ...
    */
    MenuButton {
        id : helpButton
        trueIcon.source: "../../images/icons/image_part_028.png"
        Layout.leftMargin: 15

        onClicked: dialog.open()

        // The PopUp Window
        Dialog {
            id: dialog
            title: qsTr("Help And About")
            visible: false

            anchors.centerIn: Overlay.overlay
            width: 800
            height: 600
            modal : false

            standardButtons: Dialog.Ok

            contentItem: ColumnLayout {

                // SwipeView containing the two pages
                SwipeView {
                    id: view
                    Layout.fillHeight: true
                    Layout.fillWidth: true
                    clip: true

                    // The "Help" Page
                    Label{
                        id: help
                        text: qsTr("This is the Help Page" + '\n'+
                                   "This page is not used yet.")
                    }

                    //The "About" Page
                    Label{
                       id: about
                       text: qsTr("This is the About Page" + '\n'+
                                  "This page is not used yet.")
                    }
                }

                // A PageIndicator showing on which of the two pages the user is
                PageIndicator {
                    id: indicator
                    Layout.alignment: Qt.AlignHCenter
                    interactive: true
                    count: view.count
                    currentIndex: view.currentIndex
                }

            }
        }

        ToolTip.visible: hovered
        ToolTip.text: "Help"
    }

    /* A MenuButton with a "Gear" icon and "Parameters" text
       When clicked, opens a PopUp Window containing different
       CheckBoxes, Switches, Sliders, ...
       In order to adjust various parameters

       Work In Progress
    */
    MenuButton {
        id : changeButton
        trueIcon.source: "../../images/icons/image_part_001.png"
        Layout.minimumWidth: 200

        onClicked: params.open()

        Dialog {
            id: params
            title: qsTr("Visualization Parameters")
            visible: false

            anchors.centerIn: Overlay.overlay
            width: 800
            height: 600
            modal : false

            standardButtons: Dialog.Ok | Dialog.Apply

            contentItem: ColumnLayout {

                Label{
                    text : "This page is not used yet."
                }

                /*
                ComboBox {
                    id: vizType
                    model: ListModel {
                        id: model
                        ListElement { text: "Banana" }
                        ListElement { text: "Apple" }
                        ListElement { text: "Coconut" }
                    }
                }


                ComboBox {
                    id: vizType2
                    model: ListModel {
                        id: model2
                        ListElement { text: "Banana" }
                        ListElement { text: "Apple" }
                        ListElement { text: "Coconut" }
                    }
                }
                */

                Item {
                    Layout.fillHeight: true
                }
            }
        }

        ToolTip.visible: hovered
        ToolTip.text: "Visualization Parameters"
    }

    // An empty Item in order to separate the Buttons on the left and those on the right
    Item {
        Layout.fillWidth: true
    }

    /* A MenuButton with a "Plus" icon
       When clicked, sends the user back to the Home Page
       on which he will be able to load a different file
    */
    MenuButton {
        id : newButton
        trueIcon.source: "../../images/icons/image_part_025.png"

        onClicked: pages.pop()

        ToolTip.visible: hovered
        ToolTip.text: "New Visualization"
    }

    /* A MenuButton with a "X" icon
       When clicked, suits the Program
    */
    MenuButton {
        id : exitButton
        trueIcon.source: "../../images/icons/image_part_004.png"

        onClicked: Qt.quit()
        ToolTip.visible: hovered
        ToolTip.text: "Exit Programm"
    }
}
