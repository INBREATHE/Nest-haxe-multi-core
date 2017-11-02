package nest.modules.pipes;

import nest.modules.pipes.interfaces.IPipeMessage;
import nest.modules.pipes.plumbing.MergePipe;
import nest.modules.pipes.interfaces.IPipeFitting;
import nest.interfaces.INotification;
import nest.modules.pipes.plumbing.Junction;
import nest.patterns.mediator.Mediator;
/**
 * Junction Mediator.
 * <P>
 * A base class for handling the Pipe Junction in an IPipeAware
 * Core.</P>
 */
class JunctionMediator extends Mediator {

    /**
     * Accept input pipe notification name constant.
     */
    public static var ACCEPT_INPUT_PIPE(default, never):String 	= 'acceptInputPipe';

    /**
     * Accept output pipe notification name constant.
     */
    public static var ACCEPT_OUTPUT_PIPE(default, never):String 	= 'acceptOutputPipe';

    public function new( component : Junction )
    {
        super( component );
    }
    /**
     * List Notification Interests.
     * <P>
     * Returns the notification interests for this base class.
     * Override in subclass and call <code>super.listNotificationInterests</code>
     * to get this list, then add any sublcass interests to
     * the array before returning.</P>
     */
    //==================================================================================================
    override public function listNotificationInterests() : Array<String> {
    //==================================================================================================
        return [
            JunctionMediator.ACCEPT_INPUT_PIPE,
            JunctionMediator.ACCEPT_OUTPUT_PIPE
        ];
    }
    /**
     * Handle Notification.
     * <P>
     * This provides the handling for common junction activities. It
     * accepts input and output pipes in response to <code>IPipeAware</code>
     * interface calls.</P>
     * <P>
     * Override in subclass, and call <code>super.handleNotification</code>
     * if none of the subclass-specific notification names are matched.</P>
     */
    override public function handleNotification( note : INotification ) : Void
    {
        var connectionChannel	: String = note.getType();
        var pipeToConnect		: IPipeFitting = cast note.getBody();
        var junction            : Junction = cast getViewComponent();
        trace("\n> Nest -> JunctionMediator:", this, connectionChannel, pipeToConnect);

        switch( note.getName() )
        {
            // accept an input pipe
            // register the pipe and if successful
            // set this mediator as its listener
            case JunctionMediator.ACCEPT_INPUT_PIPE:
                trace("\t\t : ACCEPT_INPUT_PIPE channel:", connectionChannel);
                trace("\t\t : hasInputPipe =", junction.hasInputPipe(connectionChannel));
                if(junction.hasInputPipe(connectionChannel))
                {
                    MergePipeToInputChannel(pipeToConnect, connectionChannel);
                }
                else if(junction.registerPipe(connectionChannel, Junction.INPUT, pipeToConnect))
                {
                    junction.addPipeListener(connectionChannel, this, handlePipeMessage);
                }
            // accept an output pipe
            case JunctionMediator.ACCEPT_OUTPUT_PIPE:
                trace("\t\t : ACCEPT_OUTPUT_PIPE channel =", connectionChannel);
                trace("\t\t : hasInputPipe =", junction.hasOutputPipe(connectionChannel));
                if(junction.hasOutputPipe(connectionChannel))
                {
                    AddPipeToOutputChannel(pipeToConnect, connectionChannel);
                }
                else
                {
                    junction.registerPipe( connectionChannel, Junction.OUTPUT, pipeToConnect );
                }
        }
    }

    private function AddPipeToOutputChannel( outputPipe : IPipeFitting, channelName : String ) : Void
    {
        var junction            : Junction = cast getViewComponent();
        var outputChannelPipe   : IPipeFitting = cast junction.retrievePipe(channelName);
        trace("\t\t : AddPipeToOutputChannel -> Connect =", outputChannelPipe, outputPipe);
        if(outputChannelPipe) {
            outputChannelPipe.connect(outputPipe);
//            trace("\t\t :", "PIPES COUNT:", outputChannelPipe.outputsCount());
        }
    }

    private function MergePipeToInputChannel( inputPipe : IPipeFitting, channelName : String ) : Void
    {
        var junction     : Junction = cast getViewComponent();
        var pipeForInput : MergePipe = cast junction.retrievePipe(channelName);

        trace("\t\t : MergeInputPipeWithTee -> Connect = " + pipeForInput + " " + inputPipe);
        if(pipeForInput) {
            pipeForInput.connectInput(inputPipe);
            trace("\t\t : CHAIN LENGTH: " + pipeForInput.chainLength);
        }
    }

    /**
     * Handle incoming pipe messages.
     * <P>
     * Override in subclass and handle messages appropriately for the module.</P>
     */
    public function handlePipeMessage( message : IPipeMessage ) : Void
    {
    }
}
