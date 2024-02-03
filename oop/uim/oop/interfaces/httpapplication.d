module uim.oop.interfaces.httpapplication;

import uim.oop;

@safe:

// An interface defining the methods that the http server depend on.
interface IHttpApplication : IRequestHandler {
    // Load all the application configuration and bootstrap logic.
    void bootstrap();

    // Define the HTTP middleware layers for an application.
    MiddlewareQueue middleware(MiddlewareQueue middlewareQueue);
}
