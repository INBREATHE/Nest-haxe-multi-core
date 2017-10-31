package nest.patterns.mediator;
import nest.patterns.observer.Notifier;
import nest.patterns.observer.NFunction;
import nest.interfaces.INotification;
import nest.interfaces.IMediator;

class Mediator extends Notifier implements IMediator
{
    private var _mediatorName       : String;
    private var _viewComponent      : Dynamic;
    private var _listNotifications  : Array<String>;
    private var _listNFunctions     : Array<NFunction>;

    public function new( ?viewComponent:Dynamic ) {
        if( viewComponent != null ) _viewComponent = viewComponent;
        _mediatorName = Type.getClassName( Type.getClass(this) );
        _listNotifications = listNotificationInterests();
        _listNFunctions = listNotificationsFunctions();
    }

    public function getMediatorName()							: String 	{ return _mediatorName; }
    public function setViewComponent( value : Dynamic )			: Void 		{ _viewComponent = value; }
    public function getViewComponent()							: Dynamic 	{ return _viewComponent; }
    public function handleNotification( note:INotification )	: Void 		{ }
    public function onRegister()								: Void 		{ }
    public function onRemove()									: Void 		{ ClearNotificationsLists(); }

    public function getListNotifications()						: Array<String> 	{ return _listNotifications; }
    public function getListNFunctions()						    : Array<NFunction> 	{ return _listNFunctions; }

    private function listNotificationInterests()				: Array<String> 	{ return new Array<String>(); }
    private function listNotificationsFunctions()				: Array<NFunction> 	{ return new Array<NFunction>(); }

    private function applyViewComponentMethod( name:String, data:Dynamic ) : Void {
        Reflect.callMethod( _viewComponent, Reflect.field( _viewComponent, name), [data] );
    }

    private function ClearNotificationsLists():Void {
        var nf:NFunction;
        var counter:Int = _listNFunctions.length;
        while(counter-- > 0) {
            nf = _listNFunctions[counter];
            nf.clear();
        }
        _listNFunctions = null;
        _listNotifications = null;
    }
}
