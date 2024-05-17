/*********************************************************************************************************
	Copyright: © 2015-2024 Ozan Nurettin Süel (Sicherheitsschmiede)                                        
	License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
	Authors: Ozan Nurettin Süel (Sicherheitsschmiede)                                                      
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
        *   parameters. Modifying this list will allow users to have more influence
        *   over pagination, be careful with what you permit.
        *
        * @var Json[string]
        */
        configuration.updateDefaults([
            "page":Json(1),
            "limit":Json(20),
            "maxLimit":Json(100),
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
     *  settings = [
     *    "limit":20,
     *    "maxLimit":100
     *  ];
     *  myResults = paginator.paginate(myTable, settings);
     * ```
     *
     * The above settings will be used to paginate any repository. You can configure
     * repository specific settings by keying the settings with the repository alias.
     *
     * ```
     *  settings = [
     *    "Articles":[
     *      "limit":20,
     *      "maxLimit":100
     *    ],
     *    "Comments":[... ]
     *  ];
     *  myResults = paginator.paginate(myTable, settings);
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
     *   "Articles":[
     *     "finder":"custom",
     *     "sortableFields":["title", "author_id", "comment_count"],
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
     *    "Articles":[
     *      "finder":"popular"
     *    ]
     *  ];
     *  myResults = paginator.paginate(myTable, settings);
     * ```
     *
     * Would paginate using the `find("popular")` method.
     *
     * You can also pass an already created instance of a query to this method:
     *
     * ```
     * myQuery = this.Articles.find("popular").matching("Tags", function (q) {
     *   return q.where(["name":"uimD"])
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
     * articles = paginator.paginate(articlesQuery, ["scope":"articles"]);
     * tags = paginator.paginate(tagsQuery, ["scope":"tags"]);
     * ```
     *
     * Each of the above queries will use different query string parameter sets
     * for pagination data. An example URL paginating both results would be:
     *
     * ```
     use uim\ORM\Entity;dashboard?articles[page]=1&tags[page]=2
     * ```
     *
     * @param \uim\Datasource\IRepository|\uim\Datasource\IQuery object The repository or query
     *   to paginate.
     * @param Json[string] myParams Request params
     * @param Json[string] settings The settings/configuration used for pagination.
     * @return \uim\Datasource\IResultset Query results
     * @throws \uim\Datasource\Exception\PageOutOfBoundsException
     */
    IDSResultset paginate(object object, Json[string] myParams= null, Json[string] settings= null) {
        myQuery = null;
        if (object instanceof IQuery) {
            myQuery = object;
            object = myQuery.getRepository();
            if (object == null) {
                throw new DuimException("No repository set for query.");
            }
        }

        myData = this.extractData(object, myParams, settings);
        myQuery = getQuery(object, myQuery, myData);

        cleanQuery = clone myQuery;
        myResults = myQuery.all();
        myData["numResults"] = count(myResults);
        myData["count"] = getCount(cleanQuery, myData);

        pagingParams = this.buildParams(myData);
        aliasName = object.aliasName();
        _pagingParams = [aliasName: pagingParams];
        if (pagingParams["requestedPage"] > pagingParams["page"]) {
            throw new DPageOutOfBoundsException([
                "requestedPage":pagingParams["requestedPage"],
                "pagingParams":_pagingParams,
            ]);
        }

        return myResults;
    }

    // Get query for fetching paginated results.
    // \uim\Datasource\IRepository object Repository instance.
    // \uim\Datasource\IQuery|null myQuery Query Instance.
    //  Json[string] myData Pagination data.
    protected IDSQuery getQuery(IRepository object, ?IQuery myQuery, Json[string] myData) {
        if (myQuery == null) {
            myQuery = object.find(myData["finder"], myData["options"]);
        } else {
            myQuery.applyOptions(myData["options"]);
        }

        return myQuery;
    }

    /**
     * Get total count of records.
     *
     * @param \uim\Datasource\IQuery myQuery Query instance.
     * @param Json[string] myData Pagination data.
     */
    protected int getCount(IQuery myQuery, Json[string] myData) {
        return myQuery.count();
    }

    /**
     * Extract pagination data needed
     *
     * @param \uim\Datasource\IRepository object The repository object.
     * @param Json[string] myParams Request params
     * @param Json[string] settings The settings/configuration used for pagination.
     * @return Json[string] Array with keys "defaults", "options" and "finder"
     */
    protected auto extractData(IRepository anRepository, Json[string] myParams, Json[string] settings): array
    {
        aliasName = object.aliasName();
        defaults = getDefaults(aliasName, settings);
        options = mergeOptions(myParams, defaults);
        options = validateSort(anRepository, options);
        options = checkLimit(options);

        auto updatedOptions = options.update["page":1, "scope":null];
        options["page"] = (int)options["page"] < 1 ? 1 : (int)options["page"];
        [myFinder, options] = _extractFinder(options);

        return compact("defaults", "options", "finder");
    }

    /**
     * Build pagination params.
     *
     * @param Json[string] myData Paginator data containing keys "options",
     *   "count", "defaults", "finder", "numResults".
     * @return Json[string] Paging params.
     */
    protected auto buildParams(Json[string] myData): array
    {
        limit = myData["options"]["limit"];

        paging = [
            "count":myData["count"],
            "current":myData["numResults"],
            "perPage":limit,
            "page":myData["options"]["page"],
            "requestedPage":myData["options"]["page"],
        ];

        paging = addPageCountParams(paging, myData);
        paging = addStartEndParams(paging, myData);
        paging = addPrevNextParams(paging, myData);
        paging = addSortingParams(paging, myData);

        paging += [
            "limit":myData["defaults"]["limit"] != limit ? limit : null,
            "scope":myData["options"]["scope"],
            "finder":myData["finder"],
        ];

        return paging;
    }

    /**
     * Add "page" and "pageCount" params.
     *
     * @param Json[string] myParams Paging params.
     * @param Json[string] myData Paginator data.
     * @return Json[string] Updated params.
     */
    protected auto addPageCountParams(Json[string] myParams, Json[string] myData): array
    {
        page = myParams["page"];
        pageCount = 0;

        if (myParams["count"] !== null) {
            pageCount = max((int)ceil(myParams["count"] / myParams["perPage"]), 1);
            page = min(page, pageCount);
        } elseif (myParams["current"] == 0 && myParams["requestedPage"] > 1) {
            page = 1;
        }

        myParams["page"] = page;
        myParams["pageCount"] = pageCount;

        return myParams;
    }

    /**
     * Add "start" and "end" params.
     *
     * @param Json[string] myParams Paging params.
     * @param Json[string] myData Paginator data.
     * @return Json[string] Updated params.
     */
    protected auto addStartEndParams(Json[string] myParams, Json[string] myData): array
    {
        start = end = 0;

        if (myParams["current"] > 0) {
            start = ((myParams["page"] - 1) * myParams["perPage"]) + 1;
            end = start + myParams["current"] - 1;
        }

        myParams["start"] = start;
        myParams["end"] = end;

        return myParams;
    }

    /**
     * Add "prevPage" and "nextPage" params.
     *
     * @param Json[string] myParams Paginator params.
     * @param Json[string] myData Paging data.
     * @return Json[string] Updated params.
     */
    protected auto addPrevNextParams(Json[string] myParams, Json[string] myData): array
    {
        myParams["prevPage"] = myParams["page"] > 1;
        if (myParams["count"] == null) {
            myParams["nextPage"] = true;
        } else {
            myParams["nextPage"] = myParams["count"] > myParams["page"] * myParams["perPage"];
        }

        return myParams;
    }

    /**
     * Add sorting / ordering params.
     *
     * @param Json[string] myParams Paginator params.
     * @param Json[string] myData Paging data.
     * @return Json[string] Updated params.
     */
    protected auto addSortingParams(Json[string] myParams, Json[string] myData): array
    {
        defaults = myData["defaults"];
        order = (array)myData["options"]["order"];
        sortDefault = directionDefault = false;

        if (!defaults.isEmpty("order")) && count(defaults["order"]) == 1) {
            sortDefault = key(defaults["order"]);
            directionDefault = current(defaults["order"]);
        }

        myParams += [
            "sort":myData["options"]["sort"],
            "direction":isset(myData["options"]["sort"]) && count(order) ? current(order) : null,
            "sortDefault":sortDefault,
            "directionDefault":directionDefault,
            "completeSort":order,
        ];

        return myParams;
    }

    /**
     * Extracts the finder name and options out of the provided pagination options.
     *
     * @param Json[string] options the pagination options.
     * @return Json[string] An array containing in the first position the finder name
     *   and in the second the options to be passed to it.
     */
    protected auto _extractFinder(Json[string] options): array
    {
        myType = !options.isEmpty("finder"]) ? options["finder"] : "all";
        options.remove("finder"], options["maxLimit"]);

        if (is_array(myType)) {
            options = (array)current(myType) + options;
            myType = key(myType);
        }

        return [myType, options];
    }

    /**
     * Get paging params after pagination operation.
     *
     * @return array
     */
    auto getPagingParams(): array
    {
        return _pagingParams;
    }

    /**
     * Shim method for reading the deprecated whitelist or allowedParameters options
     */
    protected string[] getAllowedParameters() {
        allowed = configuration.get("allowedParameters");
        if (!allowed) {
            allowed= null;
        }
        whitelist = configuration.get("whitelist");
        if (whitelist) {
            deprecationWarning("The `whitelist` option is deprecated. Use the `allowedParameters` option instead.");

            return array_merge(allowed, whitelist);
        }

        return allowed;
    }

    /**
     * Shim method for reading the deprecated sortWhitelist or sortableFields options.
     * @param Json[string] myConfig The configuration data to coalesce and emit warnings on.
     */
    protected string[] getSortableFields(Json[string] myConfig) {
        allowed = myConfig.get("sortableFields", null);
        if (allowed !== null) {
            return allowed;
        }
        deprecated = myConfig["sortWhitelist"] ?? null;
        if (deprecated !== null) {
            deprecationWarning("The `sortWhitelist` option is deprecated. Use `sortableFields` instead.");
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
     * @param Json[string] myParams Request params.
     * @param Json[string] settings The settings to merge with the request data.
     * @return Array of merged options.
     */
    Json[string] mergeOptions(Json[string] myParams, Json[string] settings) {
        if (!settings.isEmpty("scope"))) {
            scope = settings["scope"];
            myParams = !myParams.isEmpty(scope)) ? (array)myParams[scope] : [];
        }

        allowed = getAllowedParameters();
        myParams = array_intersect_key(myParams, array_flip(allowed));

        return array_merge(settings, myParams);
    }

    /**
     * Get the settings for a myModel. If there are no settings for a specific
     * repository, the general settings will be used.
     *
     * @param string aliasName Model name to get settings for.
     * @param Json[string] settings The settings which is used for combining.
     * @return Json[string] An array of pagination settings for a model,
     *   or the general settings.
     */
    auto getDefaults(string aliasName, Json[string] settings): array
    {
        if (isset(settings[aliasName])) {
            settings = settings[aliasName];
        }

        defaults = configuration.data;
        defaults["whitelist"] = defaults["allowedParameters"] = getAllowedParameters();

        maxLimit = settings["maxLimit"] ?? defaults["maxLimit"];
        limit = settings["limit"] ?? defaults["limit"];

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
     * @param \uim\Datasource\IRepository object Repository object.
     * @param Json[string] options The pagination options being used for this request.
     */
    Json[string] validateSort(IRepository object, Json[string] options) {
        if (isset(options["sort"])) {
            direction = null;
            if (isset(options["direction"])) {
                direction = strtolower(options["direction"]);
            }
            if (!in_array(direction, ["asc", "desc"], true)) {
                direction = "asc";
            }

            order = isset(options["order"]) && (options["order"].isArray ? options["order"] : [];
            if (order && options["sort"] && indexOf(options["sort"], ".") == false) {
                order = _removeAliases(order, object.aliasName());
            }

            options["order"] = [options["sort"]: direction] + order;
        } else {
            options["sort"] = null;
        }
        options.remove("direction"]);

        if (options.isEmpty("order"])) {
            options["order"]= null;
        }
        if (!(options["order"].isArray) {
            return options;
        }

        sortAllowed = false;
        allowed = getSortableFields(options);
        if (allowed !== null) {
            options["sortableFields"] = options["sortWhitelist"] = allowed;

            myField = key(options["order"]);
            sortAllowed = in_array(myField, allowed, true);
            if (!sortAllowed) {
                options["order"]= null;
                options["sort"] = null;

                return options;
            }
        }

        if (
            options["sort"] == null
            && count(options["order"]) == 1
            && !key(options["order"].isNumeric)
        ) {
            options["sort"] = key(options["order"]);
        }

        options["order"] = _prefix(object, options["order"], sortAllowed);

        return options;
    }

    /**
     * Remove alias if needed.
     *
     * @param Json[string] fieldNames Current fields
     * @param string myModel Current model alias
     * @return Json[string] fieldNames Unaliased fields where applicable
     */
    protected auto _removeAliases(Json[string] fieldNames, string myModel): array
    {
        myResult= null;
        foreach (fieldNames as myField: sort) {
            if (indexOf(myField, ".") == false) {
                myResult[myField] = sort;
                continue;
            }

            [aliasName, currentField] = explode(".", myField);

            if (aliasName == myModel) {
                myResult[currentField] = sort;
                continue;
            }

            myResult[myField] = sort;
        }

        return myResult;
    }

    /**
     * Prefixes the field with the table alias if possible.
     *
     * @param \uim\Datasource\IRepository object Repository object.
     * @param Json[string] order DOrder array.
     * @param bool allowed Whether the field was allowed.
     * @return Json[string] Final order array.
     */
    protected auto _prefix(IRepository object, Json[string] order, bool allowed = false): array
    {
        myTableAlias = object.aliasName();
        myTableOrder= null;
        foreach (order as myKey: myValue) {
            if (myKey.isNumeric) {
                myTableOrder[] = myValue;
                continue;
            }
            myField = myKey;
            aliasName = myTableAlias;

            if (indexOf(myKey, ".") !== false) {
                [aliasName, myField] = explode(".", myKey);
            }
            correctAlias = (myTableAlias == aliasName);

            if (correctAlias && allowed) {
                // Disambiguate fields in schema. As id is quite common.
                if (object.hasField(myField)) {
                    myField = aliasName . "." . myField;
                }
                myTableOrder[myField] = myValue;
            } elseif (correctAlias && object.hasField(myField)) {
                myTableOrder[myTableAlias . "." . myField] = myValue;
            } elseif (!correctAlias && allowed) {
                myTableOrder[aliasName . "." . myField] = myValue;
            }
        }

        return myTableOrder;
    }

    /**
     * Check the limit parameter and ensure it"s within the maxLimit bounds.
     *
     * @param Json[string] options An array of options with a limit key to be checked.
     * @return Json[string] An array of options for pagination.
     */
    function checkLimit(Json[string] options): array
    {
        options["limit"] = (int)options["limit"];
        if (options["limit"] < 1) {
            options["limit"] = 1;
        }
        options["limit"] = max(min(options["limit"], options["maxLimit"]), 1);

        return options;
    } */
}
