package app.controller.commands.prepare;

import app.controller.commands.data.GetMainDataCommand;
import app.consts.commands.DataCommands;
import nest.interfaces.INotification;
import nest.patterns.command.AsyncCommand;

class PrepareControllerCommand extends AsyncCommand
{
    public function new() {}

    override public function execute( notification:INotification ):Void {
        trace("-> execute: body = " + notification.getBody());

        facade.registerCommand( DataCommands.GET_MAIN, GetMainDataCommand );

        this.commandComplete();
    }
}
