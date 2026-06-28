import QtQuick 2.15

Rectangle {
    id: root
    color: "#1a1b26"

    property int stage

    onStageChanged: {
        if (stage == 1) {
            introAnimation.running = true
        }
    }

    Text {
        id: label
        anchors.centerIn: parent
        text: "Tokyo Night"
        color: "#7aa2f7"
        font.pixelSize: Math.round(parent.height * 0.05)
        font.family: "Noto Sans"
        opacity: 0
    }

    OpacityAnimator {
        id: introAnimation
        running: false
        target: label
        from: 0
        to: 1
        duration: 800
        easing.type: Easing.InOutQuad
    }
}
