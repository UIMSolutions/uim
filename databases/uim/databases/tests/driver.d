module uim.databases.tests.driver;

import uim.commands;
@safe:

version (test_uim_commands) {
  unittest {
    writeln("-----  ", __MODULE__, "\t  -----");
  }
}

bool testDBDriver(IDBDriver driver) {
    assert(driver !is null, "testDriver -> driver is null");
    
    return true;
}