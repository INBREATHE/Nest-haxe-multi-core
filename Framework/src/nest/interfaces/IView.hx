package nest.interfaces;
interface IView
{
    function registerObserver( notificationName : String, observer : IObserver ) : Void;

    function notifyObservers   ( notification : INotification ) : Void;
    function registerMediator  ( mediatorClass : Class<Dynamic> ) : Void;
    function getMediator       ( mediatorClass : Class<Dynamic> ) : IMediator;
    function removeMediator    ( mediatorClass : Class<Dynamic> ) : IMediator;
    function hasMediator       ( mediatorClass : Class<Dynamic> ) : Bool;
}
