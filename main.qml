import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.3

ApplicationWindow {
    visible: true
    width: 480
    height: 640
    title: qsTr("Food Additives")

    StackView {
        id: stackView
        anchors.fill: parent

        initialItem: Additives{
            width: stackView.width
            height: stackView.height
        }
    }
}
