package nest.entities.elements;

import nest.entities.screen.Screen;
class Transition
{
    public function new() {}

    public var onShowStart		: Screen->Void;
    public var onShowComplete	: Screen->Void;
    public var onHideComplete	: Screen->Void;

    public var isHidePossible : Bool = true;
    public var isShowPossible : Bool = true;

    //==================================================================================================
    public function hide( screen : Screen, isReturn : Bool ) : Void { screen.show(); onShowComplete(screen); }
    public function show( screen : Screen, isReturn : Bool ) : Void { screen.hide(function() : Void { onHideComplete(screen); }); }
    //==================================================================================================


}
