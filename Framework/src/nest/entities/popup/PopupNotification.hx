package nest.entities.popup;
class PopupNotification {

    static public var
        SHOW_POPUP(default, never)	        : String = "nest_note_popup_show";
    static public var
        SHOW_POPUP_BY_NAME(default, never)	: String = "nest_note_popup_show_by_name";
    static public var
        HIDE_POPUP(default, never)			: String = "nest_note_popup_hide";
    static public var
        HIDE_ALL_POPUPS(default, never)		: String = "nest_note_popup_hide_all";
    static public var
        UNLOCK_POPUP(default, never)		: String = "nest_note_popup_unlock";
    static public var
        UPDATE_POPUP(default, never)		: String = "nest_note_popup_update";
    static public var
        REGISTER_POPUP(default, never)		: String = "nest_note_popup_register";

    public function new() {
    }
}
