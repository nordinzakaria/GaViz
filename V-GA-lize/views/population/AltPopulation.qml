import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.3
import QtQuick.Shapes 1.0

import "../../utils.js" as Utils
import "../individual/"

import gaviz 1.0

/* The AltPopulation Frame replaces the Population Frame when you zoom in enough
    It displays the same set of coloured squares representing each individual, but more detailed :
      - The square's border's colour corresponds to the one in the Population Frame
      - Inside are to vertical rectangles representing each gene of the Individual
*/
Item {
    id: altPopulationView

    property int fitness: 0

    property int population: 0
    property int generation: 0
    property int cluster: 0
    property int individual: 0

    property double zoomValue : 0
    property double zoomLimit : 0
    property double minScore: 0

    property int imagePerSeconds: 60

    property alias flickable : generations

    signal individualSelected(int population, int generation, int cluster, int individual);

    onZoomValueChanged: visible ? repaintTimer.running = true : repaintTimer.running = false ;

    TableView {
        id: generations

        anchors.fill: parent

        model : CustomTableModel {
            rows: gaviz.getNbGenerations()
            columns: gaviz.getMaxNbIndPerGeneration()
        }

        ScrollBar.horizontal: ScrollBar {}
        ScrollBar.vertical: ScrollBar {}

        clip: true

        rowSpacing: 0
        columnSpacing: 0

        delegate: IndividualRectangleZoom {

            implicitHeight: visible ? zoomValue : zoomLimit
            implicitWidth: visible ? zoomValue : zoomLimit

            population: 0
            generation: index%gaviz.getNbGenerations();
            cluster: 0
            individual: index/gaviz.getNbGenerations();

            minScore: altPopulationView.minScore;

            highlight: altPopulationView.individual == individual &&
                       altPopulationView.generation == generation

            mouseArea {
                onClicked: {
                    altPopulationView.individualSelected(population,
                                                        generation,
                                                        cluster,
                                                        individual)
                }
            }
        }


    }

    Timer {
        id: repaintTimer
        interval: 1000/imagePerSeconds   // 60 image per seconds
        running: false
        repeat: false
        onTriggered: generations.forceLayout()
    }

}
