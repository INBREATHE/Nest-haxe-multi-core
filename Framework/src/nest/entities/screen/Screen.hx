package nest.entities.screen;

import flash.display.Sprite;
import nest.interfaces.IScreen;

class Screen extends Sprite implements IScreen
{
    public static var PREVIOUS(default, never):String = "nest_screen_mark_previous";

    public static var sf		: Float	= 0;
    public static var sw		: Int 	= 0;
    public static var sh		: Int 	= 0;
    public static var swhalf	: Int	= 0;
    public static var shhalf	: Int	= 0;

    public var isShown		: Bool = false;
    public var rebuildable	: Bool = false;

    public function new( name : String ) {
        super();
        this.name = name;
    }

    //==================================================================================================
    public function show() : Void {
    //==================================================================================================
        isShown = true;
    }

    //==================================================================================================
    public function hide( ?callback:Void->Void ) : Void {
    //==================================================================================================
        isShown = false;
        if(callback != null) callback();
    }

    /**
	 * This function called from ScreenMediator after screen removed when:
	 * if(_rebuild) screen.clear();
	*/
    public /*abstract*/ function clear() : Void { }
    public /*abstract*/ function build( content:Dynamic ) : Void { }

    public function onAdded() : Void { }
    public function onRemoved() : Void { }

    /**
	 * First application send notification ScreenCommand.LOCALIZE
	 * with parameter: body = language
	 * Initial command SetupLanguageMiscCommand
	 */
    public function localize(localeData:Dynamic) : Void {

    }

    //==================================================================================================
    public function disableInteractivity() : Void {  }
    public function enableInteractivity() : Void {  }
    //==================================================================================================

    public function getEntityType() : EntityType { return EntityType.SCREEN; }
    public function getLocaleID( ) : String { return this.name; }
    //==================================================================================================
}