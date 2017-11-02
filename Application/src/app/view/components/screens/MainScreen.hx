package app.view.components.screens;

import openfl.text.TextField;
import app.consts.Screens;
import nest.entities.screen.Screen;
import openfl.events.Event;
import openfl.display.Graphics;

class MainScreen extends Screen
{
    private var _messageTF:TextField = new TextField();

    public function new()
    {
        super( Screens.MAIN );

        this.addChild( _messageTF );
        this.addEventListener( Event.ADDED_TO_STAGE, Handle_AddedToStage );
    }

    private function Handle_AddedToStage(e:Event):Void
    {
        var g:Graphics = this.graphics;
        g.beginFill(0xffcc00);
        g.drawRect(0,0, stage.stageWidth, stage.stageHeight * 0.5);
        g.endFill();

        CenterMessage();
    }

    public function showMessage( value:String ) : Void
    {
        _messageTF.text = value;
        if( stage != null ) CenterMessage();
    }

    private function CenterMessage() : Void
    {
        _messageTF.x = ( this.stage.stageWidth - _messageTF.textWidth ) * 0.5;
        _messageTF.y = ( this.height - _messageTF.textHeight ) * 0.5;

    }
}
