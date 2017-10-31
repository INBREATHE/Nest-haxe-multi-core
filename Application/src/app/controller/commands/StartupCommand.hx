package app.controller.commands;

import app.controller.commands.prepare.PrepareModelCommand;
import app.controller.commands.prepare.PrepareCompleteCommand;
import app.controller.commands.prepare.PrepareViewCommand;
import app.controller.commands.prepare.PrepareControllerCommand;
import app.controller.commands.prepare.PrepareModulesCommand;
import nest.patterns.command.AsyncMacroCommand;

class StartupCommand extends AsyncMacroCommand
{
    public function new () {}

    override public function initializeAsyncMacroCommand() : Void
    {
        this.addSubCommands([
        	PrepareModulesCommand		// AsyncCommand
        ,	PrepareModelCommand     	// AsyncCommand
        ,	PrepareControllerCommand	// AsyncCommand
        ,	PrepareViewCommand			// AsyncCommand
        ,	PrepareCompleteCommand		// SimpleCommand
        ]);
    }
}
