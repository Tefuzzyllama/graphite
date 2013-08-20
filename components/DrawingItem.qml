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
import Ubuntu.Components.Popups 0.1
import Ubuntu.Components.ListItems 0.1 as ListItem
import "../ui"

UbuntuShape {
    id: drawingItem
    width: units.gu(10)
    height: units.gu(10)

    image: Image {
        source: contents.src
    }
    MouseArea {
        id: input
        anchors.fill: parent
        onClicked: {
            sketchPage.openDrawing(model);
            pageStack.push(sketchPage);
        }
        onPressAndHold: {
            PopupUtils.open(itemPopoverComponent, drawingItem);
        }
        Component {
            id: itemPopoverComponent
            Popover {
                id: itemPopover
                Column {
                    anchors {
                        top: parent.top
                        right: parent.right
                        left: parent.left
                    }

                    ListItem.Standard {
                        text: i18n.tr("delete");
                        onTriggered: {
                            requestDelete(model);
                            PopupUtils.close(itemPopover);
                        }
                    }
                }
            }
        }
    }

    function requestDelete (drawing) {
        print("delete requested for " + drawing.docId);
        graphiteDrawingDb.putDoc("", drawing.docId);
    }
}
