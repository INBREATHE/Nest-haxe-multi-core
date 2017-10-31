package nest.entities.screen.commands;

import nest.interfaces.INotification;
import nest.patterns.command.SimpleCommand;

class RemoveScreenCommand extends SimpleCommand
{
    @Inject public var screensProxy:ScreensProxy;

    override public function execute( notification:INotification ) : Void
    {
        var screenName      : String = notification.getType();
        var screenCache		: ScreenCache = screensProxy.getCacheByScreenName(screenName);
        var screenMediator	: ScreenMediator = cast facade.getMediator(screenCache.mediatorName);
    }

    public function new() {}
}
