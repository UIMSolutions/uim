/*********************************************************************************************************
	Copyright: © 2015-2024 Ozan Nurettin Süel (UIManufaktur)                                        
	License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
	Authors: Ozan Nurettin Süel (UIManufaktur)                                                      
**********************************************************************************************************/
module uim.models.interfaces.element;

import uim.models;
@safe:

interface IElement {
	// Read data from STRINGAA
  void readFromStringAA(STRINGAA reqParameters, bool usePrefix = false);

  // Read data from request
  void readFromRequest(STRINGAA requestValues, bool usePrefix = true);
}