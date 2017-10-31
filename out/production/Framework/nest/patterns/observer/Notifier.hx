package nest.patterns.observer;

import nest.patterns.facade.Facade;
import nest.interfaces.IFacade;
import nest.interfaces.INotifier;

class Notifier implements INotifier
{
    private var facade:IFacade;

    //==================================================================================================
    public function initializeNotifier( multitonKey : String ) : Void {
    //==================================================================================================
        facade = Facade.getInstance( multitonKey );
    }

    //==================================================================================================
    public function send( notificationName : String, ?body : Dynamic, ?type : String ) : Void {
    //==================================================================================================
        facade.send( new Notification( notificationName, body, type ) );
    }

    //==================================================================================================
    public function exec( commandName:String, ?body:Dynamic, ?type:String ) : Void {
    //==================================================================================================
        facade.exec( new Notification( commandName, body, type ) );
    }

    public function getMultitonKey():String { return facade.getMultitonKey(); }
}