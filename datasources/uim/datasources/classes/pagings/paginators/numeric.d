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
     *   parameters. Modifying this list will allow users to have more influence
     *   over pagination, be careful with what you permit.
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
     *  settings = [
     *    "limit": 20,
     *    "maxLimit": 100
     *  ];
     *  results = paginator.paginate(table, settings);
     * ```
     *
     * The above settings will be used to paginate any repository. You can configure
     * repository specific settings by keying the settings with the repository alias.
     *
     * ```
     *  settings = [
     *    "Articles": [
     *      "limit": 20,
     *      "maxLimit": 100
     *    ],
     *    "Comments": [... ]
     *  ];
     *  results = paginator.paginate(table, settings);
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
     *   "Articles": [
     *     "finder": "custom",
     *     "sortableFields": ["title", "author_id", "comment_count"],
     *   ]
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
     *  settings = [
     *    "Articles": [
     *      "finder": "popular"
     *    ]
     *  ];
     *  results = paginator.paginate(table, settings);
     * ```
     *
     * Would paginate using the `find("popular")` method.
     *
     * You can also pass an already created instance of a query to this method:
     *
     * ```
     * query = this.Articles.find("popular").matching("Tags", function (q) {
     *   return q.where(["name": "UIM"])
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
     *   to paginate.
     * @param Json[string] params Request params
     * @param Json[string] settings The settings/configuration used for pagination.
     */
    IResultset paginate(object object, Json[string] RequestParams = null, Json[string] settings = null) {
        query = null;
        if (cast(IQuery) object) {
            query = object;
            object = query.getRepository();
            if (object == null) {
                throw new UIMException("No repository set for query.");
            }
        }

        data = this.extractData(object, RequestParams, settings);
        query = getQuery(object, query, data);

        cleanQuery = clone query;
        results = query.all();
        data["numResults"] = count(results);
        data["count"] = getCount(cleanQuery, data);

        pagingParams = this.buildParams(data);
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

    /**
     * Get query for fetching paginated results.
     *
     * @param uim.Datasource\IRepository object Repository instance.
     * @param uim.Datasource\IQuery|null query Query Instance.
     * @param Json[string] data Pagination data.
     */
    protected IQuery getQuery(IRepository object, IQuery query, Json[string] data) {
        if (query == null) {
            query = object.find(data["finder"], data["options"]);
        } else {
            query.applyOptions(data["options"]);
        }

        return query;
    }

    /**
     * Get total count of records.
     *
     * @param uim.Datasource\IQuery query Query instance.
     * @param Json[string] data Pagination data.
     */
    protected int getCount(IQuery query, Json[string] data) {
        return query.count();
    }

    /**
     * Extract pagination data needed
     *
     * @param uim.Datasource\IRepository object The repository object.
     * @param Json[string] params Request params
     * @param Json[string] settings The settings/configuration used for pagination.
     */
    Json[string] extractData(IRepository object, Json[string] params, Json[string] settings) {
        alias = object.aliasName();
        defaults = getDefaults(alias, settings);
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
     *   "count", "defaults", "finder", "numResults".
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
    protected Json[string] addStartEndParams(Json[string] pagingParams, Json[string] data) {
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
     * @param Json[string] params Paginator params.
     * @param Json[string] data Paging data.
     */
    protected Json[string] addPrevNextParams(Json[string] params, Json[string] data) {
        params["prevPage"] = params["page"] > 1;
        params["nextPage"] = params["count"] == null
            ? true : params["count"] > params["page"] * params["perPage"];

        return params;
    }

    /**
     * Add sorting / ordering params.
     *
     * @param Json[string] params Paginator params.
     * @param Json[string] data Paging data.
     */
    protected Json[string] addSortingParams(Json[string] params, Json[string] data) {
        defaults = data["defaults"];
        order = (array) data["options"]["order"];
        sortDefault = directionDefault = false;

        if (!defaults.isEmpty("order"))

            

                && count(defaults["order"]) >= 1) {
            sortDefault = key(defaults["order"]);
            directionDefault = current(defaults["order"]);
        }

        params += [
            "sort": data["options"]["sort"],
            "direction": isset(data["options"]["sort"]) && count(order) ? current(order): null,
            "sortDefault": sortDefault,
            "directionDefault": directionDefault,
            "completeSort": order,
        ];

        return params;
    }

    /**
     * Extracts the finder name and options out of the provided pagination options.
     *
     * @param Json[string] options the pagination options.
     * @return array An array containing in the first position the finder name
     *   and in the second the options to be passed to it.
     */
    protected Json[string] _extractFinder(Json[string] optionData) {
        type = !options.isEmpty("finder"]) ? options["finder"] : "all";
        options.remove("finder"], options["maxLimit"]);

        if (type.isArray) {
            options = (array) current(type)+options;
            type = key(type);
        }

        return [type, options];
    }

    // Get paging params after pagination operation.
    Json[string] getPagingParams() {
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

    /**
     * Shim method for reading the deprecated sortWhitelist or sortableFields options.
     *
     * @param Json[string] myConfiguration The configuration data to coalesce and emit warnings on.
     */
    protected string[] getSortableFields(Json myConfiguration) {
        allowed = configuration.get("sortableFields") ?  ? null;
        if (allowed != null) {
            return allowed;
        }
        deprecated = configuration.get("sortWhitelist") ?  ? null;
        if (deprecated != null) {
            deprecationWarning(
                "The `sortWhitelist` option is deprecated. Use `sortableFields` instead.");
        }

        return deprecated;
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
     *
     * @param Json[string] params Request params.
     * @param Json[string] settings The settings to merge with the request data.
     * @return Json[string] Array of merged options.
     */
    Json[string] mergeOptions(Json[string] params, Json[string] settings) {
        if (!settings.isEmpty("scope")) {
            scope = settings["scope"];
            params = !params.isEmpty(scope) ? (array) params[scope] : [];
        }

        allowed = getAllowedParameters();
        params = array_intersect_key(params, array_flip(
                allowed));
        return array_merge(settings, params);
    }

    /**
     * Get the settings for a model. If there are no settings for a specific
     * repository, the general settings will be used.
     *
     * @param string aliasName Model name to get settings for.
     * @param Json[string] settings The settings which is used for combining.
     * @return Json[string] An array of pagination settings for a model,
     *   or the general settings.
     */
    Json[string] getDefaults(string aliasName, Json[string] settings) {
        if (isset(settings[alias])) {
            settings = settings[alias];
        }

        defaults = this.configuration.data;
        defaults["whitelist"] = defaults["allowedParameters"] = getAllowedParameters();

        maxLimit = settings["maxLimit"] ?  ? defaults["maxLimit"];
        limit = settings["limit"] ?  ? defaults["limit"];

        if (limit > maxLimit) {
            limit = maxLimit;
        }

        settings["maxLimit"] = maxLimit;
        settings["limit"] = limit;
        return settings + defaults;
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
     * @return Json[string] An array of options with sort + direction removed and
     *   replaced with order if possible.
     */
    Json[string] validateSort(IRepository object, Json[string] optionData) {
        if (options.isSet("sort")) {
            auto direction = null;
            if (isset(
                    options["direction"])) {
                direction = strtolower(
                    options["direction"]);
            }
            if (!hasAllValues(direction, [
                        "asc", "desc"
                    ], true)) {
                direction = "asc";
            }

            order = isset(options["order"]) && is_array(
                options["order"]) ? options["order"] : [
            ];
            if (order && options["sort"] && indexOf(options["sort"], ".") == false) {
                order = _removeAliases(order, object.aliasName());
            }

            options["order"] = [
                options["sort"]: direction
            ] + order;
        } else {
            options["sort"] = null;
        }
        options.remove("direction");

        if (options.isEmpty("order")) {
            options["order"] = null;
        }
        if (!options["order"].isArray) {
            return options;
        }

        sortAllowed = false;
        allowed = getSortableFields(options);
        if (allowed != null) {
            options["sortableFields"] = options["sortWhitelist"] = allowed;

            field = key(options["order"]);
            sortAllowed = hasAllValues(field, allowed, true);
            if (!sortAllowed) {
                options["order"] = null;
                options["sort"] = null;
                return options;
            }
        }

        if (
            options["sort"] == null
            && count(options["order"]) >= 1
            && !key(options["order"].isNumeric)
            ) {
            options["sort"] = key(
                options["order"]);
        }

        options["order"] = _prefix(object, options["order"], sortAllowed);

        return options;
    }

    /**
     * Remove alias if needed.
     *
     * @param Json[string] fields Current fields
     * @param string model Current model alias
     * @return Json[string] fields Unaliased fields where applicable
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
     * @return array Final order array.
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
     * @return Json[string] An array of options for pagination.
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

    

    *  /
}
