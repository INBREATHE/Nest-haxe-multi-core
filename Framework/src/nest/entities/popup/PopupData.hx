package nest.entities.popup;

class PopupData
{
    public var data(default, null)      : Dynamic;
    public var onAdded(default, null)	: Dynamic->Void;
    public var onRemoved(default, null) : Dynamic->Void;
    public var onShown(default, null)	: Dynamic->Void;

    public function new(data:Dynamic = null) {
        this.data = data;
    }

    public function onPopupAdded( callback : Dynamic->Void ) : PopupData {
        this.onAdded = callback;
        return this;
    }

    public function onPopupShown( callback : Dynamic->Void ) : PopupData {
        this.onShown = callback;
        return this;
    }

    public function onPopupRemoved( callback : Dynamic->Void ) : PopupData {
        this.onRemoved = callback;
        return this;
    }
}
