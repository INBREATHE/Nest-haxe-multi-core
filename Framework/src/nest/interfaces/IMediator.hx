package nest.interfaces;
import nest.patterns.observer.NFunction;

interface IMediator extends INotifier
{
    function getMediatorName        () : String;
    function getViewComponent       () : Dynamic;
    function setViewComponent       ( value : Dynamic ) : Void;
    function getListNotifications   () : Array<String>;
    function getListNFunctions      () : Array<NFunction>;
    function handleNotification     ( note:INotification ) : Void;
    function onRegister()           : Void;
    function onRemove()             : Void;

}
