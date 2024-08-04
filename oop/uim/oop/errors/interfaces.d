/*********************************************************************************************************
	Copyright: © 2015-2024 Ozan Nurettin Süel (UIManufaktur)                                        
	License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
	Authors: Ozan Nurettin Süel (UIManufaktur)                                                      
**********************************************************************************************************/
module uim.oop.errors.interfaces;

import uim.oop;
@safe:

interface IError {
  size_t code();

  void message(string message);
  string message();

  string fileName();

  size_t lineNumber();

  size_t[string][] trace();
}