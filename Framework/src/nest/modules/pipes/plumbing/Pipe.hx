package nest.modules.pipes.plumbing;

import nest.modules.pipes.interfaces.IPipeMessage;
import nest.modules.pipes.interfaces.IPipeFitting;

class Pipe implements IPipeFitting
{
    private static var serial : Float = 1;

    public static function newChannelID() : Int { return serial++; }

    public var chainLength : Int = 0;

    private var _channelID	: Int = 0;
    private var _pipeName	: String;

    private var output:IPipeFitting;

    public function new( channelID : Int )
    {
        _channelID = channelID;
    }

    /**
     * Connect another PipeFitting to the output.
     *
     * PipeFittings connect to and write to other
     * PipeFittings in a one-way, syncrhonous chain.</P>
     *
     * @return Boolean true if no other fitting was already connected.
     */
    public function connect( output : IPipeFitting ) : Bool
    {
        var success : Bool = false;
        if (this.output == null) {
            output.pipeName = this.pipeName;
            if(Std.is(output, Filter)) {
                output.channelID = this._channelID;
            }
            this.output = output;
            success = true;
            chainLength++;
        }
        return success;
    }

    /**
     * Disconnect the Pipe Fitting connected to the output.
     * <P>
     * This disconnects the output fitting, returning a
     * reference to it. If you were splicing another fitting
     * into a pipeline, you need to keep (at least briefly)
     * a reference to both sides of the pipeline in order to
     * connect them to the input and output of whatever
     * fiting that you're splicing in.</P>
     *
     * @return IPipeFitting the now disconnected output fitting
     */
    public function disconnect( ) : IPipeFitting
    {
        var disconnectedFitting:IPipeFitting = this.output;
        this.output = null;
        return disconnectedFitting;
    }

    /**
     * Write the message to the connected output.
     *
     * @param message the message to write
     * @return Boolean whether any connected downpipe outputs failed
     */
    public function write( message : IPipeMessage ) : Bool
    {
        return output && output.write( message );
    }

    public function getPipeName() : String { return _pipeName; }

    public function setPipeName( value : String ) : Void { _pipeName = value; }

    public function getChannelID() : Int { return _channelID; }

    public function setChannelID( value : Int ) : Void { _channelID = value; }

}
