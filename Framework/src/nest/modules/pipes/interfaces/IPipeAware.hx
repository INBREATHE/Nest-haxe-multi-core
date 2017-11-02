package nest.modules.pipes.interfaces;

/**
 * Pipe Aware interface.
 * <P>
 * Can be implemented by any PureMVC Core that wishes
 * to communicate with other Cores using the Pipes
 * utility.</P>
 */


interface IPipeAware {
    function acceptInputPipe( name : String, pipe : IPipeFitting ) : Void;
    function acceptOutputPipe( name : String, pipe : IPipeFitting ) : Void;
}
