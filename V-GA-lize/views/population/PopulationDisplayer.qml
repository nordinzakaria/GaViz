import QtQuick 2.0

Item {
    id: populationDisplayer

    property int fitness: 0

    property int population: 0
    property int generation: 0
    property int cluster: 0
    property int individual: 0

    property double zoomValue : 0
    property double zoomLimit : 0

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

        zoomValue: 30
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

                    visible : true;
                    zoomValue :  populationDisplayer.zoomValue
                    minScore : populationDisplayer.minScore

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
        if (zoomValue > zoomLimit && populationDisplayer.state == "population"){
            populationDisplayer.state = (stateGroup.state = "altPopulation")
            console.debug("change")
        }else if(zoomValue <= zoomLimit && populationDisplayer.state == "altPopulation"){
            populationDisplayer.state = (stateGroup.state = "population")
            console.debug("change")
        }

        console.debug(populationDisplayer.state)
    }

}
