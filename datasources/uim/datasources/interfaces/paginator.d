module uim.datasources.interfaces.paginator;

import uim.datasources;

@safe:

// This interface describes the methods for paginator instance.
interface IPaginator {
    //  Handles pagination of data.
    IResultset paginate(Json target, Json[string] requestData = null, Json[string] paginationData = null);

    // Get paging params after pagination operation.
    Json[string] pagingData();
}
