package nest.entities.screen;
import openfl.events.Event;
class ScreenMediator {

    private var _dataRequest : String = "";
    private var _dataNotification : String = "";
    private var _dataForScreen : ScreenData;
    private var _isReady : Bool;

    private var _screen:Screen;

    public var isBackPossible:Bool = false;

    public function new(
        viewComponent		: Dynamic,
        dataNotification	: String,
        dataCommand			: String = null
    ) {
        this._dataNotification = dataNotification;
        this._dataRequest = dataCommand;
        this._screen = cast viewComponent;

        super( viewComponent );

        _screen.rebuildable = true;
        _screen.addEventListener( Event.ADDED_TO_STAGE, Handle_AddComponentToStage );
    }

    public var isReady(default, default) : Bool;

    private function Handle_AddComponentToStage( e : Event ) : Void {
        _screen.onAdded();
//        SetupComponentListeners();
        _screen.removeEventListener(	Event.ADDED_TO_STAGE, 		Handle_AddComponentToStage);
        _screen.addEventListener(	Event.REMOVED_FROM_STAGE, 	Handle_RemoveComponentFromStage);
        _screen.addEventListener(	Event.TRIGGERED, 			ComponentTrigger);
    }

    private function Handle_RemoveComponentFromStage( e : Event ) : Void {
        _screen.onRemoved();
//        RemoveComponentListeners();
        _screen.addEventListener(	Event.ADDED_TO_STAGE, 		Handle_AddComponentToStage);
        _screen.removeEventListener(	Event.REMOVED_FROM_STAGE, 	Handle_RemoveComponentFromStage);
        _screen.removeEventListener(	Event.TRIGGERED, 			ComponentTrigger);
        if(_screen.rebuildable) _screen.clear();
    }

    //==================================================================================================
    private /*abstract*/ function LocalizeScreen() : Void { }
    private /*abstract*/ function SetupScreenData( data : Dynamic ) : Void { }
    private /*abstract*/ function ComponentTrigger(e:Event) : Void { }
    private /*abstract*/ function SetupComponentListeners() : Void { }
    private /*abstract*/ function RemoveComponentListeners() : Void { }
    //==================================================================================================
}
