package nest.core;

import nest.interfaces.INotification;
import nest.interfaces.IMediator;
import nest.interfaces.IObserver;
import nest.interfaces.IView;

class View implements IView {
    static private var MULTITON_MSG(default, never) : String = "View instance for this Multiton key already constructed!";
    static private var instanceMap : Map<String, IView> = new Map<String, IView>();
    static public function getInstance( key:String ):IView {
        var instance:IView = instanceMap[ key ];
        if (instance == null ) instance = new View( key );
        return instance;
    }

    private var _multitonKey : String;

    public function new( key : String ) {
        if (instanceMap[ key ] != null) throw MULTITON_MSG;
        _multitonKey = key;
        instanceMap[ _multitonKey ] = this;
        initializeView();
    }

    private function initializeView() : Void {
        trace("-> initializeView");
    }

    public function registerObserver( notificationName : String, observer : IObserver ) : Void {}

    public function notifyObservers   ( notification : INotification ) : Void {}
    public function registerMediator  ( mediatorClass : Class<Dynamic> ) : Void {}
    public function removeMediator    ( mediatorClass : Class<Dynamic> ) : IMediator { return null; }
    public function hasMediator       ( mediatorClass : Class<Dynamic> ) : Bool { return false; }
    public function getMediator       ( mediatorClass : Class<Dynamic> ) : IMediator { return null; }

}
