package nest.entities.popup;

import nest.interfaces.INotification;
import nest.entities.application.ApplicationNotification;
import openfl.events.Event;
import openfl.display.DisplayObject;
import nest.interfaces.IPopup;
import nest.patterns.mediator.Mediator;

class PopupsMediator extends Mediator
{
    private var _popupsCount:Int = 0;
    private var _popupsQueue(default, never):Array<Popup> = new Array<Popup>();
    private var _popupsStorage(default, never):Map<String, IPopup> = new Map<String, IPopup>();

    public function new() { super(new Map<String, Popup>()); }

    override public function listNotificationInterests():Array<String> {
        return new Array<String>(
            PopupNotification.SHOW_POPUP
        ,	PopupNotification.SHOW_POPUP_BY_NAME
        ,	PopupNotification.HIDE_POPUP
        ,	PopupNotification.REGISTER_POPUP
        ,	PopupNotification.HIDE_ALL_POPUPS
        ,	PopupNotification.UNLOCK_POPUP
        ,	PopupNotification.UPDATE_POPUP
        );
    }

    override public function handleNotification( note:INotification ) : Void {
        switch ( note.getName() ) {
            case PopupNotification.HIDE_POPUP:
                if(_popupsCount > 0)
                    /**
					 * note.getType() - The name of popup
					 * note.getBody() - force delete (without popup.hide)
					 */
                    Notification_HidePopup(	String(note.getType()), Bool(note.getBody()) || false );
                break;
            case PopupNotification.REGISTER_POPUP:      Notification_RegisterPopup(Popup(note.getBody())); break;
            case PopupNotification.SHOW_POPUP_BY_NAME:  Notification_ShowPopupByName(PopupData(note.getBody()), note.getType()); break;
            case PopupNotification.SHOW_POPUP:          Notification_ShowPopup(Popup(note.getBody())); break;
            case PopupNotification.HIDE_ALL_POPUPS:     Notification_HideAllPopups(); break;
            case PopupNotification.UNLOCK_POPUP:        Notification_UnlockPopup(String(note.getBody())); break;
            case PopupNotification.UPDATE_POPUP:        Notification_UpdatePopup(note.getBody(), String(note.getType())); break;
        }
    }

    //==================================================================================================
    private function RemovePopupFromStage( name : String ) : Void {
    //==================================================================================================
        var popup:Popup = this.GetPopupByName(name);
        if(popup == null) return;

        RemoveListeners(popup);
        RemovePopupByName(name);

        this.send( ApplicationNotification.REMOVE_ELEMENT, popup );
        this.send( ApplicationNotification.POPUP_CLOSED, _popupsCount, name);
    }

    //==================================================================================================
    private function Notification_UpdatePopup( popupData : Dynamic, popupName : String ) : Void {
    //==================================================================================================
        trace("> Notification_UpdatePopup:", popupName, popupData)
        var popup:Popup = _popupsStorage.get( popupName );
        popup.prepare( popupData );
    }

    //==================================================================================================
    private function Notification_UnlockPopup( ?popupName : String ) : Void {
    //==================================================================================================
        trace("> Notification_UnlockPopup:", popupName)
        if(popupName == null) return;
        var popup:Popup = _popupsStorage.get( popupName );
    }

    //==================================================================================================
    private function Notification_ShowPopupByName(popupData:PopupData, name:String) : Void {
    //==================================================================================================
        var popup:Popup = _popupsStorage.get( name );
        trace("> Notification_ShowPopupByName:", name)
        if (GetPopupByName( name ) != null) popup.hide(function() {
            trace("> Notification_ShowPopupByName > Hide Popup:", name)
            RemovePopupFromStage(name);
            popup.setup(popupData);
            AddPopup(popup);
        });
        else {
            popup.setup(popupData);
            this.AddPopup(popup);
        }
    }

    //==================================================================================================
    private function Notification_RegisterPopup( popup : Popup ) : Void {
    //==================================================================================================
        _popupsStorage.set( popup.name, popup );
    }

    //==================================================================================================
    private function Notification_ShowPopup( popup : Popup ) : Void {
    //==================================================================================================
        var popupName:String = popup.name;
        if (GetPopupByName(popupName) != null) RemovePopupFromStage(popupName);
        this.AddPopup(popup);
    }

    //==================================================================================================
    private function Notification_HideAllPopups() : Void {
    //==================================================================================================
        var popups:Map<String, IPopup> = cast getViewComponent();
        if(_popupsCount > 0) for (name in popups) RemovePopupFromStage(name);
    }

    //==================================================================================================
    private function Notification_HidePopup( popupName:String, force : Bool ) : Void {
    //==================================================================================================
        var popup : Popup = this.GetPopupByName(popupName);
        if (popup) {
            if(force) RemovePopupFromStage(popup.name);
            else popup.hide(RemovePopupFromStage);
        }
    }

    //==================================================================================================
    private function AddPopupToStageAndShow( value : DisplayObject ) : Void {
    //==================================================================================================
        SetupListeners(value);
        this.send( ApplicationNotification.ADD_ELEMENT, value );
        this.send( ApplicationNotification.POPUP_OPENED, _popupsCount, Popup(value).name );
        Popup(value).show();
    }

    //==================================================================================================
    private function Handle_ClosePopup( e : Event ) : Void {
    //==================================================================================================
        var popup : Popup = Popup(e.currentTarget);
        popup.hide(function(popupname:String){ return function(){ RemovePopupFromStage(popupname)} }(popup.name));
    }

    //==================================================================================================
    private function Handle_CommandFromPopup( e : Event, data : Dynamic) : Void {
    //==================================================================================================
        var popup		: Popup = Popup(e.currentTarget);
        var command	    : String = popup.command;
        trace("> Handle_CommandFromPopup:", popup.name, "command = ", command);
        if(command) {
            if(facade.hasCommand(command)){
                this.exec( command, data );
            } else this.send( command, data );
        }
    }

    //==================================================================================================
    private function AddPopup( popup : Popup ) : Void {
    //==================================================================================================
        var counter:Int = _popupsCount;
        var tempPopup:Popup;
        var order:Int = popup.getOrder();
        while(counter--) {
            tempPopup = _popupsQueue[counter];
            if(order >= tempPopup.getOrder()){
                popup.localIndex = counter + 1;
                break;
            }
        }

        _popupsQueue.insert(popup.localIndex, popup);
        _popupsCount++;

        var popups:Map<String, IPopup> = cast getViewComponent();
        popups.set( popup.name, popup );
        if( popup.parent == null ) AddPopupToStageAndShow( popup );
        else popup.show();
    }

    //==================================================================================================
    private function SetupListeners( popup : DisplayObject ) : Void {
    //==================================================================================================
        trace("> SetupListeners");
        popup.addEventListener(PopupEvents.COMMAND_FROM_POPUP, Handle_CommandFromPopup);

        popup.addEventListener(PopupEvents.POPUP_SHOWN, 		Handle_PopupShown);
        popup.addEventListener(PopupEvents.TAP_HAPPEND_OK, 		Handle_ClosePopup);
        popup.addEventListener(PopupEvents.TAP_HAPPEND_CLOSE, 	Handle_ClosePopup);
    }

    //==================================================================================================
    private function RemoveListeners( popup : DisplayObject ) : Void {
    //==================================================================================================
        if(!popup.hasEventListener(PopupEvents.COMMAND_FROM_POPUP)) return;
        popup.removeEventListener(PopupEvents.COMMAND_FROM_POPUP, Handle_CommandFromPopup);

        popup.removeEventListener(PopupEvents.TAP_HAPPEND_OK, 	Handle_ClosePopup);
        popup.removeEventListener(PopupEvents.TAP_HAPPEND_CLOSE, Handle_ClosePopup);
    }

    //==================================================================================================
    private function GetPopupByName( ?name : String ) : Popup {
    //==================================================================================================
        var popups:Map<String, IPopup> = cast getViewComponent();
        if(name == null) name = _popupsQueue[ _popupsCount - 1 ].name;
        return popups.get( name );
    }

    //==================================================================================================
    private function RemovePopupByName( name : String ) : Void {
    //==================================================================================================
        var popups:Map<String, IPopup> = cast getViewComponent();
        var popup:Popup = popups.get(name);
        _popupsQueue.remove(popup);
        popups.remove( name );
        popup.localIndex = 0;
        _popupsCount--;
    }
}
