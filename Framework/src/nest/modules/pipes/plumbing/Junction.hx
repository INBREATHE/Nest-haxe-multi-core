package nest.modules.pipes.plumbing;

/**
	 * Pipe Junction.
	 *
	 * <P>
	 * Manages Pipes for a Module.
	 *
	 * <P>
	 * When you register a Pipe with a Junction, it is
	 * declared as being an INPUT pipe or an OUTPUT pipe.</P>
	 *
	 * <P>
	 * You can retrieve or remove a registered Pipe by name,
	 * check to see if a Pipe with a given name exists,or if
	 * it exists AND is an INPUT or an OUTPUT Pipe.</P>
	 *
	 * <P>
	 * You can send an <code>IPipeMessage</code> on a named INPUT Pipe
	 * or add a <code>PipeListener</code> to registered INPUT Pipe.</P>
	 */
import nest.modules.pipes.interfaces.IPipeMessage;
import nest.modules.pipes.interfaces.IPipeFitting;
class Junction
{
    /**
     *  INPUT Pipe Type
     */
    public static var INPUT(default, never) : String 	= 'input';
    /**
     *  OUTPUT Pipe Type
     */
    public static var OUTPUT(default, never) : String 	= 'output';

    // Constructor.
    public function new( ) {
        pipesMap = new Map<String, IPipeFitting>();
        pipeTypesMap = new Map<String, String>();
    }

    /**
     * Register a pipe with the junction.
     * <P>
     * Pipes are registered by unique name and type,
     * which must be either <code>Junction.INPUT</code>
     * or <code>Junction.OUTPUT</code>.</P>
     * <P>
     * NOTE: You cannot have an INPUT pipe and an OUTPUT
     * pipe registered with the same name. All pipe names
     * must be unique regardless of type.</P>
     *
     * @return Boolean true if successfully registered. false if another pipe exists by that name.
     */
    public function registerPipe( name : String, type : String, pipe : IPipeFitting ) : Bool
    {
        var success:Bool = true;
        if ( pipesMap.exists(name) == false )
        {
            pipe.setPipeName(name);
            pipesMap.set( name, pipe );
            pipeTypesMap.set( name, type );
            switch (type) {
                case INPUT: 	inputPipes.push(name);	 	break;
                case OUTPUT: 	outputPipes.push(name); 	break;
                default: success = false;
            }
        } else success = false;
        return success;
    }

    /**
     * Does this junction have a pipe by this name?
     *
     * @param name the pipe to check for
     * @return Boolean whether as pipe is registered with that name.
     */
    public function hasPipe( name : String ) : Bool
    {
        return pipesMap.exists( name );
    }

    /**
     * Does this junction have an INPUT pipe by this name?
     *
     * @param name the pipe to check for
     * @return Boolean whether an INPUT pipe is registered with that name.
     */
    public function hasInputPipe( name : String ) : Bool
    {
    return ( hasPipe(name) && ( pipeTypesMap.get(name) == INPUT ) );
    }

    /**
     * Does this junction have an OUTPUT pipe by this name?
     *
     * @param name the pipe to check for
     * @return Boolean whether an OUTPUT pipe is registered with that name.
     */
    public function hasOutputPipe( name : String ) : Bool
    {
        return ( hasPipe(name) && (pipeTypesMap.get(name) == OUTPUT) );
    }

    /**
     * Remove the pipe with this name if it is registered.
     * <P>
     * NOTE: You cannot have an INPUT pipe and an OUTPUT
     * pipe registered with the same name. All pipe names
     * must be unique regardless of type.</P>
     *
     * @param name the pipe to remove
     */
    public function removePipe( name : String ) : Void
    {
        if ( hasPipe(name) )
        {
            var type:String = pipeTypesMap.get(name);
            var pipesList:Array<String>;
            switch (type) {
                case INPUT: pipesList = inputPipes; break;
                case OUTPUT: pipesList = outputPipes; break;
            }
            var counter:Int = pipesList.length;
            var pipeName:String;
            while(counter--) {
                pipeName = pipesList[counter];
                if (pipeName == name){
                    pipesList.splice(counter, 1);
                    break;
                }
            }
            pipesMap.remove(name);
            pipeTypesMap.remove(name);
        }
    }

    /**
     * Retrieve the named pipe.
     *
     * @param name the pipe to retrieve
     * @return IPipeFitting the pipe registered by the given name if it exists
     */
    public function retrievePipe( name:String ):IPipeFitting
    {
        var original    : IPipeFitting = pipesMap.get(name);
        var result      : IPipeFitting = original;
        var isFilter    : Bool = Std.is(result, Filter);
        while(result != null && isFilter) {
            result = Filter(result).getOutput();
            isFilter = Std.is(result, Filter);
        }
        return result || original;
    }

    /**
     * Add a PipeListener to an INPUT pipe.
     * <P>
     * NOTE: there can only be one PipeListener per pipe,
     * and the listener function must accept an IPipeMessage
     * as its sole argument.</P>
     *
     * @param name the INPUT pipe to add a PipeListener to
     * @param context the calling context or 'this' object
     * @param listener the function on the context to call
     */
    public function addPipeListener( inputPipeName : String, context : Dynamic, listener : Dynamic->Void ) : Bool
    {
        var success:Bool = false;
        if ( hasPipe(inputPipeName) )
        {
            var pipe : IPipeFitting = pipesMap.get( inputPipeName );
            success = pipe.connect( new PipeListener(context, listener) );
        }
        return success;
    }

    /**
     * Send a message on an OUTPUT pipe.
     *
     * @param name the OUTPUT pipe to send the message on
     * @param message the IPipeMessage to send
     * @param individual message will be send only to pipe from where this message is comming from, by channelID
     */
    public function sendMessage(
        outputPipeName  : String,
        message         : IPipeMessage,
        isIndividual    : Bool = true
    ) : Bool {
        var success:Bool = false;
        var outputPipeExist : Bool = hasOutputPipe(outputPipeName);
        //			trace(">\tJunction.sendMessage: hasOutputPipe =", outputPipeExist );
        //			trace(">\tJunction.sendMessage: outputPipeName =", outputPipeName );
        if ( outputPipeExist )
        {
            var pipe : IPipeFitting = pipesMap.get( outputPipeName );
            if(isIndividual && !message.getPipeID()) message.setPipeID(pipe.getChannelID());
            {
//				trace(">\tJunction.sendMessage: message responsePipeID = " + message.getResponsePipeID(), "| pipeID = " + message.getPipeID() );
                success = pipe.write(message);
            }
        }
        return success;
    }

    /**
     * Send a message on an OUTPUT pipe.
     *
     * @param name the OUTPUT pipe to send the message on
     * @param message the IPipeMessage to send
     * @param individual message will be send only to pipe from where this message is comming from, by channelID
     */
    public function acceptMessage(
        inputPipeName   : String,
        message         : IPipeMessage,
        isIndividual    : Bool = true
    ) : Bool {
        var success : Bool = false;
        var checkInputPipe : Bool = hasInputPipe(inputPipeName);
//			trace(">\tJunction.sendMessage: hasInputPipe =", checkInputPipe );
//			trace(">\tJunction.sendMessage: inputPipeName =", inputPipeName );
//			trace(">\tJunction.sendMessage: message =", message );
        if ( checkInputPipe )
        {
            var pipe : IPipeFitting = pipesMap.get( inputPipeName );
            if(isIndividual && !message.getPipeID()) message.setPipeID(pipe.getChannelID());
            {
                success = pipe.write(message);
            }
        }
//			trace(">\tJunction.sendMessage: success =",success);
        return success;
    }

    /**
     *  The names of the INPUT pipes
     */
    private var inputPipes : Array<String> = [];

    /**
     *  The names of the OUTPUT pipes
     */
    private var outputPipes : Array<String> = [];

    /**
     * The map of pipe names to their pipes
     */
    private var pipesMap : Map<String, IPipeFitting>;

    /**
     * The map of pipe names to their types
     */
    private var pipeTypesMap : Map<String, String>;

}
