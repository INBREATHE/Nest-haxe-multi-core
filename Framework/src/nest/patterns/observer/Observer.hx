package nest.patterns.observer;
import nest.interfaces.INotification;
import nest.interfaces.IObserver;

class Observer  implements IObserver
{
    private var _notify     : INotification->Void;
    private var _context    : Dynamic;

    public function new(
        notify : INotification->Void,
        context : Dynamic
    ) {
        _notify = notify;
        _context = context;
    }

    //==================================================================================================
    public function notifyObserver( notification : INotification ) : Void {
    //==================================================================================================
        _notify( notification );
    }

    //==================================================================================================
    public function compareNotifyContext( context : Dynamic ) : Bool {
    //==================================================================================================
        return context == this._context;
    }
}
