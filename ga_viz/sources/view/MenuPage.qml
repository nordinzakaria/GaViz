import QtQuick 2.0
import QtQuick.Controls 2.3
import QtQuick.Dialogs 1.0
import QtQuick.Layouts 1.3
import gaviz 1.0


Page {
    id: menuPage

    ColumnLayout {
        anchors.fill: parent
        spacing: 20

        Item {
            Layout.fillHeight: true
        }

        Label {
            id: title
            anchors.horizontalCenter: parent.horizontalCenter
            Layout.bottomMargin: 20

            text: "GA VIZ"
            font.pixelSize: 30
        }

        Button {
            id: dialogButton
            anchors.horizontalCenter: parent.horizontalCenter
            highlighted: true

            text: "Load file"
            onClicked:{
                quitButton.enabled = false
                dialogButton.enabled = false
                fileDialog.open()
            }
        }

        Button {
            id: quitButton
            anchors.horizontalCenter: parent.horizontalCenter
            highlighted: true

            text: "Quit"
            onClicked: Qt.quit()
        }

        ProgressBar {
            id: prg
            anchors.horizontalCenter: parent.horizontalCenter
            Layout.preferredWidth: 0.7 * parent.width

            from: 0   // C++ loop starts out with 0
            to: 1 // C++ loop ends with "Count"

            Label {
                id: progressPercentage
                anchors.top: parent.bottom
                visible: true
                text: (prg.value * 100).toFixed(1) + "%"
            }


            Connections {
                target: gaviz
                onProgressChanged: prg.value = gaviz.progress;
            }
        }


        Label {
            id: fileInfo
            anchors.horizontalCenter: parent.horizontalCenter
            Layout.preferredHeight: 0.5 * parent.height
            horizontalAlignment: Text.AlignHCenter
        }
    }

    FileDialog {
        id: fileDialog
        title: "Please choose a file"
        folder: shortcuts.home
        modality: Qt.NonModal

        onAccepted: {
            console.log("File selected"+fileDialog.fileUrl)
            gaviz.readGAFile(fileDialog.fileUrl)
        }

        onRejected: {
             console.log("Canceled")
            }
    }


    Timer {
        id: readGATimer
        interval: 1000
        running: false
        repeat: false
        onTriggered: gaviz.readGAFile(fileDialog.fileUrl)
    }

    Connections {
        target: gaviz
        onDoneLoadingFile: {
            if(success)
            {

                console.log("Population info:\n")
                console.log("Number of Generations : "+ gaviz.getNbGenerations())
                console.log("Max Num Individuals in a Generation : "+ gaviz.getMaxNbIndPerGeneration())
                console.log("Number of Objective Functions : " + gaviz.getNbObjectiveFunctions())
                console.log("Max fitness: " + gaviz.getMaxFitness(0))
                console.log("Min fitness: " + gaviz.getMinFitness(0))

                pages.push(vizPage)
            }
            else
            {
                console.log("Failed to load file")
            }
        }
    }
}
