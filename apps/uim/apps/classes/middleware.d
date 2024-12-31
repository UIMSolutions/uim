/****************************************************************************************************************
* Copyright: © 2017-2024 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.apps.classes.middleware;

import uim.apps;

@safe:

/**
 * Base class for standalone HTTP applications
 *
 * Provides a base class to inherit from for applications using
 * only the http package. This class defines a fallback handler
 * that renders a simple 404 response.
 *
 * You can overload the `handle` method to provide your own logic
 * to run when no middleware generates a response.
 */
class DMiddlewareApplication : UIMObject { // }: IHttpApplication {
    /* 
    abstract void bootstrap();

    abstract DMiddlewareQueue middleware(MiddlewareQueue aMiddlewareQueue);

    // Generate a 404 response as no middleware handled the request.
    IResponse handle(IServerRequest serverRequest) {
        return new DResponse(["body": 'Not found", "status": 404]);
    } */
}
