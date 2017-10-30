package app.controller.commands;

import app.model.proxy.UserProxy;
import nest.interfaces.INotification;
import nest.patterns.command.SimpleCommand;

class StartupCommand extends SimpleCommand
{
    @Inject public var userProxy:UserProxy;

    public function new () {}

    override public function execute( notification:INotification ):Void {
        trace("-> execute: body = " + notification.getBody());
    }
}
