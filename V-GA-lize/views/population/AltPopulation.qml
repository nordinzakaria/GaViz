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
    property double minScore: 0

    property alias view : generations

    signal individualSelected(int population, int generation, int cluster, int individual);

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

        rowSpacing: 10
        columnSpacing: 10

        contentX: 0 // TODO
        contentY: 0 // TODO

        delegate: IndividualRectangleZoom {

            implicitHeight: zoomValue
            implicitWidth: zoomValue

            population: 0
            generation: index%gaviz.getNbGenerations();
            cluster: 0
            individual: index/gaviz.getNbGenerations();

            minScore: altPopulationView.minScore

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
}
