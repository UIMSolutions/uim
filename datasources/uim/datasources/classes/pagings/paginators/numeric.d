module uim.datasources.classes.pagings.paginators.numeric;

import uim.datasources;

@safe:

// This class is used to handle automatic model data pagination.
class DNumericPaginator : IPaginator {
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
        configuration
            .setDefault("page", 1)
            .setDefault("limit", 20)
            .setDefault("maxLimit", 100)
            .setDefault("allowedParameters", ["limit", "sort", "page", "direction"])
        ]);

        return true;
    }

    mixin(TProperty!("string", "name"));

    // Paging params after pagination operation is done.
    protected Json[string]_pagingParams = null;

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
     * inside that key will be used. Otherwise, the top level configuration will
     * be used.
     *
     * ```
     * settings = [
     *   "limit": 20,
     *   "maxLimit": 100
     * ];
     * results = paginator.paginate(table, settings);
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
     * results = paginator.paginate(table, settings);
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
     * results = paginator.paginate(table, settings);
     * ```
     *
     * Would paginate using the `find("popular")` method.
     *
     * You can also pass an already created instance of a query to this method:
     *
     * ```
     * query = this.Articles.find("popular").matching("Tags", function (q) {
     *  return q.where(["name": "UIM"])
     * });
     * results = paginator.paginate(query);
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
     * dashboard?articles[page]=1&tags[page]=2
     * ```
     */
    IResultset paginate(IQuery queryObject, Json[string] requestData = null, Json[string] paginationData = null) {
        auto query = null;
        if (cast(IQuery) object) {
            query = object;
            repository = query.getRepository();
            if (repository == null) {
                throw new DException("No repository set for query.");
            }
        }

        auto data = this.extractData(object, requestData, paginationData);
        query = getQuery(object, query, data);

        cleanQuery = query.clone;
        auto results = query.all();
        data.set("numResults", count(results));
        data.set("count", getCount(cleanQuery, data));

        auto pagingParams = this.buildParams(data);
        aliasName = object.aliasName();
        _pagingParams = [aliasName: pagingParams];
        if (pagingParams["requestedPage"] > pagingParams["page"]) {
            throw new DPageOutOfBoundsException([
                "requestedPage": pagingParams["requestedPage"],
                "pagingParams": _pagingParams,
            ]);
        }

        return results;
    }

    // Get query for fetching paginated results.
    protected IQuery getQuery(IRepository object, IQuery query, Json[string] paginationData) {
        if (query == null) {
            query = object.find(paginationData["finder"], paginationData["options"]);
        } else {
            query.applyOptions(paginationData["options"]);
        }

        return query;
    }

    // Get total count of records.
    protected int getCount(IQuery query, Json[string] paginationData) {
        return query.count();
    }

    // Extract pagination data needed
    Json[string] extractData(IRepository repository, Json[string] requestData, Json[string] paginationData) {
        string aliasName = repository.aliasName();
        auto defaults = getDefaults(aliasName, paginationData);
        auto options = this.mergeOptions(requestData, defaults);
        options = this.validateSort(repository, options);
        options = this.checkLimit(options);

        options.merge(["page": 1, "scope": Json(null)]);
        options = options.set("page", options.getLong("page") < 1 ? 1 : options.getLong("page"));
        [finder, options] = _extractFinder(options);

        return [
            "defaults": defaults, 
            "options": options, 
            "finder": finder
        ];
    }

    // Build pagination params.
    protected Json[string] buildParams(Json[string] paginatorData) {
        auto limit = paginatorData.get("options.limit");

        auto paging = [
            "count": paginatorData.get("count"),
            "current": paginatorData.get("numResults"),
            "perPage": limit,
            "page": paginatorData.get("options.page"),
            "requestedPage": paginatorData.get("options.page"),
        ];

        auto paging = addPageCountParams(paging, data)
            .addStartEndParams(paging, data)
            .addPrevNextParams(paging, data)
            .addSortingParams(paging, data);

        return paging.merge([
            "limit": data.get("defaults.limit") != limit ? limit: null,
            "scope": data.get("options.scope"),
            "finder": data.get("finder"),
        ]);
    }

    // Add "page" and "pageCount" params.
    protected Json[string] addPageCountParams(Json[string] pagingParams, Json[string] paginatorData) {
        long pageNumber = pagingParams["page"];
        long pageCount = 0;

        if (pagingParams.haskey("count")) {
            pageCount = max(ceil(pagingParams.getLong("count") / pagingParams["perPage"]), 1);
            pageNumber = min(pageNumber, pageCount);
        }
        else if(pagingParams.getLong("current") == 0 && pagingParams.getLong("requestedPage") > 1) {
            pageNumber = 1;
        }

        pagingParams.set("page", pageNumber);
        pagingParams.set("pageCount", pageCount);

        return pagingParams;
    }

    // Add "start" and "end" params.
    protected Json[string] addStartEndParams(Json[string] pagingParams, Json[string] paginatorData) {
        int start = 0;
        int end = 0;

        if (pagingParams.getInteger("current") > 0) {
            start = ((pagingParams["page"] - 1) * pagingParams["perPage"]) + 1;
            end = start + pagingParams["current"] - 1;
        }

        pagingParams.set("start", start);
        pagingParams.set("end", end);
        return pagingParams;
    }

    // Add "prevPage" and "nextPage" params.
    protected Json[string] addPrevNextParams(Json[string] paginatorData, Json[string] pagingData) {
        paginatorData.set("prevPage", paginatorData.getLong("page") > 1);
        paginatorData.set("nextPage", paginatorData.hasKey("count")
            ? true 
            : paginatorData.getLong("count") > paginatorData.getLong("page") * paginatorData.getLong("perPage"));

        return paginatorData;
    }

    // Add sorting / ordering params.
    protected Json[string] addSortingParams(Json[string] paginatorData, Json[string] pagingData) {
        auto defaults = pagingData["defaults"];
        auto order = pagingData.getArray("options.order");
        string directionDefault;
        string sortDefault;

        if (!defaults.isEmpty("order") && count(defaults["order"]) >= 1) {
            sortDefault = key(defaults["order"]);
            directionDefault = currentValue(defaults["order"]);
        }

        paginatorData.set([
            "sort": pagingData.get("options.sort"),
            "direction": pagingData.hasKey("options.sort") && count(order) ? currentValue(order): null,
            "sortDefault": sortDefault,
            "directionDefault": directionDefault,
            "completeSort": order,
        ]);

        return paginatorData;
    }

    // Extracts the finder name and options out of the provided pagination options.
    protected Json[string] _extractFinder(Json[string] paginationOptions) {
        auto type = !paginationOptions.isEmpty("finder") ? paginationoptions.get("finder") : "all";
        // paginationOptions.remove("finder"), paginationoptions.get("maxLimit"]);

        if (type.isArray) {
            paginationOptions = /* (array) */ currentValue(type) + paginationOptions;
            type = key(type);
        }

        return [type, paginationOptions];
    }

    // Get paging params after pagination operation.
    Json[string] pagingData() {
        return _pagingParams;
    }

    // Shim method for reading the deprecated whitelist or allowedParameters options
    protected string[] getAllowedParameters() {
        auto allowed = configuration.get("allowedParameters");
        if (!allowed) {
            allowed = null;
        }

        if (auto whitelist = configuration.get("whitelist")) {
            deprecationWarning(
                "The `whitelist` option is deprecated. Use the `allowedParameters` option instead.");

            return array_merge(allowed, whitelist);
        }

        return allowed;
    }

    // Shim method for reading the deprecated sortWhitelist or sortableFields options.
    protected string[] getSortableFields(Json myConfiguration) {
        return configuration.getStringArray("sortableFields");
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
    Json[string] mergeOptions(Json[string] requestData, Json[string] settingsToMerge) {
        string scopeValue;
        if (!settingsToMerge.isEmpty("scope")) {
            scopeValue = settingsToMerge.getString("scope");
            requestData = requestData.getMap(scopeValue);
        }

        auto allowed = getAllowedParameters();
        auto params = intersectinternalKey(requestData, array_flip(allowed));
        return array_merge(settingsToMerge, requestData);
    }

    /**
     * Get the settings for a model. If there are no settings for a specific
     * repository, the general settings will be used.
     */
    Json[string] getDefaults(string aliasName, Json[string] settingData) {
        if (settingData.hasKey(aliasName)) {
            settingData = settingData[aliasName];
        }

        auto defaultData = configuration.data;
        defaultData.set("allowedParameters", getAllowedParameters());
        defaultData.set("whitelist", defaultData.get("allowedParameters"));

        auto maxLimit = settingData.getLong("maxLimit", defaultData.getLong("maxLimit"));
        auto limit = settingData.getLong("limit", defaultData.getLong("limit"));

        if (limit > maxLimit) {
            limit = maxLimit;
        }

        settingData.set("maxLimit", maxLimit);
        settingData.set("limit", limit);
        return settings.merge(defaultData);
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
     */
    Json[string] validateSort(IRepository repository, Json[string] paginationOptions) {
        if (paginationOptions.hasKey("sort")) {
            auto direction = null;
            if (paginationOptions.hasKey("direction")) {
                direction = paginationOptions.getString("direction").lower;
            }
            if (!hasAllValues(direction, ["asc", "desc"], true)) {
                direction = "asc";
            }

            auto order = paginationOptions.hasKey("order") && paginationoptions.isArray("order")
                ? paginationoptions.get("order") : null;
            if (order && !paginationOptions.getString("sort").contains(".")) {
                order = _removeAliases(order, repository.aliasName());
            }

            paginationOptions.set("order", [paginationOptions.getString("sort"): direction].set(order));
        } else {
            paginationOptions.set("sort", null);
        }
        paginationOptions.remove("direction");

        if (paginationOptions.isEmpty("order")) {
            paginationOptions.set("order", null);
        }
        if (!paginationOptions.isArray("order")) {
            return paginationOptions;
        }

        auto sortAllowed = false;
        auto allowed = getSortableFields(paginationOptions);
        if (allowed != null) {
            paginationOptions.set("sortWhitelist", allowed);
            paginationOptions.set("sortableFields", paginationOptions.get("sortWhitelist"));

            auto field = key(paginationOptions.getString("order"));
            auto sortAllowed = hasAllValues(field, allowed, true);
            if (!sortAllowed) {
                paginationOptions.set("order", null);
                paginationOptions.set("sort", null);
                return paginationOptions;
            }
        }

        if (paginationOptions.isNull("sort") && count(paginationOptions.get("order")) >= 1 && !key(
                paginationOptions.get("order").isNumeric)) {
            paginationOptions.set("sort", key(paginationOptions.getString("order")));
        }

        paginationOptions.set("order", _prefix(repository, paginationOptions.get("order"), sortAllowed));
        return paginationOptions;
    }

    // Remove alias if needed.
    protected Json[string] _removeAliases(string[] fieldNames, string modelAlias) {
        Json[string] result = null;
        foreach (field, sort; fields) {
            if (!field.contains(".")) {
                result[field] = sort;
                continue;
            }

            [aliasName, currentField] = field.split(".");
            if (aliasName == modelAlias) {
                result.set(currentField, sort);
                continue;
            }

            result[field] = sort;
        }
        return result;
    }

    // Prefixes the field with the table alias if possible.
    protected Json[string] _prefix(IRepository repository, Json[string] orderData, bool allowed = false) {
        auto tableAlias = repository.aliasName();
        Json[string] tableOrder = null;
        orderData.byKeyValue.each!((kv) {
            if (kv.key.isNumeric) {
                tableOrder ~= kv.value;
                continue;
            }
            string field = kv.key;
            string aliasName = tableAlias;

            if (indexOf(kv.key, ".") == true) {
                [aliasName, field] = explode(".", kv.key);
            }
            correctAlias = (tableAlias == aliasName);
            if (correctAlias && allowed) {
                // Disambiguate fields in schema. As id is quite common.
                if (repository.hasField(field)) {
                    field = aliasName ~ "." ~ field;
                }
                tableOrder.set(field, kv.value);
            }
            else if(correctAlias && repository.hasField(field)) {
                tableOrder.set(tableAlias ~ "." ~ field, kv.value);
            }
            else if(!correctAlias && allowed) {
                tableOrder.set(aliasName ~ "." ~ field, kv.value);
            }
        });

        return tableOrder;
    }

    // Check the limit parameter and ensure it"s within the maxLimit bounds.
    Json[string] checkLimit(Json[string] options = null) {
        int limitOption = options.getLong("limit");
        if (limitOption < 1) {
            limitOption = 1;
        }
        options = options.set("limit", max(min(limitOption, options.getLong("maxLimit")), 1));
        return options;
    }
}
