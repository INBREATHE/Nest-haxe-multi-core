package app.controller.commands.prepare;

import nest.interfaces.INotification;
import nest.patterns.command.SimpleCommand;

class PrepareCompleteCommand extends SimpleCommand
{
    public function new() {}

    override public function execute( notification:INotification ):Void {
        trace("-> execute: body = " + notification.getBody());
    }
}
