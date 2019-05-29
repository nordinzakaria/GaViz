import QtQuick 2.0
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3
import QtQuick.Dialogs 1.0
import gaviz 1.0
Frame {
    id: tspPopulationFrame
    property int selectedGeneration: 0

    RowLayout{
        Canvas{
            id: tspCanvas

            Layout.fillHeight: true

            renderStrategy: Canvas.Threaded
            renderTarget: Canvas.FramebufferObject

            smooth: false

            onPaint: {
                var context = getContext("2d")

                context.reset()
                var centreX = width / 2;
                var centreY = height / 2;

                console.log("Selected Fitness = " + selectedFitness)
                console.log("Number of Generations = " + gaviz.getNbGenerations(selectedPopulation))
                console.log("Selected Generation = " + selectedGeneration)

                var numberOfIndividuals = gaviz.getNbIndInGeneration(selectedPopulation, selectedGeneration)
                var degreesPerIndividual = 360 / numberOfIndividuals

                context.beginPath()
                context.fillStyle = "red"
                context.moveTo(centreX, centreY)
                context.arc(centreX, centreY, width / 4, Math.PI * 0.5, Math.PI * 2, false)
                context.lineTo(centreX, centreY)
                context.fill()
            }
        }
        Timer {
            id: repaintTimer
            interval: 100
            running: true
            repeat: true
            onTriggered: tspCanvas.requestPaint()
        }
    }
}
