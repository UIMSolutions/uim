module uim.jsonbase.interfaces.tenant;

import uim.jsonbase;

@safe:
interface IJsonTenant {  
  string name();
  IJsonBase base();
}