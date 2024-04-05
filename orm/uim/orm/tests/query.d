module uim.orm.tests.query;

import uim.orm;

@safe:

bool testQuery(IQuery queryToTest) {
    assert(queryToTest !is null, "In testQuery: queryToTest is null");
    
    return true;
}