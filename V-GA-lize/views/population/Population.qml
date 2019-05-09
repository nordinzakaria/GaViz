import QtQuick 2.0
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3
import QtQuick.Dialogs 1.0
import gaviz 1.0

Frame { // a visual frame
    id: populationView

    Flickable { // can be scrolled like in a touch-based UI
        id: canvasParent
        anchors.fill: parent

        contentWidth: gaviz.getMaxNbIndPerGeneration() * zoomValue
        contentHeight: gaviz.getNbGenerations(selectedPopulation) * zoomValue
        clip: true

        Connections {
            target: vizPage
            onZoomValueChanged: {
                canvasParent.contentX = firstIndividual * zoomValue
                canvasParent.contentY = firstGeneration * zoomValue
                canvasParent.updateCanvasPosition()
            }
        }

        onMovementEnded: updateCanvasPosition()

        function updateCanvasPosition()
        {
            canvasParent.contentX -= canvasParent.contentX % zoomValue
            canvasParent.contentY -= canvasParent.contentY % zoomValue
            firstIndividual = canvasParent.contentX / zoomValue
            firstGeneration = canvasParent.contentY / zoomValue
        }

        ProgressBar {
            id: prgPop
            anchors.horizontalCenter: parent.horizontalCenter
            Layout.preferredWidth: 0.7 * parent.width

            from: 0
            to: 100

            Label {
                id: popprogPercentage
                anchors.top: parent.bottom
                visible: true
                text: prgPop.value.toFixed(1) + "%"
            }
        }

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

                console.log("selectedFitness = " + selectedFitness)
                console.log("num gen = " + gaviz.getNbGenerations(selectedPopulation))
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

                    prgPop.value = g * 100 / gaviz.getNbGenerations(selectedPopulation)
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
                populationView.grabToImage(function(result) {
                                           result.saveToFile(populationDialog.fileUrl);
                                       });
            }
        }

    }

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
            return rgb(0, 1, score)
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
