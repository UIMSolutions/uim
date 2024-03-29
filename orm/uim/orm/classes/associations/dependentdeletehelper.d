/*********************************************************************************************************
  Copyright: © 2015-2024 Ozan Nurettin Süel (Sicherheitsschmiede)                                        
  License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
  Authors: Ozan Nurettin Süel (Sicherheitsschmiede)                                                      
**********************************************************************************************************/
module uim.orm.classes.associations.dependentdeletehelper;

import uim.orm;

@safe:

/**
 * Helper class for cascading deletes in associations.
 *
 * @internal
 */
class DependentDeleteHelper {
    /**
     * Cascade a delete to remove dependent records.
     *
     * This method does nothing if the association is not dependent.
     *
     * anAssociation - The association callbacks are being cascaded on.
     * @param DORMDatasource\IEntity anEntity The entity that started the cascaded delete.
     * @param array<string, mixed> options The options for the original delete.
     * @return bool Success.
     * /
    bool cascadeDelete_(DORMAssociation anAssociation, IEntity anEntity, IData[string] optionData = null) {
        if (!anAssociation.getDependent()) {
            return true;
        }
        table = anAssociation.getTarget();
        /** @psalm-suppress InvalidArgument * /
        foreignKey = array_map([anAssociation, "aliasField"], (array)anAssociation.getForeignKeys());
        bindingKey = (array)anAssociation.getBindingKey();
        bindingValue = entity.extract(bindingKey);
        if (in_array(null, bindingValue, true)) {
            return true;
        }
        conditions = array_combine(foreignKey, bindingValue);

        if (anAssociation.getCascadeCallbacks()) {
            foreach (anAssociation.find().where(conditions).all().toList() as related) {
                success = table.delete_(related, options);
                if (!success) {
                    return false;
                }
            }

            return true;
        }

        anAssociation.deleteAll(conditions);

        return true;
    } */
}
