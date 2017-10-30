package nest.interfaces;

interface INotifier extends IMultiton extends IAcceptable
{
    function send( notificationName : String, ?body : Dynamic, ?type : String ) : Void;
    function exec( commandName : String, ?body : Dynamic, ?type : String ) : Void;

    function initializeNotifier ( key : String ) : Void;
}
