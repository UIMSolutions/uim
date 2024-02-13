module uim.jsonbases.interfaces.tenantmanager;

import uim.jsonbases;

@safe:
interface IJsonTenantManager {
  // Tenants
  bool hasTenants(string[] someNames...);
  bool hasTenants(string[] someNames = null);
  size_t countTenants(string[] someNames...);
  size_t countTenants(string[] someNames = null);
  string[] existingTenants(string[] someNames...);
  string[] existingTenants(string[] someNames = null);
  string[] tenantNames();
  IJsonTenant[] tenants();

  // Tenant
  bool hasTenant(string aName);
  IJsonTenant tenant(string aName);

  // Add tenants
  bool addTenants(IJsonTenant[] someTenants...);
  bool addTenants(IJsonTenant[] someTenants);
  bool addTenants(IJsonTenant[string] someTenants);

  // Add tenant
  bool addTenant(IJsonTenant aTenant);
  bool addTenant(string aName, IJsonTenant aTenant);

  // Create Tenants
  IJsonTenant[] createTenants(string[] someNames...);
  IJsonTenant[] createTenants(string[] someNames);

  IJsonTenant createTenant(string aName);

  // Delete
  bool deleteTenant(string aName);
}
