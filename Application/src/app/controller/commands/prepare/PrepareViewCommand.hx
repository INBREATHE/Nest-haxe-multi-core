package app.controller.commands.prepare;

import app.view.components.screens.MainScreen;
import app.view.mediators.screens.MainScreenMediator;
import nest.interfaces.INotification;
import nest.patterns.command.AsyncCommand;

class PrepareViewCommand extends AsyncCommand
{
    override public function execute( notification:INotification ):Void {
        trace("-> execute: body = " + notification.getBody());

        facade.registerMediator( MainScreenMediator.NAME, new MainScreenMediator( new MainScreen() ) );

        this.commandComplete();
    }
}
