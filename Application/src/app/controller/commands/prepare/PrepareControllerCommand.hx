package app.controller.commands.prepare;

import nest.interfaces.INotification;
import nest.patterns.command.AsyncCommand;

class PrepareControllerCommand extends AsyncCommand
{
    public function new() {}

    override public function execute( notification:INotification ):Void {
        trace("-> execute: body = " + notification.getBody());

        this.commandComplete();
    }
}
