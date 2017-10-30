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

    private var _commandMap 	: Map<String, Class<Dynamic>> = new Map<String, Class<Dynamic>>();
    private var _replyCountMap 	: Map<String, Int> = new Map<String, Int>();

    private function initializeController() : Void {
        trace("-> initializeController");
    }

    //==================================================================================================
    public function registerCommand        ( notificationName : String, commandClass : Class<Dynamic> ) : Void {
    //==================================================================================================
        _commandMap.set( notificationName, commandClass );
    }
    public function registerPoolCommand   ( notificationName : String, commandClass : Class<Dynamic> ) : Void {}
    public function registerCountCommand   ( notificationName : String, commandClass : Class<Dynamic>, replyCount : Int ) : Void {}
    public function executeCommand         ( notification : INotification ) : Void {
        var commandClass : Class<Dynamic> = _commandMap.get(notification.getName());
        var commandInstance:ICommand = Type.createEmptyInstance( commandClass );
        commandInstance.execute( notification );
    }
    public function removeCommand          ( notificationName : String ) : Bool { return false; }
    public function hasCommand             ( notificationName : String ) : Bool {
        return _commandMap.exists( notificationName );
    }

    //==================================================================================================
    public static function removeController( key:String ) : Void {
    //==================================================================================================
        instanceMap.remove( key );
    }
}
