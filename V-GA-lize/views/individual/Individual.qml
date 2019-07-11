import QtQuick 2.7
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3
import QtQuick.Shapes 1.0
import QtQuick.Dialogs 1.0
import QtQuick.Window 2.2


import gaviz 1.0
import "../menu"
import "../../utils.js" as Utils

/* The Individual Frame appears when you click on a square in the Population Frames
    It contains :
       - Two Labels on the left displaying the Generation and Number of the selected individual
       - A SwipeView containing two pages :
           - the first displays the individual and its parents (only if not from generation 0)
           - the second displays the individual's value and an animated circle :
               The colour has the same meaning than before (from red if over minimum, to blue if very close)
               The circle is complete depending on how far over the minimum the value is
       - A Frame displaying :
           - The different values of the individual depending on the objective functions,
           - Their Rank in the generation
*/
Frame {
    id: individualView

    //TODO make an assumtion of the size of the object
    Layout.fillWidth: true
    Layout.preferredHeight: 0.5 * parent.height

    property int selectedFitness: 0

    property int selectedPopulation: 0
    property int selectedGeneration: 0
    property int selectedIndividual: 0

    property double individualFitness: 0
    property int individualRank: 0

    property int parent1Index: -1
    property int parent2Index: -1
    property int parent1Rank: 0
    property int parent2Rank: 0
    property double parent1Fitness: 0
    property double parent2Fitness: 0

    property var mycanvas: individualcharacteristic.mycanvas
    property var swipeV: swipeView
    property var leftB: buttonLeft
    property var rightB: buttonRight

    property double minScore: 0

    signal individualChanged(int population, int generation, int individual);

    onSelectedIndividualChanged :
    {
        individualFitness = gaviz.getIndividualProperty(selectedPopulation, selectedGeneration, 0, selectedIndividual, selectedFitness, IndividualProperty.Fitness)
        individualRank    = selectedIndividual;

        if (selectedGeneration > 0) {
            parent1Index = gaviz.getIndividualProperty(selectedPopulation, selectedGeneration, 0, selectedIndividual, selectedFitness, IndividualProperty.Parent1)
            parent2Index = gaviz.getIndividualProperty(selectedPopulation, selectedGeneration, 0, selectedIndividual, selectedFitness, IndividualProperty.Parent2)

            parent1Fitness = gaviz.getIndividualProperty(selectedPopulation, selectedGeneration-1, 0, parent1Index, selectedFitness, IndividualProperty.Fitness)
            parent2Fitness = gaviz.getIndividualProperty(selectedPopulation, selectedGeneration-1, 0, parent2Index, selectedFitness, IndividualProperty.Fitness)

            parent1Rank = parent1Index
            parent2Rank = parent2Index
        }

        mycanvas.animationProgress = 0;
    }

    ColumnLayout {
        id: individualViewTopColumn
        anchors.fill: parent

        RowLayout{
            Layout.topMargin: -7
            Frame {
                id: viewTitle
                Label {
                    text: qsTr("INDIVIDUAL VIEW")
                    font.pixelSize: 24
                }
            }

            Item{
                Layout.fillWidth: true
            }

            MenuButton{
                id : exitIndividual
                trueIcon.source: "../../images/icons/image_part_004.png"

                onClicked: individualView.visible = false
                ToolTip.visible: hovered
                ToolTip.text: qsTr("Close Individual View")
            }
        }

        VerticalSeparator{
            Layout.fillWidth: true
            Layout.leftMargin: -11
            Layout.rightMargin: -11
        }

        RowLayout {
            id: rowBelowTitle
            Layout.fillWidth: true
            Layout.fillHeight: true

            ColumnLayout {
                id: genIndIndex
                Layout.preferredWidth: viewTitle.width

                Label {
                    text: qsTr("Generation %1").arg(selectedGeneration)
                    font.pixelSize: 24
                }
                Label {
                    text: qsTr("Individual %1").arg(selectedIndividual)
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
                        id: buttonLeft
                        Layout.preferredWidth: 50
                        Layout.fillHeight: true
                        visible: false

                        text: "<"

                        onClicked: {
                            swipeView.currentIndex--
                            visible = false
                            buttonRight.visible = true
                        }
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
                                id: genealogyPage

                                Column {
                                    id: column /* outer column */
                                    anchors.fill: parent

                                    spacing: 10
                                    Text {
                                        color: "white"
                                        anchors.horizontalCenter: parent.horizontalCenter
                                        text: qsTr("Parents")
                                        visible: individualView.selectedGeneration > 0
                                    }
                                    Row { /* inner row */
                                        anchors.horizontalCenter: parent.horizontalCenter
                                        spacing: 10
                                        visible: individualView.selectedGeneration > 0


                                        IndividualRectangleZoom{
                                            id: parent1

                                            population : individualView.selectedPopulation
                                            generation : individualView.selectedGeneration - 1
                                            cluster : 0
                                            individual: individualView.parent1Index

                                            minScore: individualView.minScore

                                            width: swipeframe.width / 4;
                                            height: swipeframe.height / 4

                                            mouseArea {
                                                onReleased: {
                                                    var population = parent1.population
                                                    var generation = parent1.generation
                                                    var individual = parent1.individual

                                                    individualView.individualChanged(population, generation, individual)
                                                }
                                                cursorShape: Qt.PointingHandCursor
                                            }

                                        }

                                        IndividualRectangleZoom{
                                            id: parent2

                                            population : individualView.selectedPopulation
                                            generation : individualView.selectedGeneration - 1
                                            cluster : 0
                                            individual: individualView.parent2Index

                                            minScore: individualView.minScore

                                            width: swipeframe.width / 4;
                                            height: swipeframe.height / 4

                                            mouseArea {
                                                onReleased: {
                                                    var population = parent2.population
                                                    var generation = parent2.generation
                                                    var individual = parent2.individual

                                                    individualView.individualChanged(population, generation, individual)
                                                }
                                                cursorShape: Qt.PointingHandCursor
                                            }

                                        }

                                    }

                                    Text {
                                        color: "white"
                                        anchors.horizontalCenter: parent.horizontalCenter
                                        text: qsTr("Individual")
                                    }


                                    IndividualRectangleZoom{
                                        id: coloredInd

                                        population : individualView.selectedPopulation
                                        generation : individualView.selectedGeneration
                                        cluster : 0
                                        individual: individualView.selectedIndividual

                                        minScore: individualView.minScore

                                        width: swipeframe.width / 4;
                                        height: swipeframe.height / 4
                                        anchors.horizontalCenter: parent.horizontalCenter

                                        property int numgenes: gaviz.getIndividualProperty(selectedPopulation, selectedGeneration, 0, selectedIndividual, selectedFitness, IndividualProperty.NumGenes)

                                    }

                                }
                            }

                            IndividualCharacteristic{
                                id: individualcharacteristic

                                parent1 : individualView.parent1Index
                                parent2 : individualView.parent2Index

                                selectedFitness: individualView.selectedFitness

                                selectedIndividual: individualView.selectedIndividual
                                selectedGeneration: individualView.selectedGeneration
                                selectedPopulation: individualView.selectedPopulation

                                mNumberFunctions: gaviz.getNbObjectiveFunctions()
                                mFunctions: gaviz.getObjectiveFunctions()
                            }

                            MouseArea {
                                anchors.fill: parent.currentItem
                                onPressAndHold: { swipeDialog.open() }
                            }

                            FileDialog {
                                id: swipeDialog
                                title: qsTr("Please choose a file")
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
                        id: buttonRight
                        Layout.preferredWidth: 50
                        Layout.fillHeight: true
                        visible: true

                        text: ">"

                        onClicked: {
                            swipeView.currentIndex++
                            visible = false
                            buttonLeft.visible = true
                        }
                    }

                }

            }

            Frame {
                id: lastBox
                Layout.fillHeight: true
                Layout.preferredWidth: 0.3*parent.width

                clip: true
                ColumnLayout{
                    anchors.fill: parent
                    Layout.fillHeight: true
                    Layout.fillWidth:  true

                    Label {
                        text: qsTr("Individual Statistics")
                        font.pixelSize: 24
                    }

                    Repeater {
                        id: rep1
                        model: gaviz.getNbObjectiveFunctions()
                        Label {
                            //property int ng: gaviz.getIndividualProperty(selectedPopulation, selectedGeneration, 0, selectedIndividual, index, IndividualProperty.NumGenes)
                            text: "Fitness " + index +": "+
                                  gaviz.getIndividualProperty(selectedPopulation, selectedGeneration, 0, selectedIndividual, index, IndividualProperty.Fitness)
                                  + '\n' + "Rank: " + selectedIndividual + '\n' + "Genes : " + coloredInd.numgenes
                        }
                    }

                    Label {
                        text: ""
                    }

                    // add popup window for gene
                    Button{
                        id : inspector
                        text: qsTr("See Genes")

                        onClicked: {
                            //TODO unwanted dependencie
                            if(menuBar.params.tsp === Qt.Unchecked)
                                dialog.open()
                            else
                                tspDialog.open()
                        }

                        Dialog {
                            id: dialog
                            title: qsTr("Genes Inspector")
                            visible: false

                            anchors.centerIn: Overlay.overlay
                            width: 800
                            height: 600
                            modal : true


                            contentItem: IndividualGeneInspector {
                                population: individualView.selectedPopulation
                                generation: individualView.selectedGeneration
                                cluster: 0
                                individual: individualView.selectedIndividual

                                minScore: individualView.minScore
                            }


                            standardButtons: Dialog.Close
                        }

                        Dialog {
                            id: tspDialog
                            title: qsTr("Genes Inspector")
                            visible: false

                            anchors.centerIn: Overlay.overlay
                            width: 900
                            height: 700
                            modal : true

                            //standardButtons: Dialog.Ok

                            contentItem: ColumnLayout {
                                Frame{
                                    id: tspframe

                                    Layout.preferredHeight: parent.height
                                    Layout.preferredWidth: parent.width

                                    Column { /* inner column */
                                        anchors.horizontalCenter: parent.horizontalCenter
                                        spacing: 10

                                        Text {
                                            color: "white"
                                            anchors.horizontalCenter: parent.horizontalCenter
                                            text: qsTr("Proposed Route :")
                                        }

                                        Canvas{
                                            id: tspCanvas
                                            width: 600
                                            height: 600

                                            anchors.centerIn: tspframe.Center

                                            property real radius: 6
                                            property real margin: 25
                                            property var pointsArray : []
                                            property int numgenes: gaviz.getIndividualProperty(selectedPopulation,
                                                                                               selectedGeneration, 0,
                                                                                               selectedIndividual,
                                                                                               selectedFitness, IndividualProperty.NumGenes)
                                            onPaint: {
                                                pointsArray = []
                                                var context = getContext("2d");
                                                context.reset()
                                                tspCanvas.requestPaint();

                                                var gene, geneX, geneY;

                                                for(var k = 0; k < numgenes; k++){
                                                    gene = gaviz.getGene(selectedGeneration, 0, selectedIndividual, k)
                                                    geneX = gene.slice(1).slice(0, gene.length-2).split(",")[0]
                                                    geneY = gene.slice(1).slice(0, gene.length-2).split(",")[1]

                                                    tspCanvas.pointsArray.push({"x": (geneX * 1.4), "y": (geneY * 1.4)})
                                                }

                                                context.save()
                                                if(pointsArray.length > 0){
                                                    for(var i = 0; i < pointsArray.length; i++){
                                                        if(i === 0)
                                                        {
                                                            context.clearRect(0, 0, width, height)
                                                            context.fillStyle = "white"
                                                            context.fillRect(0, 0, width, height)
                                                            context.fill()
                                                            context.fillStyle = "green"
                                                        }
                                                        else if(i === 1)
                                                            context.fillStyle = "black"
                                                        else if( i === pointsArray.length-1)
                                                            context.fillStyle = "red"

                                                        var point= pointsArray[i]
                                                        context.fillRect(point["x"]-radius, point["y"]-radius, 2*radius, 2*radius)
                                                    }
                                                    context.strokeStyle = Qt.rgba(0, 1, 1, 0)
                                                    context.fill()
                                                    context.stroke()
                                                    context.beginPath()
                                                    var start = pointsArray[0]
                                                    context.moveTo(start["x"], start["y"])
                                                    for(var j=1; j < pointsArray.length; j++){
                                                        var end= pointsArray[j]
                                                        context.lineTo(end["x"], end["y"])
                                                        context.moveTo(end["x"], end["y"])
                                                    }
                                                    context.closePath()
                                                    context.strokeStyle = Qt.rgba(0, 0, 1, 0.5)
                                                    context.lineWidth = 2
                                                    context.stroke()
                                                }
                                                context.restore()

                                            }
                                        }
                                    }
                                }
                            }
                        }

                    }
                }
            }
        }
    }
}

