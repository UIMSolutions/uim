module uim.orm.classes.associations.association;

import uim.orm;
@safe:

version (test_uim_orm) {
  unittest {
    writeln("-----  ", __MODULE__, "\t  -----");
  }
}

class DORMAssociation : UIMObject, IORMAssociation {
    mixin(ORMAssociationThis!());
}