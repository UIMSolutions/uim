/*********************************************************************************************************
  Copyright: © 2015-2024 Ozan Nurettin Süel (UIManufaktur)                                        
  License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
  Authors: Ozan Nurettin Süel (UIManufaktur)                                                      
**********************************************************************************************************/
module uim.orm.classes.associations.dependentdeletehelper;

import uim.orm;

@safe:

/**
 * Helper class for cascading deletes in associations.
 *
 * @internal
 */
class DDependentDeleteHelper {
    /**
     * Cascade a delete to remove dependent records.
     *
     * This method does nothing if the association is not dependent.
     *
     * anAssociation - The association callbacks are being cascaded on.
     * @param DORMDatasource\IORMEntity anEntity The entity that started the cascaded delete.
     * @param Json[string] options The options for the original delete.
     */
    bool cascadeRemove(DORMAssociation anAssociation, IORMEntity anEntity, Json[string] options = null) {
        if (!anAssociation.getDependent()) {
            return true;
        }
        
        auto table = anAssociation.getTarget();
        /** @psalm-suppress InvalidArgument */
        auto foreignKey = array_map([anAssociation, "aliasField"], /* (array) */anAssociation.foreignKeys());
        auto bindingKey = /* (array) */anAssociation.getBindingKey();
        auto bindingValue = entity.extract(bindingKey);
        if (isIn(null, bindingValue, true)) {
            return true;
        }
        conditions = array_combine(foreignKey, bindingValue);

        if (anAssociation.getCascadeCallbacks()) {
            return anAssociation.find().where(conditions).all().toList().all!(related => table.remove(related, options));
        }

        anAssociation.deleteAll(conditions);

        return true;
    } 
}
