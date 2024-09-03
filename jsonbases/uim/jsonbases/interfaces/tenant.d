module uim.jsonbases.interfaces.tenant;

import uim.jsonbases;

@safe:
interface IJsonTenant : INamed {  
  IJsonBase base();
}