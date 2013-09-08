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
import "../components"

Page {
    id: sketchPage
    property bool isDrawing: false
    property bool drawingStarted: false
    property bool drawingFinished: false
    property bool clearRequested: false
    property bool undoRequested: false
    property real pencilBrushSize: 4
    property real eraserBrushSize: 10
    property variant document
    property variant docRequested: null
    property string docName
    property string tool: "pencil"

    ListModel {
        id: undoStack
    }

    MouseArea {
        property int startx: 0;
        property int starty: 0;
        property int mx: 0;
        property int my: 0;
        id: input
        anchors.fill: canvas

        onPressed: {
            startx = mouse.x;
            starty = mouse.y;
            mx = mouse.x;
            my = mouse.y;
            sketchPage.drawingStarted = true;
            canvas.requestPaint();
        }
        onPositionChanged: {
            mx = mouse.x;
            my = mouse.y;
            sketchPage.isDrawing = true;
            canvas.requestPaint();
        }
        onReleased: {
            isDrawing = false;
            drawingFinished = true;
            canvas.requestPaint();
        }
    }

    BorderImage {
        id: shadow
        source: "../graphics/shadow.png"
        width: canvas.width + 16; height: canvas.height + 16
        border.left: 8; border.top: 8
        border.right: 8; border.bottom: 8
        anchors.centerIn: canvas
    }

    Canvas {
        id: canvas
        anchors.centerIn: parent
        antialiasing: true
        smooth: true
        renderStrategy: Canvas.Immediate

        Component.onCompleted: {
            width = mainView.width;
            height = mainView.height;
        }

        onImageLoaded: {
            print("image loaded")
        }

        onPaint: {
//            print("start x: " + input.startx);
//            print("mouse X: " + input.mx);
//            print("start y: " + input.starty);
//            print("mouse Y: " + input.my);
//            print("distance: " + distanceBetweenTwoPoints
//                  (input.startx, input.starty, input.mx, input.my));
            var ctx = canvas.getContext('2d');


            if (clearRequested) {
                print("clear requested");
                ctx.reset();
                ctx.fillStyle = "white";
                ctx.rect(0, 0, width, height);
                ctx.fill();
                clearRequested = false;
            }

            if (docRequested) {
                print("doc requested")
                ctx.reset();
                ctx.fillStyle = "white";
                ctx.rect(0, 0, width, height);
                ctx.fill();
                ctx.drawImage(docRequested.contents.src, 0, 0);
                docRequested = null;
            }

            if (undoRequested) {
                print("undo requested");
                if (undoStack.count > 0) {
                    print("undo stack: " + undoStack.count);
                    ctx.drawImage(undoStack.get(undoStack.count - 1).src, 0, 0);
                    undoStack.remove(undoStack.count - 1);
                    saveDrawing();
                    print("undo finished");
                }
                else {
                    print("undo stack = 0")
                }

                undoRequested = false;
            }

            if (sketchPage.drawingStarted) {
                print("drawing started");
                undoStack.append({"src": canvas.toDataURL("image/png")});
                canvas.loadImage(undoStack.get(undoStack.count - 1).src);
                print("undo stack: " + undoStack.count);
                if (tool == "eraser") {
                    ctx.save();
                    ctx.strokeStyle = "white";
                    ctx.beginPath();
                    ctx.moveTo(input.mx, input.my);
                    ctx.restore();
                }
                drawingStarted = false;
            }
            else if (sketchPage.isDrawing) {
                ctx.save();

//                print("drawing continues...");
//                ctx.lineTo(input.mx, input.my);
//                ctx.stroke();
                var brushx, brushy;
                var dist = distanceBetweenTwoPoints
                                 (input.startx, input.starty, input.mx, input.my);
                var angl = angleBetweenTwoPoints
                                 (input.startx, input.starty, input.mx, input.my);
                var brushSizeOt = pencilBrushSize / 2;
                var iplacement = 1;

                if (tool == "pencil") {
                    for (var iz = 0; iz <= dist || iz == 0; iz += iplacement) {
                        ctx.globalAlpha = 0.3;
                        brushx = input.startx + (Math.sin(angl) * iz) - brushSizeOt;
                        brushy = input.starty + (Math.cos(angl) * iz) - brushSizeOt;
                        ctx.drawImage("../graphics/pencil_brush_"
                                    + toolbar.sketchPageColour + ".png",
                                    brushx, brushy, pencilBrushSize, pencilBrushSize);
                    }
                }
                else if (tool == "eraser") {
                    ctx.save();
                    ctx.lineCap = "round";
                    ctx.globalAlpha = 1;
                    ctx.strokeStyle = "white";
                    ctx.lineWidth = eraserBrushSize;
                    ctx.lineTo(input.mx, input.my);
                    ctx.stroke();
                    ctx.restore();
                }

                input.startx = input.mx;
                input.starty = input.my;

                ctx.restore();

                isDrawing = false;
            }
            else if (sketchPage.drawingFinished) {
                print("drawing finished");
                saveDrawing();
                drawingFinished = false;
            }
        }
    }

    function newDrawing() {
        print("New Drawing");
        undoStack.clear();

        var date = new Date();
        docName = Qt.formatDateTime(date, "yyMMddhhmmss");

        clearRequested = true;
        canvas.requestPaint();
        canvas.width = mainView.width;
        canvas.height = mainView.height;
    }

    function openDrawing(doc) {
        print("opening " + doc.docId)
        undoStack.clear();

        docName = doc.docId;
        docRequested = doc;

        canvas.requestPaint();
        canvas.width = mainView.width;
        canvas.height = mainView.height;
    }

    function undo() {
//        print("undoing");
        undoRequested = true;
        canvas.requestPaint();
    }

    function saveDrawing() {
        document = {};
        document = drawingTemplate;
        document.docId = docName;
        document.contents = {"src": canvas.toDataURL("image/jpeg")};
    }

    // Helper function to work out distance between two points
    function distanceBetweenTwoPoints(sx, sy, ex, ey) {
        var dx = ex - sx;
        var dy = ey - sy;
        return Math.sqrt(Math.pow(dx, 2) + Math.pow(dy, 2));
    }

    function angleBetweenTwoPoints(sx, sy, ex, ey) {
        var dx = ex - sx;
        var dy = ey - sy;
        return Math.atan2(dx, dy);
    }

    tools: CanvasToolbar {
        id: toolbar
    }

    onToolChanged: {
        toolbar.onToolSelected(tool);
    }
}
