package nest.modules.pipes.plumbing;

import nest.modules.pipes.interfaces.IPipeMessage;
import nest.modules.pipes.interfaces.IPipeFitting;

/**
 * Pipe Listener.
 * <P>
 * Allows a class that does not implement <code>IPipeFitting</code> to
 * be the final recipient of the messages in a pipeline.</P>
 *
 * @see Junction
 */
class PipeListener implements IPipeFitting
{
    private var context : Dynamic;
    private var listener : Dynamic->Void;
    private var _pipeName : String;
    private var _id : Int = Pipe.newChannelID();

    public function new( context : Dynamic, listener : Dynamic->Void  )
    {
        this.context = context;
        this.listener = listener;
    }

    /**
     *  Can't connect anything beyond this.
     */
    public function connect( output : IPipeFitting ) : Bool
    {
        return false;
    }

    /**
     *  Can't disconnect since you can't connect, either.
     */
    public function disconnect():IPipeFitting
    {
        return null;
    }

    // Write the message to the listener
    public function write( message : IPipeMessage ) : Bool
    {
        listener.apply(context,[message]);
        return true;
    }

    public function getPipeName() : String { return _pipeName; }
    public function setPipeName( value : String) : Void { _pipeName = value; }

    public function getChannelID() : Int { return _id; }
    public function setChannelID( value : Int) : Void { _id = value; }
}
