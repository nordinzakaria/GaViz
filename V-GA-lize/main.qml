/*
==============================================================================================
|  This Program is developed by Yann MARTY under the supervision of Dr. NORDIN               |
|  in UTP ( University Teknologi PETRONAS, Seri Iskandar, Perak, Malaysia)                   |
|  in the context of a Research Attachment Program (RAP).                                    |
|                                                                                            |
|  - Edited in 2019 -                                                                        |
==============================================================================================

==============================================================================================
|  V-GA-Lize is a program allowing the visualization of Genetic Algorithm Results.           |
|                                                                                            |
|  It has been created in order to study how the GA worked when it ran                       |
|  and to view different kind of statistics concerning the population studied.               |
==============================================================================================

*/

import QtQuick 2.9
import QtQuick.Window 2.2
import QtQuick.Controls 2.3

import "./main"

/* The Main ApplicationWindow on which the Program appears
   Contains :
      - A MainMenu, which is the first page viewed
        when launching the program
*/
ApplicationWindow {
    id: window

    visible: true
    visibility: qsTr("Maximized")
    title: qsTr("V-GA-Lize")

    minimumWidth: 800
    minimumHeight: 600

    palette: gaviz.palette

    property MainMenu mainMenu: mm1
    MainMenu{
        id: mm1
    }
}
