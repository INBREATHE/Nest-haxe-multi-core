package nest.interfaces;
import String;
interface IFacade
{
    function getMultitonKey():String;

    function registerProxy	        ( proxyClass : Class<Dynamic> ) : Void;
    function removeProxy	        ( proxyClass : Class<Dynamic> ) : IProxy;
    function hasProxy		        ( proxyClass : Class<Dynamic> ) : Bool;
    function getProxy	            ( proxyClass : Class<Dynamic> ) : IProxy;

    function registerCommand	    ( notificationName : String, commandClass : Class<Dynamic> ) : Void;
    function registerPoolCommand	( notificationName : String, commandClass : Class<Dynamic> ) : Void;
    function registerCountCommand	( notificationName : String, commandClass : Class<Dynamic>, count : Int ) : Void;
    function removeCommand		    ( notificationName : String ) : Void;
    function hasCommand			    ( notificationName : String ) : Bool;

    function registerMediator	    ( mediatorName : String, mediator : IMediator ) : Void;
    function removeMediator		    ( mediatorName : String ) : IMediator;
    function hasMediator		    ( mediatorName : String ) : Bool;
    function getMediator	        ( mediatorName : String ) : IMediator;

    function send	(notification : INotification ) : Void;
    function exec	(notification : INotification ) : Void;
}
