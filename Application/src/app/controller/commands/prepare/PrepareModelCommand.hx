package app.controller.commands.prepare;

import app.model.proxy.UserProxy;
import nest.interfaces.INotification;
import nest.patterns.command.AsyncCommand;

class PrepareModelCommand extends AsyncCommand
{
    public function new() {}

    override public function execute( notification:INotification ):Void
    {
        trace("-> execute: body = " + notification.getBody());

        this.facade.registerProxy( UserProxy );

        this.commandComplete();
    }
}
