package nest.entities.screen;
import nest.entities.application.ApplicationNotification;
import nest.interfaces.INotification;
import nest.patterns.mediator.Mediator;
import openfl.events.Event;

class ScreenMediator extends Mediator {

    private var _dataRequest        : String = "";
    private var _dataNotification   : String = "";
    private var _dataForScreen      : ScreenData;
    private var _isReady            : Bool;

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

    /**
	 * When screen mediator ready to use we first register him in ScreenProxy
	 */
    //==================================================================================================
    override public function onRegister() : Void {
    //==================================================================================================
        this.exec( ScreenCommands.REGISTER, this.getViewComponent(), this.getMediatorName() );
    }

    public var isReady(default, default) : Bool;

    private function Handle_AddComponentToStage( e : Event ) : Void {
        _screen.onAdded();
        SetupComponentListeners();
        _screen.removeEventListener(	Event.ADDED_TO_STAGE, 		Handle_AddComponentToStage);
        _screen.addEventListener(	    Event.REMOVED_FROM_STAGE, 	Handle_RemoveComponentFromStage);
//        _screen.addEventListener(	Event.TRIGGERED, 			ComponentTrigger);
    }

    private function Handle_RemoveComponentFromStage( e : Event ) : Void {
        _screen.onRemoved();
        RemoveComponentListeners();
        _screen.addEventListener(	    Event.ADDED_TO_STAGE, 		Handle_AddComponentToStage);
        _screen.removeEventListener(	Event.REMOVED_FROM_STAGE, 	Handle_RemoveComponentFromStage);
//        _screen.removeEventListener(	Event.TRIGGERED, 			ComponentTrigger);
        if(_screen.rebuildable) _screen.clear();
    }

    //==================================================================================================
    private /*abstract*/ function LocalizeScreen() : Void { }
    private /*abstract*/ function SetupScreenData( data : Dynamic ) : Void { }
    private /*abstract*/ function ComponentTrigger(e:Event) : Void { }
    private /*abstract*/ function SetupComponentListeners() : Void { }
    private /*abstract*/ function RemoveComponentListeners() : Void { }
    //==================================================================================================

    //==================================================================================================
    override public function listNotificationInterests() : Array<String> {
    //==================================================================================================
        return [
            _dataNotification
        ];
    }

    //==================================================================================================
    override public function handleNotification( notification : INotification ) : Void {
    //==================================================================================================
        var name:String = notification.getName();
        trace("> handleNotification : " + name);
        if(name == _dataNotification) {
            SetupScreenData( notification.getBody() );
            ContentReady();
        }
    }

    //==================================================================================================
    private function ContentReady() : Void {
    //==================================================================================================
        if(_dataForScreen != null && _dataForScreen.hasContentReadyCallback())
        _dataForScreen.contentReadyCallback();

        this.send(
            ApplicationNotification.SHOW_SCREEN,
            _screen,
            _dataForScreen.previous ? Screen.PREVIOUS : _screen.name
        );

        _dataForScreen = null;
        _isReady = true;
    }

    /**
	 * This method is called from ChangeScreenCommand
	 * screenMediator.onPrepareDataForScreen(screenData);
	 */
    //==================================================================================================
    public function prepareDataForScreen( screenData : ScreenData ) : Void {
    //==================================================================================================
        _dataForScreen = screenData;
        if( _screen.rebuildable ) {
            _isReady = false;
            if( facade.hasCommand(_dataRequest) ) {
                this.exec( _dataRequest, _dataForScreen.data, _dataNotification );
            } else {
                this.send( _dataRequest, _dataForScreen.data, _dataNotification );
            }
        } else {
            ContentReady();
        }
    }

    /**
	 * This function is called when screen is hiding
	 * but before notification ApplicationNotification.HIDE_SCREEN is sent
	 * from ChangeScreenCommand
	 */
    //==================================================================================================
    public function onLeave() : Void {
    //==================================================================================================
        /** ADNROID - When we go to game we disable this for screen  */
        this.isBackPossible = false;
//        if( viewComponent is ScrollScreen && ScrollScreen(viewComponent).isScrollAvailable )
//        this.send( ScrollerNotifications.RESET_SCROLLER );
    }
}
