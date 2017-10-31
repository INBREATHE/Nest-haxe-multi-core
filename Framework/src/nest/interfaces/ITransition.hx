package nest.interfaces;

import nest.entities.screen.Screen;

interface ITransition
{
    function getIsShowPossible():Bool;
    function getIsHidePossible():Bool;
    function hide( screen : Screen, isReturn : Bool) : Void;
    function show( screen : Screen, isReturn : Bool) : Void;
}
