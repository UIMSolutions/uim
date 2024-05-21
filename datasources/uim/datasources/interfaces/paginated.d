module uim.datasources.interfaces.paginated;

import uim.datasources;

@safe:

// This interface describes the methods for pagination instance.
interface IPaginated { // : Countable, Traversable {
    // Get current page number.
    int currentPage();

    // Get items per page.
    int perPage();

    // Get Total items counts.
    int totalCount();

    // Get total page count.
    int pageCount();

    // Get whether there`s a previous page.
    bool hasPrevPage();

    // Get whether there`s a next page.
    bool hasNextPage();

    // Get paginated items.
    Json[string] items();

    // Get paging param.
    Json[string] pagingParam(string aName);

    // Get all paging params.
    Json[string] pagingData();
}
