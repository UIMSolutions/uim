module uim.http.classes.middleware.middleware;

import uim.http;
@safe:

class DMiddleware : UIMObject, IMiddleware {
    mixin(MiddlewareThis!());
}