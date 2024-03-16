module uim.databases.classes.statements.statement;

import uim.databases;

@safe:

class DDBStatement {
    mixin TConfigurable!(); 

        // Hook method
    bool initialize(IData[string] initData = null) {
        configuration(MemoryConfiguration);
        setConfigurationData(initData);

        return true;
    }
}