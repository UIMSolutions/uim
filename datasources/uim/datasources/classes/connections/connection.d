module uim.datasources.classes.connections.connection;

import uim.datasources;

@safe:

class DDBConnection : IDataSourceConnection
{
      // Hook method
    bool initialize(IData[string] initData = null) {
        
        // configuration(MemoryConfiguration);
        // configurationData(initData);

        return true;
    }
  const string ROLE_WRITE = "write";

  const string ROLE_READ = "read";

}
