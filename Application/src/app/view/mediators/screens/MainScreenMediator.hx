package app.view.mediators.screens;

import app.view.components.screens.MainScreen;
import app.consts.commands.DataCommands;
import app.consts.notifications.DataNotifications;
import openfl.display.Sprite;
import nest.entities.screen.ScreenMediator;

class MainScreenMediator extends ScreenMediator
{
    static public var NAME(default, never):String = "MainScreenMediator";

    public function new( viewComponent : Sprite ) {
        super(
            viewComponent,
            DataNotifications.TAKE_MAIN,
            DataCommands.GET_MAIN
        );
    }

    override public function getMediatorName() : String { return NAME; }

    //==================================================================================================
    override public function SetupScreenData( data:Dynamic ) : Void {
    //==================================================================================================
        var message:String = cast data;
        var mainScreen:MainScreen = cast getViewComponent();
        trace("> SetupScreenData: message = " + message);
        mainScreen.showMessage( message );
    }
}
