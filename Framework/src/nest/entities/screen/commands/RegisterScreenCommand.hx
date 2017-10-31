package nest.entities.screen.commands;

import nest.interfaces.INotification;
import nest.patterns.command.SimpleCommand;

class RegisterScreenCommand extends SimpleCommand
{
    @Inject public var screensProxy:ScreensProxy;

    override public function execute( notification:INotification ) : Void
    {
        var screen:Screen = cast notification.getBody();
        var mediatorName:String = notification.getType();
        var screenCache:ScreenCache = new ScreenCache(Screen(screen), mediatorName);
        screensProxy.cacheScreenByName(Screen(screen).name, screenCache);
    }

    public function new() {}
}
