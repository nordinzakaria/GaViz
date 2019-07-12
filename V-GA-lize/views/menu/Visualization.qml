import QtQuick 2.0
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3
import QtQuick.Dialogs 1.0

import "../menu"
import "../population"
import "../individual"
import "../tools"
import "../graph"
import gaviz 1.0


/* The Visualization Page, on which you will be sent after selecting a file
   It contains everything that you can see after loading a file
   Including :
      - A Menu at the top, containing different buttons
      - A ToolBar allowing you to interract with the Views
      - A SwipeView containing the Views of the Population in the first page
          and the Graphs in the second page
      - A PageIndicator in order to show on which of the SwipeView's page
          the user is
*/
Page {
    id: vizPage
    background : Image {
        source: "../../images/BlenderBackground3.png"
        opacity: 0.08
    }
    property double minZoomValue: 1.0
    property double zoomValue: 1.0
    property double zoomlimit: 50.0
    property double maxZoomValue: 100.0

    property int firstGeneration: 1     // first row in view
    property int firstIndividual: 1     // first column in view

    property double minLimit: 0.0
    property double maxLimit: 100.0
    property double minScore: 0.0

    property bool showClusters: false

    property int selectedGeneration: 0
    property int selectedIndividual: 0
    property int selectedPopulation: 0

    property int selectedFitness: 0

    onSelectedIndividualChanged: {
        individualView.visible = true
    }

    // Main ColumnLayout, containing all the elements listed above
    ColumnLayout{
        anchors.fill : parent

        /* The Menu at the top of the screen
           Contains :
              - A Logo
              - A "Help" Button, opening a PopUp Window the contains
                   two pages : "Help" and "About"
              - A "Parameters" Button, opening a PopUp Window
              - A "New" Button, allowing to return to the MenuPage
                   in order to load a different File
              - A "Quit" Button, in order to leave the program
        */
        Menu {
            id: menuBar
            Layout.preferredWidth: parent.width
            Layout.preferredHeight: 60
        }

        VerticalSeparator{
            Layout.fillWidth: true
            Layout.bottomMargin: -10
        }

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
        ToolBar {
            id: toolBar
            Layout.leftMargin: 10
            Layout.preferredWidth: parent.width
            Layout.preferredHeight: 0.07 * parent.height
            Layout.topMargin: 0

            onZoomChanged: {
                zoomValue = zoom;
            }

            onMinScoreChanged: {
                vizPage.minScore = minScore;
            }
        }

        VerticalSeparator{
            Layout.fillWidth: true
        }

        /* The Main SwipeView containing all of the visualization elements

           Including on the First Page :
              - The Population View
              - The Alternative Population View
              - The Individual View

           And on the Second Page :
              - The Graph Views
        */
        SwipeView {
            id: sview
            Layout.fillWidth: true
            Layout.fillHeight: true

            /* The ColumnLayout, First Page of the SwipeView
               Contains :
                  - The Population View
                  - The Alternative Population View
                  - The Individual View
            */
            ColumnLayout {
                Layout.fillWidth: true
                Layout.fillHeight: true

                PopulationDisplayer {
                    id: altPopulationView

                    fitness: vizPage.selectedFitness

                    zoomValue: vizPage.zoomValue;
                    zoomLimit: vizPage.zoomlimit;

                    minScore : vizPage.minScore

                    population: vizPage.selectedPopulation;
                    individual: vizPage.selectedIndividual;
                    generation: vizPage.selectedGeneration;

                    Layout.fillWidth: true
                    Layout.fillHeight: true

                    onIndividualSelected: {
                        vizPage.selectedPopulation = population;
                        vizPage.selectedGeneration = generation;
                        vizPage.selectedIndividual = individual;
                    }
                }

                Individual {
                    id: individualView


                    selectedPopulation: vizPage.selectedPopulation;
                    selectedIndividual: vizPage.selectedIndividual;
                    selectedGeneration: vizPage.selectedGeneration;

                    onIndividualChanged: {
                        vizPage.selectedPopulation = population;
                        vizPage.selectedGeneration = generation;
                        vizPage.selectedIndividual = individual;
                    }

                    minScore: vizPage.minScore

                    visible: false
                }

            }

            /* The Graph Frame, Second Page of the SwipeView
               Contains different types of graphs on which it is
                  possible to interract using the diffent available Tools

               See More Information in ..\views\graph\Graph.qml
            */
            Graph {
                id: graphView

                implicitHeight: parent.height
                visible: true


            }

        }

        // A PageIndicator in order to show on which of the SwipeView's page the user is
        PageIndicator {
            id: pageIndicator
            interactive: true
            count: sview.count
            currentIndex: sview.currentIndex
            Layout.alignment: Qt.AlignBottom | Qt.AlignHCenter

        }

        Keys.onPressed: {
            if (event.key === Qt.Key_Escape) {
                individualView.visible = false
            }
        }
    }
}
