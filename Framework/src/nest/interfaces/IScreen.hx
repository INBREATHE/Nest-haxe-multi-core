package nest.interfaces;
interface IScreen
{
    function show() : Void;
    function build( content : Dynamic ) : Void;
    function hide( ?callback : Void->Void ) : Void;

    function clear() : Void;
    function onAdded() : Void;
    function onRemoved() : Void;
}
