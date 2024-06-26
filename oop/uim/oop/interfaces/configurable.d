/*********************************************************************************************************
	Copyright: © 2015-2024 Ozan Nurettin Süel (UIManufaktur)                                        
	License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
	Authors: Ozan Nurettin Süel (UIManufaktur)                                                      
**********************************************************************************************************/
module uim.oop.interfaces.configurable;

import uim.oop;

@safe:

interface IConfigurable {
    // Gets configuration
    IConfiguration configuration();
    // Sets configuration
    void configuration(IConfiguration newConfiguration);

    /* 
    void setConfigurationData(Json newData); 

    void setConfigurationData(string key, Json newData); 
    */

    // TODO Json getConfigurationData(string key); 
}