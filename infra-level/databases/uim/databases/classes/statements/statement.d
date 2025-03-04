module uim.databases.classes.statements.statement;

import uim.databases;

@safe:

class DStatement : UIMObject, IStatement {
    mixin(StatementThis!());
}