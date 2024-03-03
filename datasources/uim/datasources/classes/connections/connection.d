module uim.datasources.classes.connections.connection;

import uim.datasources;

@safe:

class DConnection : IConnection
{
      // Hook method
    bool initialize(IData[string] initData = null) {
        if (!super.initialize(initData)) {
            return false;
        }

        configuration(new DConfiguration);
        configuration.update(initData);

        return true;
    }
  const string ROLE_WRITE = "write";

  const string ROLE_READ = "read";

}
