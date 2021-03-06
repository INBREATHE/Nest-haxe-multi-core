package nest.core;

import nest.patterns.observer.Observer;
import nest.patterns.observer.NFunction;
import nest.injector.Injector;
import nest.interfaces.INotification;
import nest.interfaces.IMediator;
import nest.interfaces.IObserver;
import nest.interfaces.IView;

class View implements IView
{
    static private var MULTITON_MSG(default, never) : String = "View instance for this Multiton key already constructed!";
    static private var instanceMap : Map<String, IView> = new Map<String, IView>();
    static public function getInstance( key:String ):IView {
        if (instanceMap.exists( key )) return instanceMap.get( key );
        else return new View( key );
    }

    private function new( key : String ) {
        _multitonKey = key;
        instanceMap[ _multitonKey ] = this;
        initializeView();
    }

    private var _multitonKey : String;

    private var mediatorMap(default, never)     : Map<String, IMediator> = new Map<String, IMediator>();
    private var observerMap(default, never)		: Map<String, Array<IObserver>> = new Map<String, Array<IObserver>>();

    private function initializeView() : Void {
        trace("-> initializeView");
    }

    //==================================================================================================
    public function registerObserver( notificationName : String, observer : IObserver ) : Void {
    //==================================================================================================
//		trace("> registerObserver: name = " + notificationName);
        if( observerMap.exists( notificationName ) ) {
            observerMap.get( notificationName ).push( observer );
        } else {
            observerMap.set( notificationName, [ observer ]);
        }
    }

    //==================================================================================================
    public function notifyObservers   ( notification : INotification ) : Void {
    //==================================================================================================
        var notificationName:String = notification.getName();
        if( observerMap.exists( notificationName ) ) {
            var _observers:Array<IObserver> = observerMap.get( notificationName );
            for(observer in _observers) observer.notifyObserver( notification );
        }
    }

    //==================================================================================================
    public function registerMediator  ( mediatorName:String, mediator:IMediator ) : Void {
    //==================================================================================================
        if ( mediatorMap.exists( mediatorName )) return;

        mediator.initializeNotifier( _multitonKey );
        mediatorMap.set( mediatorName, mediator );

        Injector.mapTargetClass( Type.getClass( mediator ), _multitonKey );
        Injector.injectTo( mediator, _multitonKey );
		trace("> registerMediator: " + mediatorName);

        var interestsNotifications:Array<String> = mediator.getListNotifications();
        var interestsNFunctions:Array<NFunction> = mediator.getListNFunctions();

        var counter	        : Int;
        var notifyMethod	: Dynamic->Void;
        var notifyContext	: Dynamic;
        var notifyName		: String;
        var nFunction       : NFunction;

        notifyMethod = mediator.handleNotification;
        counter = interestsNotifications.length;
        while(counter-- > 0) {
            notifyName = interestsNotifications[counter];
            trace("> registerMediator -> notification: name = " + notifyName);
            registerObserver( notifyName, new Observer( notifyMethod, mediator ) );
        }

        counter = interestsNFunctions.length;
        while(counter-- > 0) {
            nFunction = interestsNFunctions[counter];
            notifyName = nFunction.name;
            notifyMethod = function(note:INotification) nFunction.func(note.getBody());
            trace("> registerMediator -> nfunction: name = " + notifyName + " | method = " + notifyMethod);
            registerObserver( notifyName, new Observer( notifyMethod, mediator ) );
        }

        mediator.onRegister();
    }
    public function removeMediator    ( mediatorName : String ) : IMediator { return null; }
    public function hasMediator       ( mediatorName : String ) : Bool { return mediatorMap.exists( mediatorName ); }
    public function getMediator       ( mediatorName : String ) : IMediator { return cast mediatorMap.get( mediatorName ); }

}
