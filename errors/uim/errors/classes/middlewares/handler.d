module uim.errors.classes.middlewares.handler;

import uim.errors;

@safe:

/**
 * Error handling middleware.
 *
 * Traps exceptions and converts them into HTML or content-type appropriate
 * error pages using the UIM ExceptionRenderer.
 */
class DErrorHandlerMiddleware : UIMObject, IErrorMiddleware {
    this(Json[string] initData = null) {
        super(initData);
    }
}
