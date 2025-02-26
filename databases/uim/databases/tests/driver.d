module uim.databases.tests.driver;

import uim.databases;
@safe:

version (test_uim_databases) {
  unittest {
    writeln("-----  ", __MODULE__, "\t  -----");
  }
}

bool testDBDriver(IDBDriver driver) {
    assert(driver !is null, "testDriver -> driver is null");
    
    return true;
}