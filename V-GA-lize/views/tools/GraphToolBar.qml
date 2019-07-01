import QtQuick 2.0
import QtQuick.Controls 2.1
import QtQuick.Layouts 1.3

import gaviz 1.0

RowLayout {
    id : row

    property alias fitToGenerationCheckBox: fitToGenerationCheckBox

    property int selectedPopulation: 0
    property int selectedGeneration: 0

    /**
      *
      * Signals to notify exeternals elements.
      *
      */
    signal fitnessChange(int fitness);                  // Emited when selecting a fitness.
    signal selectedGenerationChange(int generation);    // Emited when selecting another generation.
    signal fitGenerationChange(bool checked);           // Emited when the checkbox is checked/unchecked.
    signal chartListIndexChange(int index);             // Emited when selecting a new chart.


    // The comboBox for selecting fitness
    Tool{

        Label {
            id: fitnesslist1Label

            text: "Function Choice :"
        }

        ComboBox {
            id: fitnesslist1
            currentIndex: 0

            model: gaviz.getObjectiveFunctions()
            onCurrentIndexChanged: {
                row.fitnessChange(currentIndex);
            }
        }
    }

    ToolSeparator{
        Layout.fillHeight: true
        Layout.rightMargin: 10
        Layout.leftMargin: 10
    }

    Tool{
        Label {
            id: chartlistLabel

            text: "Graph Type :"
        }

        ComboBox {
            id: chartlist

            currentIndex: 0
            width: 150

            model:   ["SCATTERPLOT", "AVERAGE", "STDDEV", "MINMAX", "HISTOGRAM" ]

            onCurrentIndexChanged: {
                row.chartListIndexChange(currentIndex);
            }
        }
    }

    ToolSeparator{
        Layout.fillHeight: true
        Layout.rightMargin: 10
        Layout.leftMargin: 10
    }

    Tool {

        Label {
            text: "Generation Selection :"
        }

        Slider {
            Layout.fillWidth: true
            Layout.leftMargin: 20
            live: true
            stepSize: 1
            from: 0
            value: selectedGeneration
            to: gaviz.getNbGenerations(selectedPopulation) - 1

            onValueChanged: {
                var intValue =parseInt(value);
                row.selectedGenerationChange(intValue);
            }
        }
    }

    ToolSeparator{
        Layout.fillHeight: true
        Layout.rightMargin: 10
        Layout.leftMargin: 10
    }

    Tool {
        RowLayout{

            Label {
                text: "Fit to gen : "
            }

            CheckBox {
                id: fitToGenerationCheckBox
                onCheckStateChanged: {
                    row.fitGenerationChange(checked);
                }
            }

        }
    }
}
