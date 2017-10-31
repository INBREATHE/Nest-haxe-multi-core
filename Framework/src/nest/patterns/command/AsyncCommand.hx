package nest.patterns.command;

import nest.interfaces.IAsyncCommand;

class AsyncCommand extends SimpleCommand implements IAsyncCommand
{
    //==================================================================================================
    public function setOnComplete ( onCompleteCallback:Void->Void ) : Void {
    //==================================================================================================
        _onCompleteCallback = onCompleteCallback;
    }

    //==================================================================================================
    private function commandComplete () : Void {
    //==================================================================================================
        _onCompleteCallback();
        _onCompleteCallback = null;
    }

    private var _onCompleteCallback	: Void->Void;
}
