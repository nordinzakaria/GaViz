import QtQuick 2.0
import QtQuick.Controls 2.1
import QtQuick.Layouts 1.3

import gaviz 1.0

RowLayout {
    property alias fitToGenerationCheckBox: fitToGenerationCheckBox
    Tool{
        Label {
            id: fitnesslist1Label
            text: "Function Choice :"
        }

        ComboBox {
            id: fitnesslist1
            currentIndex: 0
            model: gaviz.getObjectiveFunctions()
            width: 150
            onCurrentIndexChanged: selectedFitness1 = currentIndex
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
                    var charts = [scatterplot, averageplot, stddevplot, minmaxplot0, minmaxplot1, histoplot, histoplot1]
                    for (var i=0; i<charts.length; i++)
                    {
                        charts[i].visible = false
                    }
                    if (currentIndex == 3)
                    {
                        charts[3].visible = true
                        charts[4].visible = true
                    }
                    else
                    if (currentIndex == 4)
                    {
                        charts[5].visible = true
                        charts[6].visible = true
                    }

                    else
                        charts[currentIndex].visible = true
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
             live: false
             stepSize: 1
             from: 0
             value: selectedGeneration
             to: gaviz.getNbGenerations(selectedPopulation) - 1

             onValueChanged: {
                     selectedGeneration = parseInt(value)
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
                      updateBounds()
                  }
         }

        }
    }
}
