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
    signal fitnessChanged(int fitness);                  // Emited when selecting a fitness.
    signal generationChanged(int generation);    // Emited when selecting another generation.
    signal fitGenerationChanged(bool checked);           // Emited when the checkbox is checked/unchecked.
    signal chartChanged(int index);             // Emited when selecting a new chart.


    // The comboBox for selecting fitness
    ColumnLayout {
        id: fitnesslist

        Label {
            text: qsTr("Function Choice :")
        }

        ComboBox {
            model: gaviz.getObjectiveFunctions()
            currentIndex: 0

            onCurrentIndexChanged: {
                row.fitnessChanged(currentIndex);
            }
        }
    }

    ToolSeparator{
        Layout.fillHeight: true
        Layout.rightMargin: 10
        Layout.leftMargin: 10
    }

    ColumnLayout {
        id: chartlist

        Label {
            text: qsTr("Graph Type :")
        }

        ComboBox {
            width: 150

            model:   ["SCATTERPLOT", "AVERAGE", "STDDEV", "MINMAX", "HISTOGRAM" ]
            currentIndex: 0

            onCurrentIndexChanged: {
                row.chartChanged(currentIndex);
            }
        }
    }

    ToolSeparator{
        Layout.fillHeight: true
        Layout.rightMargin: 10
        Layout.leftMargin: 10
    }

    ColumnLayout {
        id: selectGeneration

        Label {
            text: qsTr("Generation Selection :");
        }

        Slider {
            Layout.fillWidth: true
            Layout.leftMargin: 20

            live: true

            from: 0
            value: selectedGeneration
            to: gaviz.getNbGenerations(selectedPopulation) - 1
            stepSize: 1

            onValueChanged: {
                var intValue = parseInt(value);
                row.generationChanged(intValue);
            }
        }
    }

    ToolSeparator{
        Layout.fillHeight: true
        Layout.rightMargin: 10
        Layout.leftMargin: 10
    }

    RowLayout{
        id: fitToGeneration

        Label {
            text: qsTr("Fit to gen : ");
        }

        CheckBox {
            id: fitToGenerationCheckBox
            onCheckStateChanged: {
                row.fitGenerationChanged(checked);
            }
        }

    }
}
