module uim.datasources.interfaces.paginator;

mixin(Version!"test_uim_datasources");

import uim.datasources;
@safe:

    // This interface describes the methods for paginator instance.
interface IDatasourcePaginator : IObject {
    //  Handles pagination of data.
/*     IDatasourceResultset paginate(Json target, Json[string] requestData = null, Json[string] paginationData = null);

    // Get paging params after pagination operation.
    Json[string] pagingData(); */
}