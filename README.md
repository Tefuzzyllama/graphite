Graphite Drawing
================

Introduction
------------

Graphite is a drawing application for Ubuntu touch designed to run primarily on tablets, but will also work on phones and desktop computers.

This app is being developed for the [Ubuntu App Showdown](http://developer.ubuntu.com/showdown/).


## TODO and known issues ##

This app is far from complete and is extremely early in development.

* Implement drawing logic in SketchPage.qml
    + putImageData() doesn't like accepting variables of type CanvasImageData
    + mousePosX and mousePosY are not defining for some reason
    + write logic for different tools:
        * pen
        * pencil
        * eraser
* Complete EventsTab.qml
* Complete AllSketchesTab.qml
* Write SketchbooksTab.qml
* Implement logic for saving files (local storage and Ubuntu One, any ideas how?)
* Implement logic for sharing with online accounts
