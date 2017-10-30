package nest.patterns.observer;
import nest.interfaces.INotification;
class NFunction
{
    public var name	: String;
    public var func	: INotification->Void;

    public function new( name : String, func : INotification->Void ) {
        this.name = name;
        this.func = func;
    }

    public function clear() : Void {
        func = null;
        name = null;
    }
}
