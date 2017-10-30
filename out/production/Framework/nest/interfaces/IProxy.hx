package nest.interfaces;

interface IProxy extends INotifier extends IInjectable
{
    function getProxyName   () : String;
    function getData        () : Dynamic;
    function setData        ( data : Dynamic ) : Void;
    function onRegister     () : Void;
    function onRemove       () : Void;
}
