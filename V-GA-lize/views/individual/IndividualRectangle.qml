import QtQuick 2.0
import QtQuick.Layouts 1.13

Item {
    id: individualRectangle

    property int population: 0
    property int generation: 0
    property int cluster: 0
    property int individual: 0

    property double minScore: 0
    property int numGenes: 0

    Rectangle {
        id: rectangle

        anchors.fill: parent

        color: {
            var minScore = individualRectangle.minScore;

            var population = individualRectangle.population
            var generation = individualRectangle.generation;
            var cluster = individualRectangle.cluster;
            var individual = individualRectangle.individual;
            var score = gaviz.getIndividualProperty(population, generation, cluster, individual, selectedFitness, IndividualProperty.Fitness)

            var maxScore = minScore+5

            return Utils.getFillStyle(minScore,score,maxScore);
        }

        Item {
            id: centeredRectangle

            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter

            implicitWidth: rectangle.width * 0.9
            implicitHeight: rectangle.height * 0.9

            RowLayout {
                id: genesLayout

                anchors.fill : parent

                Repeater {
                    id: genes

                    model: individualRectangle.numGenes

                    delegate: Rectangle {

                        color: {

                            var generation = individualRectangle.generation;
                            var cluster = individualRectangle.cluster;
                            var individual = individualRectangle.individual;


                            return Utils.getGeneStyle(generation, cluster,individual, index);
                        }

                    }
                }
            }
        }
    }
}
