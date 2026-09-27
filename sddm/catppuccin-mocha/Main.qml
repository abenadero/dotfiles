import QtQuick
import QtQuick.Controls
import QtQuick.Effects

Item {
    id: root

    width: 1366
    height: 768

    opacity: 0

    // Catppuccin Mocha 
    property color crust: "#11111b"
    property color textColor: "#cdd6f4"
    property color subtextColor: "#8f8f8f"

    property color mauve: "#b4befe"
    property color green: "#00ff99"
    property color orange: "#ff6633"
    property color pink: "#ff0066"

    // idle | checking | failed
    property string authState: "idle"

    function login() {
        if (username.text.length === 0 ||
            password.text.length === 0)
            return

        authState = "checking"
        statusText.text = "Autenticando..."

        username.enabled = false
        password.enabled = false
        session.enabled = false

        sddm.login(
            username.text,
            password.text,
            session.currentIndex
        )
    }

    /*
     * =========================================================
     * FADE IN
     * =========================================================
     */

    NumberAnimation on opacity {
        from: 0
        to: 1
        duration: 500
        easing.type: Easing.Linear
    }


    /*
     * =========================================================
     * BACKGROUND
     * =========================================================
     */

    Image {
        id: backgroundSource

        anchors.fill: parent

        source: "assets/background.png"
        fillMode: Image.PreserveAspectCrop

        opacity: 0
    }

    MultiEffect {
        id: backgroundBlur

        anchors.fill: parent

        source: backgroundSource

        blurEnabled: true
        blur: 0.85
        blurMax: 32
        blurMultiplier: 1.0

        autoPaddingEnabled: false
    }


    /*
     * =========================================================
     * CLOCK
     * =========================================================
     */

    Text {
        id: clock

        anchors.horizontalCenter: parent.horizontalCenter

        y: parent.height * 0.10

        text: Qt.formatTime(new Date(), "HH:mm")

        color: textColor

        font.family: "FiraCode Nerd Font Mono"
        font.pixelSize: 120
    }


    /*
     * =========================================================
     * DATE
     * =========================================================
     */

    Text {
        id: date

        anchors.horizontalCenter: parent.horizontalCenter

        y: parent.height * 0.34

        color: textColor

        font.family: "FiraCode Nerd Font Mono"
        font.pixelSize: 18
    }

    Timer {
        interval: 1000
        running: true
        repeat: true

        onTriggered: {
            var now = new Date()

            clock.text = Qt.formatTime(now, "HH:mm")

            date.text = Qt.formatDate(
                now,
                "dddd, dd MMMM yyyy"
            )
        }
    }


    /*
     * =========================================================
     * CHARACTER
     * =========================================================
     */

    Image {
        id: character

        source: "assets/chibicat-laptop.png"

        width: 100
        height: 100

        fillMode: Image.PreserveAspectFit

        anchors.verticalCenter: parent.verticalCenter

        x: parent.width * 0.30 - width / 2
    }


    /*
     * =========================================================
     * LOGIN FORM
     * =========================================================
     */

    Column {
        id: loginForm

        width: parent.width * 0.20

        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter

        anchors.verticalCenterOffset: -20

        spacing: 10


        /*
         * USERNAME
         */

        Rectangle {
            width: parent.width
            height: root.height * 0.05

            radius: 6

            color: root.crust

            border.width: 2
            border.color: username.activeFocus
                          ? root.mauve
                          : "#585b70"

            TextField {
                id: username

                anchors.fill: parent
                anchors.margins: 3

		background: null

                text: userModel.lastUser !== ""
                      ? userModel.lastUser
                      : "abenadero"

                color: root.subtextColor

                horizontalAlignment: TextInput.AlignHCenter
                verticalAlignment: TextInput.AlignVCenter

                font.family: "FiraCode Nerd Font Mono"
                font.pixelSize: 16

                selectByMouse: true

                KeyNavigation.tab: password
            }
        }


        /*
         * PASSWORD
         */

        Item {
            id: passwordContainer

            width: parent.width
            height: root.height * 0.05


            /*
             * BORDER
             */

            Rectangle {
                anchors.fill: parent

                radius: 6

                gradient: Gradient {
                    orientation: Gradient.Horizontal

                    GradientStop {
                        position: 0

                        color:
                            root.authState === "checking"
                            ? root.green
                            : root.authState === "failed"
                            ? root.orange
                            : root.mauve
                    }

                    GradientStop {
                        position: 1

                        color:
                            root.authState === "checking"
                            ? root.orange
                            : root.authState === "failed"
                            ? root.pink
                            : root.mauve
                    }
                }
            }


            /*
             * INNER TRANSPARENT AREA
             */

            Rectangle {
                anchors.fill: parent
                anchors.margins: 3

                radius: 4

                color: root.crust
            }


            /*
             * PASSWORD INPUT
             */

            TextField {
                id: password

                anchors.fill: parent
                anchors.margins: 3

                background: null

                color: root.subtextColor

                placeholderText: "Contraseña..."
                placeholderTextColor: root.subtextColor

                horizontalAlignment: TextInput.AlignHCenter
                verticalAlignment: TextInput.AlignVCenter

                font.family: "FiraCode Nerd Font Mono"
                font.pixelSize: 16

                echoMode: TextInput.Password
                passwordCharacter: "•"

                selectByMouse: false

                Keys.onReturnPressed: root.login()
                Keys.onEnterPressed: root.login()

                KeyNavigation.backtab: username
                KeyNavigation.tab: session
            }


            /*
             * AUTH ANIMATION
             */

            SequentialAnimation {
                id: checkingAnimation

                running: root.authState === "checking"

                loops: Animation.Infinite

                NumberAnimation {
                    target: password
                    property: "opacity"

                    from: 1
                    to: 0.45

                    duration: 350
                }

                NumberAnimation {
                    target: password
                    property: "opacity"

                    from: 0.45
                    to: 1

                    duration: 350
                }

                onStopped: password.opacity = 1
            }
        }


        /*
         * SESSION SELECTOR
         */

        ComboBox {
            id: session

            width: parent.width
            height: 34

            model: sessionModel

            currentIndex: sessionModel.lastIndex

            textRole: "name"

            font.family: "FiraCode Nerd Font Mono"
            font.pixelSize: 13


            /*
             * BACKGROUND
             */

            background: Rectangle {
                radius: 6

                color: "#1e1e2e"

                border.width: 1
                border.color: session.activeFocus
                              ? root.mauve
                              : "#585b70"
            }


            /*
             * CURRENT TEXT
             */

            contentItem: Text {
                leftPadding: 12
                rightPadding: 30

                text: session.displayText

                color: root.textColor

                font.family: "FiraCode Nerd Font Mono"
                font.pixelSize: 13

                verticalAlignment: Text.AlignVCenter

                elide: Text.ElideRight
            }


            /*
             * ARROW
             */

            indicator: Text {
                text: ""

                color: root.mauve

                font.family: "FiraCode Nerd Font Mono"
                font.pixelSize: 16

                anchors.right: parent.right
                anchors.rightMargin: 10
                anchors.verticalCenter: parent.verticalCenter
            }


            /*
             * POPUP
             */

            popup: Popup {
                y: session.height + 4

                width: session.width

                implicitHeight: Math.min(
                    contentItem.implicitHeight,
                    220
                )

                padding: 4


                background: Rectangle {
                    radius: 6

                    color: "#181825"

                    border.width: 1
                    border.color: root.mauve
                }


                contentItem: ListView {
                    clip: true

                    implicitHeight: contentHeight

                    model: session.popup.visible
                           ? session.delegateModel
                           : null

                    currentIndex: session.highlightedIndex
                }
            }


            /*
             * SESSION ITEMS
             */

            delegate: ItemDelegate {
                width: session.width - 8
                height: 34

                highlighted:
                    session.highlightedIndex === index

                contentItem: Text {
                    text: model.name

                    color: highlighted
                           ? root.mauve
                           : root.textColor

                    font.family: "FiraCode Nerd Font Mono"
                    font.pixelSize: 13

                    verticalAlignment: Text.AlignVCenter

                    leftPadding: 8
                }

                background: Rectangle {
                    radius: 4

                    color: highlighted
                           ? "#313244"
                           : "transparent"
                }
            }

            KeyNavigation.backtab: password
        }
    }


    /*
     * =========================================================
     * STATUS TEXT
     * =========================================================
     */

    Text {
        id: statusText

        anchors.horizontalCenter: loginForm.horizontalCenter

        anchors.top: loginForm.bottom
        anchors.topMargin: 12

        text: ""

        font.family: "FiraCode Nerd Font Mono"
        font.pixelSize: 14

        color:
            root.authState === "failed"
            ? root.pink
            : root.mauve

        Behavior on opacity {
            NumberAnimation {
                duration: 200
            }
        }
    }


    /*
     * =========================================================
     * SDDM EVENTS
     * =========================================================
     */

    Connections {
        target: sddm

        function onLoginFailed() {
            root.authState = "failed"

            statusText.text = "Usuario o contraseña incorrectos"

            password.text = ""

            username.enabled = true
            password.enabled = true
            session.enabled = true

            password.forceActiveFocus()

            failureReset.restart()
        }
    }


    /*
     * RESET FAILURE STATE
     */

    Timer {
        id: failureReset

        interval: 1500
        repeat: false

        onTriggered: {
            root.authState = "idle"
            statusText.text = ""
        }
    }


    /*
     * =========================================================
     * INITIALIZATION
     * =========================================================
     */

    Component.onCompleted: {
        var now = new Date()

        clock.text = Qt.formatTime(now, "HH:mm")

        date.text = Qt.formatDate(
            now,
            "dddd, dd MMMM yyyy"
        )

        password.forceActiveFocus()
    }
}
