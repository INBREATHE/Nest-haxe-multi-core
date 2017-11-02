package app.controller.commands.prepare;

import app.consts.Screens;
import nest.entities.screen.ScreenCommands;
import nest.interfaces.INotification;
import nest.patterns.command.SimpleCommand;

class PrepareCompleteCommand extends SimpleCommand
{
    public function new() {}

    override public function execute( notification:INotification ):Void {
        trace("-> execute: body = " + notification.getBody());

        this.exec( ScreenCommands.CHANGE, null, Screens.MAIN );

    }
}
