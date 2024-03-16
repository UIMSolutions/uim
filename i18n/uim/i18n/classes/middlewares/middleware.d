module uim.i18n.classes.middlewares.middleware;

import uim.i18n;

@safe:

class D18NMiddleware : IMiddleware {
    mixin TConfigurable!();

    this() {
        initialize;
    }

    bool initialize(IData[string] initData = null) {
        configuration(MemoryConfiguration);
        setConfigurationData(initData);
        
        return true;
    }
}