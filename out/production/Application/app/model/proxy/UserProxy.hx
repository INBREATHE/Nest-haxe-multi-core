package app.model.proxy;

import app.model.vo.UserVO;
import nest.patterns.proxy.Proxy;

class UserProxy extends Proxy
{
    static public var NAME(default, never):String = "UserProxy";

    public function new() {
        super(new UserVO());
    }

    override public function getProxyName() : String { return NAME; }
    override public function onRegister() : Void {
        trace("-> onRegister");
    }

//    public function setUser(value:UserVO):void {
//        if(user == null && value) _database.store(Tables.USER, value);
//        setData(value);
//    }
//    public function getUser():UserVO { return user; }
}
