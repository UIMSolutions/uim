module uim.orm.interfaces.association;

import uim.orm;

@safe:

interface IAssociation : INamed {
    void sourceTable(ITable newTable);
    ITable sourceTable();
}