import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.3
import QtQuick.Shapes 1.0
Item {
    id: populationDisplayer

    property int fitness: 0

    property int population: 0
    property int generation: 0
    property int cluster: 0
    property int individual: 0

    property double zoomValue: 0
    property double zoomLimit: 0

    property double minScore: 0

    state: (stateGroup.state = "population")

    signal individualSelected(int population, int generation, int cluster, int individual);

    onZoomValueChanged: zoomCheck()

    Population {
        id : population

        anchors.fill : parent

        fitness: populationDisplayer.fitness

        population: populationDisplayer.population
        generation: populationDisplayer.generation
        cluster : populationDisplayer.cluster
        individual : populationDisplayer.individual

        zoomValue: 1
        minScore: 0

        onIndividualSelected: {
            populationDisplayer.individualSelected(population, generation, cluster, individual);
        }

    }

    AltPopulation {
        id : altPopulation

        anchors.fill : parent

        fitness: populationDisplayer.fitness

        population: populationDisplayer.population
        generation: populationDisplayer.generation
        cluster : populationDisplayer.cluster
        individual : populationDisplayer.individual

        zoomValue: 50
        zoomLimit: populationDisplayer.zoomLimit
        minScore: 0

        onIndividualSelected: {
            populationDisplayer.individualSelected(population, generation, cluster, individual);
        }

    }

    StateGroup {
        id : stateGroup

        states: [

            State {
                name: "population"
                PropertyChanges {
                    target: population

                    zoomValue :  populationDisplayer.zoomValue
                    minScore : populationDisplayer.minScore

                    visible : true;

                }
                PropertyChanges {
                    target: altPopulation

                    visible: false
                    zoomValue : 1
                    minScore : 0
                }
            },
            State {
                name: "altPopulation"
                PropertyChanges {
                    target: population

                    visible: false
                    zoomValue : 1
                    minScore : 0
                }
                PropertyChanges {
                    target: altPopulation

                    visible: true;
                    zoomValue :  populationDisplayer.zoomValue
                    minScore : populationDisplayer.minScore

                }
            }
        ]
    }

    function zoomCheck(){
        var ratioX;
        var ratioY;
        if (zoomValue > zoomLimit && populationDisplayer.state == "population"){
            populationDisplayer.state = (stateGroup.state = "altPopulation")
        }else if(zoomValue <= zoomLimit && populationDisplayer.state == "altPopulation"){
            populationDisplayer.state = (stateGroup.state = "population")
        }
    }

}
