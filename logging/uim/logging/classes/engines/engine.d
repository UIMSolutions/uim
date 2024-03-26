module uim.logging.classes.engines.engine;

import uim.logging;

@safe:
// Base log engine class.
class DLogEngine : ILogEngine {
    mixin TConfigurable!();

    this() {
        initialize;
        this.name("LogEngine");  
    }

    this(IData[string] initData) {
        this.initialize(initData);
        this.name("LogEngine");  
    }

    this(string name) { 
        this(); 
        this.name(name); 
    }

    bool initialize(IData[string] initData = null) {
        configuration(MemoryConfiguration);
        setConfigurationData(initData);
        
        return true;
    }

  mixin(TProperty!("ILogFormatter", "formatter"));
  mixin(TProperty!("string", "name"));
  mixin(TProperty!("string", "className"));
}
