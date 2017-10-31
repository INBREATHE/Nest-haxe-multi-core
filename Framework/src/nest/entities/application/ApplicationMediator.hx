package nest.entities.application;

import openfl.events.Event;
import nest.interfaces.INotification;
import nest.entities.screen.Screen;
import nest.patterns.mediator.Mediator;
import nest.patterns.observer.NFunction;

class ApplicationMediator extends Mediator
{
    static public var NAME(default, never):String = "ApplicationMediator";

    public function new( viewComponent : Dynamic ) {
        super( viewComponent );
        var application:Application = cast getViewComponent();
        application.notifier = this;
    }

    //==================================================================================================
    override public function listNotificationsFunctions() : Array<NFunction> {
    //==================================================================================================
        var application:Application = cast getViewComponent();
        return [
            new NFunction( ApplicationNotification.SHOW_SCREEN, 		Notification_ShowScreen		)
        ,	new NFunction( ApplicationNotification.HIDE_SCREEN, 		Notification_HideScreen		)

        ,	new NFunction( ApplicationNotification.ADD_ELEMENT, 		application.addElement      )
        ,	new NFunction( ApplicationNotification.REMOVE_ELEMENT, 		application.removeElement   )
        ];
    }

    //==================================================================================================
    override public function handleNotification( note:INotification ) : Void {
    //==================================================================================================
        var name:String = note.getName();
        var body:Dynamic = note.getBody();
        var application:Application = cast getViewComponent();
        switch (name) {
            case ApplicationNotification.PREPARE: 		application.prepare();
            case ApplicationNotification.INITIALIZED: 	application.initialized();
        }
    }

    //==================================================================================================
    override public function listNotificationInterests():Array<String> {
    //==================================================================================================
        return [
            ApplicationNotification.PREPARE
        ,	ApplicationNotification.INITIALIZED
        ];
    }

    //==================================================================================================
    private function Notification_HideScreen( screen : Screen ) : Void {
    //==================================================================================================
		trace("> ApplicationMediator Notification_HideScreen" + screen);
        var application:Application = cast getViewComponent();
        application.hideScreen(screen, false);
    }

    //==================================================================================================
    private function Notification_ShowScreen( screen : Screen ) : Void {
    //==================================================================================================
		trace("> ApplicationMediator Notification_ShowScreen" + screen);
        var application:Application = cast getViewComponent();
        application.showScreen(screen, false);
    }

    //==================================================================================================
    override public function onRegister() : Void {
    //==================================================================================================
        // This event fired after catching ApplicationNotification.INITIALIZED
        var application:Application = cast getViewComponent();
        application.addEventListener( Application.EVENT_READY, ApplicationReadyHandler );
    }

    //==================================================================================================
    private function ApplicationReadyHandler( e:Event ) : Void {
    //==================================================================================================
        this.exec( ApplicationFacade.READY );
        var application:Application = cast getViewComponent();
        application.removeEventListener( Application.EVENT_READY, ApplicationReadyHandler );
    }

    //==================================================================================================
    override public function onRemove() : Void { super.onRemove(); }
    //==================================================================================================

}
