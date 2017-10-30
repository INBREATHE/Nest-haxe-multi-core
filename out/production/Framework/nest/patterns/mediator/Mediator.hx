package nest.patterns.mediator;
import nest.patterns.observer.NFunction;
import nest.interfaces.INotification;
import nest.interfaces.IMediator;
import nest.patterns.proxy.nest.patterns.observer.Notifier;

class Mediator extends Notifier implements IMediator
{
    static private var ERROR_NO_CHILD:String = "There is no child function";

    private var _viewComponent      : Dynamic;
    private var _listNotifications  : Array<String>;
    private var _listNFunctions     : Array<NFunction>;

    public function new( ?viewComponent:Dynamic ) {
        if( viewComponent != null ) _viewComponent = viewComponent;
        _listNotifications = listNotificationInterests();
        _listNFunctions = listNotificationsFunctions();
    }

    public function getMediatorName()							: String 	{ throw "NO MEDIATOR NAME"; return ""; }
    public function setViewComponent( value : Dynamic )			: Void 		{ this.viewComponent = value; }
    public function getViewComponent()							: Dynamic 	{ return viewComponent; }
    public function handleNotification( note:INotification )	: Void 		{ }
    public function onRegister()								: Void 		{ }
    public function onRemove()									: Void 		{
        while(_listNFunctions.length) _listNFunctions.shift().clear();
        _listNotifications.length = 0;
    }
    public function getListNotifications()						: Array<String> 	{ return _listNotifications; }
    public function getListNFunctions()						    : Array<NFunction> 	{ return _listNFunctions; }

    private function listNotificationInterests()				: Array<String> 	{ return new Array<String>(); }
    private function listNotificationsFunctions()				: Array<NFunction> 	{ return new Array<NFunction>(); }
}
