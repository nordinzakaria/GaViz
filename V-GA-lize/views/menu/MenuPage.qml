import QtQuick 2.0
import QtQuick.Controls 2.3
import QtQuick.Dialogs 1.0
import QtQuick.Layouts 1.3
import gaviz 1.0

/* The MenuPage, home page of the program
   Allows you to select a file to load
      or quit the program
*/
Page {
    id: menuPage

    signal fileLoaded();

    state: stateGroup.state = "idle";   //start in the idle state

    background : Image {
        source: "../../images/BlenderBackground3.png"
        opacity: 0.8
    }

    /* This ColumnLayout serves to contain all the visible elements in the Page
       Contains :
          - An empty Item in order to fill the empty part,
              in order to keep all the other element at the bottom
          - A Button allowing to Load a File
          - A Button allowing to Quit the Program
          - A Label displaying information about the loaded file
          - A ProgressBar showing the loading of the file
    */
    ColumnLayout {
        anchors.fill: parent
        spacing: 20


        Item {
            Layout.fillHeight: true
        }


        Button {
            id: dialogButton
            Layout.alignment: Qt.AlignRight
            Layout.rightMargin:  (0.15 * parent.width)

            text: "Load file"

            onReleased: {
                fileDialog.open();
            }
        }

        Button {
            id: quitButton
            Layout.alignment: Qt.AlignRight
            Layout.rightMargin:  (0.15 * parent.width)

            text: "Quit"
            onReleased: Qt.quit();
        }

        Label {
            id: fileInfo
            Layout.alignment: Qt.AlignHCenter
            Layout.preferredHeight: 0.5 * parent.height
            horizontalAlignment: Text.AlignHCenter
        }

        ProgressBar {
            id: prg
            Layout.alignment: Qt.AlignHCenter | Qt.AlignBottom
            Layout.bottomMargin: 0.05 * parent.height
            Layout.preferredWidth: 0.8 * parent.width

            from: 0   // C++ loop starts out with 0
            to: 1 // C++ loop ends with "Count"

            Label {
                id: progressPercentage
                anchors.bottom: parent.top
                anchors.bottomMargin: parent.height
                anchors.horizontalCenter: parent.horizontalCenter

                visible: parent.visible
                color: "black"
                font.bold: true

                text: (prg.value * 100).toFixed(1) + "%"
            }

            Connections {
                target: gaviz


                onProgressChanged: prg.value = gaviz.progress;
            }
        }

    }

    // This FileDialog is open when you press the "Load File" Button
    FileDialog {
        id: fileDialog
        title: "Please choose a file"
        folder: shortcuts.home
        modality: Qt.NonModal

        onAccepted: {
            console.debug("Accepted");

            menuPage.state = stateGroup.state = "parsing";
            gaviz.readGAFile(fileDialog.fileUrl);
        }

        onRejected: {
            console.degub("Canceled");

            menuPage.state = stateGroup.state = "idle";
        }

    }

    // Connections displaying info about the loaded file in the console
    Connections {
        target: gaviz

        onDoneLoadingFile: {

            /* If the loading is successful,
               Displays info about the file and sends the user
               to the Visualization Page
            */
            if(success)
            {
                console.debug("Population info:\n")
                console.debug("Number of Generations : "+ gaviz.getNbGenerations())
                console.debug("Max Num Individuals in a Generation : "+ gaviz.getMaxNbIndPerGeneration())
                console.debug("Number of Objective Functions : " + gaviz.getNbObjectiveFunctions())
                console.debug("Max fitness: " + gaviz.getMaxFitness(0))
                console.debug("Min fitness: " + gaviz.getMinFitness(0))

                /**
                  * When the file is parsed successfully by gaviz we emit fileLoaded()
                  *
                  */
                fileLoaded();

            }
            else
            {
                console.log("Failed to load file")
            }
            menuPage.state = stateGroup.state = "idle";
        }
    }

    StateGroup {
        id : stateGroup

        states: [

            State {
                name: "idle"
                PropertyChanges {
                    target: prg

                    value : 0;
                    visible : false;
                }
            },
            State {
                name: "parsing"
                PropertyChanges {
                    target: prg

                    visible : true;
                }
            }
        ]
    }
}
