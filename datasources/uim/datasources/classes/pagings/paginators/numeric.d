module uim.datasources.classes.pagings.paginators.numeric;

import uim.datasources;

@safe:

/**
 * This class is used to handle automatic model data pagination.
 */
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

        return true;
    }

    mixin(TProperty!("string", "name"));

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
    protected configuration.updateDefaults([
            "page": 1,
            "limit": 20,
            "maxLimit": 100,
            "allowedParameters": ["limit", "sort", "page", "direction"],
        ]);

    /**
     * Paging params after pagination operation is done.
     *
     * @var array<string, array>
     */
    protected _pagingParams = null;

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
     *
     * @param uim.Datasource\IRepository|uim.Datasource\IQuery object The repository or query
     *  to paginate.
     * @param Json[string] params Request params
     * @param Json[string] paginationData The paginationData/configuration used for pagination.
     */
    IResultset paginate(object object, Json[string] requestData = null, Json[string] paginationData = null) {
        auto query = null;
        if (cast(IQuery) object) {
            query = object;
            object = query.getRepository();
            if (object == null) {
                throw new UIMException("No repository set for query.");
            }
        }

        auto data = this.extractData(object, requestData, paginationData);
        query = getQuery(object, query, data);

        cleanQuery = clone query;
        auto results = query.all();
        data["numResults"] = count(results);
        data["count"] = getCount(cleanQuery, data);

        auto pagingParams = this.buildParams(data);
        alias = object.aliasName();
        _pagingParams = [alias: pagingParams];
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

    /**
     * Extract pagination data needed
     *
     * @param uim.Datasource\IRepository object The repository object.
     * @param Json[string] params Request params
     * @param Json[string] paginationData The paginationData/configuration used for pagination.
     */
    Json[string] extractData(IRepository object, Json[string] params, Json[string] paginationData) {
        alias = object.aliasName();
        defaults = getDefaults(alias, paginationData);
        options = this.mergeOptions(params, defaults);
        options = this.validateSort(object, options);
        options = this.checkLimit(options);

        auto updatedOptions = options.update["page": 1, "scope": Json(null)];
        options["page"] = (int) options["page"] < 1 ? 1 : (int) options["page"];
        [finder, options] = _extractFinder(options);

        return compact("defaults", "options", "finder");
    }

    /**
     * Build pagination params.
     *
     * @param Json[string] data Paginator data containing keys "options",
     *  "count", "defaults", "finder", "numResults".
     */
    protected Json[string] buildParams(Json[string] data) {
        limit = data["options"]["limit"];

        paging = [
            "count": data["count"],
            "current": data["numResults"],
            "perPage": limit,
            "page": data["options"]["page"],
            "requestedPage": data["options"]["page"],
        ];

        paging = this.addPageCountParams(paging, data);
        paging = this.addStartEndParams(paging, data);
        paging = this.addPrevNextParams(paging, data);
        paging = this.addSortingParams(paging, data);

        paging += [
            "limit": data["defaults"]["limit"] != limit ? limit: null,
            "scope": data["options"]["scope"],
            "finder": data["finder"],
        ];

        return paging;
    }

    /**
     * Add "page" and "pageCount" params.
     *
     * @param Json[string] data Paginator data.
     */
    protected Json[string] addPageCountParams(Json[string] pagingParams, Json[string] paginatorData) {
        page = pagingParams["page"];
        pageCount = 0;

        if (pagingParams["count"] != null) {
            pageCount = max((int) ceil(pagingParams["count"] / pagingParams["perPage"]), 1);
            page = min(page, pageCount);
        }
        elseif(pagingParams["current"] == 0 && pagingParams["requestedPage"] > 1) {
            page = 1;
        }

        pagingParams["page"] = page;
        pagingParams["pageCount"] = pageCount;

        return params;
    }

    /**
     * Add "start" and "end" params.
     *
     * @param Json[string] data Paginator data.
     */
    protected Json[string] addStartEndParams(Json[string] pagingParams, Json[string] paginatorData) {
        start = end = 0;

        if (pagingParams["current"] > 0) {
            start = ((pagingParams["page"] - 1) * pagingParams["perPage"]) + 1;
            end = start + pagingParams["current"] - 1;
        }

        pagingParams["start"] = start;
        pagingParams["end"] = end;

        return pagingParams;
    }

    /**
     * Add "prevPage" and "nextPage" params.
     *
     * @param Json[string] paginatorData Paginator paginatorData.
     * @param Json[string] pagingData Paging pagingData.
     */
    protected Json[string] addPrevNextParams(Json[string] paginatorData, Json[string] pagingData) {
        paginatorData["prevPage"] = paginatorData["page"] > 1;
        paginatorData["nextPage"] = paginatorData["count"] == null
            ? true : paginatorData["count"] > paginatorData["page"] * paginatorData["perPage"];

        return paginatorData;
    }

    /**
     * Add sorting / ordering params.
     *
     * @param Json[string] paginatorData Paginator paginatorData.
     * @param Json[string] pagingData Paging pagingData.
     */
    protected Json[string] addSortingParams(Json[string] paginatorData, Json[string] pagingData) {
        defaults = pagingData["defaults"];
        order = (array) pagingData["options"]["order"];
        sortDefault = directionDefault = false;

        if (!defaults.isEmpty("order"))

            

                && count(defaults["order"]) >= 1) {
            sortDefault = key(defaults["order"]);
            directionDefault = current(defaults["order"]);
        }

        paginatorData += [
            "sort": pagingData["options"]["sort"],
            "direction": isset(pagingData["options"]["sort"]) && count(order) ? current(order): null,
            "sortDefault": sortDefault,
            "directionDefault": directionDefault,
            "completeSort": order,
        ];

        return paginatorData;
    }

    /**
     * Extracts the finder name and options out of the provided pagination options.
     *
     * @param Json[string] options the pagination options.
     */
    protected Json[string] _extractFinder(Json[string] paginationOptions) {
        type = !paginationOptions.isEmpty("finder") ? paginationOptions["finder"] : "all";
        paginationOptions.remove("finder"), options["maxLimit"]);

        if (type.isArray) {
            paginationOptions = (array) current(type)+paginationOptions;
            type = key(type);
        }

        return [type, paginationOptions];
    }

    // Get paging params after pagination operation.
    Json[string] pagingParams() {
        return _pagingParams;
    }

    // Shim method for reading the deprecated whitelist or allowedParameters options
    protected string[] getAllowedParameters() {
        allowed = this.configuration.get("allowedParameters");
        if (!allowed) {
            allowed = null;
        }
        whitelist = this.configuration.get("whitelist");
        if (whitelist) {
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
        if (!settingsToMerge.isEmpty("scope")) {
            scope = settingsToMerge["scope"];
            requestData = !requestData.isEmpty(scope) ? (array) requestData[scope] : [];
        }

        allowed = getAllowedParameters();
        params = array_intersect_key(requestData, array_flip(
                allowed));
        return array_merge(settingsToMerge, requestData);
    }

    /**
     * Get the settings for a model. If there are no settings for a specific
     * repository, the general settings will be used.
     *
     * @param string aliasName Model name to get settings for.
     * @param Json[string] settings The settings which is used for combining.
     */
    Json[string] getDefaults(string aliasName, Json[string] settings) {
        if (isset(settings[alias])) {
            settings = settings[alias];
        }

        auto defaultData = this.configuration.data;
        defaultData["whitelist"] = defaultData["allowedParameters"] = getAllowedParameters();

        maxLimit = settings["maxLimit"] ?  ? defaultData["maxLimit"];
        limit = settings["limit"] ?  ? defaultData["limit"];

        if (limit > maxLimit) {
            limit = maxLimit;
        }

        settings["maxLimit"] = maxLimit;
        settings["limit"] = limit;
        return settings + defaultData;
    }

    /**
     * Validate that the desired sorting can be performed on the object.
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
     * @param uim.Datasource\IRepository object Repository object.
     * @param Json[string] options The pagination options being used for this request.
     */
    Json[string] validateSort(IRepository object, Json[string] paginationOptions) {
        if (paginationOptions.isSet("sort")) {
            auto direction = null;
            if (isset(
                    paginationOptions["direction"])) {
                direction = strtolower(
                    paginationOptions["direction"]);
            }
            if (!hasAllValues(direction, [
                        "asc", "desc"
                    ], true)) {
                direction = "asc";
            }

            order = isset(paginationOptions["order"]) && is_array(
                paginationOptions["order"]) ? paginationOptions["order"] : [
            ];
            if (order && paginationOptions["sort"] && indexOf(paginationOptions["sort"], ".") == false) {
                order = _removeAliases(order, object.aliasName());
            }

            paginationOptions["order"] = [
                paginationOptions["sort"]: direction
            ] + order;
        } else {
            paginationOptions["sort"] = null;
        }
        paginationOptions.remove("direction");

        if (paginationOptions.isEmpty("order")) {
            paginationOptions["order"] = null;
        }
        if (!paginationOptions["order"].isArray) {
            return paginationOptions;
        }

        sortAllowed = false;
        allowed = getSortableFields(paginationOptions);
        if (allowed != null) {
            paginationOptions["sortableFields"] = paginationOptions["sortWhitelist"] = allowed;

            field = key(paginationOptions["order"]);
            sortAllowed = hasAllValues(field, allowed, true);
            if (!sortAllowed) {
                paginationOptions["order"] = null;
                paginationOptions["sort"] = null;
                return paginationOptions;
            }
        }

        if (
            paginationOptions["sort"] == null
            && count(paginationOptions["order"]) >= 1
            && !key(paginationOptions["order"].isNumeric)
            ) {
            paginationOptions["sort"] = key(
                paginationOptions["order"]);
        }

        paginationOptions["order"] = _prefix(object, paginationOptions["order"], sortAllowed);

        return paginationOptions;
    }

    /**
     * Remove alias if needed.
     *
     * @param Json[string] fields Current fields
     * @param string model Current model alias
     */
    protected Json[string] _removeAliases(string[] fieldNames, string model) {
        result = null;
        foreach (fields as field : sort) {
            if (indexOf(field, ".") == false) {
                result[field] = sort;
                continue;
            }

            [alias, currentField] = explode(".", field);
            if (alias == model) {
                result[currentField] = sort;
                continue;
            }

            result[field] = sort;
        }

        return result;
    }

    /**
     * Prefixes the field with the table alias if possible.
     *
     * @param uim.Datasource\IRepository object Repository object.
     * @param Json[string] order DOrder array.
     * @param bool allowed Whether the field was allowed.
     */
    protected Json[string] _prefix(IRepository object, Json[string] order, bool allowed = false) {
        tableAlias = object.aliasName();
        tableOrder = null;
        foreach (order as key : value) {
            if (key.isNumeric) {
                tableOrder ~= value;
                continue;
            }
            field = key;
            alias = tableAlias;

            if (indexOf(key, ".") != false) {
                [alias, field] = explode(".", key);
            }
            correctAlias = (
                tableAlias == alias);
            if (
                correctAlias && allowed) {
                // Disambiguate fields in schema. As id is quite common.
                if (object.hasField(
                        field)) {
                    field = alias ~ "." ~ field;
                }
                tableOrder[field] = value;
            }
            elseif(correctAlias && object.hasField(
                    field)) {
                tableOrder[tableAlias ~ "." ~ field] = value;
            }
            elseif(!correctAlias && allowed) {
                tableOrder[alias ~ "." ~ field] = value;
            }
        }

        return tableOrder;
    }

    /**
     * Check the limit parameter and ensure it"s within the maxLimit bounds.
     *
     * @param Json[string] options An array of options with a limit key to be checked.
     */
    Json[string] checkLimit(
        Json[string] optionData) {
        options["limit"] = (int) options["limit"];
        if (options["limit"] < 1) {
            options["limit"] = 1;
        }
        options["limit"] = max(min(options["limit"], options["maxLimit"]), 1);

        return options;
    }

    

    */
}
