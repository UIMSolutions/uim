/*********************************************************************************************************
	Copyright: © 2015-2024 Ozan Nurettin Süel (UIManufaktur)                                        
	License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
	Authors: Ozan Nurettin Süel (UIManufaktur)                                                      
**********************************************************************************************************/
module uim.datasources.interfaces.locator;

import uim.datasources;

@safe:
// Registries for repository objects should implement this interface.
interface ILocator {
    // Get a repository instance from the registry.
    IRepository get(string aliasName, Json[string] buildData = null);

    // Set a repository instance.
    IRepository set(string aliasName, IRepository repository);

    // Check to see if an instance exists in the registry.
    bool exists(string aliasName);

    // Removes an repository instance from the registry.
    bool removeByKey(string aliasName);

    // Clears the registry of configuration and instances.
    void clear();
}
