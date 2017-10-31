package nest.entities.popup;

import nest.entities.elements.Element;
import openfl.events.Event;
import nest.interfaces.IPopup;

class Popup extends Element implements IPopup
{
    public var command(default, null):String;
    public var commands(null, default):Array<String>;

    private var _commandID	: Int;
    private var _onAdded	: Dynamic->Void;
    private var _onShown	: Dynamic->Void;
    private var _onRemoved	: Dynamic->Void;

    /**
	 * This is a number in popupsArray
	 * It's used for removing popups from screen
	 * when android back button is pressed
	 */
    public var localIndex:Int = 0;
    /**
	 * Check if remove operation for popup is available
	 */
    public var backRemovable:Bool = true;

    public function new( name : String ) {
        this.name = name;
        this.addEventListener( Event.ADDED_TO_STAGE, Handler_ADDED_TO_STAGE );
    }

    //==================================================================================================
    private function Handler_ADDED_TO_STAGE( e : Event ) : Void {
    //==================================================================================================
        this.removeEventListener( Event.ADDED_TO_STAGE, Handler_ADDED_TO_STAGE);
        this.addEventListener( Event.REMOVED_FROM_STAGE, Handler_REMOVED_FROM_STAGE);

        _onAdded && _onAdded() && (_onAdded = null);
    }

    //==================================================================================================
    private function Handler_REMOVED_FROM_STAGE( e : Event ) : Void {
    //==================================================================================================
        this.addEventListener( Event.ADDED_TO_STAGE, Handler_ADDED_TO_STAGE);
        this.removeEventListener( Event.REMOVED_FROM_STAGE, Handler_REMOVED_FROM_STAGE);

        _onRemoved && _onRemoved() && (_onRemoved = null) && (_onShown = null);
    }

    //==================================================================================================
    public function setup( popupData : PopupData ) : Void {
    //==================================================================================================
        _onAdded 	= popupData.onAdded;
        _onShown 	= popupData.onShown;
        _onRemoved 	= popupData.onRemoved;

        prepare(popupData.data);
    }

    public function prepare( params:Dynamic ) : Void { }
    public function show() : Void { }
    public function hide( next : String->Void ) : Void { next(this.name); }

    public function getLocaleID():String { return this.name; }
    public function getEntityType():EntityType { return EntityType.POPUP; }

}
