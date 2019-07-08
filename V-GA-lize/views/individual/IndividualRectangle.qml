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

            var score = gaviz.getIndividualProperty(individualRectangle.population,
                                                    individualRectangle.generation,
                                                    individualRectangle.cluster,
                                                    individualRectangle.individual,
                                                    0, IndividualProperty.Fitness)

            var maxScore = minScore+5

            return Utils.getFillStyle(minScore,score,maxScore);
        }

        Item {
            id: centeredRectangle

            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter

            width: rectangle.width * 0.9
            implicitHeight: rectangle.height * 0.9



            ListView {
                id: genesView

                anchors.fill: parent

                orientation : ListView.Horizontal
                spacing: 0

                model : {
                    return gaviz.getIndividualProperty(individualRectangle.population,
                                                       individualRectangle.generation,
                                                       individualRectangle.cluster,
                                                       individualRectangle.individual,
                                                       0, IndividualProperty.NumGenes)
                }

                delegate: Rectangle {

                    anchors.top: parent.top
                    anchors.bottom : parent.bottom

                    implicitWidth: genesView.width/genesView.model

                    color: {
                        return Utils.getGeneStyle(individualRectangle.generation,
                                                  individualRectangle.cluster,
                                                  individualRectangle.individual, index);
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
