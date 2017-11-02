package nest.entities.screen;

import nest.patterns.proxy.Proxy;

class ScreensProxy extends Proxy
{
    public var currentScreenCache(default, default):ScreenCache;

    //==================================================================================================
    override public function onRegister() : Void {
    //==================================================================================================
        this.setData( new Map<String, ScreenCache>() );
    }

    //==================================================================================================
    public function cacheScreenByName( name : String, value : ScreenCache ) : Void {
    //==================================================================================================
        var cache:Map<String, ScreenCache> = cast this.getData();
        cache.set( name, value);
    }

    //==================================================================================================
    public function getCacheByScreenName( value : String ) : ScreenCache {
    //==================================================================================================
        var cache:Map<String, ScreenCache> = cast this.getData();
        return cast cache.get(value);
    }

    //==================================================================================================
    public function getScreenByName( value : String ) : Screen {
    //==================================================================================================
        return this.getCacheByScreenName(value).screen;
    }

    //==================================================================================================
    public function getFirstCachedScreen() : ScreenCache {
    //==================================================================================================
        var result:ScreenCache;
        var cache:Map<String, ScreenCache> = cast this.getData();
        var name:String = cache.keys().next();
        result = cast cache.get(name);
        return result;
    }

    //==================================================================================================
    public function getCurrentScreenName() : String { return currentScreenCache.name; 	}
    //==================================================================================================


}
