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
        var currentScreenCache  : ScreenCache 		= screensProxy.currentScreenCache;
        var currentScreenName	: String 			= currentScreenCache != null ? currentScreenCache.name : null;
        var goPrevious		    : Bool			    = (nextScreenName == Screen.PREVIOUS) || (currentScreenCache != null && currentScreenCache.prevScreenCache != null && currentScreenCache.prevScreenCache.name == nextScreenName);
        var targetScreenCache	: ScreenCache 		= if(goPrevious) currentScreenCache.prevScreenCache
                                                      else screensProxy.getCacheByScreenName(nextScreenName);
        if(targetScreenCache == null) targetScreenCache = screensProxy.getFirstCachedScreen();
        var screenMediator	    : ScreenMediator 	= cast facade.getMediator( targetScreenCache.mediatorName );

        trace("> screenMediatorName = " + targetScreenCache.mediatorName );
        trace("> screenMediator = " + screenMediator);

        var currentScreenCacheExist : Bool = currentScreenCache != null;

        if(currentScreenCacheExist) {
            if(!goPrevious && targetScreenCache.prevScreenCache == null)	targetScreenCache.prevScreenCache = currentScreenCache;
            else currentScreenCache.prevScreenCache = null;

            var sm:ScreenMediator = cast facade.getMediator(currentScreenCache.mediatorName);
            sm.onLeave();

            this.send( ApplicationNotification.HIDE_SCREEN, currentScreenCache.screen, nextScreenName );
        }

        var body:Dynamic = notification.getBody();
        var screenData : ScreenData = (body != null && body) ? cast body : new ScreenData();

        screensProxy.currentScreenCache = targetScreenCache;
        screenData.previous = goPrevious;
        screenData.fromScreen = currentScreenName;
        screenData.toScreen = targetScreenCache.name;

        trace("> nextScreenName: " + nextScreenName);
        trace("> goPrevious: " + goPrevious);
        trace("> screenData: " + screenData);

        if(currentScreenCacheExist && currentScreenCache.screen != null)
        {
            function ScreenRemovedFromStage( e:Event ) : Void {
                var screen:Screen = cast e.currentTarget;
                screen.removeEventListener( Event.REMOVED_FROM_STAGE, ScreenRemovedFromStage );
                send( PopupNotification.HIDE_ALL_POPUPS );

                screenMediator.prepareDataForScreen( screenData );
            }
            currentScreenCache.screen.addEventListener( Event.REMOVED_FROM_STAGE, ScreenRemovedFromStage );
        }
        else screenMediator.prepareDataForScreen( screenData );
    }

    public function new() {}
}
