module uim.databases.classes.statements.statement;

import uim.databases;

@safe:

class DDBStatement {
        // Hook method
    bool initialize(IData[string] initData = null) {
        if (!super.initialize(initData)) {
            return false;
        }

        configuration(new DConfiguration);
        configuration.update(initData);

        return true;
    }
}