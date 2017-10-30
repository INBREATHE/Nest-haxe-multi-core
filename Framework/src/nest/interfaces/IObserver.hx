package nest.interfaces;
interface IObserver
{
    function notifyObserver( notification : INotification ) : Void;
    function compareNotifyContext( object : Dynamic ) : Bool;
}
