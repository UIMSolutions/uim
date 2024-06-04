/*********************************************************************************************************
	Copyright: © 2015-2024 Ozan Nurettin Süel (UIManufaktur)                                        
	License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
	Authors: Ozan Nurettin Süel (UIManufaktur)                                                      
**********************************************************************************************************/
module uim.datasources.classes.pagings.paginators.paginator;

@safe:
import uim.datasources;

// This class is used to handle automatic model data pagination.
class DPaginator : IPaginator {
    mixin TConfigurable;

    this() {
        initialize;
    }

    this(Json[string] initData) {
        initialize(initData);
    }

    this(string name) {
        this().name(name);
    }

    // Hook method
    bool initialize(Json[string] initData = null) {
        configuration(MemoryConfiguration);
        configuration.data(initData);

        /**
        * Default pagination settings.
        *
        * When calling paginate() these settings will be merged with the configuration
        * you provide.
        *
        * - `maxLimit` - The maximum limit users can choose to view. Defaults to 100
        * - `limit` - The initial number of items per page. Defaults to 20.
        * - `page` - The starting page, defaults to 1.
        * - `allowedParameters` - A list of parameters users are allowed to set using request
        *  parameters. Modifying this list will allow users to have more influence
        *  over pagination, be careful with what you permit.
        *
        * @var Json[string]
        */
        configuration.updateDefaults([
            "page": Json(1),
            "limit": Json(20),
            "maxLimit": Json(100),
            // TODO "allowedParameters": Json.emptyArray(["limit", "sort", "page", "direction"]),
        ]);
    
        return true;
    }

    mixin(TProperty!("string", "name"));

    // Paging params after pagination operation is done.
    protected STRINGAA _pagingParams= null;

    /**
     * Handles automatic pagination of model records.
     *
     * ### Configuring pagination
     *
     * When calling `paginate()` you can use the settings parameter to pass in
     * pagination settings. These settings are used to build the queries made
     * and control other pagination settings.
     *
     * If your settings contain a key with the current table"s alias. The data
     * inside that key will be used. Otherwise the top level configuration will
     * be used.
     *
     * ```
     * settings = [
     *   "limit": 20,
     *   "maxLimit": 100
     * ];
     * myResults = paginator.paginate(myTable, settings);
     * ```
     *
     * The above settings will be used to paginate any repository. You can configure
     * repository specific settings by keying the settings with the repository alias.
     *
     * ```
     * settings = [
     *   "Articles": [
     *     "limit": 20,
     *     "maxLimit": 100
     *   ],
     *   "Comments": [... ]
     * ];
     * myResults = paginator.paginate(myTable, settings);
     * ```
     *
     * This would allow you to have different pagination settings for
     * `Articles` and `Comments` repositories.
     *
     * ### Controlling sort fields
     *
     * By default UIM will automatically allow sorting on any column on the
     * repository object being paginated. Often times you will want to allow
     * sorting on either associated columns or calculated fields. In these cases
     * you will need to define an allowed list of all the columns you wish to allow
     * sorting on. You can define the allowed sort fields in the `settings` parameter:
     *
     * ```
     * settings = [
     *  "Articles": [
     *    "finder": "custom",
     *    "sortableFields": ["title", "author_id", "comment_count"],
     *  ]
     * ];
     * ```
     *
     * Passing an empty array as sortableFields disallows sorting altogether.
     *
     * ### Paginating with custom finders
     *
     * You can paginate with any find type defined on your table using the
     * `finder` option.
     *
     * ```
     * settings = [
     *   "Articles": [
     *     "finder": "popular"
     *   ]
     * ];
     * myResults = paginator.paginate(myTable, settings);
     * ```
     *
     * Would paginate using the `find("popular")` method.
     *
     * You can also pass an already created instance of a query to this method:
     *
     * ```
     * myQuery = this.Articles.find("popular").matching("Tags", function (q) {
     *  return q.where(["name": "uimD"])
     * });
     * myResults = paginator.paginate(myQuery);
     * ```
     *
     * ### Scoping Request parameters
     *
     * By using request parameter scopes you can paginate multiple queries in
     * the same controller action:
     *
     * ```
     * articles = paginator.paginate(articlesQuery, ["scope": "articles"]);
     * tags = paginator.paginate(tagsQuery, ["scope": "tags"]);
     * ```
     *
     * Each of the above queries will use different query string parameter sets
     * for pagination data. An example URL paginating both results would be:
     *
     * ```
     use uim\ORM\Entity;dashboard?articles[page]=1&tags[page]=2
     * ```
     */
    IDSResultset paginate(Query objectToPaginate, Json[string] requestData = null, Json[string] paginationData = null) {
        myQuery = null;
        if (cast(IQuery)objectToPaginate  ) {
            myQuery = objectToPaginate;
            objectToPaginate = myQuery.getRepository();
            if (objectToPaginate == null) {
                throw new DDException("No repository set for query.");
            }
        }

        paginatorOptions = this.extractData(objectToPaginate, requestData, paginationData);
        myQuery = getQuery(objectToPaginate, myQuery, paginatorOptions);

        cleanQuery = clone myQuery;
        myResults = myQuery.all();
        paginatorOptions["numResults"] = count(myResults);
        paginatorOptions["count"] = getCount(cleanQuery, paginatorOptions);

        pagingParams = this.buildParams(paginatorOptions);
        aliasName = objectToPaginate.aliasName();
        _pagingParams = [aliasName: pagingParams];
        if (pagingParams["requestedPage"] > pagingParams["page"]) {
            throw new DPageOutOfBoundsException([
                "requestedPage": pagingParams["requestedPage"],
                "pagingParams": _pagingParams,
            ]);
        }

        return myResults;
    }

    // Get query for fetching paginated results.
    protected IDSQuery getQuery(IRepository repository, IQuery query, Json[string] myData) {
        if (query == null) {
            query = repository.find(myData["finder"], myData["options"]);
        } else {
            query.applyOptions(myData["options"]);
        }

        return query;
    }

    // Get total count of records.
    protected int getCount(IQuery query, Json[string] paginationData) {
        return query.count();
    }

    // Extract pagination data needed
    protected Json[string] extractData(IRepository repository, Json[string] requestData, Json[string] paginationData) {
        aliasName = repository.aliasName();
        defaults = getDefaults(aliasName, paginationData);
        options = mergeOptions(requestData, defaults);
        options = validateSort(anRepository, options);
        options = checkLimit(options);

        auto updatedOptions = options.update["page": 1, "scope": null];
        options["page"] = (int)options["page"] < 1 ? 1 : (int)options["page"];
        [myFinder, options] = _extractFinder(options);

        return compact("defaults", "options", "finder");
    }

    // Build pagination params.
    protected Json[string] buildParams(Json[string] paginatorOptions) {
        limit = myData["options.limit"];

        // containing keys "options",
        // "count", "defaults", "finder", "numResults".
        Json[string] paging = [
            "count": myData["count"],
            "current": myData["numResults"],
            "perPage": limit,
            "page": myData["options.page"],
            "requestedPage": myData["options.page"],
        ];

        paging = addPageCountParams(paging, paginatorOptions);
        paging = addStartEndParams(paging, paginatorOptions);
        paging = addPrevNextParams(paging, paginatorOptions);
        paging = addSortingParams(paging, paginatorOptions);

        paging += [
            "limit": paginatorOptions["defaults.limit"] != limit ? limit : null,
            "scope": paginatorOptions["options.scope"],
            "finder": paginatorOptions["finder"],
        ];

        return paging;
    }

    // Add "page" and "pageCount" params.
    protected Json[string] addPageCountParams(Json[string] pagingOptions, Json[string] paginatorOptions) {
        auto page = pagingOptions["page"];
        auto pageCount = 0;

        if (!pagingOptions.isNull("count")) {
            pageCount = max((int)ceil(pagingOptions["count"] / pagingOptions["perPage"]), 1);
            page = min(page, pageCount);
        } elseif (pagingOptions["current"] == 0 && pagingOptions["requestedPage"] > 1) {
            page = 1;
        }

        pagingOptions["page"] = page;
        pagingOptions["pageCount"] = pageCount;

        return pagingOptions;
    }

    /**
     * Add "start" and "end" params.
     *
     * @param Json[string] pagingOptions Paging params.
     * @param Json[string] myData Paginator data.
     */
    protected Json[string] addStartEndParams(Json[string] pagingOptions, Json[string] paginatorOptions) {
        start = end = 0;

        if (pagingOptions["current"] > 0) {
            start = ((pagingOptions["page"] - 1) * pagingOptions["perPage"]) + 1;
            end = start + pagingOptions["current"] - 1;
        }

        pagingOptions["start"] = start;
        pagingOptions["end"] = end;

        return pagingOptions;
    }

    // Add "prevPage" and "nextPage" params.
    protected Json[string] addPrevNextParams(Json[string] paginatorOptions, Json[string] pagingOptions) {
        paginatorOptions["prevPage"] = paginatorOptions["page"] > 1;
        paginatorOptions["nextPage"] = paginatorOptions["count"] == null
            ? true
            paginatorOptions["count"] > paginatorOptions["page"] * paginatorOptions["perPage"];

        return paginatorOptions;
    }

    // Add sorting / ordering params.
    protected Json[string] addSortingParams(Json[string] paginatorOptions, Json[string] pagingOptions) 
        auto defaults = pagingOptions["defaults"];
        auto order = /* (array) */pagingOptions["options.order"];
        bool sortDefault = directionDefault = false;

        if (!defaults.isEmpty("order")) && count(defaults["order"]) == 1) {
            sortDefault = key(defaults["order"]);
            directionDefault = current(defaults["order"]);
        }

        return paginatorOptions.update([
            "sort": pagingOptions["options.sort"],
            "direction": isset(pagingOptions["options.sort"]) && count(order) ? current(order) : null,
            "sortDefault": sortDefault,
            "directionDefault": directionDefault,
            "completeSort": order,
        ]);
    }

    // Extracts the finder name and options out of the provided pagination options.
    protected Json[string] _extractFinder(Json[string] paginationOptions) {
        auto myType = !paginationOptions.isEmpty("finder") ? paginationOptions["finder"] : "all";
        paginationOptions.remove("finder", paginationOptions["maxLimit"]);

        if (isArray(myType)) {
            paginationOptions = /* (array) */current(myType) + paginationOptions;
            myType = key(myType);
        }

        return [myType, paginationOptions];
    }

    // Get paging params after pagination operation.
    Json[string] pagingOptions() {
        return _pagingParams;
    }

    // Shim method for reading the deprecated whitelist or allowedParameters options
    protected string[] getAllowedParameters() {
        allowed = configuration.get("allowedParameters");
        if (!allowed) {
            allowed = null;
        }
        whitelist = configuration.get("whitelist");
        if (whitelist) {
            deprecationWarning("The `whitelist` option is deprecated. Use the `allowedParameters` option instead.");

            return array_merge(allowed, whitelist);
        }

        return allowed;
    }

    // Shim method for reading the deprecated sortWhitelist or sortableFields options.
    protected string[] getSortableFields(Json[string] configData) {
        auto allowed = configData.get("sortableFields");
        if (!allowed.isNull) {
            return allowed;
        }
        
        auto deprecatedMode = configData.get("sortWhitelist");
        if (!deprecatedMode.isNull) {
            deprecationWarning("The `sortWhitelist` option is deprecated. Use `sortableFields` instead.");
        }

        return deprecatedMode;
    }

    /**
     * Merges the various options that Paginator uses.
     * Pulls settings together from the following places:
     *
     * - General pagination settings
     * - Model specific settings.
     * - Request parameters
     *
     * The result of this method is the aggregate of all the option sets
     * combined together. You can change config value `allowedParameters` to modify
     * which options/values can be set using request parameters.
     */
    Json[string] mergeOptions(Json[string] requestData, Json[string] settingsData) {
        if (!settingsData.isEmpty("scope"))) {
            scope = settingsData["scope"];
            requestData = !requestData.isEmpty(scope) ? /* (array) */requestData[scope] : [];
        }

        allowed = getAllowedParameters();
        requestData = array_intersect_key(requestData, array_flip(allowed));

        return array_merge(settingsData, requestData);
    }

    /**
     * Get the settings for a myModel. If there are no settings for a specific
     * repository, the general settings will be used.
     */
    Json[string] getDefaults(string aliasName, Json[string] settingsData) {
        if (settingsData.hasKey(aliasName)) {
            settingsData = settingsData[aliasName];
        }

        auto defaults = configuration.data;
        defaults["whitelist"] = defaults["allowedParameters"] = getAllowedParameters();

        int maxLimit = settingsData.getInt("maxLimit", defaults.getInt("maxLimit"));
        int limit = settingsData.getInt("limit", defaults..getInt("limit"));

        if (limit > maxLimit) {
            limit = maxLimit;
        }

        settingsData["maxLimit"] = maxLimit.toJson;
        settingsData["limit"] = limit.toJson;

        return settingsData.merge(defaults);
    }

    /**
     * Validate that the desired sorting can be performed on the repository.
     *
     * Only fields or virtualFields can be sorted on. The direction param will
     * also be sanitized. Lastly sort + direction keys will be converted into
     * the model friendly order key.
     *
     * You can use the allowedParameters option to control which columns/fields are
     * available for sorting via URL parameters. This helps prevent users from ordering large
     * result sets on un-indexed values.
     *
     * If you need to sort on associated columns or synthetic properties you
     * will need to use the `sortableFields` option.
     *
     * Any columns listed in the allowed sort fields will be implicitly trusted.
     * You can use this to sort on synthetic columns, or columns added in custom
     * find operations that may not exist in the schema.
     *
     * The default order options provided to paginate() will be merged with the user"s
     * requested sorting field/direction.
     *
     * @param Json[string] paginationData The pagination options being used for this request.
     */
    Json[string] validateSort(IRepository repository, Json[string] paginationData) {
        if (paginationData.hasKey("sort")) {
            direction = null;
            if (paginationData.hasKey("direction")) {
                direction = strtolower(paginationData["direction"]);
            }
            if (!in_array(direction, ["asc", "desc"], true)) {
                direction = "asc";
            }

            order = paginationData.hasKey("order") && paginationData["order"].isArray ? paginationData["order"] : [];
            if (order && paginationData.hasKey("sort") && indexOf(paginationData.getString("sort"), ".") == false) {
                order = _removeAliases(order, repository.aliasName());
            }

            paginationData["order"] = [paginationData.hasKey("sort"): direction] + order;
        } else {
            paginationData["sort"] = null;
        }
        paginationData.remove("direction");

        if (paginationData.isEmpty("order")) {
            paginationData["order"]= null;
        }
        if (!paginationData["order"].isArray) {
            return paginationData;
        }

        sortAllowed = false;
        allowed = getSortableFields(paginationData);
        if (allowed !== null) {
            paginationData["sortableFields"] = allowed;
            paginationData["sortWhitelist"] = allowed;

            myField = key(paginationData.hasKey("order"));
            sortAllowed = in_array(myField, allowed, true);
            if (!sortAllowed) {
                paginationData["order"]= null;
                paginationData["sort"] = null;

                return paginationData;
            }
        }

        if (
            paginationData["sort"] == null
            && count(paginationData["order"]) == 1
            && !key(paginationData["order"].isNumeric)
        ) {
            paginationData["sort"] = key(paginationData["order"]);
        }

        paginationData["order"] = _prefix(repository, paginationData["order"], sortAllowed);

        return paginationData;
    }

    // Remove alias if needed.
    protected Json[string] _removeAliases(Json[string] fieldNames, string modelAlias) {
        myResult= null;
        foreach (fieldNames as myField: sort) {
            if (indexOf(myField, ".") == false) {
                myResult[myField] = sort;
                continue;
            }

            [aliasName, currentField] = explode(".", myField);

            if (aliasName == modelAlias) {
                myResult[currentField] = sort;
                continue;
            }

            myResult[myField] = sort;
        }

        return myResult;
    }

    // Prefixes the field with the table alias if possible.
    protected Json[string] _prefix(IRepository repository, Json[string] orderData, bool isAllowed = false) {
        sring myTableAlias = repository.aliasName();
        myTableOrder= null;
        foreach (orderData as myKey: myValue) {
            if (myKey.isNumeric) {
                myTableOrder ~= myValue;
                continue;
            }
            myField = myKey;
            aliasName = myTableAlias;

            if (indexOf(myKey, ".") !== false) {
                [aliasName, myField] = explode(".", myKey);
            }
            correctAlias = (myTableAlias == aliasName);

            if (correctAlias && isAllowed) {
                // Disambiguate fields in schema. As id is quite common.
                if (repository.hasField(myField)) {
                    myField = aliasName ~ "." ~ myField;
                }
                myTableOrder[myField] = myValue;
            } elseif (correctAlias && repository.hasField(myField)) {
                myTableOrder[myTableAlias ~ "." ~ myField] = myValue;
            } elseif (!correctAlias && isAllowed) {
                myTableOrder[aliasName ~ "." ~ myField] = myValue;
            }
        }

        return myTableOrder;
    }

    // Check the limit parameter and ensure it"s within the maxLimit bounds.
    Json[string] checkLimit(Json[string] options) {
        options["limit"] = (int)options["limit"];
        if (options["limit"] < 1) {
            options["limit"] = 1;
        }
        options["limit"] = max(min(options["limit"], options["maxLimit"]), 1);

        return options;
    } 
}
