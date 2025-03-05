/****************************************************************************************************************
* Copyright: © 2018-2025 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.oop.interfaces.httpapplication; 

import uim.oop;

@safe:

// An interface defining the methods that the http server depend on.
interface IHttpApplication /* : IRequestHandler */ {
    // Load all the application configuration and bootstrap logic.
    void bootstrap();

    // Define the HTTP middleware layers for an application.
    // TODO MiddlewareQueue middleware(MiddlewareQueue middlewareQueue);
}
