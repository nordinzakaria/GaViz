import QtQuick 2.0
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.12

import gaviz 1.0


Item {
    id: individualcharacteristic

    property color myTextColor: "white"
    property int mNumberFunctions
    property var mFunctions

    property int parent1
    property int parent2

    property int selectedPopulation: 0
    property int selectedGeneration: 0
    property int individualIndex: 0
    property int selectedFitness: 0



    property alias mycanvas: mycanvas



    RowLayout{
        id: my_layout

        anchors.fill: parent

        Canvas {
            id: mycanvas


            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            Layout.preferredHeight: Math.min(parent.width,parent.height)
            Layout.preferredWidth: height    // For the canvas to be a square

            property int animationProgress: 0
            onAnimationProgressChanged: requestPaint()

            onPaint: {

                var loop = mNumberFunctions;

                var radiusmin =  parent.height*0.25;
                var radiusmax = parent.height*0.5;
                var lineWidth = (radiusmax-radiusmin)/loop;
                var scaling = lineWidth;

                var x;
                var y;
                var radius;
                var beginAngle;
                var endAngle;

                var ratio;

                var ctx = getContext("2d");
                ctx.reset();

                for(var i=0;i<loop;i++){
                    //TODO
                    ctx.beginPath();
                    ctx.lineWidth = lineWidth;
                    ctx.strokeStyle = Qt.rgba(Math.random(),Math.random(),Math.random(),1);

                    ratio  = Math.random();
                    x = width/2;
                    y = height/2;
                    radius = radiusmin+(scaling*i);
                    beginAngle = 1.5*Math.PI;
                    endAngle = beginAngle + (2*Math.PI * ratio);

                    ctx.arc(x, y, radius, beginAngle, endAngle, false);

                    ctx.stroke();
                }
            }

            transitions: Transition {
                NumberAnimation {
                    property: "animationProgress"
                    easing.type: Easing.OutExpo
                    duration: 4000
                }
            }
        }



        ColumnLayout{
            id: variableLayout

            Label{
                text: 'Ranking'
                font.pixelSize: 22
                color: myTextColor
            }

            Repeater{
                model: mNumberFunctions

                ColumnLayout{
                    Label{
                        text: mFunctions[index] + ' : ' + gaviz.getIndividualProperty(selectedPopulation, selectedGeneration, 0, individualIndex, index, IndividualProperty.Rank) +'/100'
                        color: myTextColor
                    }

                    Rectangle {
                        color: Qt.rgba(Math.random(),Math.random(),Math.random(),1);
                        Layout.preferredHeight: 3
                        Layout.preferredWidth: variableLayout.width
                    }
                }

            }
        }

    }

}

/*##^## Designer {
    D{i:0;autoSize:true;height:480;width:640}
}
 ##^##*/
