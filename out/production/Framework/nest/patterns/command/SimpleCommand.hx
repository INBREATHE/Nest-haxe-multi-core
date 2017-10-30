package nest.patterns.command;

import nest.patterns.observer.Notifier;
import nest.interfaces.INotification;
import nest.interfaces.ICommand;

class SimpleCommand extends Notifier implements ICommand
{
    public function execute( notification:INotification ) : Void { }
}