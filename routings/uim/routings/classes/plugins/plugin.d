module uim.routings.classes.plugins.plugin;

import uim.routings;

@safe:

class DRoutingPlugin : UIMObject, IRoutingPlugin {
    mixin(RoutingPluginThis!());

    override bool initialize(Json[string] initData = null) {
        if (!super.initialize(initData)) {
            return false;
        }

        return true;
    }
    
    // Do bootstrapping or not
    protected bool _bootstrapEnabled = true;

    // Console middleware
    protected bool _consoleEnabled = true;

    // Enable middleware
    protected bool _isMiddlewareEnabled = true;

    // Register container services
    protected bool _isServiceEnabled = true;

    // Load routes or not
    protected bool _routesEnabled = true;

    // The path to this plugin.
    protected string _path = null;

    // The class path for this plugin.
    protected string _classnamePath = null;

    // The config path for this plugin.
    protected string _configPath = null;

    // The templates path for this plugin.
    protected string _templatePath = null;
}
