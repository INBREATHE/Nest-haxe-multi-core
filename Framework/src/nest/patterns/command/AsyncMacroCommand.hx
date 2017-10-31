package nest.patterns.command;

import nest.interfaces.INotification;
import nest.interfaces.ICommand;
import nest.patterns.observer.Notifier;
import nest.interfaces.IAsyncCommand;

class AsyncMacroCommand  extends Notifier implements IAsyncCommand
{
    private var _onComplete		:	Void->Void;
    private var _subCommands	:	Array<Class<Dynamic>>;
    private var _notification	:	INotification;
    private var _counter		: 	Int = 0;

    //==================================================================================================
    override public function initializeNotifier( key : String ) : Void {
    //==================================================================================================
        _subCommands = new Array<Class<Dynamic>>();
        super.initializeNotifier(key);
        initializeAsyncMacroCommand();
    }

    public function initializeAsyncMacroCommand() : Void { }
    public function deInitializeAsyncMacroCommand() : Void {
        _counter = _subCommands.length;
        var commandClassRef : Class<Dynamic>;
        var multitonKey : String = getMultitonKey();
        while(_counter-- > 0) {
            commandClassRef = _subCommands[_counter];
//        Injector.unmapTarget(commandClassRef, multitonKey);
        }
        commandClassRef = null;
    }

    //==================================================================================================
    public function addSubCommand( commandClassRef : Class<Dynamic> ) : Void {
    //==================================================================================================
        _subCommands.push( commandClassRef );
    }

    //==================================================================================================
    public function addSubCommands( classes : Array<Class<Dynamic>> ) : Void {
    //==================================================================================================
        trace("> addSubCommands classes = " + classes.length);
        trace("> addSubCommands _subCommands = " + _subCommands);
        _subCommands = _subCommands.concat(classes);
        trace("> addSubCommands counter = " + _subCommands.length);
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
        trace("> ExecuteNextCommand: _counter = " + _counter + " | length = " + (if(_subCommands != null) _subCommands.length else 0));
        if (_subCommands.length > _counter) NextCommand();
        else {
            deInitializeAsyncMacroCommand();
            if(_onComplete != null) _onComplete();
            _notification   =   null;
            _onComplete		=	null;
            _subCommands 	= 	null;
        }
    }

    //==================================================================================================
    private function NextCommand () : Void {
    //==================================================================================================
        var commandClassRef	: Class<Dynamic> = cast _subCommands[_counter++];
        var commandInstance	: ICommand = Type.createEmptyInstance(commandClassRef);
        var multitonKey		: String = getMultitonKey();
        var isAsync			: Bool = Std.is(commandInstance, IAsyncCommand);

        commandInstance.initializeNotifier( multitonKey );

        if (isAsync) {
            var asyncCommand:IAsyncCommand = cast commandInstance;
            asyncCommand.setOnComplete( ExecuteNextCommand );
        }
        commandInstance.execute( _notification );
        if (!isAsync) ExecuteNextCommand();
    }
}
