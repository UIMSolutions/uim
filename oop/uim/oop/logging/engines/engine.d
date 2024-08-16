module uim.oop.logging.engines.engine;

import uim.oop;

@safe:
// Base log engine class.
class DLogEngine : ILogEngine {
    mixin TConfigurable;

    this() {
        initialize;
        this.name("LogEngine");  
    }

    this(Json[string] initData) {
        this.initialize(initData);
        this.name("LogEngine");  
    }

    this(string name) { 
        this(); 
        this.name(name); 
    }

    bool initialize(Json[string] initData = null) {
        configuration(MemoryConfiguration);
        configuration.data(initData);
        
        return true;
    }

  mixin(TProperty!("ILogFormatter", "formatter"));
  mixin(TProperty!("string", "name"));
  mixin(TProperty!("string", "classname"));
}
