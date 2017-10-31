package ;

import nest.entities.application.Application;
import nest.entities.application.ApplicationMediator;
import nest.entities.application.ApplicationFacade;
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

        appFacade.registerMediator( ApplicationMediator.NAME, appMediator );

        this.addChild(app);

        appFacade.startup();
    }
}
