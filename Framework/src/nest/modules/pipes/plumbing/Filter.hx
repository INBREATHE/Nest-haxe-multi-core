package nest.modules.pipes.plumbing;

/**
 * Pipe Filter.
 * <P>
 * Filters may modify the contents of messages before writing them to
 * their output pipe fitting. They may also have their parameters and
 * filter function passed to them by control message, as well as having
 * their Bypass/Filter operation mode toggled via control message.</p>
 */
import nest.modules.pipes.messages.Message;
import nest.modules.pipes.interfaces.IPipeMessage;
import nest.modules.pipes.interfaces.IPipeFitting;
class Filter extends Pipe
{
    /**
     * Constructor.
     * <P>
     * Optionally connect the output and set the parameters.</P>
     */
    public function new(
        name : String,
        ?output : IPipeFitting,
        ?filter : Dynamic->Void,
        ?params : Dynamic )
    {
        var outputExist : Bool = output != null;
        super( outputExist ? output.getChannelID() : Pipe.newChannelID() );
        if(outputExist) this.connect(output);
        this.name = name;
        if ( filter != null ) setFilter( filter );
        if ( params != null ) setParams( params );
    }

    public function getOutput():IPipeFitting
    {
        return this.output;
    }

    /**
     * Handle the incoming message.
     * <P>
     * If message type is normal, filter the message (unless in BYPASS mode)
     * and write the result to the output pipe fitting if the filter
     * operation is successful.</P>
     *
     * <P>
     * The FilterControlMessage.SET_PARAMS message type tells the Filter
     * that the message class is FilterControlMessage, which it
     * casts the message to in order to retrieve the filter parameters
     * object if the message is addressed to this filter.</P>
     *
     * <P>
     * The FilterControlMessage.SET_FILTER message type tells the Filter
     * that the message class is FilterControlMessage, which it
     * casts the message to in order to retrieve the filter function.</P>
     *
     * <P>
     * The FilterControlMessage.BYPASS message type tells the Filter
     * that it should go into Bypass mode operation, passing all normal
     * messages through unfiltered.</P>
     *
     * <P>
     * The FilterControlMessage.FILTER message type tells the Filter
     * that it should go into Filtering mode operation, filtering all
     * normal normal messages before writing out. This is the default
     * mode of operation and so this message type need only be sent to
     * cancel a previous BYPASS message.</P>
     *
     * <P>
     * The Filter only acts on the control message if it is targeted
     * to this named filter instance. Otherwise it writes through to the
     * output.</P>
     *
     * @return Boolean True if the filter process does not throw an error and subsequent operations
     * in the pipeline succede.
     */
    override public function write( message : IPipeMessage ) : Bool
    {
        var outputMessage:IPipeMessage = message;
        var success:Bool = true;

//			trace("FILTER WRITE:", message.getType() == Message.NORMAL);
//			trace("\t\t : Mode:", mode === FilterControlMessage.FILTER);

        // Filter normal messages
        switch ( message.getType() )
        {
            case  Message.WORKER:
            case  Message.NORMAL:
                if ( mode == FilterControlMessage.FILTER ) {
                    outputMessage = applyFilter( message );
                }
//					trace("> FILTER\t\t : Output:", output);
//					trace("> FILTER\t\t : outputMessage:", JSON.stringify(outputMessage));
                success = output != null && outputMessage && output.write( outputMessage );

            // Accept parameters from control message
            case FilterControlMessage.SET_PARAMS:
                if (isTarget(message)) 					{
                    setParams( FilterControlMessage(message).getParams() );
                } else {
                    success = output.write( outputMessage );
                }

            // Accept filter function from control message
            case FilterControlMessage.SET_FILTER:
                if (isTarget(message)){
                    setFilter( FilterControlMessage(message).getFilter() );
                } else {
                    success = output.write( outputMessage );
                }

            // Toggle between Filter or Bypass operational modes
            case FilterControlMessage.BYPASS:
            case FilterControlMessage.FILTER:
                if (isTarget(message)){
                    mode = FilterControlMessage(message).getType();
                } else {
                    success = output.write( outputMessage );
                }
            // Write control messages for other fittings through
            default:
                success = output.write( outputMessage );
        }
        return success;
    }

    /**
     * Is the message directed at this filter instance?
     */
    private function isTarget( m : IPipeMessage ) : Bool
    {
        var filterMessage : FilterControlMessage = cast m;
        return ( filterMessage != null && m.getName() == this.name );
    }

    /**
     * Set the Filter parameters.
     * <P>
     * This can be an object can contain whatever arbitrary
     * properties and values your filter method requires to
     * operate.</P>
     *
     * @param params the parameters object
     */
    public function setParams( params : Dynamic ) : Void
    {
        this.params = params;
    }

    /**
     * Set the Filter function.
     * <P>
     * It must accept two arguments; an IPipeMessage,
     * and a parameter Object, which can contain whatever
     * arbitrary properties and values your filter method
     * requires.</P>
     *
     * @param filter the filter function.
     */
    public function setFilter( filter : Dynamic->Void ) : Void
    {
        this.filter = filter;
    }

    /**
     * Filter the message.
     */
    private function applyFilter( message:IPipeMessage ):IPipeMessage
    {
        return filter(message, params);
    }

    private var mode    : String = FilterControlMessage.FILTER;
    private var filter  : Dynamic->Void;// = function( message : IPipeMessage, ?params : Dynamic) return null;
    private var params  : Dynamic;
    private var name    : String;

}
