package nest.injector;
import haxe.rtti.Meta;
import nest.interfaces.IAcceptable;
import nest.interfaces.IInjectable;
import nest.interfaces.INotifier;

@:final class Injector
{

    static private var INJECT(default, never):String = "Inject";

    static private var _core_targets(default, never): Map<String, Dynamic> = new Map<String, Dynamic>();
    static private var _core_source(default, never): Map<String, Map<String, INotifier>> 	= new Map();

    //==================================================================================================
    static public function mapSource( key:String, source : INotifier ) : Void {
    //==================================================================================================
        var multitonKey   : String = source.getMultitonKey();
        var sourcesCore   : Map<String, INotifier> = _core_source[ multitonKey ];
        if(sourcesCore == null) {
            sourcesCore = new Map<String, INotifier>();
            _core_source[ multitonKey ] = sourcesCore;
        }
        trace("-> mapSource: key = " + key);
        sourcesCore[ key ] = source;
    }

    //==================================================================================================
    static public function mapTarget( target : IAcceptable, multitonKey : String ) : Void {
   //==================================================================================================
        var sourcesCore : Map<String, INotifier> = _core_source[ multitonKey ];
        var targetClass : Class<Dynamic> = Type.getClass(target);
        var metaData = Meta.getFields( targetClass );

        trace(metaData);
        trace(Reflect.fields(target));

        for (field in Reflect.fields(metaData)) {
            trace("-> mapTarget: field = " + field + " field = " + Type.getClass(Reflect.field(target, field)) + " " + Type.getClass(Reflect.getProperty(target, field)));
            trace("-> mapTarget: value = " + (Type.typeof(Reflect.field(target, field))));
        }
    }

    //==================================================================================================
    static public function mapInject( object : INotifier ) : Dynamic {
    //==================================================================================================
        var multitonKey : String = object.getMultitonKey();
        return null;
    }

    //==================================================================================================
    static public function injectTo( target : Dynamic, to : INotifier ) : Void {
    //==================================================================================================
    }

    //==================================================================================================
    static public function hasTarget( target : Dynamic, multitonKey : String ) : Bool {
    //==================================================================================================
        var targets : Dynamic = _core_targets[ multitonKey ];
        trace("\ttargets:", targets);
        return targets && !(targets[ target ] == null);
    }

    //==================================================================================================
    public static function unmapTarget( target : Dynamic, multitonKey : String ) : Void {
    //==================================================================================================
    }

    //==================================================================================================
    public static function unmapSource( name : String, multitonKey : String ) : Void {
    //==================================================================================================

    }
}