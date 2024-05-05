module uim.datasources.interfaces.paginator;

import uim.datasources;

@safe:

// This interface describes the methods for paginator instance.
interface IPaginator {
    // TODO
    /**
     * Handles pagination of data.
     * Params:
     * Json target Anything that needs to be paginated.
     * @param Json[string] params Request params.
     * @param Json[string] settings The settings/configuration used for pagination.
     * /
IResultset paginate(object  object, Json[string] myParams = null, 
    array settings = null);

    /**
     * Get paging params after pagination operation.
     * @return array
     * /
    array getPagingParams(); */
}
