module errors.uim.errors.classes.renderers.textexception;

import uim.errors;

@safe:

/**
 * Plain text exception rendering with a stack trace.
 *
 * Useful in CI or plain text environments.
 */
class TextExceptionRenderer : IExceptionRenderer {
    protected Throwable error;

    this(Throwable errorToRender) {
        this.error = error;
    }
    
    /**
     * Render an exception into a plain text message.
     */
    IResponse|string render() {
        return "%s : %s on line %s of %s\nTrace:\n%s".format(
            this.error.getCode(),
            this.error.getMessage(),
            this.error.getLine(),
            this.error.getFile(),
            this.error.getTraceAsString(),
        );
    }
    
    /**
     * Write output to stdout.
     * @param \Psr\Http\Message\IResponse|string aoutput The output to print.
     */
    void write(IResponse|string aoutput) {
        assert(isString(output));
        echo output;
    }
}
