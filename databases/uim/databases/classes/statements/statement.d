module uim.databases.classes.statements.statement;

import uim.databases;

@safe:

class DDBStatement {
    mixin TConfigurable; 

        // Hook method
    bool initialize(Json[string] initData = null) {
        configuration(MemoryConfiguration);
        configuration.data(initData);

        return true;
    }
}