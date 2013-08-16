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
import Ubuntu.Components.ListItems 0.1 as ListItem
import Ubuntu.Components.Popups 0.1
import "../ui"

ToolbarItems {
    id: canvasToolbar
    property string sketchPageTool: "pencil"

    back: ToolbarButton {
        text: i18n.tr("Sketches")
        iconSource: icon("back")

        onTriggered: {
            pageStack.pop()
        }
    }

    ToolbarButton {
        id: toolsButton
        text: i18n.tr("Tools")
        iconSource: icon("edit")

        onTriggered: {
            PopupUtils.open(popoverComponent, toolsButton)
        }
    }
    ToolbarButton {
        text: i18n.tr("Colours")
        iconSource: Qt.resolvedUrl("../graphics/wheel.svg")
    }
    ToolbarButton {
        text: i18n.tr("Undo")
        iconSource: icon("undo")

        onTriggered: {
            sketchPage.undo()
        }
    }

    Component {
        id: popoverComponent
        Popover {
            id: toolsPopover
            Column {
                anchors {
                    left: parent.left
                    top: parent.top
                    right: parent.right
                }

                ListItem.Standard {
                    id: pencilItem
                    text: i18n.tr("Pencil")
                    Image {
                        id: pencilSlctdImage
                        source: icon("select")
                        visible: false
                        anchors {
                            right: parent.right
                            rightMargin: units.gu("2")
                            verticalCenter: parent.verticalCenter
                        }
                        Component.onCompleted: {
                            if (sketchPageTool == "pencil") {
                                pencilSlctdImage.visible = true;
                            }
                        }

                        width: 24
                        height: 24
                    }

                    onTriggered: {
                        print("pencil selected");
                        sketchPage.tool = "pencil";
                        PopupUtils.close(toolsPopover);
                    }
                }
                ListItem.Standard {
                    id: eraserItem
                    text: i18n.tr("Eraser")
                    Image {
                        id: eraserSlctdImage
                        source: icon("select")
                        visible: false
                        anchors {
                            right: parent.right
                            rightMargin: units.gu("2")
                            verticalCenter: parent.verticalCenter
                        }
                        Component.onCompleted: {
                            if (sketchPageTool == "eraser") {
                                eraserSlctdImage.visible = true;
                            }
                        }

                        width: 24
                        height: 24
                    }
                    onTriggered: {
                        print("eraser selected");
                        sketchPage.tool = "eraser";
                        PopupUtils.close(toolsPopover);
                    }
                }
            }
        }
    }

    function onToolSelected (tool) {
        sketchPageTool = tool;
    }
}
