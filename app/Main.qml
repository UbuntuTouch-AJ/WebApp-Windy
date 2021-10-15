import QtQuick 2.9
import Ubuntu.Components 1.3
import QtQuick.Window 2.2
import Morph.Web 0.1
import "Buttons"
import QtWebEngine 1.7
import Qt.labs.settings 1.0
import QtSystemInfo 5.5

MainView {
  id:window
  objectName: "mainView"
  theme.name: "Ubuntu.Components.Themes.SuruDark"

  applicationName: "windy"


  backgroundColor : "#ffffff"





  WebView {
    id: webview
    anchors{ fill: parent}

    enableSelectOverride: true


    settings.fullScreenSupportEnabled: true
    property var currentWebview: webview
    settings.pluginsEnabled: true

    onFullScreenRequested: function(request) {
      nav.visible = !nav.visible
      request.accept();
    }



    profile:  WebEngineProfile{
      id: webContext
      persistentCookiesPolicy: WebEngineProfile.ForcePersistentCookies
      property alias dataPath: webContext.persistentStoragePath

      dataPath: dataLocation



      httpUserAgent: "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/83.0.4103.106 Safari/537.36"
    }

    anchors{
      fill:parent
    }

    url: "https://www.windy.com/"
    userScripts: [
      WebEngineScript {
        injectionPoint: WebEngineScript.DocumentReady
        worldId: WebEngineScript.MainWorld
        name: "QWebChannel"
        sourceUrl: "ubuntutheme.js"
      }
    ]


  }
  RadialBottomEdge {
    id: nav
    visible: true
    actions: [

    RadialAction {
      id: start
      iconSource: Qt.resolvedUrl("icons/home.png")
      onTriggered: {
        webview.url = "https://www.windy.com"
      }
      text: qsTr("Start")
      },
      RadialAction {
        id: tools
        iconSource: Qt.resolvedUrl("icons/tools.png")
        onTriggered: {
          webview.url = "https://www.windy.com/de/-Men%C3%BC/tools?"
        }
        text: qsTr("Tools")
      },
      RadialAction {
        id: forward
        enabled: webview.canGoForward
        iconName: "go-next"
        onTriggered: {
          webview.goForward()
        }
        text: qsTr("Vorwärts")
      },
      RadialAction {
        id: distance
        iconSource: Qt.resolvedUrl("icons/distance.png")
        onTriggered: {
          webview.url = "https://www.windy.com/distance?"
        }
        text: qsTr("Distance")
      },
      RadialAction {
        id: settings
        iconSource: Qt.resolvedUrl("icons/settings.png")
        onTriggered: {
          webview.url = "https://www.windy.com/de/-Einstellungen/settings?"
        }
        text: qsTr("Settings")
      },
      RadialAction {
        id: login
        iconSource: Qt.resolvedUrl("icons/login.png")
        onTriggered: {
          webview.url = "https://account.windy.com/login?purpose=client2&redirectUrl=https://www.windy.com/?"
        }
        text: qsTr("Login")
      },
      RadialAction {
        id: back
        enabled: webview.canGoBack
        iconName: "go-previous"
        onTriggered: {
          webview.goBack()
        }
        text: qsTr("Zurück")
      },
      RadialAction {
        id: favorite
        iconSource: Qt.resolvedUrl("icons/favorite.png")
        onTriggered: {
          webview.url = "https://www.windy.com/de/-Favoriten/favs?"
        }
        text: qsTr("Favorite")

      }
    ]
  }

  Connections {
    target: Qt.inputMethod
    onVisibleChanged: nav.visible = !nav.visible
  }

  Connections {
    target: webview

    onIsFullScreenChanged: {
      window.setFullscreen()
      if (currentWebview.isFullScreen) {
        nav.state = "hidden"
      }
      else {
        nav.state = "shown"
      }
    }

  }

  Connections {
    target: webview

    onIsFullScreenChanged: window.setFullscreen(webview.isFullScreen)
  }
  function setFullscreen(fullscreen) {
    if (!window.forceFullscreen) {
      if (fullscreen) {
        if (window.visibility != Window.FullScreen) {
          internal.currentWindowState = window.visibility
          window.visibility = 5
        }
      } else {
        window.visibility = internal.currentWindowState
        //window.currentWebview.fullscreen = false
        //window.currentWebview.fullscreen = false
      }
    }
  }

  Connections {
    target: UriHandler

    onOpened: {

      if (uris.length > 0) {
        console.log('Incoming call from UriHandler ' + uris[0]);
        webview.url = uris[0];
      }
    }
  }



  ScreenSaver {
    id: screenSaver
    screenSaverEnabled: !(Qt.application.active) || !webview.recentlyAudible
  }
}
