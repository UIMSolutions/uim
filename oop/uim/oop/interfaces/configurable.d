/*********************************************************************************************************
	Copyright: © 2015-2024 Ozan Nurettin Süel (Sicherheitsschmiede)                                        
	License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
	Authors: Ozan Nurettin Süel (Sicherheitsschmiede)                                                      
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

    void setConfigurationData(string key, IData newData); 
    */

    // TODO IData getConfigurationData(string key); 
}