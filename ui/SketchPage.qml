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
    property bool clearRequested: true;
    property bool undoRequested: false;
    property bool isDrawing: false;
    property real mousePosX: 0;
    property real mousePosY: 0;
    property variant imageStack: [];
    property var ctx;
    property real penWidth: 6;
    property real penHeight: 6;

    MouseArea {
        id: inputArea
        anchors.fill: canvas

        onClicked: {
            print("input detected")
        }
        onPressed: {
            startDraw(mouse)
        }
        onPositionChanged: {
            updateDraw(mouse)
        }
        onReleased: {
            endDraw(mouse)
        }
    }

    Canvas {
        id: canvas
        anchors.fill: parent
        renderStrategy: Canvas.Threaded

        onPaint: {
            paintSketch();
        }
    }

    tools: CanvasToolbar {

    }

    function newDrawing() {
        clearRequested = true;
        imageStack.length = 0;
    }

    function undo() {
        undoRequested = true;
        canvas.requestPaint();
        print("undo requested: " + undoRequested);
    }

    function startDraw(evts) {
        print("drawing started")
        isDrawing = true;
        mousePosX = evts.x;
        mousePosY = evts.y;
        canvas.requestPaint();
    }

    function updateDraw(evts) {
        mousePosX = evts.x;
        mousePosY = evts.y;
        canvas.requestPaint();
    }

    function endDraw(evts) {
        isDrawing = false;
        mousePosX = evts.x;
        mousePosY = evts.y;
        imageStack.push(ctx.getImageData(canvas.width, canvas.height));
        canvas.requestPaint();
    }

    function paintSketch() {
        ctx = canvas.getContext("2d");
        print("painting")
        if (clearRequested) {
            clear();
        }

        print("isDrawing: " + isDrawing);
        if (isDrawing) {
            ctx.fillStyle = "#FFF0A5"
            ctx.ellipse(mousePosX - penWidth/2, mousePosY - penHeight/2,
                        penWidth, penHeight);
            ctx.fill();
        }

        print("undo requested: " + undoRequested);
        if (undoRequested) {
            print("undoing");
            imageStack.pop();
            ctx.putImageData(imageStack[imageStack.length], 0, 0);
            undoRequested = false;
        }
    }

    function clear() {
        ctx = canvas.getContext("2d");
        ctx.fillStyle = "white";
        ctx.rect(0, 0, canvas.width, canvas.height);
        ctx.fill();
        imageStack.push(ctx.getImageData(canvas.width, canvas.height));
        clearRequested = false;
    }
}
