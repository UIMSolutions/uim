module uim.errors.classes.middlewares.middleware;

import uim.errors;

@safe:

class DErrorMiddleware : UIMObject, IErrorMiddleware {
    this(Json[string] initData = null) {
        super(initData);
    }
}
