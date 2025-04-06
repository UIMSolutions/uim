/*********************************************************************************************************
	Copyright: © 2018-2025 Ozan Nurettin Süel (UIManufaktur)                                        
	License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
	Authors: Ozan Nurettin Süel (UIManufaktur)                                                      
**********************************************************************************************************/
module uim.datasources.interfaces.manager;

mixin(Version!"test_uim_datasources");

import uim.datasources;
@safe:

interface IConnectionManager {
    // Get the connection instance for the given name.
    IDatasourceConnection getConnection(string name = null);
    
    // Get the connection instance for the given name.
    IDatasourceConnection getConnection(string name, string role);
    
    // Get the connection instance for the given name.
    IDatasourceConnection getConnection(string name, string role, Json[string] initData);
}