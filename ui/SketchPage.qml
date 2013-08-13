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
    property bool isDrawing: false;
    property bool drawingStarted: false;
    property bool drawingFinished: false;
    property bool clearRequested: false;
    property variant imageStack: ["hi", "vegetables"]

    MouseArea {
        property int mx: 0;
        property int my: 0;
        id: input
        anchors.fill: canvas

        onPressed: {
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
        renderStrategy: Canvas.Immediate
        antialiasing: true
        smooth: true

        Component.onCompleted: {
            width = mainView.width - units.gu("5");
            height = mainView.height - units.gu("5");
        }

        onPaint: {
            print("mouse X: " + input.mx);
            print("mouse Y: " + input.my);
            var ctx = canvas.getContext('2d');
            ctx.strokeStyle = "#808080";

            if (clearRequested) {
                print("clear requested");
                ctx.reset();
                ctx.clearRect(0, 0, width, height);
                ctx.fillStyle = "white";
                ctx.rect(0, 0, width, height);
                ctx.fill();
                clearRequested = false;
            }

            if (sketchPage.drawingStarted) {
                print("drawing started");
                ctx.beginPath();
                ctx.moveTo(input.mx, input.my);
                drawingStarted = false;
            }
            else if (sketchPage.isDrawing) {
//                print("drawing continues...");
                ctx.lineTo(input.mx, input.my);
                ctx.stroke();
                isDrawing = false;
            }
            else if (sketchPage.drawingFinished) {
                print("drawing finished");
                drawingFinished = false;
            }
        }
    }

    function newDrawing() {
        print("New Drawing")
        clearRequested = true;
        canvas.requestPaint();
    }

    function undo() {
        print("undoing");
    }

    tools: CanvasToolbar {

    }
}
