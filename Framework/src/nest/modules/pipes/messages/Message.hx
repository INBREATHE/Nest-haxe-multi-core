package nest.modules.pipes.messages;

import nest.modules.pipes.interfaces.IPipeMessage;

class Message implements IPipeMessage {

    public static var INDEX	: Int = 0;

    public static var BASE(default, never)	    : String = "pipe-message/";
    public static var NORMAL(default, never) 	: String = BASE + "normal/";
    public static var WORKER(default, never) 	: String = BASE + "worker/";

    public var body			: Dynamic;
    public var header		: Dynamic;
    public var responseID	: Int;
    public var pipeID		: Int;
    public var messageType	: String;
    public var messageID	: String;

    public function new( messageType : String, ?header : Dynamic, ?body : Dynamic ) {
        setBody( body );
        setHeader( header );

        this.messageType = messageType;
        this.messageID = String(++INDEX);
    }

    public function getType() : String { return this.messageType; }

    public function getHeader() : Dynamic { return this.header; }
    public function setHeader( value : Dynamic ) : Void { this.header = value;	}

    public function getBody() : Dynamic { return body; }
    public function setBody( value : Dynamic ) : Void { this.body = value; }

    public function getPipeID() : Int { return this.pipeID; }
    public function setPipeID( value : Int ) : Void { this.pipeID = value; }

    public function getResponsePipeID() : Int { return this.responseID; }
    public function setResponsePipeID( value : Int ) : Void { this.responseID = value; }

    public function getMessageID():String { return this.messageID; }
}
