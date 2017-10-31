package nest.interfaces;
interface IPopup
{
    function setup( data : PopupData ) : Void;
    function prepare( params : Dynamic ) : Void;
    function show() : Void;
    function hide( next : String->Void ) : Void;
}
