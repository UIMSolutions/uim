module uim.routings.mixins.plugin;

import uim.routings;
@safe: 

string routingPluginThis(string name = null) {
    string fullName = name ~ "RoutingPlugin";
    return objThis(fullName);
}

template RoutingPluginThis(string name = null) {
    const char[] RoutingPluginThis = routingPluginThis(name);
}

string routingPluginCalls(string name) {
    string fullName = name ~ "RoutingPlugin";
    return objCalls(fullName);
}

template RoutingPluginCalls(string name) {
    const char[] RoutingPluginCalls = routingPluginCalls(name);
}
