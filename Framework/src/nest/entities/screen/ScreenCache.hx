package nest.entities.screen;
class ScreenCache {

    public var screen           : Screen;
    public var mediatorName     : String;
    public var prevScreenCache  : ScreenCache;

    public var name(get, null)  : String;
    public function get_name():String { return this.screen.name; }

    public function new( screen : Screen, mediatorName : String ) {
        this.mediatorName = mediatorName;
        this.screen = screen;
    }
}
