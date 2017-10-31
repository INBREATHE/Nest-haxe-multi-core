package nest.injector;

import haxe.rtti.Meta;

#if !macro @:build(nest.injector.InjectorMacro.findInjectMetadata()) #end
@:final class Injector
{
    static private var _multiton_sources(default, never): Map<String, Map<String, Dynamic>> 	= new Map<String, Map<String, Dynamic>>();
    static private var _multiton_targets(default, never): Map<String, Map<String, Map<String, String>>> = new Map<String, Map<String, Map<String, String>>>();

    //==================================================================================================
    static public function mapSource( source : Dynamic, multitonKey : String ) : Void {
    //==================================================================================================
        if(!_multiton_sources.exists( multitonKey )) _multiton_sources.set( multitonKey, new Map<String, Dynamic>());
        var sources : Map<String, Dynamic> = _multiton_sources.get( multitonKey );
        var key : String = Type.getClassName( Type.getClass( source ) );
        sources.set(key, source);
        trace("-> mapSource: at " + multitonKey + " -> " + key);
    }

    //==================================================================================================
    static public function mapTargetClass( classRef : Class<Dynamic>, multitonKey : String ) : Void {
    //==================================================================================================
        var classRefName:String = Type.getClassName(classRef);

        var meta = Meta.getType(classRef);
        var inject:Array<String> = cast meta.Inject;

        if(inject == null) return;

        if(!_multiton_targets.exists( multitonKey )) _multiton_targets.set( multitonKey, new Map<String, Map<String, String>>() );
        var targets : Map<String, Map<String, String>> = _multiton_targets.get( multitonKey );

        if(!targets.exists( classRefName )) targets.set( classRefName, new Map<String, String>() );
        var targetInjections:Map<String, String> = targets.get( classRefName );

        var fieldNameType:Array<String>;
        var fieldName:String;
        var fieldType:String;

        for(field in inject) {
            fieldNameType = field.split(":");
            fieldName = fieldNameType[0];
            fieldType = fieldNameType[1];
            targetInjections.set(fieldName, fieldType);
        }
    }

    //==================================================================================================
    static public function injectTo( target : Dynamic, multitonKey : String ) : Void {
    //==================================================================================================
        if(_multiton_sources.exists( multitonKey ) && _multiton_targets.exists( multitonKey ))
        {
            var sources : Map<String, Dynamic> = _multiton_sources.get( multitonKey );
            var targets : Map<String, Map<String, String>> = _multiton_targets.get( multitonKey );

            var classRefName:String = Type.getClassName(Type.getClass(target));

            if(targets.exists(classRefName))
            {
                var injectTargets:Map<String, String> = targets.get( classRefName );
                var sourceRef:String;
                for( fieldName in injectTargets.keys()) {
                    sourceRef = injectTargets.get(fieldName);
                    if( sources.exists(sourceRef) ) {
                        trace("injectTo " + target + "; field > name = " + fieldName + "; source = " + sourceRef);
                        Reflect.setField( target, fieldName, sources.get(sourceRef) );
                    }
                }
            }
        }
    }

    //==================================================================================================
    public static function clear( target : Dynamic, multitonKey : String ) : Void {
    //==================================================================================================
        if(_multiton_targets.exists( multitonKey ))
        {
            var targets : Map<String, Map<String, String>> = _multiton_targets.get( multitonKey );
            var classRefName:String = Type.getClassName(Type.getClass(target));
            if(targets.exists(classRefName))
            {
                var injectTargets:Map<String, String> = targets.get( classRefName );
                for( fieldName in injectTargets.keys()) {
                    Reflect.setField( target, fieldName, null );
                }
            }
        }
    }

    //==================================================================================================
    public static function unmapSource( name : String, multitonKey : String ) : Void {
    //==================================================================================================

    }
}