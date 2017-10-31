package nest.entities.screen;

class ScreenCommands
{
    static public var
        REGISTER(default, never)	: String = "nest_command_screen_register";
    static public var
        CHANGE(default, never)		: String = "nest_command_screen_change";
    static public var
        REMOVE(default, never)		: String = "nest_command_screen_remove";
    static public var
        LOCALIZE(default, never)	: String = "nest_command_screen_localize";

    public function new() {}
}
