package app.model.vo;
class UserVO
{
    public function new() {}

    public var uuid				: String;
    public var firstname		: String = "FirstName";
    public var lastname			: String = "LastName";

    public var score			: Int = 0;
    public var playtime			: Int = 0;
    public var lastplaytime		: Int = 0;

    public var os				: String = "";
    public var lng				: String = "";
    public var version			: String = "";
    public var registered		: Bool = false;
}
