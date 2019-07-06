import QtQuick 2.0
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.5
import gaviz 1.0

Item {
    id: root

    property int population: 0
    property int generation: 0
    property int cluster: 0
    property int individual: 0

    property double minScore: 0.0

    ColumnLayout {
        anchors.fill: parent

        Text {
            id: title

            text: qsTr("Gene inspector");
        }

        Rectangle {
            id: idcard

            Layout.fillWidth: true;
            Layout.preferredHeight: parent.height * 0.4

            border.color: "white"
            border.width: 2
            color: "transparent"

            RowLayout {
                id: layout1

                anchors.fill:parent

                anchors.margins: {
                    left: idcard.width*0.05     // 5% of the parent width
                    right: idcard.width*0.05    // 5% of the parent width
                    top: idcard.height*0.05     // 5% of the parent height
                    bottom: idcard.height*0.05  // 5% of the parent height
                }


                ColumnLayout{
                    Layout.fillHeight: true

                    Text {
                        text: {
                            var fitness = gaviz.getIndividualProperty(population, generation, cluster, individual, 0, IndividualProperty.Fitness);
                            return qsTr("Fitness: %L1").arg(fitness)
                        }
                        color: "white"
                    }

                    Text {
                        text: qsTr("Rank: %1").arg(individual)
                        color: "white"
                    }
                    Text {
                        text: {
                            var numGenes = gaviz.getIndividualProperty(population, generation, cluster, individual, 0, IndividualProperty.NumGenes);
                            qsTr("Genes: %1").arg(numGenes)
                        }
                        color: "white"
                    }
                }

                IndividualRectangle {
                    Layout.fillHeight: true
                    Layout.fillWidth: true

                    Layout.alignment: Layout.Center

                    population: root.population
                    generation: root.generation
                    cluster: root.cluster
                    individual : root.individual

                    minScore: root.minScore

                }
            }
        }

        Rectangle {
            id: genes

            border.color: "white"
            border.width: 2
            color: "transparent"


            Layout.fillWidth: true;
            Layout.fillHeight: true;

            GridLayout {
                id: grid

                anchors.fill: parent

                anchors.margins: {
                    left: genes.width*0.05      // 5% of the parent width
                    right: genes.width*0.05     // 5% of the parent width
                    bottom: genes.height*0.05   // 5% of the parent height
                    top: genes.height*0.05      // 5% of the parent height
                }

                columns: 4 // TODO :hardcoded

                Repeater {
                    model : {
                        return gaviz.getIndividualProperty(root.population,
                                                           root.generation,
                                                           root.cluster,
                                                           root.individual,
                                                           0, IndividualProperty.NumGenes)
                    }

                    delegate: Text {
                        text: {
                            var fitness = gaviz.getGene(root.generation, root.cluster, root.individual, index)
                            return qsTr("Gene n°%1: %L2").arg(index).arg(fitness)
                        }

                        color: "white"
                    }
                }
            }
        }
    }
}
