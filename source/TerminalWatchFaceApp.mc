using Toybox.Application as Application;
using Toybox.WatchUi as WatchUi;

class TerminalWatchFaceApp extends Application.AppBase {

    function initialize() {
        Application.AppBase.initialize();
    }

    function getInitialView() {
        return [ new TerminalWatchFaceView() ];
    }
}
