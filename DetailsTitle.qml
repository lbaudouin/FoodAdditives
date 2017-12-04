import QtQuick 2.0
import QtQuick.Controls 2.2

Rectangle{

    property alias title: content.text

    color: "#222"
    width: parent.width
    height: content.height * 1.5

    Text{
        id: content
        font.pointSize: 14
        anchors.centerIn: parent
        color: "white"
    }
}
