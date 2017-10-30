package nest.interfaces;

interface ICommand extends INotifier
{
    function execute( note:INotification ) : Void;
}
