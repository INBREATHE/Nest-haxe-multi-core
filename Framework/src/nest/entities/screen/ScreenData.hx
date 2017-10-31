package nest.entities.screen;

class ScreenData
{
    public function new( ?data:Dynamic ) {
        this.data = data;
    }

    public var contentReadyCallback(default, null):Void->Void;

    public var data(default, null):Dynamic;

    public var previous	    : Bool;
    public var fromScreen	: String;
    public var toScreen	    : String;

    public function hasContentReadyCallback():Bool { return this.contentReadyCallback != null; }
    public function onContentReady(callback:Void->Void):ScreenData {
        this.contentReadyCallback = callback;
        return this;
    }
}
