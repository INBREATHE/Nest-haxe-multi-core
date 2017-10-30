package nest.patterns.command;
import nest.interfaces.INotification;
import nest.interfaces.ICommand;
import nest.patterns.observer.Notifier;

class MacroCommand extends Notifier implements ICommand
{
    private var _subCommands:Array<Class<Dynamic>> = new Array<Class<Dynamic>>();

    public function new() { super(); }

    //==================================================================================================
    override public function initializeNotifier( multitonKey:String ) : Void {
    //==================================================================================================
        super.initializeNotifier( multitonKey );
        initializeMacroCommand();
    }

    private function initializeMacroCommand() : Void { }

    //==================================================================================================
    public function addSubCommand( commandClassRef : Class<Dynamic> ): Void {
    //==================================================================================================
        _subCommands.push( commandClassRef );
    }

    //==================================================================================================
    public function addSubCommands( classes : Array<Class<Dynamic>> ): Void {
    //==================================================================================================
        _subCommands = _subCommands.concat(classes);
    }

    //==================================================================================================
    public function execute( notification : INotification ) : Void {
    //==================================================================================================
        var commandClassRef : Class<Dynamic>;
        var commandInstance : ICommand;
        var multitonKey:String = getMultitonKey();
        while (_subCommands.length > 0) {
            commandClassRef = _subCommands.shift() as Class;
            commandInstance = Type.createEmptyInstance(commandClassRef);
            commandInstance.initializeNotifier( multitonKey );
            commandInstance.execute( notification );
        }
        commandClassRef = null;
        commandInstance = null;
    }
}
