import QtQuick
import Quickshell
import Quickshell.Io
import qs.Commons
import qs.Ui
import "PokemonData.js" as PK

BarWidget {
  id: root
  moduleName: "aletgdev.pokemon-companion"

  property var state: PK.defaultState()
  property string currentLanguage: "es"
  property int currentPokemonId: 25

  readonly property var pokemon: PK.getPokemonById(currentPokemonId)
  readonly property var strings: PK.getStrings(currentLanguage)

  function injectPanel() {
    var target = panelLoader.item
    if (!target) return
    if ("bar" in target) target.bar = root.bar
    if ("settings" in target) target.settings = root.settings
    if ("anchorItem" in target) target.anchorItem = button
    if ("hostWidget" in target) target.hostWidget = root
  }

  function refresh() {
    stateFile.reload()
    if (panelLoader.item && panelLoader.item.refresh) panelLoader.item.refresh()
  }

  function togglePanel() {
    if (panelLoader.item && panelLoader.item.toggle) panelLoader.item.toggle()
  }

  readonly property bool opened: panelLoader.item ? panelLoader.item.opened === true : false

  function open() {
    if (panelLoader.item && panelLoader.item.open) panelLoader.item.open()
  }

  function close() {
    if (panelLoader.item && panelLoader.item.close) panelLoader.item.close()
  }

  readonly property bool popoutSwitchClosing: panelLoader.item ? panelLoader.item.popoutSwitchClosing === true : false

  function closeForPopoutSwitch() {
    if (panelLoader.item) panelLoader.item.closeForPopoutSwitch()
  }

  function nextCompanion() {
    var next = PK.nextPokemon(root.currentPokemonId)
    root.currentPokemonId = next.id
    saveState()
  }

  function quickPet() {
    root.state.language = root.currentLanguage
    var res = PK.pet(root.state)
    saveState()
    if (root.bar) {
      root.bar.run("omarchy-notification-send " + Util.shellQuote(res.message))
    }
  }

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

  implicitWidth: button.implicitWidth
  implicitHeight: button.implicitHeight

  onBarChanged: injectPanel()
  onSettingsChanged: injectPanel()

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

  // Timer to add a berry and passive experience every 10 minutes of system uptime
  Timer {
    interval: 600000 // 10 minutes
    running: true
    repeat: true
    onTriggered: {
      root.state.berries = Math.min(20, (root.state.berries || 0) + 1)
      root.state.exp = (root.state.exp || 0) + 5
      if (root.state.exp >= (root.state.maxExp || 100)) {
        root.state.level = (root.state.level || 1) + 1
        root.state.exp -= root.state.maxExp
        root.state.maxExp = Math.floor(root.state.maxExp * 1.25)
      }
      root.saveState()
    }
  }

  Loader {
    id: panelLoader
    active: true
    source: Qt.resolvedUrl("Panel.qml")
    visible: false
    onLoaded: {
      root.injectPanel()
      Qt.callLater(root.injectPanel)
    }
  }

  WidgetButton {
    id: button
    anchors.fill: parent
    bar: root.bar
    text: " "
    hasVisualContent: true
    labelVisible: false
    fixedWidth: contentRow.implicitWidth + Style.space(16)
    fixedHeight: root.bar ? root.bar.barSize : Style.bar.sizeHorizontal
    tooltipText: (root.pokemon ? root.pokemon.name : "Pokémon") + " (" + (root.strings.levelShort || "Nv.") + (root.state ? root.state.level : 1) + ") — " + (root.state ? root.state.friendship : 0) + "%"

    onPressed: function(b) {
      if (!root.bar) return
      if (b === Qt.RightButton) {
        root.quickPet()
      } else if (b === Qt.MiddleButton) {
        root.nextCompanion()
      } else {
        root.togglePanel()
      }
    }

    Row {
      id: contentRow
      anchors.centerIn: parent
      spacing: Style.space(4)

      AnimatedImage {
        id: sprite
        width: Style.space(24)
        height: Style.space(24)
        anchors.verticalCenter: parent.verticalCenter
        source: Qt.resolvedUrl("assets/sprites/" + (root.pokemon ? root.pokemon.id : 25) + ".gif")
        fillMode: Image.PreserveAspectFit
        smooth: false
        playing: true
        asynchronous: false
      }

      Text {
        id: levelLabel
        anchors.verticalCenter: parent.verticalCenter
        text: (root.strings.levelShort || "Nv.") + (root.state && root.state.level ? root.state.level : 5)
        color: root.bar ? root.bar.barForeground : Color.foreground
        font.family: root.bar ? root.bar.fontFamily : Style.font.family
        font.pixelSize: Style.font.caption
        font.bold: true
      }
    }
  }
}
