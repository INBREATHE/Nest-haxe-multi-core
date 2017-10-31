package nest.patterns.facade;

import nest.core.View;
import nest.core.Model;
import nest.core.Controller;
import nest.interfaces.INotification;
import nest.interfaces.IProxy;
import nest.interfaces.IMediator;
import nest.interfaces.IView;
import nest.interfaces.IModel;
import nest.interfaces.IController;
import nest.interfaces.IFacade;

class Facade implements IFacade
{
    static public var MULTITON_INSTANCE_MISSED(default, never):String = "Facade instance for this Multiton key not constructed!";

    static public var instanceMap : Map<String, IFacade> = new Map<String, IFacade>();
    static public function getInstance( key:String ):IFacade {
        if (instanceMap.exists( key ) ) return instanceMap.get( key );
        return new Facade( key );
    }

    private var _key:String;

    public function getMultitonKey():String { return _key; }

    private var _controller : IController;
    private var _model		: IModel;
    private var _view		: IView;

    private function new( key:String ) {
        _key = key;
        instanceMap[ _key ] = this;
        initializeFacade();
    }

    private function initializeFacade() : Void {
        trace("-> initializeFacade");
        initializeModel();
        initializeController();
        initializeView();
    }

    // INITIALIZE
    //========================================================================================================================================
    private function initializeController()	: Void { if ( _controller == null ) _controller = Controller.getInstance( _key ); }
    private function initializeModel()		: Void { if ( _model == null ) _model = Model.getInstance( _key ); }
    private function initializeView()		: Void { if ( _view == null ) _view = View.getInstance( _key ); }
    //========================================================================================================================================

    // REGISTER
    //========================================================================================================================================
    public function registerProxy 			( proxyClass : Class<Dynamic> )     : Void  { _model.registerProxy ( proxyClass ); 			}
    public function registerMediator		( mediatorName : String, mediator : IMediator )	: Void 	{ _view.registerMediator( mediatorName, mediator ); 	    }

    public function registerCommand			( notificationName : String, commandClass : Class<Dynamic> ) : Void 	{ _controller.registerCommand( notificationName, commandClass );  	}
    public function registerPoolCommand		( notificationName : String, commandClass : Class<Dynamic> ) : Void 	{ _controller.registerPoolCommand( notificationName, commandClass );  	}
    public function registerCountCommand	( notificationName : String, commandClass : Class<Dynamic>, count : Int ) : Void { _controller.registerCountCommand( notificationName, commandClass, count );  	}
    //========================================================================================================================================

    // HAS
    //========================================================================================================================================
    public function hasProxy	( proxyClass : Class<Dynamic> ) : Bool 	{ return _model.hasProxy( proxyClass ); }
    public function hasMediator	( mediatorName : String ) 	    : Bool 	{ return _view.hasMediator( mediatorName ); }
    public function hasCommand	( notificationName : String )   : Bool 	{ return _controller.hasCommand( notificationName ); }
    //========================================================================================================================================

    // RETRIEVE
    //========================================================================================================================================
    public function getProxy 	( proxyClass : Class<Dynamic> )	: IProxy 	{ return _model.getProxy ( proxyClass ); }
    public function getMediator	( mediatorName : String )	    : IMediator { return _view.getMediator( mediatorName ); }
    //========================================================================================================================================

    // REMOVE
    //========================================================================================================================================
    public function removeProxy 	( proxyClass : Class<Dynamic> )	: IProxy 	{ return _model.removeProxy ( proxyClass ); }
    public function removeMediator	( mediatorName : String ) 	    : IMediator { return _view.removeMediator( mediatorName ); }
    public function removeCommand	( notificationName : String )	: Void 		{ _controller.removeCommand( notificationName ); }
    //========================================================================================================================================

    // IFacade
    //========================================================================================================================================
    public function send 	( notification : INotification ) : Void 	{ _view.notifyObservers( notification ); }
    public function exec	( notification : INotification ) : Void 	{ _controller.executeCommand( notification ); }
    //========================================================================================================================================
}
