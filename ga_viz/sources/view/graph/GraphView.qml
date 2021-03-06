import QtQuick 2.0
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3
import QtQuick.Shapes 1.0
import QtQuick.Dialogs 1.0
import QtQuick.Controls.Styles 1.4
import QtCharts 2.3

import gaviz 1.0


Frame {
    id: graphView

    Layout.fillWidth: true
    Layout.fillHeight: true

    property alias fitToGeneration : fitToGenerationCheckBox.checked
    property int axisWidth: 1
    property int selectedGeneration: 0

    property int selectedFitness0: 0
    property int selectedFitness1: 0
    property real maxFitness0:  gaviz.getMaxFitness(selectedPopulation, selectedFitness0)
    property real maxFitness1:  gaviz.getMaxFitness(selectedPopulation, selectedFitness1)
    property real minFitness0:  gaviz.getMinFitness(selectedPopulation, selectedFitness0)
    property real minFitness1:  gaviz.getMinFitness(selectedPopulation, selectedFitness1)
    property int selectedFitness: selectedFitness0


    ColumnLayout {
        anchors.fill: parent

        RowLayout {
            spacing: 20

            Frame {
                id: viewTitle
                Label {
                    text: "GRAPH VIEW"
                    font.pixelSize: 24
                }
            }

            Label {
                text: "Generation " + selectedGeneration
                font.pixelSize: 24
            }
        }

        RowLayout {


            ComboBox {
                id: fitnesslist1
                currentIndex: 0
                model: gaviz.getObjectiveFunctions()
                width: 150
                onCurrentIndexChanged: selectedFitness1 = currentIndex
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

        Slider {
            Layout.preferredWidth: parent.width - 20
            Layout.leftMargin: 20
            from: 0
            value: 0
            to: gaviz.getNbGenerations(selectedPopulation) - 1

            onValueChanged: {
                selectedGeneration = value
                updateBounds()
            }
        }

        RowLayout {
            CheckBox {
                     id: fitToGenerationCheckBox
                     onCheckStateChanged: {
                         updateBounds()
                     }
                 }

             Label {
                     text: "Fit to gen"
                 }
        }

        ChartView {
            id: scatterplot
            Layout.fillWidth: true
            height: 350
            antialiasing: true
            visible: true
            theme: ChartView.ChartThemeBlueCerulean


            function populate()
            {
                var sz = gaviz.getNbIndInGeneration(selectedPopulation, selectedGeneration)
                var fitness0 = gaviz.getIndividualPropertyList(selectedPopulation, selectedGeneration, 0, selectedFitness0, IndividualProperty.Fitness)
                var fitness1 = gaviz.getIndividualPropertyList(selectedPopulation, selectedGeneration, 0, selectedFitness1, IndividualProperty.Fitness)
                console.log('redrawing scatter')

                for (var i=0; i<sz; i++) {
                    scatter1.append(fitness0[i], fitness1[i])
                    }
            }

            ScatterSeries {
                id: scatter1
                name: "F0:"+gaviz.getObjectiveFunction(selectedFitness0) + " vs F1:" + gaviz.getObjectiveFunction(selectedFitness1)
                Component.onCompleted: {
                        var sz = gaviz.getNbIndInGeneration(selectedPopulation, selectedGeneration)
                        var fitness0 = gaviz.getIndividualPropertyList(selectedPopulation, selectedGeneration, 0, selectedFitness0, IndividualProperty.Fitness)
                        var fitness1 = gaviz.getIndividualPropertyList(selectedPopulation, selectedGeneration, 0, selectedFitness1, IndividualProperty.Fitness)
                        console.log('redrawing scatter')

                        for (var i=0; i<sz; i++) {
                            scatter1.append(fitness0[i], fitness1[i])
                            }
                    }
                }

            MouseArea {
                   anchors.fill: parent
                   onPressAndHold: { chartDialog.open() }
               }

            FileDialog {
                id: chartDialog
                title: "Please choose a file"
                folder: shortcuts.home
                modality: Qt.NonModal
                selectExisting : false
                nameFilters: [ "Image files (*.jpg *.png)", "All files (*)" ]

                onAccepted: {
                    scatterplot.grabToImage(function(result) {
                                               var localfile = gaviz.getLocalFile(chartDialog.fileUrl)
                                                console.log('saving to '+localfile)
                                               result.saveToFile(localfile);
                                           });
                }
            }


        }


        ChartView {
            Layout.fillWidth: true
            height: 350
            id: averageplot
            title: "Average"
            antialiasing: true
            visible:false
            theme: ChartView.ChartThemeBlueCerulean

            ValueAxis {
                    id: xAxisAvg
                    min: 0
                    max: gaviz.getNbGenerations(selectedPopulation)
                }


            LineSeries {
                id: avgseries0
                name: "F0:"+gaviz.getObjectiveFunction(selectedFitness0)
                axisX: xAxisAvg
                Component.onCompleted: {
                        var gsz = gaviz.getNbGenerations(selectedPopulation)
                        for (var i=0; i<gsz; i++) {
                            avgseries0.append(i, gaviz.getStats(selectedPopulation, i, selectedFitness0, StatsProperty.AVERAGE))
                          }
                    }
            }

            LineSeries {
                id: avgseries1
                name: "F1:"+gaviz.getObjectiveFunction(selectedFitness1)
                axisX: xAxisAvg
                Component.onCompleted: {
                        var gsz = gaviz.getNbGenerations(selectedPopulation)
                        for (var i=0; i<gsz; i++) {
                            avgseries1.append(i, gaviz.getStats(selectedPopulation, i, selectedFitness1, StatsProperty.AVERAGE))
                          }
                    }
            }

            MouseArea {
                   anchors.fill: parent
                   onPressAndHold: { averageDialog.open() }
               }

            FileDialog {
                id: averageDialog
                title: "Please choose a file"
                folder: shortcuts.home
                modality: Qt.NonModal
                selectExisting : false
                nameFilters: [ "Image files (*.jpg *.png)", "All files (*)" ]

                onAccepted: {
                    averageplot.grabToImage(function(result) {
                                               var localfile = gaviz.getLocalFile(averageDialog.fileUrl)
                                               result.saveToFile(localfile);
                                           });
                }
            }

        }

        RowLayout {

        ChartView {
            width: parent.width/2
            height: 350

            id: minmaxplot0
            title: "Min and Max for "+gaviz.getObjectiveFunction(selectedFitness0)
            antialiasing: true
            visible:false
            theme: ChartView.ChartThemeBlueCerulean


            ValueAxis {
                    id: xAxisMinMax
                    min: 0
                    max: gaviz.getNbGenerations(selectedPopulation)
                }

            LineSeries {
                id: minseries0
                name: "Min"
                axisX: xAxisMinMax
                Component.onCompleted: {
                        var gsz = gaviz.getNbGenerations(selectedPopulation)
                        for (var i=0; i<gsz; i++) {
                            minseries0.append(i, gaviz.getStats(selectedPopulation, i, selectedFitness0, StatsProperty.MAX))
                          }
                    }
            }
            LineSeries {
                id: maxseries0
                name: "Max"
                axisX: xAxisMinMax
                Component.onCompleted: {
                        var gsz = gaviz.getNbGenerations(selectedPopulation)
                        for (var i=0; i<gsz; i++) {
                            maxseries0.append(i, gaviz.getStats(selectedPopulation, i, selectedFitness0, StatsProperty.MIN))
                          }
                    }
            }

            MouseArea {
                   anchors.fill: parent
                   onPressAndHold:  { minmaxDialog0.open() }
               }

            FileDialog {
                id: minmaxDialog0
                title: "Please choose a file"
                folder: shortcuts.home
                modality: Qt.NonModal
                selectExisting : false
                nameFilters: [ "Image files (*.jpg *.png)", "All files (*)" ]

                onAccepted: {
                    minmaxplot0.grabToImage(function(result) {
                                               var localfile = gaviz.getLocalFile(minmaxDialog0.fileUrl)
                                               result.saveToFile(localfile);
                                           });
                }
            }
        }

        ChartView {
            width: parent.width/2
            height: 350

            id: minmaxplot1
            title: "Min and Max for "+gaviz.getObjectiveFunction(selectedFitness1)
            antialiasing: true
            visible:false
            theme: ChartView.ChartThemeBlueCerulean


            ValueAxis {
                    id: xAxisMinMax1
                    min: 0
                    max: gaviz.getNbGenerations(selectedPopulation)
                }


            LineSeries {
                id: minseries1
                name: "Min"
                axisX: xAxisMinMax1

                Component.onCompleted: {
                        var gsz = gaviz.getNbGenerations(selectedPopulation)
                        for (var i=0; i<gsz; i++) {
                            minseries1.append(i, gaviz.getStats(selectedPopulation, i, selectedFitness1, StatsProperty.MAX))
                          }
                    }
            }
            LineSeries {
                id: maxseries1
                name: "Max"
                axisX: xAxisMinMax1

                Component.onCompleted: {
                        var gsz = gaviz.getNbGenerations(selectedPopulation)
                        for (var i=0; i<gsz; i++) {
                            maxseries1.append(i, gaviz.getStats(selectedPopulation, i, selectedFitness1, StatsProperty.MIN))
                          }
                    }
            }

            MouseArea {
                   anchors.fill: parent
                   onPressAndHold:  { minmaxDialog1.open() }
               }

            FileDialog {
                id: minmaxDialog1
                title: "Please choose a file"
                folder: shortcuts.home
                modality: Qt.NonModal
                selectExisting : false
                nameFilters: [ "Image files (*.jpg *.png)", "All files (*)" ]

                onAccepted: {
                    minmaxplot1.grabToImage(function(result) {
                                               var localfile = gaviz.getLocalFile(minmaxDialog1.fileUrl)
                                               result.saveToFile(localfile);
                                           });
                }
            }
        }
        }

        ChartView {
            Layout.fillWidth: true
            height: 350
            id: stddevplot
            title: "Standard Deviation"
            antialiasing: true
            visible:false
            theme: ChartView.ChartThemeBlueCerulean

            ValueAxis {
                    id: xAxisStddev
                    min: 0
                    max: gaviz.getNbGenerations(selectedPopulation)
                }

            LineSeries {
                id: stddevseries0
                name: 'F0:'+gaviz.getObjectiveFunction(selectedFitness0)
                axisX: xAxisStddev
                Component.onCompleted: {
                        var gsz = gaviz.getNbGenerations(selectedPopulation)
                        for (var i=0; i<gsz; i++) {
                            stddevseries0.append(i, gaviz.getStats(selectedPopulation, i, selectedFitness0, StatsProperty.STDDEV))
                          }
                    }
            }

            LineSeries {
                id: stddevseries1
                name: 'F1:'+gaviz.getObjectiveFunction(selectedFitness1)
                axisX: xAxisStddev
                Component.onCompleted: {
                        var gsz = gaviz.getNbGenerations(selectedPopulation)
                        for (var i=0; i<gsz; i++) {
                            stddevseries1.append(i, gaviz.getStats(selectedPopulation, i, selectedFitness1, StatsProperty.STDDEV))
                          }
                    }
            }

            MouseArea {
                   anchors.fill: parent
                   onPressAndHold:  { stddevDialog.open() }
               }

            FileDialog {
                id: stddevDialog
                title: "Please choose a file"
                folder: shortcuts.home
                modality: Qt.NonModal
                selectExisting : false
                nameFilters: [ "Image files (*.jpg *.png)", "All files (*)" ]

                onAccepted: {
                    stddevplot.grabToImage(function(result) {
                                               var localfile = gaviz.getLocalFile(stddevDialog.fileUrl)
                                               result.saveToFile(localfile);
                                           });
                }
            }

        }

        RowLayout {

        ChartView {
            id: histoplot
            width: parent.width/2
            height: 350
            antialiasing: true
            visible: false
            theme: ChartView.ChartThemeBlueCerulean


            function populate()
            {
                var sz = gaviz.getNbIndInGeneration(selectedPopulation, selectedGeneration)
                var fitness = gaviz.getIndividualPropertyList(selectedPopulation, selectedGeneration, 0, selectedFitness0, IndividualProperty.Fitness)
                var count = [0, 0, 0, 0, 0]

                for (var i=0; i<sz; i++)
                {
                    if (fitness[i] < 0.2)
                        count[0] ++
                    else
                    if (fitness[i] < 0.4)
                        count[1] ++
                    else
                    if (fitness[i] < 0.6)
                        count[2] ++
                    else
                    if (fitness[i] < 0.8)
                        count[3] ++
                    else
                        count[4] ++
                }

                var max = 0
                for (i=0; i<count.length; i++)
                {
                    console.log('count at index '+i+' is '+count[i])
                    if (count[i] > max)
                        max = count[i]
                }

                valueAxis.max = max
                histoseries.append(gaviz.getObjectiveFunction(selectedFitness0), count)
            }

            BarSeries {
                id: histoseries
                name: "F0:"+gaviz.getObjectiveFunction(selectedFitness0)
                axisX: BarCategoryAxis { categories: ["<0.2", "<0.4", "<0.6", "<0.8", "<1" ] }
                axisY: ValueAxis {    //  <- custom ValueAxis attached to the y-axis
                                id: valueAxis
                            }
                Component.onCompleted: {
                    histoplot.populate()
                    }
                }

            MouseArea {
                   anchors.fill: parent
                   onPressAndHold: { histoDialog.open() }
               }

            FileDialog {
                id: histoDialog
                title: "Please choose a file"
                folder: shortcuts.home
                modality: Qt.NonModal
                selectExisting : false
                nameFilters: [ "Image files (*.jpg *.png)", "All files (*)" ]

                onAccepted: {
                    histoplot.grabToImage(function(result) {
                                               var localfile = gaviz.getLocalFile(histoDialog.fileUrl)
                                                console.log('saving to '+localfile)
                                               result.saveToFile(localfile);
                                           });
                }
            }


        }

        ChartView {
            id: histoplot1
            width: parent.width/2
            height: 350
            antialiasing: true
            visible: false
            theme: ChartView.ChartThemeBlueCerulean


            function populate()
            {
                var sz = gaviz.getNbIndInGeneration(selectedPopulation, selectedGeneration)
                var fitness = gaviz.getIndividualPropertyList(selectedPopulation, selectedGeneration, 0, selectedFitness1, IndividualProperty.Fitness)
                var count = [0, 0, 0, 0, 0]

                for (var i=0; i<sz; i++)
                {
                    if (fitness[i] < 0.2)
                        count[0] ++
                    else
                    if (fitness[i] < 0.4)
                        count[1] ++
                    else
                    if (fitness[i] < 0.6)
                        count[2] ++
                    else
                    if (fitness[i] < 0.8)
                        count[3] ++
                    else
                        count[4] ++
                }

                var max = 0
                for (i=0; i<count.length; i++)
                {
                    console.log('count at index '+i+' is '+count[i])
                    if (count[i] > max)
                        max = count[i]
                }

                valueAxis1.max = max
                histoseries1.append(gaviz.getObjectiveFunction(selectedFitness1), count)
            }

            BarSeries {
                id: histoseries1
                name: "F1:"+gaviz.getObjectiveFunction(selectedFitness1)
                axisX: BarCategoryAxis { categories: ["<0.2", "<0.4", "<0.6", "<0.8", "<1" ] }
                axisY: ValueAxis {    //  <- custom ValueAxis attached to the y-axis
                                id: valueAxis1
                            }
                Component.onCompleted: {
                    histoplot1.populate()
                    }
                }

            MouseArea {
                   anchors.fill: parent
                   onPressAndHold: { histoDialog1.open() }
               }

            FileDialog {
                id: histoDialog1
                title: "Please choose a file"
                folder: shortcuts.home
                modality: Qt.NonModal
                selectExisting : false
                nameFilters: [ "Image files (*.jpg *.png)", "All files (*)" ]

                onAccepted: {
                    histoplot1.grabToImage(function(result) {
                                               var localfile = gaviz.getLocalFile(histoDialog1.fileUrl)
                                                console.log('saving to '+localfile)
                                               result.saveToFile(localfile);
                                           });
                    }
                }
            }

        }

    }


    function updateBounds ()
    {
        console.log('minFitness0 was '+minFitness0+', maxFitness0 was '+maxFitness0)
        console.log('minFitness1 was '+minFitness1+', maxFitness1 was '+maxFitness1)


        minFitness0 = fitToGeneration ? gaviz.getMinFitness(selectedPopulation, selectedGeneration, selectedFitness0) :
                                        gaviz.getMinFitness(selectedPopulation, selectedFitness0)
        minFitness1 = fitToGeneration ? gaviz.getMinFitness(selectedPopulation, selectedGeneration, selectedFitness1) :
                                        gaviz.getMinFitness(selectedPopulation, selectedFitness1)
        maxFitness0 = fitToGeneration ? gaviz.getMaxFitness(selectedPopulation, selectedGeneration, selectedFitness0) :
                                        gaviz.getMaxFitness(selectedPopulation, selectedFitness0)
        maxFitness1 = fitToGeneration ? gaviz.getMaxFitness(selectedPopulation, selectedGeneration, selectedFitness1) :
                                        gaviz.getMaxFitness(selectedPopulation, selectedFitness1)

        console.log('minFitness0 = '+minFitness0+', maxFitness0='+maxFitness0 +" for gen "+selectedGeneration+', for fitness '+selectedFitness0)
        console.log('minFitness1 = '+minFitness1+', maxFitness1='+maxFitness1)

        scatter1.clear()
        scatterplot.populate()
    }
}

