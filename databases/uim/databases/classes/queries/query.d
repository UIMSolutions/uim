module uim.databases.classes.queries.query;

import uim.databases;

@safe:

class DSQLQuery : UIMObject, ISQLQuery {
    mixin(SQLQueryThis!());
}