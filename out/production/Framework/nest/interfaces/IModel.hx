package nest.interfaces;

interface IModel
{
    function registerProxy	( proxyClass : Class<Dynamic> ) : Void;
    function getProxy		( proxyClass : Class<Dynamic> ) : IProxy;
    function removeProxy    ( proxyClass : Class<Dynamic> ) : IProxy;
    function hasProxy		( proxyClass : Class<Dynamic> ) : Bool;
}
