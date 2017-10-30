package nest.patterns.command;

import nest.interfaces.INotification;
import nest.interfaces.ICommand;
import nest.patterns.observer.Notifier;
import nest.interfaces.IAsyncCommand;

class AsyncMacroCommand  extends Notifier implements IAsyncCommand
{
    public function new() { super(); }

    private var _onComplete		:	Void->Void;
    private var _subCommands	:	Array<Class<Dynamic>>;
    private var _notification	:	INotification;
    private var _counter		: 	Int = 0;

    public function AsyncMacroCommand() {
        _subCommands = new Array<Class<Dynamic>>();
    }

    //==================================================================================================
    override public function initializeNotifier( key : String ) : Void {
    //==================================================================================================
        super.initializeNotifier(key);
        initializeAsyncMacroCommand();
    }

    public function initializeAsyncMacroCommand() : Void { }

    //==================================================================================================
    public function addSubCommand( commandClassRef : Class<Dynamic> ) : Void {
    //==================================================================================================
        _subCommands.push( commandClassRef );
    }

    //==================================================================================================
    public function addSubCommands( classes : Array<Class<Dynamic>> ) : Void {
    //==================================================================================================
        _subCommands = _subCommands.concat(classes);
    }

    //==================================================================================================
    public function setOnComplete ( value : Void->Void ) : Void { _onComplete = value; }
    //==================================================================================================

    //==================================================================================================
    public function execute( notification:INotification ) : Void {
    //==================================================================================================
        _notification = notification;
        ExecuteNextCommand();
    }

    //==================================================================================================
    private function ExecuteNextCommand() : Void {
    //==================================================================================================
        if (_subCommands.length > _counter) NextCommand();
        else {
            if(_onComplete != null) _onComplete();
            _onComplete		=	null;
            _subCommands 	= 	null;
        }
    }

    //==================================================================================================
    private function NextCommand () : Void {
    //==================================================================================================
        var commandClassRef	: Class<Dynamic> = Class(_subCommands[_counter++]);
        var commandInstance	: ICommand = Type.createEmptyInstance(commandClassRef);
        var multitonKey		: String = getMultitonKey();
        var isAsync			: Bool = commandInstance is IAsyncCommand;

        commandInstance.initializeNotifier( multitonKey );
        if (isAsync) IAsyncCommand( commandInstance ).setOnComplete( ExecuteNextCommand );

        commandInstance.execute( _notification );
        if (!isAsync) ExecuteNextCommand();
    }
}
