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
import "../components"

Page {
    id: allSketches

    title: "All Sketches"

    tools: Toolbar {
        id: toolbar
    }

    Text {
        id: text
        text: "Create a drawing by swiping up from the bottom of the screen and pressing new."
        wrapMode: Text.WordWrap
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        anchors.fill: parent
    }

    GridView {
        anchors.margins: {
            right: units.gu(2)
            left: units.gu(2)
            bottom: units.gu(2)
            top: units.gu(2)
        }
        anchors.fill: parent
        model: modelQuery

        delegate: UbuntuShape {
            id: drawingItem
            width: units.gu(10)
            height: units.gu(10)

            Component.onCompleted: text.visible = false;

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
                                    PopupUtils.open(deleteDialogComponent)
                                    PopupUtils.close(itemPopover)
                                }
                            }
                        }
                    }
                }
            }

            Component {
                id: deleteDialogComponent

                Dialog {
                    id: deleteDialog
                    title: "Delete sketch"
                    text: "Are you sure you want to delete this sketch?"

                    Button {
                        text: "Yes"
                        onClicked: {
                            PopupUtils.close(deleteDialog)
                            graphiteDrawingDb.putDoc("", model.docId)
                            print("deleted")
                        }
                    }
                    Button {
                        text: "No"
                        onClicked: PopupUtils.close(deleteDialog)
                    }
                }
            }
        }
    }
}
