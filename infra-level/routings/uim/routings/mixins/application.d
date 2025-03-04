module uim.routings.mixins.application;

import uim.routings;
@safe: 

string routingApplicationThis(string name = null) {
    string fullName = name ~ "RoutingApplication";
    return objThis(fullName);
}

template RoutingApplicationThis(string name = null) {
    const char[] RoutingApplicationThis = routingApplicationThis(name);
}

string routingApplicationCalls(string name) {
    string fullName = name ~ "RoutingApplication";
    return objCalls(fullName);
}

template RoutingApplicationCalls(string name) {
    const char[] RoutingApplicationCalls = routingApplicationCalls(name);
}
