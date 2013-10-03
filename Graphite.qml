/*
    Copyright 2013 Adam Cowdy <tefuzzyllama@gmail.com>

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/

import QtQuick 2.0
import Ubuntu.Components 0.1
import U1db 1.0 as U1db
import "ui"

MainView {
    id: mainView
    // objectName for functional testing purposes (autopilot-qt5)
    objectName: "mainView"
    
    applicationName: "com.ubuntu.developer.tefuzzyllama.graphite"
    
    automaticOrientation: true
    
    width: units.gu(75)
    height: units.gu(60)

    headerColor: Qt.rgba(0.8, 0.2, 0.2, 1)
    backgroundColor: Qt.rgba(0.8, 0.3, 0.3, 1)
    footerColor: Qt.rgba(0.8, 0.3, 0.3, 1)
    
    PageStack {
        id: pageStack
        Component.onCompleted: push(allSketchesPage)
        
        AllSketchesPage {
            id: allSketchesPage
            visible: false
        }

        SketchPage {
            id: sketchPage
            visible: false
        }
    }

    U1db.Database {
        id: graphiteDrawingDb
        path: "graphite.u1db"
    }

    U1db.Document {
        id: drawingTemplate
        docId: "template"
        database: graphiteDrawingDb
    }

    U1db.Index {
        database: graphiteDrawingDb
        id: by_src
        expression: ["src"]
    }

    U1db.Query {
        id: modelQuery
        index: by_src
        query: [{"src":"*"}]
    }

    // Helper functions
    function icon(name) {
        return "/usr/share/icons/ubuntu-mobile/actions/scalable/" + name + ".svg"
    }
}
