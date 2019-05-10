import QtQuick 2.0
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3
import QtQuick.Shapes 1.0
import QtQuick.Dialogs 1.0

import gaviz 1.0

Frame {
    id: individualView

    Layout.fillWidth: true
    Layout.preferredHeight: 0.5 * parent.height

    property int selectedFitness: 0
    property int selectedGeneration
    property int individualIndex: selectedIndividual
    property double individualFitness: 0
    property int individualRank: 0

    property int parent1Index: -1
    property int parent2Index: -1
    property double parent1Fitness: 0
    property int parent1Rank: 0
    property double parent2Fitness: 0
    property int parent2Rank: 0

    function selectIndividual(genIndex, indIndex)
    {
        selectedGeneration = genIndex
        individualIndex = indIndex
        individualFitness = gaviz.getIndividualProperty(selectedPopulation, selectedGeneration, 0, individualIndex, selectedFitness, IndividualProperty.Fitness)
        individualRank    = indIndex

        if (selectedGeneration > 0) {
            parent1Index = gaviz.getIndividualProperty(selectedPopulation, selectedGeneration, 0, individualIndex, selectedFitness, IndividualProperty.Parent1)
            parent2Index = gaviz.getIndividualProperty(selectedPopulation, selectedGeneration, 0, individualIndex, selectedFitness, IndividualProperty.Parent2)

            parent1Fitness = gaviz.getIndividualProperty(selectedPopulation, selectedGeneration-1, 0, parent1Index, selectedFitness, IndividualProperty.Fitness)
            parent2Fitness = gaviz.getIndividualProperty(selectedPopulation, selectedGeneration-1, 0, parent2Index, selectedFitness, IndividualProperty.Fitness)

            parent1Rank = parent1Index
            parent2Rank = parent2Index
        }

        mycanvas.animationProgress = 0

        populationView.highlight()
        graphView.selectedGeneration = selectedGeneration
        visible = true
    }

    ColumnLayout {
        id: individualViewTopColumn
        anchors.fill: parent

        Frame {
            id: viewTitle
            Label {
                text: "INDIVIDUAL VIEW"
                font.pixelSize: 24
            }
        }

        RowLayout {
            id: rowBelowTitle
            Layout.fillWidth: true
            Layout.fillHeight: true

            ColumnLayout {
                id: genIndIndex
                Layout.preferredWidth: viewTitle.width

                Label {
                    text: "Generation " + selectedGeneration
                    font.pixelSize: 24
                }
                Label {
                    text: "Individual " + individualIndex
                    font.pixelSize: 24
                }

                Item {
                    Layout.fillHeight: true
                }
            }

            ColumnLayout {
                id: indViewMain
                Layout.fillWidth: true
                Layout.fillHeight: true

                RowLayout {
                    Layout.fillWidth: true
                    Layout.fillHeight: true

                    Button {
                        Layout.preferredWidth: 50
                        Layout.fillHeight: true

                        text: "<"

                        onClicked: swipeView.currentIndex--
                    }

                    Frame {
                        id: swipeframe
                        Layout.fillWidth: true
                        Layout.fillHeight: true

                        SwipeView {
                            id: swipeView
                            anchors.fill: parent
                            clip: true

                            currentIndex: 0

                            Item {
                                id: scoresPage

                                Label {
                                    text: "Scores view"
                                }

                                Canvas {
                                    id: mycanvas
                                    anchors.centerIn: parent
                                    anchors.leftMargin: 0.5 * parent.width
                                    width: parent.width
                                    height: parent.height

                                    // animation based on the value of this
                                    property real animationProgress: 0

                                    states: State {
                                        when: individualView.visible == true
                                        PropertyChanges { animationProgress: 1; target: mycanvas }
                                    }
                                    transitions: Transition {
                                        NumberAnimation {
                                            property: "animationProgress"
                                            easing.type: Easing.InOutCubic
                                            duration: 1000
                                        }
                                    }

                                    onAnimationProgressChanged: requestPaint()

                                    onPaint: {
                                        var radius = 0.4*parent.height;
                                        var lineWidth = 0.2*radius;
                                        var ctx = getContext("2d");
                                        ctx.reset();
                                        // Resets the current path to a new path.
                                        ctx.beginPath();
                                        ctx.lineWidth= lineWidth;
                                        ctx.strokeStyle = populationView.getFillStyle(selectedGeneration, 0, individualIndex, selectedFitness)
                                        // object arc(real x, real y, real radius, real startAngle, real endAngle, bool anticlockwise)
                                        ctx.arc(width/2, height/2, radius, 1.5*Math.PI, 1.5*Math.PI-2*Math.PI*animationProgress*individualFitness, true);
                                        // Strokes the subpaths with the current stroke style.
                                        ctx.stroke();
                                    }
                                }

                                ColumnLayout {
                                    anchors.verticalCenter: parent.verticalCenter
                                    anchors.right: parent.horizontalCenter
                                    anchors.rightMargin: mycanvas.width * 0.01

                                    Repeater
                                    {
                                        model: gaviz.getNbObjectiveFunctions()

                                            RowLayout {
                                                Label {
                                                    text: "Fitness: "+gaviz.getObjectiveFunction(index)
                                                }
                                                Item {
                                                    Layout.fillWidth: true
                                                }
                                                Label {
                                                    text: gaviz.getIndividualProperty(selectedPopulation, selectedGeneration, 0, individualIndex, index, IndividualProperty.Fitness)
                                                }
                                            }
                                    }

                                }
                            }


                            Item {
                                id: genealogyPage

                                    Column { /* outer column */
                                      anchors.fill: parent

                                      spacing: 10
                                      Text {
                                          color: "white"
                                          anchors.horizontalCenter: parent.horizontalCenter
                                          text: "Parents"
                                      }
                                      Row { /* inner row */
                                        anchors.horizontalCenter: parent.horizontalCenter
                                        spacing: 10

                                        Rectangle {
                                            id: coloredParent1
                                            visible: parent1Index != -1
                                            width: swipeframe.width / 4; height: swipeframe.height / 4;
                                            color: populationView.getFillStyle(selectedGeneration-1, 0, parent1Index, selectedFitness)

                                            property int numgenes: (parent1Index != -1) ? gaviz.getIndividualProperty(selectedPopulation,
                                                                                                                      selectedGeneration-1, 0,
                                                                                                                      parent1Index,
                                                                                                                      selectedFitness, IndividualProperty.NumGenes) : 0
                                            property real gwidth : (numgenes > 0) ? width * 0.9 / numgenes : 0

                                            Row {
                                                anchors.horizontalCenter: parent.horizontalCenter
                                                anchors.verticalCenter: parent.verticalCenter
                                                Repeater {
                                                    id: genesrect
                                                    model: coloredParent1.numgenes
                                                    Rectangle {
                                                        width: coloredParent1.gwidth
                                                        height: coloredParent1.height * 0.9
                                                        color:altPopulationView.getGeneStyle(coloredParent1.currgen, 0,
                                                                                             coloredParent1.currind, index)
                                                    }
                                                }
                                            }

                                            MouseArea {
                                                visible: parent1Index != -1
                                                anchors.fill: parent
                                                acceptedButtons: Qt.LeftButton
                                                cursorShape: Qt.PointingHandCursor

                                                onClicked: {
                                                    individualView.selectIndividual(selectedGeneration-1, parent1Index)
                                                }
                                            }

                                        }

                                        Rectangle {
                                                id: coloredParent2
                                                visible: parent2Index != -1

                                                width: swipeframe.width / 4; height: swipeframe.height / 4
                                                color: populationView.getFillStyle(selectedGeneration-1, 0,
                                                                                   parent2Index, selectedFitness)

                                                property int numgenes: (parent2Index != -1) ? gaviz.getIndividualProperty(selectedPopulation,
                                                                                                                          selectedGeneration-1, 0,
                                                                                                                          parent2Index,
                                                                                                                          selectedFitness, IndividualProperty.NumGenes) : 0
                                                property real gwidth : (numgenes > 0) ? width * 0.9 / numgenes : 0

                                                Row {
                                                    anchors.horizontalCenter: parent.horizontalCenter
                                                    anchors.verticalCenter: parent.verticalCenter
                                                    Repeater {
                                                        id: genesrect2
                                                        model: coloredParent2.numgenes
                                                        Rectangle {
                                                            width: coloredParent2.gwidth
                                                            height: coloredParent2.height * 0.9
                                                            color:altPopulationView.getGeneStyle(coloredParent2.currgen, 0,
                                                                                                 coloredParent2.currind, index)
                                                        }
                                                    }
                                                }

                                                MouseArea {
                                                    visible: parent2Index != -1
                                                    anchors.fill: parent
                                                    acceptedButtons: Qt.LeftButton
                                                    cursorShape: Qt.PointingHandCursor

                                                    onClicked: {
                                                        individualView.selectIndividual(selectedGeneration-1, parent2Index)
                                                    }
                                                }

                                            }

                                      }

                                      Text {
                                          color: "white"
                                          anchors.horizontalCenter: parent.horizontalCenter
                                          text: "Individual"
                                            }
                                      Column { /* inner column */
                                        anchors.horizontalCenter: parent.horizontalCenter
                                        spacing: 10

                                        Rectangle {
                                            id: coloredInd
                                            width: swipeframe.width / 4; height: swipeframe.height / 4

                                            color: populationView.getFillStyle(selectedGeneration, 0,
                                                                               individualIndex, selectedFitness)
                                            property int numgenes: gaviz.getIndividualProperty(selectedPopulation,
                                                                                               selectedGeneration, 0,
                                                                                               individualIndex,
                                                                                               selectedFitness, IndividualProperty.NumGenes)
                                            property real gwidth : (numgenes > 0) ? width * 0.9 / numgenes : 0

                                            Row {
                                                anchors.horizontalCenter: parent.horizontalCenter
                                                anchors.verticalCenter: parent.verticalCenter
                                                Repeater {
                                                    id: genesrectInd
                                                    model: coloredInd.numgenes
                                                    Rectangle {
                                                        width: coloredInd.gwidth
                                                        height: coloredInd.height * 0.9
                                                        color:altPopulationView.getGeneStyle(
                                                                  selectedGeneration, 0,
                                                                  individualIndex, index)
                                                    }
                                                }
                                            }
                                        }

                                      }

                                    }
                            }


                            MouseArea {
                                   anchors.fill: parent
                                   onPressAndHold: { swipeDialog.open() }
                               }

                            FileDialog {
                                id: swipeDialog
                                title: "Please choose a file"
                                folder: shortcuts.home
                                modality: Qt.NonModal
                                selectExisting : false
                                nameFilters: [ "Image files (*.jpg *.png)", "All files (*)" ]

                                onAccepted: {
                                    swipeframe.grabToImage(function(result) {
                                                               var localfile = gaviz.getLocalFile(swipeDialog.fileUrl)
                                                               console.log('saving to '+localfile)
                                                               result.saveToFile(localfile);
                                                           });
                                }
                            }
                            }

                        }

                    Button {
                        Layout.preferredWidth: 50
                        Layout.fillHeight: true
                        text: ">"

                        onClicked: swipeView.currentIndex++
                    }

                }

            }

            Frame {
                id: lastBox
                Layout.fillHeight: true

                ColumnLayout {
                    Label {
                        text: "Individual Statistics"
                        font.pixelSize: 24
                    }

                    Repeater {
                        model: gaviz.getNbObjectiveFunctions()
                        Label {
                            text: "Fitness " + index +": "+
                                  gaviz.getIndividualProperty(selectedPopulation, selectedGeneration, 0, individualIndex, index, IndividualProperty.Fitness)
                                  + ", rank: " + individualIndex
                        }
                    }

                }

            }


        }
    }

}

