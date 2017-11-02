package nest.modules.pipes.plumbing;

import nest.modules.pipes.messages.Message;

/**
 * Filter Control Message.
 * <P>
 * A special message type for controlling the behavior of a Filter.</P>
 * <P>
 * The <code>FilterControlMessage.SET_PARAMS</code> message type tells the Filter
 * to retrieve the filter parameters object.</P>
 *
 * <P>
 * The <code>FilterControlMessage.SET_FILTER</code> message type tells the Filter
 * to retrieve the filter function.</P>
 *
 * <P>
 * The <code>FilterControlMessage.BYPASS</code> message type tells the Filter
 * that it should go into Bypass mode operation, passing all normal
 * messages through unfiltered.</P>
 *
 * <P>
 * The <code>FilterControlMessage.FILTER</code> message type tells the Filter
 * that it should go into Filtering mode operation, filtering all
 * normal normal messages before writing out. This is the default
 * mode of operation and so this message type need only be sent to
 * cancel a previous  <code>FilterControlMessage.BYPASS</code> message.</P>
 *
 * <P>
 * The Filter only acts on a control message if it is targeted
 * to this named filter instance. Otherwise it writes the message
 * through to its output unchanged.</P>
 */
class FilterControlMessage extends Message
{
    private static var BASE(default, never)		    : String  	= Message.BASE+'filter-control/';

    public static var SET_PARAMS(default, never)	: String = BASE+'setparams';
    public static var SET_FILTER(default, never)	: String = BASE+'setfilter';
    public static var BYPASS(default, never)		: String = BASE+'bypass';
    public static var FILTER(default, never)		: String = BASE+'filter';

    // Constructor
    public function new(
        type : String,
        name : String,
        ?filter : Dynamic->Void,
        ?params : Dynamic )
    {
        super( type );
        setName( name );
        if(filter != null) setFilter( filter );
        if(params != null) setParams( params );
    }

    /**
     * Set the target filter name.
     */
    public function setName( name:String ) : Void { this.name = name; }

    /**
     * Get the target filter name.
     */
    public function getName( ):String { return this.name; }

    /**
     * Set the filter function.
     */
    public function setFilter( value : Dynamic->Void ): Void { this.filter = value; }

    /**
     * Get the filter function.
     */
    public function getFilter( ) : Dynamic->Void { return this.filter; }

    /**
     * Set the parameters object.
     */
    public function setParams( params : Dynamic ): Void { this.params = params; }

    /**
     * Get the parameters object.
     */
    public function getParams( ) : Dynamic { return this.params; }

    private var params  : Dynamic;
    private var filter  : Dynamic->Void;
    private var name    : String;
}
