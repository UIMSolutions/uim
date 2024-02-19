/*********************************************************************************************************
	Copyright: © 2015-2023 Ozan Nurettin Süel (Sicherheitsschmiede)                                        
	License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
	Authors: Ozan Nurettin Süel (Sicherheitsschmiede)                                                      
**********************************************************************************************************/
module uim.datasources.interfaces.locator;

import uim.datasources;

@safe:
// Registries for repository objects should implement this interface.
interface ILocator {
    /**
     * Get a repository instance from the registry.
     *
     * @param array<string, mixed> $options The options you want to build the table with.
     * @throws \RuntimeException When trying to get alias for which instance
     *   has already been created with different options.
     */
    IRepository get(string aliasName, STRINGAA someOptions = null);

    /**
     * Set a repository instance.
     *
     * @param uim.cake.Datasource\IRepository $repository The repository to set.
     */
    IRepository set(string aliasName, IRepository $repository);

    // Check to see if an instance exists in the registry.
    bool exists(string aliasName);

    // Removes an repository instance from the registry.
    void remove(string aliasName);

    // Clears the registry of configuration and instances.
    void clear();
}
