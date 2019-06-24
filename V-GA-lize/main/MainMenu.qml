import QtQuick 2.9
import QtQuick.Window 2.2
import QtQuick.Controls 2.3

import "../views/menu"

/* The Main Page, the first you see when launching the program
   Contains :
      - A MenuPage, home page of the program
         allows you to select a file to load
      - The Visualization Page, on which you will
         be sent after selecting a file
*/
StackView {
    id: pages
    anchors.fill: parent

    initialItem: menuPage
    property Component mp : menuPage

    Component {
        id: menuPage
        MenuPage {
            onFileLoaded: {
                pages.push(vizPage);
            }
        }
    }

    Component {
        id: vizPage
        Visualization {}
    }

}
