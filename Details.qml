import QtQuick 2.7
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3

Page {
    id: details
    property string code: code

    header: ToolBar {
        RowLayout {
            anchors.fill: parent
            ToolButton {
                text: "‹"
                onClicked: stackView.pop()
            }
            Label {
                text: details.code
                elide: Label.ElideRight
                horizontalAlignment: Qt.AlignHCenter
                verticalAlignment: Qt.AlignVCenter
                Layout.fillWidth: true
                font.pointSize: 20
            }
        }
    }

    QtObject{
        id: d

        property bool ready: false
        property string title
        property string names
        property string description
        property string origin
        property string legal
        property string molecule
        property bool image: false


        Component.onCompleted: {
            var xhr = new XMLHttpRequest;
            xhr.open("GET", "https://raw.githubusercontent.com/lbaudouin/FoodAdditives/master/data/fr/"+code+".json");
            xhr.onreadystatechange = function() {
                if (xhr.readyState === XMLHttpRequest.DONE) {
                    var response = xhr.responseText;
                    // use file contents as required

                    if(response === "")
                        console.warn("Empty file")
                    else {
                        var data = JSON.parse(response)

                        if( "legal" in data )
                            d.legal = data.legal;
                        if( "title" in data )
                            d.title = data.title;
                        if( "names" in data )
                            d.names = data.names.join(', ');
                        if( "description" in data )
                            d.description = data.description;
                        if( "origin" in data )
                            d.origin = data.origin;
                        if( "molecule" in data )
                            d.molecule = data.molecule;
                        if( "image" in data )
                            d.image = data.image;
                    }

                    d.ready = true;
                }
            };
            xhr.send();
        }
    }

    Flickable{
        anchors.fill: parent

        contentWidth: width
        contentHeight: maincol.height

        flickableDirection: Flickable.AutoFlickIfNeeded

        Column{
            id: maincol
            width: parent.width

            spacing: 5

            Label{
                width: parent.width
                text: d.title
                font.pointSize: 14
                font.bold: true
                wrapMode: Text.WordWrap
                horizontalAlignment: Text.AlignHCenter
            }

            DetailsTitle{
                title: qsTr("Names")
            }

            Label{
                width: parent.width
                text: d.names
                font.pointSize: 10
                wrapMode: Text.WordWrap
                horizontalAlignment: Text.AlignHCenter
            }

            DetailsTitle{
                title: qsTr("Legal")
            }
            Label{
                width: parent.width
                text: d.legal
                font.pointSize: 10
                wrapMode: Text.WordWrap
                horizontalAlignment: Text.AlignHCenter
            }

            DetailsTitle{
                title: qsTr("Description")
            }
            Label{
                width: parent.width
                text: d.description
                font.pointSize: 10
                wrapMode: Text.WordWrap
                horizontalAlignment: Text.AlignHCenter
            }

            DetailsTitle{
                title: qsTr("Origin")
            }
            Label{
                width: parent.width
                text: d.origin
                font.pointSize: 10
                wrapMode: Text.WordWrap
                horizontalAlignment: Text.AlignHCenter
            }

            DetailsTitle{
                title: qsTr("Molecule")
            }
            Label{
                width: parent.width
                text: d.molecule
                font.pointSize: 10
                textFormat: Text.RichText
                wrapMode: Text.WordWrap
                horizontalAlignment: Text.AlignHCenter
            }

            Loader{
                active: d.image
                anchors.horizontalCenter: parent.horizontalCenter
                sourceComponent:
                    Image {
                        visible: d.image
                        source: "https://raw.githubusercontent.com/lbaudouin/FoodAdditives/master/images/"+details.code+".png";
                        fillMode: Image.PreserveAspectFit
                        width: maincol.width * 0.75
                    }
            }
        }
    }

    BusyIndicator{
        running: !d.ready
        anchors.centerIn: parent
    }
}
