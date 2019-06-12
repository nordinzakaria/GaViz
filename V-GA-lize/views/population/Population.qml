import QtQuick 2.0
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3
import QtQuick.Dialogs 1.0
import gaviz 1.0

/* The Population Frame is the first thing you will see on the Visualization Page
    It displays a set of coloured squares representing each individual in a Generation :
      - Each new line is a new Generation
      - Squares that are the most on the left have the highest values in the generation

    The colour of a square illustrates how close it is from the selected Minimum value :
      - If the square is red, it is fairly over the Minimum ;
      - If the square is blue, it is really close from the Minimum ;
      - All the part that are not visible are in fact transparent squares, meaning that their value is below the Minimum.
*/
Frame {
    id: populationView

    property int selectedIndividual: 0
    property int selectedGeneration: 0

    // The ScrollView Item allows to move on the frame by using the hotizontal and vertical ScrollBars
    ScrollView {
        id: canvasParent
        anchors.fill: parent
        ScrollBar.horizontal.policy: ScrollBar.AlwaysOn
        ScrollBar.vertical.policy: ScrollBar.AlwaysOn

        contentWidth: gaviz.getMaxNbIndPerGeneration() * zoomValue
        contentHeight: gaviz.getNbGenerations(selectedPopulation) * zoomValue

        property double contentX: 0
        property double contentY: 0

        clip: true

        Connections {
            target: vizPage
            onZoomValueChanged: {
                canvasParent.contentX = firstIndividual * zoomValue
                canvasParent.contentY = firstGeneration * zoomValue
                //canvasParent.updateCanvasPosition()
            }
        }

        //onMovementEnded: updateCanvasPosition()

        function updateCanvasPosition()
        {
            canvasParent.contentX -= canvasParent.contentX % zoomValue
            canvasParent.contentY -= canvasParent.contentY % zoomValue
            firstIndividual = canvasParent.contentX / zoomValue
            firstGeneration = canvasParent.contentY / zoomValue
        }


        /**
          *
          * I have no clue of what that is.
          *
          */
        /*ProgressBar {
            id: prgPop
            anchors.horizontalCenter: parent.horizontalCenter
            Layout.preferredWidth: 0.7 * parent.width
            visible: true

            from: 0
            to: 100

            Label {
                id: popprogPercentage
                anchors.top: parent.bottom
                visible: true
                text: prgPop.value.toFixed(1) + "%"
            }
        }*/



        Canvas {
            id: canvas

            width: gaviz.getMaxNbIndPerGeneration(selectedPopulation)
            height: gaviz.getNbGenerations(selectedPopulation)
            renderStrategy: Canvas.Threaded
            renderTarget: Canvas.FramebufferObject


            transform: Scale { origin.x: 0; origin.y: 0; xScale: zoomValue; yScale: zoomValue }
            smooth: false

            onPaint: {
                var context = getContext("2d")

                context.beginPath()
                context.clearRect(0, 0, width, height)
                context.fill()

                for (var g = 0; g < gaviz.getNbGenerations(selectedPopulation); g++)
                {
                    var wd = gaviz.getNbIndInGeneration(selectedPopulation, g)

                    for (var i = 0; i < wd; i++)
                    {
                        context.beginPath()
                        context.fillStyle = getFillStyle(g, 0, i, selectedFitness)
                        context.fillRect(i, g, 1, 1)
                        context.fill()
                    }
                }
            }
        }

        Canvas {
            id: highlightCanvas

            width: gaviz.getMaxNbIndPerGeneration(selectedPopulation)
            height: gaviz.getNbGenerations(selectedPopulation)
            z:2

            transform: Scale { origin.x: 0; origin.y: 0; xScale: zoomValue; yScale: zoomValue }
            smooth: false


            onPaint: {
                var context = getContext("2d")


                var currentIndividual = selectedIndividual;
                var currentGeneration = selectedGeneration;

                context.beginPath()
                context.clearRect(0, 0, width, height)
                context.fill()
                context.beginPath()
                context.fillStyle = Qt.rgba(1.0, 1.0, 0.0, 1.0)
                context.fillRect(selectedIndividual, selectedGeneration, 1, 1)
                context.fill()
            }
        }


        MouseArea {
            anchors.fill: parent
            acceptedButtons: Qt.LeftButton | Qt.RightButton

            onWheel: {
                if (wheel.modifiers & Qt.ControlModifier) {
                    zoomValue += wheel.angleDelta.y / 120
                }
            }

            onClicked: {
                individualView.selectIndividual(mouseY/zoomValue, mouseX/zoomValue)
                selectedIndividual = mouseX/zoomValue
                selectedGeneration = mouseY/zoomValue
                individualView.mycanvas.requestPaint()
                individualView.swipeV.currentIndex = 0
                individualView.leftB.visible = false
                individualView.rightB.visible = true

            }

            onPressAndHold: {
                populationDialog.open()
            }
        }

        FileDialog {
            id: populationDialog
            title: "Please choose a file"
            folder: shortcuts.home
            modality: Qt.NonModal
            selectExisting : false
            nameFilters: [ "Image files (*.jpg *.png)", "All files (*)" ]

            onAccepted: {

                /**
                  * What is result ?
                  */
                populationView.grabToImage(function(result) {
                                           result.saveToFile(populationDialog.fileUrl);
                                       });
            }
        }

    }
    /**
      *
      * Migth be useless, i don't get the utilisation of Timer here.
      *
      */

    Timer {
        id: repaintTimer
        interval: 100
        running: false
        repeat: false
        onTriggered: canvas.requestPaint()
    }

    Timer {
        id: altViewTimer
        interval: 100
        running: false
        repeat: false
        onTriggered: displayAltView()
    }

    function repaintView()
    {
        repaintTimer.running = false
        repaintTimer.running = true
        //canvas.requestPaint()
        highlightCanvas.requestPaint()
    }

    function highlight()
    {
        highlightCanvas.requestPaint()
    }

    function getFillStyle(g, c, i, f)
    {
        var score = gaviz.getIndividualProperty(selectedPopulation, g, c, i, f, IndividualProperty.Fitness)
        if (score >= minScore)
        {
            return rgb(minScore, minScore+5, score)
        }

        return Qt.rgba(0.0, 0.0, 0.0, 0.0)
    }

    function rgb(minimum, maximum, value)
    {
        var ratio = 2 * (value-minimum) / (maximum - minimum)
        var b = Math.max(0, 255*(1 - ratio))
        var r = Math.max(0, 255*(ratio - 1))
        var g = 255 - b - r

        return Qt.rgba(r/255.0, g/255.0, b/255.0, 1)
    }
}
