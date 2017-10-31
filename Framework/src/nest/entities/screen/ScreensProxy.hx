package nest.entities.screen;

import nest.patterns.proxy.Proxy;

class ScreensProxy extends Proxy {

    public var currentScreen(default, default):ScreenCache;

    public function new() { super(new Map<String, ScreenCache>()); }

    //==================================================================================================
    public function cacheScreenByName(name:String, value:ScreenCache):void {
    //==================================================================================================
        var cache:Map<String, ScreenCache> = cast this.getData();
        cache.set( name, value);
    }

    //==================================================================================================
    public function getCacheByScreenName(value:String):ScreenCache {
    //==================================================================================================
        var cache:Map<String, ScreenCache> = cast this.getData();
        return cast cache.get(value);
    }

    //==================================================================================================
    public function getScreenByName(value:String):Screen {
    //==================================================================================================
        return this.getCacheByScreenName(value).screen;
    }

    //==================================================================================================
    public function getFirstCachedScreen():ScreenCache {
    //==================================================================================================
        var result:ScreenCache;
        var cache:Map<String, ScreenCache> = cast this.getData();
        for (cachedScreenNames in cache) {
            result = cache[cachedScreenNames];
            break;
        }
        return result;
    }

    //==================================================================================================
    public function getCurrentScreenName():String { return _currentScreen.name; 	}
    //==================================================================================================


}
