package nest.entities.popup;
class PopupEvents {

    private static var PREFIX(default, never):String = "event_popup_";
    static public var
        COMMAND_FROM_POPUP(default, never)  :String = PREFIX + "commandFromPopup";
    static public var
        TAP_HAPPEND_OK(default, never)	    : String = PREFIX + "tapHappendOk";
    static public var
        TAP_HAPPEND_CLOSE(default, never)	: String = PREFIX + "tapHappendClose";
    static public var
        POPUP_SHOWN(default, never)			: String = PREFIX + "popup_shown";

    public function new() {}
}
