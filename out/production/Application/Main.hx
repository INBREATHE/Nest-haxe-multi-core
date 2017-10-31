package ;

import nest.patterns.observer.Notification;
import app.controller.commands.StartupCommand;
import app.model.proxy.UserProxy;
import openfl.display.Sprite;
import nest.patterns.facade.Facade;

class Main extends Sprite  {

    static private var CORE(default, never) : String = "CORE";

    static private var STARTUP(default, never) : String = "StartupCommand";

    public function new()
    {
        super();

        var facade:Facade = cast Facade.getInstance(CORE);

        facade.registerProxy( UserProxy );

        facade.registerCommand( STARTUP, StartupCommand );
        facade.exec( new Notification( STARTUP, facade.getProxy( UserProxy ) ));
        facade.exec( new Notification( STARTUP ));
    }
}
