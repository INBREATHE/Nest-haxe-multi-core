package nest.modules.pipes.interfaces;

/**
 * Pipe Message Interface.
 * <P>
 * <code>IPipeMessage</code>s are objects written into to a Pipeline,
 * composed of <code>IPipeFitting</code>s. The message is passed from
 * one fitting to the next in synchronous fashion.</P>
 * <P>
 */

interface IPipeMessage
{
    function getType():String;

    // Get the header of this message
    function getHeader() : Dynamic;

    // Set the header of this message
    function setHeader( header : Dynamic ) : Void;

    // Get the body of this message
    function getBody() : Dynamic;

    // Set the body of this message
    function setBody( body : Dynamic ) : Void;

    function getPipeID() : Int;
    function setPipeID( value : Int ) : Void;

    function getResponsePipeID() : Int;
    function setResponsePipeID( value : Int) : Void;

    function getMessageID() : String;
}
