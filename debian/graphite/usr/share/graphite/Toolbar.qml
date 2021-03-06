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
import Ubuntu.Components.Popups 0.1
import "../ui"

ToolbarItems {
    id: toolbar

    ToolbarButton {
        iconSource: icon("add")
        text: i18n.tr("New")

        onTriggered: {
            sketchPage.newDrawing()
            pageStack.push(sketchPage)
        }
    }
    ToolbarButton {
        iconSource: icon("select")
        text: i18n.tr("Select")

        onTriggered: {

        }
    }
}
