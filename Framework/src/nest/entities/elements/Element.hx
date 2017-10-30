package nest.entities.elements;

import openfl.display.Sprite;

class Element extends Sprite
{
    public function new() { super(); }

    private var _order : Int = 0;
    public function setOrder( value : Int ) : Void { _order = value; }
    public function getOrder() : Int { return _order; }
}
