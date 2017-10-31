package nest.entities.application;

import nest.patterns.observer.Notification;
import nest.patterns.facade.Facade;
import nest.interfaces.IFacade;
import nest.patterns.facade.Facade;

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

    override public function initializeController() : Void
    {
        this.registerCommand( STARTUP, StartupCommand );
    }

    public function startup() : Void
    {
        this.exec( new Notification( STARTUP ));
    }
}
