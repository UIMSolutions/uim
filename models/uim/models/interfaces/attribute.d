/*********************************************************************************************************
	Copyright: © 2015-2024 Ozan Nurettin Süel (UIManufaktur)                                        
	License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
	Authors: Ozan Nurettin Süel (UIManufaktur)                                                      
**********************************************************************************************************/
module uim.models.interfaces.attribute;

import uim.models;
@safe:

interface IAttribute {
	// Data formats of the attribute. 
  string[] dataFormats(); 

	// Check for data format
  bool hasDataFormat(string dataFormatName);
}
