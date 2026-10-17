import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import qs.Commons
import qs.Ui
import "PokemonData.js" as PK

Panel {
  id: root
  moduleName: "aletgdev.pokemon-companion"
  ipcTarget: "aletgdev.pokemon-companion"
  manageIpc: true

  property var anchorItem: null
  property var hostWidget: null
  readonly property var barIdentity: hostWidget || root

  property var state: PK.defaultState()
  property string currentLanguage: "es"
  property int currentPokemonId: 25

  readonly property var currentPokemon: PK.getPokemonById(currentPokemonId)
  readonly property var strings: PK.getStrings(currentLanguage)
  property string message: (currentPokemon ? currentPokemon.cry : "") + " ¡" + (currentPokemon ? currentPokemon.name : "") + " te acompaña fielmente!"

  function loadState(rawJson) {
    if (!rawJson) return
    try {
      var parsed = JSON.parse(rawJson)
      if (parsed && typeof parsed.pokemonId === "number") {
        root.state = parsed
        root.currentPokemonId = parsed.pokemonId
        if (parsed.language) root.currentLanguage = parsed.language
      }
    } catch (e) {}
  }

  function saveState() {
    root.state.language = root.currentLanguage
    root.state.pokemonId = root.currentPokemonId
    stateFile.setText(JSON.stringify(root.state, null, 2) + "\n")
  }

  function toggleLanguage() {
    var next = (currentLanguage === "en" ? "es" : "en")
    currentLanguage = next
    var s = PK.getStrings(next)
    root.message = s.companionDefault.replace("{cry}", root.currentPokemon ? root.currentPokemon.cry : "").replace("{name}", root.currentPokemon ? root.currentPokemon.name : "")
    saveState()
  }

  function feed() {
    root.state.language = root.currentLanguage
    var res = PK.feedBerry(root.state)
    root.message = res.message
    saveState()
  }

  function pet() {
    root.state.language = root.currentLanguage
    var res = PK.pet(root.state)
    root.message = res.message
    saveState()
  }

  function choosePokemon(id) {
    root.currentPokemonId = id
    var pk = PK.getPokemonById(id)
    var s = PK.getStrings(root.currentLanguage)
    root.message = s.companionChosen.replace("{name}", pk.name).replace("{cry}", pk.cry)
    saveState()
  }

  function randomEncounter() {
    var randomIdx = Math.floor(Math.random() * PK.POKEMON_ROSTER.length)
    var wild = PK.POKEMON_ROSTER[randomIdx]
    var s = PK.getStrings(root.currentLanguage)
    root.message = s.wildAppeared.replace("{name}", wild.name)
  }

  FileView {
    id: stateFile
    path: Quickshell.env("HOME") + "/.config/omarchy/pokemon-companion.json"
    watchChanges: true
    atomicWrites: true
    printErrors: false
    onLoaded: root.loadState(stateFile.text())
    onLoadFailed: root.saveState()
    onFileChanged: reload()
  }

  KeyboardPanel {
    id: panel
    anchorItem: root.anchorItem
    owner: root.barIdentity
    bar: root.bar
    open: root.opened
    centerOnBar: false
    contentWidth: panel.fittedContentWidth(Style.space(350))
    contentHeight: panel.fittedContentHeight(mainCol.implicitHeight)

    PanelKeyCatcher {
      id: keyCatcher
      onCloseRequested: root.close()
    }

    Column {
      id: mainCol
      anchors.left: parent.left
      anchors.right: parent.right
      anchors.top: parent.top
      anchors.margins: Style.space(12)
      spacing: Style.space(12)

      // Top bar with language switcher
      Row {
        width: parent.width
        Item { Layout.fillWidth: true; width: parent.width - langBtn.width }

        Rectangle {
          id: langBtn
          height: Style.space(22)
          width: langText.implicitWidth + Style.space(16)
          radius: Style.space(11)
          color: langMouse.pressed ? Util.alpha(Color.accent, 0.3) : (langMouse.containsMouse ? Util.alpha(Color.accent, 0.2) : Util.alpha(Color.foreground, 0.08))
          border.width: 1
          border.color: Util.alpha(Color.accent, 0.3)

          Text {
            id: langText
            anchors.centerIn: parent
            text: root.currentLanguage === "en" ? "🌐 EN | ES" : "🌐 ES | EN"
            color: Color.foreground
            font.family: Style.font.family
            font.pixelSize: Style.font.caption - 1
            font.bold: true
          }

          MouseArea {
            id: langMouse
            anchors.fill: parent
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            onClicked: root.toggleLanguage()
          }
        }
      }

      // Header card: Animated sprite + Pokemon info
      Rectangle {
        width: parent.width
        height: Style.space(82)
        radius: Style.cornerRadius
        color: Util.alpha(Color.foreground, 0.05)
        border.width: 1
        border.color: Util.alpha(Color.accent, 0.25)

        Row {
          anchors.fill: parent
          anchors.margins: Style.space(8)
          spacing: Style.space(12)

          // Pokemon sprite box
          Rectangle {
            width: Style.space(64)
            height: Style.space(64)
            radius: Style.cornerRadius
            color: Util.alpha(root.currentPokemon ? root.currentPokemon.color : Color.accent, 0.15)
            border.width: 1
            border.color: Util.alpha(root.currentPokemon ? root.currentPokemon.color : Color.accent, 0.4)

            AnimatedImage {
              anchors.centerIn: parent
              width: Style.space(56)
              height: Style.space(56)
              source: Qt.resolvedUrl("assets/sprites/" + (root.currentPokemon ? root.currentPokemon.id : 25) + ".gif")
              fillMode: Image.PreserveAspectFit
              smooth: false
              playing: true
            }
          }

          // Details column
          Column {
            anchors.verticalCenter: parent.verticalCenter
            spacing: Style.space(4)

            Row {
              spacing: Style.space(8)
              Text {
                text: root.currentPokemon ? root.currentPokemon.name : ""
                color: Color.foreground
                font.family: Style.font.family
                font.pixelSize: Style.font.title
                font.bold: true
              }

              Rectangle {
                anchors.verticalCenter: parent.verticalCenter
                height: Style.space(18)
                width: levelText.implicitWidth + Style.space(12)
                radius: Style.space(9)
                color: Util.alpha(Color.urgent, 0.2)
                border.width: 1
                border.color: Util.alpha(Color.urgent, 0.5)

                Text {
                  id: levelText
                  anchors.centerIn: parent
                  text: (root.strings.levelShort || "Nv.") + " " + (root.state ? root.state.level : 1)
                  color: Color.urgent
                  font.family: Style.font.family
                  font.pixelSize: Style.font.caption
                  font.bold: true
                }
              }
            }

            Text {
              readonly property string genusText: root.currentPokemon && root.currentPokemon.genus
                ? (root.currentPokemon.genus[root.currentLanguage] || root.currentPokemon.genus.es)
                : ""
              text: genusText + " • #" + (root.currentPokemon ? (root.currentPokemon.id < 10 ? "00" : (root.currentPokemon.id < 100 ? "0" : "")) + root.currentPokemon.id : "")
              color: Util.alpha(Color.foreground, 0.6)
              font.family: Style.font.family
              font.pixelSize: Style.font.caption
            }

            // Types badges
            Row {
              spacing: Style.space(4)
              Repeater {
                model: root.currentPokemon && root.currentPokemon.types
                  ? (root.currentPokemon.types[root.currentLanguage] || root.currentPokemon.types.es)
                  : []
                Rectangle {
                  height: Style.space(16)
                  width: typeText.implicitWidth + Style.space(8)
                  radius: Style.space(4)
                  color: Util.alpha(root.currentPokemon ? root.currentPokemon.color : Color.accent, 0.2)

                  Text {
                    id: typeText
                    anchors.centerIn: parent
                    text: modelData
                    color: Color.foreground
                    font.family: Style.font.family
                    font.pixelSize: Style.font.caption - 2
                    font.bold: true
                  }
                }
              }
            }
          }
        }
      }

      // Stats: Amistad & EXP
      Column {
        width: parent.width
        spacing: Style.space(8)

        // Amistad
        Column {
          width: parent.width
          spacing: Style.space(3)

          Row {
            width: parent.width
            Text {
              text: root.strings.friendshipTitle || "💖 Cariño / Amistad"
              color: Color.foreground
              font.family: Style.font.family
              font.pixelSize: Style.font.caption
            }
            Item { Layout.fillWidth: true; width: parent.width - 150 }
            Text {
              text: (root.state ? root.state.friendship : 0) + "%"
              color: "#ff6b81"
              font.family: Style.font.family
              font.pixelSize: Style.font.caption
              font.bold: true
            }
          }

          Rectangle {
            width: parent.width
            height: Style.space(8)
            radius: Style.space(4)
            color: Util.alpha(Color.foreground, 0.1)

            Rectangle {
              height: parent.height
              width: Math.max(parent.radius * 2, parent.width * ((root.state ? root.state.friendship : 0) / 100.0))
              radius: Style.space(4)
              color: "#ff6b81"
              Behavior on width { NumberAnimation { duration: 250 } }
            }
          }
        }

        // Experiencia
        Column {
          width: parent.width
          spacing: Style.space(3)

          Row {
            width: parent.width
            Text {
              text: root.strings.expTitle || "⭐ Experiencia"
              color: Color.foreground
              font.family: Style.font.family
              font.pixelSize: Style.font.caption
            }
            Item { Layout.fillWidth: true; width: parent.width - 150 }
            Text {
              text: (root.state ? root.state.exp : 0) + " / " + (root.state ? root.state.maxExp : 100) + " EXP"
              color: "#ffd32a"
              font.family: Style.font.family
              font.pixelSize: Style.font.caption
              font.bold: true
            }
          }

          Rectangle {
            width: parent.width
            height: Style.space(8)
            radius: Style.space(4)
            color: Util.alpha(Color.foreground, 0.1)

            Rectangle {
              height: parent.height
              width: Math.max(parent.radius * 2, parent.width * ((root.state ? root.state.exp : 0) / (root.state ? root.state.maxExp : 100)))
              radius: Style.space(4)
              color: "#ffd32a"
              Behavior on width { NumberAnimation { duration: 250 } }
            }
          }
        }
      }

      // Speech bubble / Message
      Rectangle {
        width: parent.width
        implicitHeight: speechText.implicitHeight + Style.space(16)
        radius: Style.cornerRadius
        color: Util.alpha(Color.background, 0.5)
        border.width: 1
        border.color: Util.alpha(Color.accent, 0.2)

        Text {
          id: speechText
          anchors.fill: parent
          anchors.margins: Style.space(8)
          text: root.message
          color: Color.foreground
          font.family: Style.font.family
          font.pixelSize: Style.font.body
          wrapMode: Text.Wrap
        }
      }

      // Actions row
      Row {
        width: parent.width
        spacing: Style.space(8)

        // Feed button
        Rectangle {
          width: (parent.width - Style.space(16)) / 3
          height: Style.space(36)
          radius: Style.cornerRadius
          color: feedArea.pressed ? Util.alpha(Color.accent, 0.3) : (feedArea.containsMouse ? Util.alpha(Color.accent, 0.2) : Util.alpha(Color.foreground, 0.08))
          border.width: 1
          border.color: Util.alpha(Color.accent, 0.3)

          Row {
            anchors.centerIn: parent
            spacing: Style.space(4)
            Text {
              text: "🍓"
              font.pixelSize: Style.font.caption
            }
            Text {
              text: (root.strings.feedBtn || "Baya") + " (" + (root.state ? root.state.berries : 0) + ")"
              color: Color.foreground
              font.family: Style.font.family
              font.pixelSize: Style.font.caption
              font.bold: true
            }
          }

          MouseArea {
            id: feedArea
            anchors.fill: parent
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            onClicked: root.feed()
          }
        }

        // Pet button
        Rectangle {
          width: (parent.width - Style.space(16)) / 3
          height: Style.space(36)
          radius: Style.cornerRadius
          color: petArea.pressed ? Util.alpha(Color.accent, 0.3) : (petArea.containsMouse ? Util.alpha(Color.accent, 0.2) : Util.alpha(Color.foreground, 0.08))
          border.width: 1
          border.color: Util.alpha(Color.accent, 0.3)

          Row {
            anchors.centerIn: parent
            spacing: Style.space(4)
            Text {
              text: "✨"
              font.pixelSize: Style.font.caption
            }
            Text {
              text: root.strings.petBtn || "Acariciar"
              color: Color.foreground
              font.family: Style.font.family
              font.pixelSize: Style.font.caption
              font.bold: true
            }
          }

          MouseArea {
            id: petArea
            anchors.fill: parent
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            onClicked: root.pet()
          }
        }

        // Wild encounter button
        Rectangle {
          width: (parent.width - Style.space(16)) / 3
          height: Style.space(36)
          radius: Style.cornerRadius
          color: encArea.pressed ? Util.alpha(Color.accent, 0.3) : (encArea.containsMouse ? Util.alpha(Color.accent, 0.2) : Util.alpha(Color.foreground, 0.08))
          border.width: 1
          border.color: Util.alpha(Color.accent, 0.3)

          Row {
            anchors.centerIn: parent
            spacing: Style.space(4)
            Text {
              text: "🌲"
              font.pixelSize: Style.font.caption
            }
            Text {
              text: root.strings.exploreBtn || "Explorar"
              color: Color.foreground
              font.family: Style.font.family
              font.pixelSize: Style.font.caption
              font.bold: true
            }
          }

          MouseArea {
            id: encArea
            anchors.fill: parent
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            onClicked: root.randomEncounter()
          }
        }
      }

      // Companion Quick Switcher
      Column {
        width: parent.width
        spacing: Style.space(6)

        Text {
          text: root.strings.chooseTitle || "Cambiar compañero:"
          color: Util.alpha(Color.foreground, 0.6)
          font.family: Style.font.family
          font.pixelSize: Style.font.caption
        }

        Grid {
          width: parent.width
          columns: 5
          rowSpacing: Style.space(6)
          columnSpacing: Style.space(6)

          Repeater {
            model: PK.POKEMON_ROSTER

            Rectangle {
              required property var modelData
              width: (mainCol.width - Style.space(24)) / 5
              height: Style.space(44)
              radius: Style.cornerRadius
              color: root.currentPokemonId === modelData.id
                ? Util.alpha(modelData.color || Color.accent, 0.25)
                : (itemArea.containsMouse ? Util.alpha(Color.foreground, 0.1) : Util.alpha(Color.foreground, 0.04))
              border.width: 1
              border.color: root.currentPokemonId === modelData.id
                ? (modelData.color || Color.accent)
                : Util.alpha(Color.accent, 0.2)

              AnimatedImage {
                anchors.centerIn: parent
                width: Style.space(32)
                height: Style.space(32)
                source: Qt.resolvedUrl("assets/sprites/" + modelData.id + ".gif")
                fillMode: Image.PreserveAspectFit
                smooth: false
                playing: itemArea.containsMouse || (root.currentPokemonId === modelData.id)
              }

              MouseArea {
                id: itemArea
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onClicked: root.choosePokemon(modelData.id)
              }
            }
          }
        }
      }
    }
  }
}
