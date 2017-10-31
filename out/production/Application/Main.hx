package ;

import nest.entities.application.Application;
import nest.entities.application.ApplicationMediator;
import nest.entities.application.ApplicationFacade;
import nest.patterns.observer.Notification;
import app.controller.commands.StartupCommand;
import app.model.proxy.UserProxy;
import openfl.display.Sprite;

class Main extends Sprite  {

    static private var CORE(default, never) : String = "CORE";

    static private var STARTUP(default, never) : String = "StartupCommand";

    public function new()
    {
        super();

        var app:Application = new Application();
        var appFacade:ApplicationFacade = cast ApplicationFacade.getInstance(CORE);
        var appMediator:ApplicationMediator = new ApplicationMediator(app);

        this.addChild(app);

        appFacade.registerProxy( UserProxy );

        appFacade.registerMediator( ApplicationMediator.NAME, appMediator );

        appFacade.registerCommand( STARTUP, StartupCommand );
        appFacade.exec( new Notification( STARTUP, appFacade.getProxy( UserProxy ) ));
        appFacade.exec( new Notification( STARTUP ));
    }
}
