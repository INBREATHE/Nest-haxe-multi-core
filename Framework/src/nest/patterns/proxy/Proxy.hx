package nest.patterns.proxy;
import nest.patterns.observer.Notifier;
import nest.interfaces.IProxy;

class Proxy extends Notifier implements IProxy
{
    private var _data : Dynamic;
    private var _proxyName : String;

    public function new( ?data : Dynamic ) {
        trace(" > constructor: data = " + data);
        if ( data != null ) this.setData( data );
        _proxyName = Type.getClassName( Type.getClass(this) );
    }

    public function getProxyName() : String { return _proxyName; }
    public function setData     ( data : Dynamic ) : Void { _data = data; }
    public function getData     () : Dynamic { return _data; }

    public function onRegister  () : Void {}
    public function onRemove    () : Void {}
}
