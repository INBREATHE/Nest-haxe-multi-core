package nest.entities.screen.commands;

import nest.entities.popup.PopupNotification;
import openfl.events.Event;
import nest.entities.application.ApplicationNotification;
import nest.interfaces.INotification;
import nest.patterns.command.SimpleCommand;

class ChangeScreenCommand extends SimpleCommand {

    @Inject public var screensProxy:ScreensProxy;

    override public function execute( notification:INotification ) : Void
    {
        var nextScreenName      : String            = notification.getType();
        var currentScreenCache  : ScreenCache 		= screensProxy.currentScreen;
        var currentScreenName	: String 			= currentScreenCache ? currentScreenCache.name : null;
        var goPrevious		    : Bool			    = nextScreenName == Screen.PREVIOUS || (currentScreenCache && currentScreenCache.prevScreenCache && currentScreenCache.prevScreenCache.name == nextScreenName);
        var targetScreenCache	: ScreenCache 		= (goPrevious ? currentScreenCache.prevScreenCache : screensProxy.getCacheByScreenName(nextScreenName)) || screensProxy.getFirstCachedScreen();
        var screenMediator	    : ScreenMediator 	= cast facade.getMediator(targetScreenCache.mediatorName);

        if(currentScreenCache) {
            if(!goPrevious && targetScreenCache.prevScreenCache == null)	targetScreenCache.prevScreenCache = currentScreenCache;
            else currentScreenCache.prevScreenCache = null;

            ScreenMediator(facade.getMediator(currentScreenCache.mediatorName)).onLeave();

            this.send( ApplicationNotification.HIDE_SCREEN, currentScreenCache.screen, nextScreenName );
        }

        var body:Dynamic = notification.getBody();
        var screenData : ScreenData = (body != null && body) ? cast body : new ScreenData();

        screensProxy.currentScreen = targetScreenCache;
        screenData.previous = goPrevious;
        screenData.fromScreen = currentScreenName;
        screenData.toScreen = targetScreenCache.name;

        trace("> Nest -> ChangeScreenCommand nextScreenName:", nextScreenName);
        trace("> Nest -> ChangeScreenCommand goPrevious:", goPrevious);
        trace("> Nest -> ChangeScreenCommand screenData:", screenData);

        if(currentScreenCache && currentScreenCache.screen) {
            function ScreenRemovedFromStage( e:Event ) : Void {
                currentScreenCache.screen.removeEventListeners( Event.REMOVED_FROM_STAGE, ScreenRemovedFromStage );
                send( PopupNotification.HIDE_ALL_POPUPS );
                screenMediator.prepareDataForScreen( screenData );
            }
            currentScreenCache.screen.addEventListener( Event.REMOVED_FROM_STAGE, ScreenRemovedFromStage );
        }
        else screenMediator.prepareDataForScreen( screenData );
    }

    public function new() {
    }
}
