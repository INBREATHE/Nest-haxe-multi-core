package nest.patterns.observer;

import String;
import nest.interfaces.INotification;

class Notification implements INotification
{
    private var _name : String;
    private var _body : Dynamic;
    private var _type : String;

    public function new( name:String, ?body:Dynamic, ?type:String ) {
        _name = name;
        _body = body;
        _type = type;
    }

    public function getName() : String  { return _name; }
    public function getBody() : Dynamic { return _body; }
    public function getType() : String  { return _type; }

    public function setBody( body : Dynamic ) : Void { _body = body; }
}
