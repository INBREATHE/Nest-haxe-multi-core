package nest.core;
import nest.interfaces.IProxy;
import nest.interfaces.IModel;

class Model implements IModel
{
    static private var MULTITON_MSG(default, never) : String = "Model instance for this Multiton key already constructed!";
    static private var instanceMap : Map<String, IModel> = new Map<String, IModel>();
    static public function getInstance( key:String ):IModel {
        if (instanceMap.exists( key )) return instanceMap.get( key );
        else return new Model( key );
    }

    private var _multitonKey : String;
    private var proxyMap(default, never) : Map<String, IProxy> = new Map<String, IProxy>();

    private function new( key : String ) {
        instanceMap.set( key, this );
        _multitonKey = key;
        initializeModel();
    }

    private function initializeModel() : Void {
        trace("-> initializeModel");
    }

    //==================================================================================================
    public function registerProxy	( proxyClass : Class<Dynamic> ) : Void {
    //==================================================================================================
        var proxyClassName:String = Type.getClassName( proxyClass );
        var proxy:IProxy = cast Type.createEmptyInstance( proxyClass );
        proxy.initializeNotifier( _multitonKey );
        proxyMap.set( proxyClassName, proxy );
        proxy.onRegister();
    }

    //==================================================================================================
    public function getProxy	( proxyClass : Class<Dynamic> )  : IProxy {
    //==================================================================================================
        var proxyClassName : String = Type.getClassName( proxyClass );
        return proxyMap.get( proxyClassName ) ;
    }

    //==================================================================================================
    public function removeProxy		( proxyClass : Class<Dynamic> ) 	: IProxy {
    //==================================================================================================
        var proxyClassName : String = Type.getClassName( proxyClass );
        if(proxyMap.exists( proxyClassName )) {
            var proxy:IProxy = proxyMap.get( proxyClassName );
            proxyMap.remove( proxyClassName );
            return proxy;
        }
        return null;
    }
    //==================================================================================================
    public function hasProxy		( proxyClass : Class<Dynamic> ) 	: Bool {
    //==================================================================================================
        var proxyClassName : String = Type.getClassName( proxyClass );
        return proxyMap.exists( proxyClassName );
    }
}
