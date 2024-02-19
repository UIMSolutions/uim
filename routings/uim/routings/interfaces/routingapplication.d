module source.uim.myname.interfaces.routingapplication;

import uim.routings;

@safe:

// Interface for applications that use routing.
interface IRoutingApplication {
    /**
     * Define the routes for an application.
     *
     * Use the provided RouteBuilder to define an application"s routing.
     * Params:
     * \UIM\Routing\RouteBuilder myroutes A route builder to add routes into.
     */
    void routes(RouteBuilder myroutes);
}
