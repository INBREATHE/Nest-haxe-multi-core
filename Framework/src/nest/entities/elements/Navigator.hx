package nest.entities.elements;

import nest.entities.screen.Screen;
import openfl.display.DisplayObjectContainer;

class Navigator {

    private var _container	: DisplayObjectContainer;
    private var _transition	: Transition;

    public function new( container : DisplayObjectContainer, transition : Transition ) {
        _container = container;
        _transition = transition;

        _transition.onHideComplete 	= RemoveScreen;
        _transition.onShowStart 	= AddScreenToApp;
        _transition.onShowComplete 	= ScreenChangeComplete;
    }

    //==================================================================================================
    public function showScreen( screen : Screen, isReturn : Bool ) : Void {
    //==================================================================================================
        if(_transition.isShowPossible) {
            _container.addChild( screen );
            screen.show();
        } else {
            _transition.show( screen, isReturn );
        }
    }

    //==================================================================================================
    public function hideScreen( screen : Screen, isReturn : Bool ) : Void {
    //==================================================================================================
        // From base class Transistion.as
        // Default:  _transition.isHidePossible == false
        if(_transition.isHidePossible) {
            _transition.hide(screen, isReturn);
        } else {
            screen.hide(function() {_transition.hide( screen, isReturn ); });
        }
    }

    //==================================================================================================
    private function RemoveScreen( screen : Screen ) : Void { _container.removeChild( screen ); }
    private function ScreenChangeComplete( screen : Screen ) : Void { screen.show(); }
    private function AddScreenToApp( screen : Screen ) : Void { _container.addChild(screen); }
    //==================================================================================================
}
