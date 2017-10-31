package nest.entities.application;
class ApplicationNotification
{
    private static var PREFIX(default, never) : String = "notification_application_";

    static public var PREPARE(default, never)           : String = PREFIX + "prepare";
    static public var INITIALIZED(default, never)       : String = PREFIX + "initialized";

    static public var SHOW_SCREEN(default, never)       : String = PREFIX + "show_screen";
    static public var HIDE_SCREEN(default, never)       : String = PREFIX + "hide_screen";

    static public var ADD_ELEMENT(default, never)       : String = PREFIX + "add_element";
    static public var REMOVE_ELEMENT(default, never)    : String = PREFIX + "remove_element";

    static public var POPUP_OPENED(default, never)      : String = PREFIX + "popup_opened";
    static public var POPUP_CLOSED(default, never)      : String = PREFIX + "popup_closed";
}
