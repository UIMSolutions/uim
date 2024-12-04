module uim.orm.classes.associations.association;

import uim.orm;
@safe:

class DORMAssociation : UIMObject, IORMAssociation {
    mixin(AssociationThis!());
}