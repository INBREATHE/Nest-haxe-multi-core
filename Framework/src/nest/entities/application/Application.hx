package nest.entities.application;

import openfl.events.Event;
import nest.entities.screen.Screen;
import nest.interfaces.INotifier;
import Std;
import openfl.display.DisplayObject;
import nest.entities.elements.Transition;
import nest.entities.elements.Element;
import openfl.system.Capabilities;
import nest.entities.elements.Navigator;
import openfl.display.Sprite;

class Application extends Sprite
{
    static public var EVENT_READY(default, never) : String = "application_event_ready";

    static public var SCALEFACTOR		: Float = 1;
    static public var SCREEN_DPI		: Float = cast Capabilities.screenDPI;
    static public var SCREEN_WIDTH		: Float = Capabilities.screenResolutionX;
    static public var SCREEN_HEIGHT		: Float = Capabilities.screenResolutionY;

    private var _navigator : Navigator;

    public var notifier(null, default):INotifier;

    public function new()
    {
        super();
        var _screensContainer : Element = new Element();
        _navigator = new Navigator(_screensContainer, new Transition());
        this.addElement(_screensContainer);
    }

    //==================================================================================================
    public function addElement( obj : Dynamic ) : Void {
    //==================================================================================================
        if (Std.is(obj, Element)) {
            var element:Element = cast obj;
            var addAt:Int = getObjectPositionWithPrioriotet(element.getOrder());
            addAt > 0 ? this.addChildAt(element, addAt) : this.addChild(element);
        } else {
            this.addChild(obj);
        }
    }

    //==================================================================================================
    public function removeElement( element : DisplayObject ) : Void {
    //==================================================================================================
        this.removeChild( element );
    }

    //==================================================================================================
    public function showScreen( screen : Screen, ?isReturn : Bool = false) : Void {
    //==================================================================================================
        _navigator.showScreen( screen, isReturn );
    }

    //==================================================================================================
    public function hideScreen( screen : Screen, ?isReturn : Bool = false) : Void {
    //==================================================================================================
        _navigator.hideScreen( screen, isReturn );
    }

    /**
	 * This is the first method that called when framework start
	 * Sent from PrepareBegin command
	 * */
    //==================================================================================================
    public function prepare() : Void { }
    //==================================================================================================

    //==================================================================================================
    public function initialized() : Void {
    //==================================================================================================
        this.dispatchEvent( new Event( EVENT_READY ));
    }

    //==================================================================================================
    public function getObjectPositionWithPrioriotet( prioritet : Int ) : Int {
    //==================================================================================================
        var counter:Int = this.numChildren;
        trace("> getObjectPositionWithPrioriotet: counter = " + counter + "| prioritet = " + prioritet);
        if(counter-- > 0) {
            var child:DisplayObject = cast this.getChildAt(counter);

            trace("> getObjectPositionWithPrioriotet child = " + child);
            while (counter > 0 && Std.is(child, Element)) {
                var element:Element = cast child;
                if (element.getOrder() <= prioritet) break;
                child = cast this.getChildAt(--counter);
            }
            return ++counter;
        } else return counter;
    }
}
