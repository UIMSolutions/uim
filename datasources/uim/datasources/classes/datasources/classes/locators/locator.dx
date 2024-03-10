module uim.datasources.locators.locator;

import uim.datasources;

@safe:

// Registries for repository objects should implement this interface.
interface ILocator {
  /**
     * Get a repository instance from the registry.
     * Params:
     * @param IData[string] optionData The options you want to build the table with.
     * @throws \RuntimeException When trying to get alias for which instance
     *  has already been created with different options.
     */
  IRepository get(string aliasName, IData[string] optionData = null);

  // Set a repository instance.
  IRepository set(string aliasName, IRepository repository);

  // Check to see if an instance exists in the registry.
  bool exists(string aliasName);

  // Removes an repository instance from the registry.
  void remove(string aliasName);

  // Clears the registry of configuration and instances.
  void clear();
}
