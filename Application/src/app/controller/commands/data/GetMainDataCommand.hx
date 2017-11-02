package app.controller.commands.data;

import nest.interfaces.INotification;
import nest.patterns.command.SimpleCommand;

class GetMainDataCommand extends SimpleCommand
{
    override public function execute( note:INotification ) : Void
    {
        trace("> execute: type = " + note.getType());
        this.send( note.getType(), "Data for MainScreen" );
    }
}
