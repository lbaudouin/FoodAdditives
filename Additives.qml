import QtQuick 2.7
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3
import QtQml.Models 2.2

import SortFilterProxyModel 1.0

Page {

    function open( code ){
        stackView.push( Qt.resolvedUrl( "Details.qml" ), { "code": code } )
    }

    QtObject{
        id: d

        property string lang: Qt.locale().name.substring(0,2).toLowerCase()

        property bool ready: false
        property string version
        property var list: []

        Component.onCompleted: {
            var xhr = new XMLHttpRequest;
            xhr.open("GET", "https://raw.githubusercontent.com/lbaudouin/FoodAdditives/master/data/fr/additives.json");
            xhr.onreadystatechange = function() {
                if (xhr.readyState === XMLHttpRequest.DONE) {
                    var response = xhr.responseText;
                    // use file contents as required

                    if(response === "")
                        console.warn("Empty file")
                    else {
                        var data = JSON.parse(response)

                        if( "version" in data )
                            version = data.version

                        mainModel.clear()
                        if( "list" in data ){
                            var t = data.list.length
                            for( var i=0; i<t; i++ ){
                                var tmp = data.list[i]
                                mainModel.append( tmp )
                            }
                        }

                        sortedModel.resort()

                        d.ready = true;
                    }
                }
            };
            xhr.send();
        }
    }


    header: ToolBar {
        RowLayout {
            anchors.fill: parent
            Item{
                Layout.fillWidth: true
            }

            ToolButton {
                text: "⋮"
                onClicked: menu.open()
            }
        }

        Label {
            text: qsTr("Food additives")
            elide: Label.ElideRight
            horizontalAlignment: Qt.AlignHCenter
            verticalAlignment: Qt.AlignVCenter
            font.pointSize: 20
            anchors.fill: parent
        }
    }

    Menu {
        id: menu
        x: parent.width - width

        MenuItem {
            text: qsTr("Details")
            onClicked: {
                dialog.open()
            }
        }
    }

    SortFilterProxyModel{
        id: sortedModel
        sortOrder: Qt.AscendingOrder
        sortRole: "code"

        source: ListModel{
            id: mainModel
        }
    }

    ColumnLayout{
        anchors.fill: parent
        anchors.margins: 5

        TextField{
            width: parent.width
            Layout.preferredWidth: width
            placeholderText: qsTr("Search...")
            onTextChanged: {
                sortedModel.filterString = text
            }
        }
        ListView{
            id: view
            width: parent.width
            Layout.preferredWidth: width
            Layout.fillHeight: true

            clip: true
            model: sortedModel
            delegate: itemDelegate
        }
    }

    Component{
        id: itemDelegate
        Rectangle{
            width: ListView.view.width
            height: col.height

            color: mouse.pressed ? "#222" : mouse.containsMouse ? "#444"  : "transparent"

            Column{
                id: col
                width: parent.width

                Label{
                    width: parent.width
                    wrapMode: Text.WordWrap
                    text: code + " - " + name
                    font.bold: true

                    color: dangerColor( danger )
                    function dangerColor( value ){
                        switch(value){
                        case 0: return "#427d06";
                        case 1: return "#67b800";
                        case 2: return "#b0cc00";
                        case 3: return "#cc9800";
                        case 4: return "#cc5800";
                        case 5: return "#cc0000";

                        default: return "transparent";
                        }
                    }
                }
                Label{
                    text: " ➤ " + usage
                    width: parent.width
                    wrapMode: Text.WordWrap
                }
            }

            MouseArea{
                id: mouse
                anchors.fill: parent
                hoverEnabled: true
                onClicked: {
                    open( code )
                }
            }
        }
    }


    Rectangle{
        anchors.fill: parent
        visible: dialog.visible
        color: "black"
        opacity: 0.5

        MouseArea{
            anchors.fill: parent
        }
    }

    Dialog  {
        id: dialog
        title: qsTr("Details")
        standardButtons: Dialog.Ok
        x: (parent.width - width) / 2
        y: (parent.height - height) / 2

        Item{
            height: col.height
            width: col.width
            implicitHeight: height
            implicitWidth: width
            Column{
                id: col
                Label{
                    text: "Léo Baudouin"
                }
                Label{
                    text: "baudouin.leo@gmail.com"
                }
                Label{
                    text: "2017"
                }
            }
        }
        onAccepted: close()
    }


    BusyIndicator{
        running: !d.ready
        anchors.centerIn: parent
    }
}
