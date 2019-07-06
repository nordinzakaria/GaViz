import QtQuick 2.0
import QtQuick.Layouts 1.12
import gaviz 1.0
import "../../utils.js" as Utils

Item {
    id: individualRectangle

    property int population: 0
    property int generation: 0
    property int cluster: 0
    property int individual: 0

    property double minScore: 0
    property alias mouseArea : mouseArea

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

            width: rectangle.width * 0.9
            implicitHeight: rectangle.height * 0.9



            Row {
                id: genesLayout

                anchors.fill: parent

                spacing: 0

                Repeater {
                    id: genes

                    model : {
                       return gaviz.getIndividualProperty(individualRectangle.population,
                                                          individualRectangle.generation,
                                                          individualRectangle.cluster,
                                                          individualRectangle.individual,
                                                          0, IndividualProperty.NumGenes)
                    }

                    delegate: Rectangle {

                        height: genesLayout.height
                        width: genesLayout.width/genes.model

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

    MouseArea {
        id: mouseArea
        anchors.fill: parent
    }
}
