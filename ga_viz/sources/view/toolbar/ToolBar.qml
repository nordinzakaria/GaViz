import QtQuick 2.0
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3

import gaviz 1.0

RowLayout {

    /*TextField {
        id: generationSelector

        text: "1"

        inputMethodHints: Qt.ImhDigitsOnly

        validator: IntValidator {
            bottom: 1
            top: population.getNbGenerations()
        }

        onTextEdited: {
            selectedGeneration = parseInt(generationSelector.text)
        }

        onAccepted: {
            populationView.forceActiveFocus()
            populationView.repaintView()
        }
    }*/

    ColumnLayout {

        Label {
            text: "Minimum Score"
            color: "yellow"
        }

        TextField {
            id: minScoreSelector

            text: "0.0"

            validator: DoubleValidator {
                bottom: 0.0
                top: 1.0
            }

            onTextEdited: {
                minScore = parseFloat(minScoreSelector.text)
            }

            onAccepted: {
                populationView.forceActiveFocus()
                populationView.repaintView()
            }
        }
    }

//    ColumnLayout {
//        Label {
//            text: "View Clusters"
//            color: "yellow"
//        }

//        CheckBox {
//            onCheckedChanged: {
//                showClusters = checked
//                populationView.repaintView()
//            }
//        }
//    }

    ColumnLayout {
        width: 500
        Label {
            text: "Performance type"
            color: "yellow"
            }

    ComboBox {
            id: popFitness
            currentIndex: 0
            model: gaviz.getObjectiveFunctions()
            width: parent.width
            onCurrentIndexChanged: {
                selectedFitness = currentIndex
                populationView.repaintView()

            }
        }

    }

    ColumnLayout {
        width: 500
        Label {
            text: "Population"
            color: "yellow"
            }

    ComboBox {
            id: popIndex
            currentIndex: 0
            model: gaviz.getNbPopulations()
            width: parent.width
            onCurrentIndexChanged: {
                selectedPopulation = currentIndex
                populationView.repaintView()

            }
        }

    }


    Item {
        Layout.fillWidth: true
    }
}
