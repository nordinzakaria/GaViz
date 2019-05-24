import QtQuick 2.0
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3
import QtQuick.Shapes 1.0
import QtQuick.Dialogs 1.0
import "../individual"
import gaviz 1.0

/* The AltPopulation Frame replaces the Population Frame when you zoom in enough
    It displays the same set of coloured squares representing each individual, but more detailed :
      - The square's border's colour corresponds to the one in the Population Frame
      - Inside are to vertical rectangles representing each gene of the Individual
*/
Frame {
    id: altPopulationView

    property int minZoomValue: 30.0
    property int maxZoomValue: 40.0
    property int nbGenerations: height / minZoomValue
    property int nbIndividuals: width / minZoomValue

    property int individualSpacing: 10
    property int individualWidth: zoomValue
    property int individualRadius: individualWidth

    MouseArea {
        anchors.fill: parent
        acceptedButtons: Qt.LeftButton | Qt.RightButton

        onWheel: {
            if (wheel.modifiers & Qt.ControlModifier) {
                zoomValue += wheel.angleDelta.y / 120
               }
        }
        onPressAndHold: {
            altpopulationDialog.open()
        }
    }

    FileDialog {
        id: altpopulationDialog
        title: "Please choose a file"
        folder: shortcuts.home
        modality: Qt.NonModal
        selectExisting : false
        nameFilters: [ "Image files (*.jpg *.png)", "All files (*)" ]

        onAccepted: {
            altPopulationView.grabToImage(function(result) {
                                       result.saveToFile(altpopulationDialog.fileUrl);
                                   });
        }
    }
    ScrollView {
        anchors.fill: parent

        ScrollBar.horizontal.policy: ScrollBar.AlwaysOn
        ScrollBar.vertical.policy: ScrollBar.AlwaysOn

        contentHeight: parent.height
        contentWidth: parent.width

        ListView {      // table
            id: poptable
            anchors.fill: parent
            interactive: false
            orientation: ListView.Vertical

            model: nbGenerations

            clip: true

            delegate: ListView {    // table row
                id: generationRow
                width: parent.width
                height: individualWidth

                interactive: false
                orientation: ListView.Horizontal

                model: nbIndividuals
                property int generationIndex: firstGeneration + index

                delegate: Rectangle {
                    id: individualRect
                    property int individualIndex: firstIndividual + index

                    width: individualWidth - spacing/2
                    height: width
                    color: "black"

                    Rectangle {
                        id: coloredIndividualRect

                        anchors.centerIn: parent
                        width: individualWidth - individualSpacing * (zoomValue - minZoomValue) / (maxZoomValue - minZoomValue)
                        height: width
                        color: populationView.getFillStyle(generationIndex, 0, individualIndex, selectedFitness)

                        property int currgen: generationRow.generationIndex
                        property int currind: individualRect.individualIndex
                        property int numgenes: gaviz.getIndividualProperty(selectedPopulation,
                                                                           currgen, 0,
                                                                           currind,
                                                                           selectedFitness, IndividualProperty.NumGenes)
                        property real gwidth : width * 0.9 / numgenes

                        Row {
                            anchors.horizontalCenter: parent.horizontalCenter
                            anchors.verticalCenter: parent.verticalCenter
                            Repeater {
                                id: genesrect
                                model: coloredIndividualRect.numgenes
                                Rectangle {
                                    width: coloredIndividualRect.gwidth
                                    height: coloredIndividualRect.height * 0.9
                                    color: getGeneStyle(coloredIndividualRect.currgen, 0,
                                                        coloredIndividualRect.currind, index)
                                }
                            }
                        }

                        Rectangle {
                        id: highlightRect
                        visible: (selectedGeneration == generationIndex && selectedIndividual == individualIndex)
                        radius: width * (zoomValue - minZoomValue) / (maxZoomValue - minZoomValue)
                        anchors.centerIn: parent
                        width: (individualWidth - individualSpacing * (zoomValue - minZoomValue) / (maxZoomValue - minZoomValue))
                        height: width
                        color: "black"
                        }

                        MouseArea {
                            anchors.fill: parent
                            acceptedButtons: Qt.LeftButton | Qt.RightButton
                            cursorShape: Qt.PointingHandCursor
                            onClicked: {
                                individualView.selectIndividual(generationIndex, individualIndex)
                            }
                        }
                    }
                }


            }
        }
    }

    function getGeneStyle(gen, clus, ind, gene)
    {
        var val = gaviz.getGene(gen, clus, ind, gene)
        var maxval = gaviz.getGeneMax()
        var minval = gaviz.getGeneMin()

        var col = populationView.rgb(minval, maxval, val)

        //console.log("min geneval is "+minval+", max is "+maxval)
        //console.log("for val " + val + " from index "+gene+", rgb is "+col)
        return col
    }

}
