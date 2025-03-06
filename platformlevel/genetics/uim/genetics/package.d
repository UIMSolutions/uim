/*********************************************************************************************************
  Copyright: © 2018-2025 Ozan Nurettin Süel (UIManufaktur)                                        
  License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
  Authors: Ozan Nurettin Süel (UIManufaktur)                                                      
**********************************************************************************************************/
module uim.genetics;

mixin(ImportPhobos!());

public { // Required uim libraries 
  import uim.infralevel;
  import uim.models;
}

public { // uim.genetics packages
  import uim.genetics.classes;
  import uim.genetics.collections;
  import uim.genetics.exceptions;
  import uim.genetics.factories;
  import uim.genetics.interfaces;
  import uim.genetics.helpers;
  import uim.genetics.mixins;
  import uim.genetics.registries;
  import uim.genetics.tests; 
}
