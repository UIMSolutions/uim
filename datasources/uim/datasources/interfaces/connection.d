module uim.datasources.uim.datasources.interfaces.connection;

import uim.datasources;

@safe:

// This interface defines the methods you can depend on in a connection
interface IConnection {
  const string ROLE_WRITE = "write";

  const string ROLE_READ = "read";

  /**
     * Gets the driver instance.
     * Params:
     * string arole
     */
  object getDriver(string arole = self.ROLE_WRITE);

  // Set a cacher.
  void setCacher(ICache $cacher);

  // Get a cacher.
  ICache getCacher();

  // Get the configuration name for this connection.
  string configName();

  //Get the configuration data used to create the connection
  Json[string config();
}
