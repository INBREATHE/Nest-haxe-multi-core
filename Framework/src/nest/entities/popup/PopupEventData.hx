package nest.entities.popup;

class PopupEventData
{
    public var body:Dynamic;
    public var type:String;
    public var callback(default, null):Dynamic->Void;

    public function new( body : Dynamic, ?type : String )
    {
        this.type = type;
        this.body = body;
    }

    public function onComplete( callback : Dynamic->Void ) : PopupEventData {
        this.callback = callback;
        return this;
    }
}
