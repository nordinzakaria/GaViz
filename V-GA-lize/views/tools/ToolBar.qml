import QtQuick 2.0
import QtQuick.Controls 2.1
import QtQuick.Layouts 1.3

import gaviz 1.0

/* The ToolBar that is just below the Menu
   It contains different Tools and ToolSeparators
   Including :
      - A RangeSlider allowing to select the Minimum and Maximum
          Score Limits in the Population
      - A Slider allowing to select the Minimum more precisely
          in the range given by the RangeSlider
          (if the RangeSlider is changed, this value is not)
      - A ComboBox allowing the user to select the Objective Function used
      - A ComboBox allowing the user to select the population                <-------- Not Very clear yet
      - An empty Item in order to keep all the Tools on the left
*/
RowLayout {
    Layout.maximumHeight: 0.07 * parent.height
    property alias zoomSlider: zoomSlider
/*
TextField {
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

    /* A RangeSlider allowing to select the Minimum and Maximum
         Score Limits in the Population
    */
    Tool {

        Label {
            text: "Min and Max Score Limits"
        }

        RangeSlider{
            id: minScoreSelectorLimits
            from:0
            to:
            second.value = 100

            onHoveredChanged: {
                ToolTip.visible = hovered
                ToolTip.text = "From : " + first.value + " to :" + second.value
            }
        }
    }

    ToolSeparator{
        Layout.fillHeight: true
        Layout.rightMargin: 10
        Layout.leftMargin: 10
    }

    /* A Slider allowing to select the Minimum more precisely
         in the range given by the RangeSlider
         (if the RangeSlider is changed, this value is not)
    */
    Tool{
        Label {
            text: "Wanted Quality"
        }


        Slider {
            id: minScoreSelector
            from: minScoreSelectorLimits.first.value
            to: minScoreSelectorLimits.second.value

            onValueChanged: {
                populationView.forceActiveFocus()
                populationView.repaintView()
                minScore = value
            }
            onHoveredChanged: {
                ToolTip.visible = hovered
                ToolTip.text = "Value : " + value
            }
        }
    }

    ToolSeparator{
        Layout.topMargin: 0
        Layout.fillHeight: true
        Layout.rightMargin: 10
        Layout.leftMargin: 10
    }

    // A ComboBox allowing the user to select the Objective Function used
    Tool {

        width: 500
        Label {
            text: "Performance type"
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

    ToolSeparator{
        Layout.fillHeight: true
        Layout.rightMargin: 10
        Layout.leftMargin: 10
    }

    // A ComboBox allowing the user to select the population                <-------- Not Very clear yet
    Tool {
        width: 500
        Label {
            text: "Population"
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

    ToolSeparator{
        Layout.fillHeight: true
        Layout.rightMargin: 10
        Layout.leftMargin: 10
    }

    // A Slider allowing to select and view the Zoom Value more precisely
    Tool{
        Label {
            text: "Zoom Value"
        }


        Slider {
            id: zoomSlider
            from: 1
            to: 40

            onValueChanged: {
                populationView.forceActiveFocus()
                populationView.repaintView()
                zoomValue = value
            }
            onHoveredChanged: {
                ToolTip.visible = hovered
                ToolTip.text = "Value : " + value
            }
        }
    }

    ToolSeparator{
        Layout.fillHeight: true
        Layout.rightMargin: 10
        Layout.leftMargin: 10
    }

    // An empty Item in order to keep all the Tools on the left
    Item {
        Layout.fillWidth: true
    }
}
