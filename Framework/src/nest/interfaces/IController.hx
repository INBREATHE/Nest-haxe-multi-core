package nest.interfaces;
interface IController
{
    function registerCommand        ( notificationName : String, commandClass : Class<Dynamic> ) : Void;
    function registerPoolCommand    ( notificationName : String, commandClass : Class<Dynamic> ) : Void;
    function registerCountCommand   ( notificationName : String, commandClass : Class<Dynamic>, replyCount : Int ) : Void;
    function executeCommand         ( notification : INotification ) : Void;
    function removeCommand          ( notificationName : String ) : Bool;
    function hasCommand             ( notificationName : String ) : Bool;
}
