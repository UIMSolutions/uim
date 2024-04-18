module uim.i18n.classes.middlewares.middleware;

import uim.i18n;

@safe:

class D18NMiddleware : II18NMiddleware {
    mixin TConfigurable;

    this() {
        initialize;
    }

    bool initialize(IData[string] initData = null) {
        configuration(MemoryConfiguration);
        configuration.data(initData);
        
        return true;
    }
}