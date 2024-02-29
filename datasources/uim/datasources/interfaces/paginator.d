module uim.datasources.interfaces.paginator;

import uim.cake;

@safe:

// This interface describes the methods for paginator instance.
interface IPaginator {
    // TODO
    /**
     * Handles pagination of data.
     * Params:
     * Json target Anything that needs to be paginated.
     * @param array $params Request params.
     * @param array $settings The settings/configuration used for pagination.
     * /
IResultSet paginate(object $object, array myParams = null, 
    array $settings = null);

    /**
     * Get paging params after pagination operation.
     * @return array
     * /
    array getPagingParams(); */
}
