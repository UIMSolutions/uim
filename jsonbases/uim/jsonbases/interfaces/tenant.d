module uim.jsonbases.interfaces.tenant;

import uim.jsonbases;

@safe:
interface IJsonTenant {  
  string name();
  IJsonBase base();
}