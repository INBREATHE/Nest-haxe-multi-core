package nest.interfaces;
interface IView
{
    function registerObserver( notificationName : String, observer : IObserver ) : Void;

    function notifyObservers   ( notification : INotification ) : Void;

    function registerMediator  ( mediatorName : String, mediator : IMediator ) : Void;
    function removeMediator    ( mediatorName : String ) : IMediator;
    function hasMediator       ( mediatorName : String ) : Bool;
    function getMediator       ( mediatorName : String ) : IMediator;
}
