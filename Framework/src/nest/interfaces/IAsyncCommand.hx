package nest.interfaces;
interface IAsyncCommand extends ICommand
{
    function setOnComplete ( onCompleteCallback : Void->Void ) : Void;
}