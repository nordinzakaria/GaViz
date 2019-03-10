import QtQuick 2.0
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3
import QtQuick.Dialogs 1.0

import "menubar"
import "population"
import "individual"
import "toolbar"
import "graph"
import gaviz 1.0

Page {
//ScrollView {
    id: vizPage

    property double zoomValue: 1.0
    property double minZoomValue: 1.0
    property double maxZoomValue: 40.0
    property int firstGeneration: 1     // first row in view
    property int firstIndividual: 0     // first column in view
    property double minScore: 0.0
    property bool showClusters: false
    property int selectedGeneration: 0
    property int selectedIndividual: 0
    property int selectedPopulation: 0
    property int selectedFitness: 0

    onZoomValueChanged: {
        if (zoomValue < minZoomValue)
            zoomValue = minZoomValue;
        if (zoomValue > maxZoomValue)
            zoomValue = maxZoomValue;
    }

    ColumnLayout {
        anchors.fill: parent

        MenuBar {
            id: menuBar

            Layout.preferredWidth: parent.width
            Layout.preferredHeight: 0.05 * parent.height
            Layout.maximumHeight: 0.05 * parent.height
        }

        ToolBar {
            id: toolBar

            Layout.preferredWidth: parent.width
            Layout.preferredHeight: 0.07 * parent.height
        }

        //RowLayout {
        SwipeView {
            id: sview
            Layout.fillWidth: true
            Layout.fillHeight: true

            ColumnLayout {
                Layout.fillWidth: true
                Layout.fillHeight: true

                PopulationView {
                    id: populationView
                    visible: zoomValue <= 30.0

                    Layout.fillWidth: true
                    Layout.fillHeight: true
                }

                AltPopulationView {
                    id: altPopulationView
                    visible: zoomValue > 30.0

                    Layout.fillWidth: true
                    Layout.fillHeight: true
                }

                IndividualView {
                    id: individualView
                    visible: false
                }

            }

            GraphView {
                id: graphView
                visible: true
            }

        }

        PageIndicator {
            id: pageIndicator
            interactive: true
            count: sview.count
            currentIndex: sview.currentIndex

            anchors.bottom: parent.bottom
            anchors.horizontalCenter: parent.horizontalCenter
        }

    }

    Keys.onPressed: {
            if (event.key == Qt.Key_Escape) {
                individualView.visible = false
            }
        }

}
