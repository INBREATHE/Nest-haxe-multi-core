package nest.core;
import nest.injector.Injector;
import nest.interfaces.INotification;
import nest.interfaces.ICommand;
import nest.interfaces.IController;

class Controller implements IController
{
    static private var MULTITON_MSG(default, never) : String = "Controller instance for this Multiton key already constructed!";
    static private var instanceMap : Map<String, IController> = new Map<String, IController>();
    static public function getInstance( key:String ):IController {
        if (instanceMap.exists( key )) return instanceMap.get( key );
        else return new Controller( key );
    }

    private var _multitonKey : String;
    private function new( key : String ) {
        instanceMap.set( key, this );
        _multitonKey = key;
        initializeController();
    }

    private var _classMap 	    : Map<String, Class<Dynamic>> = new Map<String, Class<Dynamic>>();
    private var _commandsPool   : Map<String, ICommand> = new Map<String, ICommand>();
    private var _replyCountMap 	: Map<String, Int> = new Map<String, Int>();

    private function initializeController() : Void {
        trace("-> initializeController");
    }

    //==================================================================================================
    public function registerCommand        ( notificationName : String, commandClass : Class<Dynamic> ) : Void {
    //==================================================================================================
        Injector.mapTargetClass( commandClass, _multitonKey );
        trace("> registerCommand: notificationName = " + notificationName);
        _classMap.set( notificationName, commandClass );
    }

    //==================================================================================================
    public function registerPoolCommand   ( notificationName : String, commandClass : Class<Dynamic> ) : Void {
    //==================================================================================================
        var commandInstance : ICommand = Type.createEmptyInstance( commandClass );
        _commandsPool.set( notificationName, commandInstance );
    }

    //==================================================================================================
    public function registerCountCommand   ( notificationName : String, commandClass : Class<Dynamic>, replyCount : Int ) : Void {}
    //==================================================================================================

    //==================================================================================================
    public function executeCommand         ( notification : INotification ) : Void {
    //==================================================================================================
        var name:String = notification.getName();
        var commandClass : Class<Dynamic>;
        var commandInstance : ICommand;

        var isPoolCommand:Bool = _commandsPool.exists( name );
        if( isPoolCommand ) {
            commandInstance = _commandsPool.get(name);
            commandClass = Type.getClass( commandInstance );
        } else {
            if(_classMap.exists( name )) {
                commandClass = _classMap.get(notification.getName());
                commandInstance = Type.createEmptyInstance( commandClass );
                commandInstance.initializeNotifier( _multitonKey );
                Injector.injectTo( commandInstance, _multitonKey );
            } else throw 'NO COMMAND REGISTERED TO ${ name }';
        }
        trace("> executeCommand: " + commandInstance);
        commandInstance.execute( notification );
        if(!isPoolCommand) Injector.clear( commandInstance, _multitonKey );
    }

    //==================================================================================================
    public function removeCommand          ( notificationName : String ) : Bool { return false; }
    //==================================================================================================
    public function hasCommand             ( notificationName : String ) : Bool {
    //==================================================================================================
        return _classMap.exists( notificationName );
    }

    //==================================================================================================
    public static function removeController( key:String ) : Void {
    //==================================================================================================
        instanceMap.remove( key );
    }
}
