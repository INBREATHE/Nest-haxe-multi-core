package nest.interfaces;
interface INotification
{
    function getName    () : String;
    function getType    () : String;
    function getBody    () : Dynamic;
    function setBody    ( body : Dynamic ) : Void;
}
