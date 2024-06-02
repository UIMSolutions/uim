/*********************************************************************************************************
	Copyright: © 2015-2024 Ozan Nurettin Süel (UIManufaktur)                                        
	License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
	Authors: Ozan Nurettin Süel (UIManufaktur)                                                      
**********************************************************************************************************/
module uim.oop.interfaces.error;

import uim.oop;
@safe:

interface IError {
  int code();

  void message(string message);
  string message();

  string file();

  int line();

  int[string][] trace();
}