package nest.entities.application;

import nest.entities.screen.commands.RemoveScreenCommand;
import nest.entities.screen.commands.ChangeScreenCommand;
import nest.entities.screen.commands.RegisterScreenCommand;
import nest.entities.screen.ScreenCommands;
import nest.entities.screen.ScreensProxy;
import nest.patterns.facade.Facade;
import nest.interfaces.IFacade;

class ApplicationFacade extends Facade
{
    static public function getInstance( key:String ):IFacade {
        if (Facade.instanceMap.exists( key ) ) return Facade.instanceMap.get( key );
        return new ApplicationFacade( key );
    }
    private function new( key:String ) { super( key ); }

    public static var
        STARTUP(default, never)		: String = "nest_command_application_startup";
    public static var
        READY(default, never)		: String = "nest_command_application_ready";
    public static var
        CORE(default, never)		: String = "nest_application_core";

    //==================================================================================================
    override public function initializeModel():Void {
    //==================================================================================================
        super.initializeModel();

        registerProxy( ScreensProxy );
    }

    //==================================================================================================
    override public function initializeController() : Void {
    //==================================================================================================
        super.initializeController();

        registerCommand( ScreenCommands.REGISTER, 	RegisterScreenCommand 	);
        registerCommand( ScreenCommands.CHANGE, 	ChangeScreenCommand 	);
        registerCommand( ScreenCommands.REMOVE, 	RemoveScreenCommand 	);
    }
}
