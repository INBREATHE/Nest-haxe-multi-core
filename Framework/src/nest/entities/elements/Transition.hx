package nest.entities.elements;

import nest.entities.screen.Screen;
class Transition
{
    public function new() {}

    public var onShowStart		: Void->Void;
    public var onShowComplete	: Void->Void;
    public var onHideComplete	: Void->Void;

    public var isHidePossible : Bool = false;
    public var isShowPossible : Bool = true;

    //==================================================================================================
    public function hide( screen : Screen, isReturn : Bool ) : Void { }
    public function show( screen : Screen, isReturn : Bool ) : Void { }
    //==================================================================================================


}
