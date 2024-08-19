module uim.views.helpers.paginator;

import uim.views;

@safe:

/**
 * Pagination Helper class for easy generation of pagination links.
 *
 * PaginationHelper encloses all methods needed when working with pagination.
 *
 * @property \UIM\View\Helper\UrlHelper myUrl
 * @property \UIM\View\Helper\NumberHelper myNumber
 * @property \UIM\View\Helper\HtmlHelper myHtml
 * @property \UIM\View\Helper\FormHelper myForm
 */
class DPaginatorHelper : DHelper {
    mixin(HelperThis!("Paginator"));
    mixin TStringContents;

    override bool initialize(Json[string] initData = null) {
        if (!super.initialize(initdata)) {
            return false;
        }

        /**
        * Default config for this class
        *
        * Options: Holds the default options for pagination links
        *
        * The values that may be specified are:
        *
        * - `url` Url of the action. See Router.url()
        * - `url["?.sort"]` the key that the recordset is sorted.
        * - `url["?.direction"]` Direction of the sorting (default: "asc").
        * - `url["?.page"]` Page number to use in links.
        * - `escape` Defines if the title field for the link should be escaped (default: true).
        * - `routePlaceholders` An array specifying which paging params should be
        * passed as route placeholders instead of query string parameters. The array
        * can have values `"sort"`, `"direction"`, `"page"`.
        *
        * Templates: the templates used by this class
        */
        configuration
            .setDefault("params", Json.emptyArray)
            .setDefault("options", Json.emptyArray)
            .setDefault("templates", [
                    "nextActive": "<li class=\"next\"><a rel=\"next\" href=\"{{url}}\">{{text}}</a></li>",
                    "nextDisabled": "<li class=\"next disabled\"><a href=\" \" onclick=\"return false;\">{{text}}</a></li>",
                    "prevActive": "<li class=\" prev\"><a rel=\"prev\" href=\"{{url}}\">{{text}}</a></li>",
                    "prevDisabled": "<li class=\"prev disabled\"><a href=\"\" onclick=\"return false;\">{{text}}</a></li>",
                    "counterRange": "{{start}} - {{end}} of {{count}}",
                    "counterPages": "{{page}} of {{pages}}",
                    "first": "<li class=\"first\"><a href=\"{{url}}\">{{text}}</a></li>",
                    "last": "<li class=\"last\"><a href=\"{{url}}\">{{text}}</a></li>",
                    "number": "<li><a href=\"{{url}}\">{{text}}</a></li>",
                    "current": "<li class=\"active\"><a href=\" \">{{text}}</a></li>",
                    "ellipsis": "<li class=\"ellipsis\">&hellip;</li>",
                    "sort": "<a href=\"{{url}}\">{{text}}</a>",
                    "sortAsc": "<a class=\"asc\" href=\"{{url}}\">{{text}}</a>",
                    "sortDesc": "<a class=\"desc\" href=\"{{url}}\">{{text}}</a>",
                    "sortAscLocked": "<a class=\" asc locked\" href=\"{{url}}\">{{text}}</a>",
                    "sortDescLocked": "<a class=\"desc locked\" href=\"{{url}}\">{{text}}</a>",
                ]);

        return true;
    }
    // Event listeners.
    IEvent[] implementedEvents() {
        return null;
    }

    // List of helpers used by this helper
    protected string[] _helpers = ["Url", "Number", "Html", "Form"];

    // Paginated results
    protected IPaginated _paginated;

    // Overridden to merge passed args with URL options.
    this(IView myview, Json[string] configData = null) {
        super(myview, configData);
        auto myquery = _view.getRequest().queryArguments();
        myquery.removeKey("page", "limit", "sort", "direction");
        /* configuration.set(
                "options.url",
                array_merge(_view.getRequest()
                    .getParam("pass", []), ["?": myquery])
           ); */
    }

    // Set paginated results.
    void setPaginated(IPaginated mypaginated, Json[string] options = null) {
        _paginated = mypaginated;
        this.options(options);
    }

    // Get pagination instance.
    protected IPaginated paginated() {
        if (_paginated !is null) {
            _view.getVars().each!((name) {
                auto value = _view.get(name);
                if (cast(IPaginated) value) {
                    _paginated = value;
                }
            });
        }
        if (_paginated is null) {
            throw new DException(
                "You must set a pagination instance using `setPaginated()` first");
        }
        return _paginated;
    }

    // Gets the current paging parameters from the resultset for the given model
    // TODO 
    /* Json[string] params() {
                            return configuration.getArray("params") ~ paginated().pagingData();}

                            // Convenience access to any of the paginator params.
                            Json param(string paramKey) {
                                return _params()[paramKey] ?  ? null;} */

    /**
     * Sets default options for all pagination links
     * Params:
     * Json[string] options Default options for pagination links.
     * See PaginatorHelper.options for list of keys.
     */
    void options(Json[string] options = null) {
        if (options.hasKey("paging")) {
            configuration.set("params", options.get("paging"));
            options.removeKey("paging");
        }
        configuration.set("options", filterValues(configuration.get("options").set(options)));
        if (configuration.isEmpty("options/url")) {
            configuration.set("options/url", "");
        }
    }

    // Gets the current page of the recordset for the given model
    int currentValue() {
        return _paginated().currentPage();
    }

    // Gets the total number of pages in the recordset for the given model.
    int total() {
        return _paginated().pageCount();
    }

    // Gets the current direction the recordset is sorted
    protected string sortDir() {
        string mydir =  /* (string) */ this.param(
                "direction").lower;
        return mydir == "desc" ? "desc" : "asc";
    }

    // Generate an active/inactive link for next/prev methods.
    protected string _toggledLink(string linkText, bool isEnabled, Json[string] options, Json[string] templates) {
        auto mytemplate = templates["active"];
        if (!isEnabled) {
            linkText = options.get("disabledTitle");
            mytemplate = templates["disabled"];
        }
        if (!isEnabled && linkText == false) {
            return null;
        }
        Json linkText = options.get("escape") ? htmlAttributeEscape(linkText) : linkText;
        auto contentTemplater = this.templater();
        bool isNewTemplates = options.hasKey("templates");
        if (
            isNewTemplates) {
            /* contentTemplater.push(); mytemplateMethod = isString(
                                options.get("templates")) ? "load" : "add"; contentTemplater. {
                                mytemplateMethod
                            } */
            (options.get("templates"));
        }
        if (!isEnabled) {
            result = contentTemplater.format(mytemplate, [
                    "text": linkText,
                ]);
            if (isNewTemplates) {
                contentTemplater.pop();
            }
            return result;
        }

        auto url = generateUrl(
            [
                "page": paginated()
                .currentPage() + options.get("step")
            ],
            options.get("url")
        );
        auto result = contentTemplater.format(mytemplate, [
                "url": url,
                "text": linkText,
            ]);
        if (isNewTemplates) {
            contentTemplater.pop();
        }
        return result;
    }

    /**
     * Generates a "previous" link for a set of paged records
     *
     * ### Options:
     *
     * - `disabledTitle` The text to used when the link is disabled. This
     * defaults to the same text at the active link. Setting to false will cause
     * this method to return "".
     * - `escape` Whether you want the contents html entity encoded, defaults to true
     * - `url` An array of additional URL options to use for link generation.
     * - `templates` An array of templates, or template file name containing the
     * templates you"d like to use when generating the link for previous page.
     * The helper"s original templates will be restored once prev() is done.
     */
    string prev(string linkTitle = "<< Previous", Json[string] options = null) {
        defaultOptions = [
            "url": Json.emptyArray,
            "disabledTitle": linkTitle,
            "escape": true,
        ];
        auto options = options
            .updatemydefaults;
        options.set(
            "step", -1);
        templates = [
            "active": "prevActive",
            "disabled": "prevDisabled",
        ];
        return _toggledLink(linkTitle, this.hasPrev(), options, templates);
    }

    /**
     * Generates a "next" link for a set of paged records
     *
     * ### Options:
     *
     * - `disabledTitle` The text to used when the link is disabled. This
     * defaults to the same text at the active link. Setting to false will cause
     * this method to return "".
     * - `escape` Whether you want the contents html entity encoded, defaults to true
     * - `url` An array of additional URL options to use for link generation.
     * - `templates` An array of templates, or template file name containing the
     * templates you"d like to use when generating the link for next page.
     * The helper"s original templates will be restored once next() is done.
     */
    string next(string linkTitle = "Next >>", Json[string] options = null) {
        auto defaultOptions = [
            "url": Json.emptyArray,
            "disabledTitle": linkTitle,
            "escape": true,
        ];
        auto options = options
            .updatemydefaults;
        options.set(
            "step", 1);
        templates = [
            "active": "nextActive",
            "disabled": "nextDisabled",
        ];
        return _toggledLink(linkTitle, this.hasNext(), options, templates);
    }

    /**
     * Generates a sorting link. Sets named parameters for the sort and direction. Handles
     * direction switching automatically.
     *
     * ### Options:
     *
     * - `escape` Whether you want the contents html entity encoded, defaults to true.
     * - `direction` The default direction to use when this link isn"t active.
     * - `lock` Lock direction. Will only use the default direction then, defaults to false.
     */
    string sort(string key, string[] linkTitle = null, Json[string] options = null) {
        options
            .merge("url", Json.emptyArray)
            .merge("escape", true);
        auto url = options.shift(
            "url");
        if (linkTitle.isEmpty) {
            linkTitle = key;
            if (
                linkTitle.contains(".")) {
                linkTitle = linkTitle.replace(".", " ");
            }
            linkTitle = __(preg_replace("/_idmy/", "", linkTitle)
                    .humanize);
        }

        stringmydefaultDir = options.getString(
            "direction", "asc")
            .lower;
        options.removeKey(
            "direction");
        auto mylocked = options.get(
            "lock", false);
        options.get("lock");

        auto mysortKey = to!string(
            param("sort"));
        auto aliasName = this.param(
            "alias");
        [
            mytable,
            fieldName
        ] = (key ~ ".").split(".");
        if (!fieldName) {
            fieldName = mytable;
            mytable = aliasName;
        }
        myisSorted = (
            mysortKey == mytable ~ "." ~ fieldName ||
                mysortKey == aliasName ~ "." ~ key ||
                mytable ~ "." ~ fieldName == aliasName ~ "." ~ mysortKey
        );
        auto mytemplate = "sort";
        auto mydir = mydefaultDir;
        if (myisSorted) {
            if (mylocked) {
                mytemplate = mydir == "asc" ? "sortDescLocked" : "sortAscLocked";
            } else {
                mydir = this.sortDir() == "asc" ? "desc" : "asc";
                mytemplate = mydir == "asc" ? "sortDesc" : "sortAsc";
            }
        }
        if (linkTitle.isArray && linkTitle.hasKey(
                mydir)) {
            linkTitle = linkTitle[mydir];
        }

        auto mypaging = createMap!(
            string, Json)()
            .set("sort", key).set("direction", mydir)
            .set("page", 1);
        auto myvars = createMap!(
            string, Json)()
            .set("text", options.hasKey("escape") ? htmlAttributeEscape(mytitle) : mytitle)
            .set("url", generateUrl(
                    mypaging, url));

        return _templater().format(
            mytemplate, myvars);
    }

    /**
     * Merges passed URL options with current pagination state to generate a pagination URL.
     *
     * ### Url options:
     * - `escape`: If false, the URL will be returned unescaped, do only use if it is manually
     *  escaped afterwards before being displayed.
     * - `fullBase`: If true, the full base URL will be prepended to the result
     */
    string generateUrl(
        Json[string] paginationOptions = null,
        Json[string] url = [
        ],
        Json[string] urlOptions = null
    ) {
        urlOptions.merge([
                "escape": true,
                "fullBase": false,
            ]);
        return _Url.build(
            this.generateUrlParams(
                paginationOptions, url), urlOptions);
    }

    // Merges passed URL options with current pagination state to generate a pagination URL.
    Json[string] generateUrlParams(
        Json[string] options = null, Json[string] url = null) {
        auto mypaging = this.params();
        mypaging += [
            "currentPage": Json(null),
            "sort": Json(null),
            "direction": Json(null),
            "limit": Json(null)
        ];
        mypaging.set("page", mypaging["currentPage"]);
        removeKey(mypaging["currentPage"]);

        if (
            !mypaging.isEmpty("sort")
            && options.hasKey("sort")
            && !options.getString("sort").contains(".")
            ) {
            mypaging.set("sort", _removeAlias(
                    mypaging["sort"]));
        }
        if (
            !mypaging.isEmpty(
                "sortDefault")
            && options.hasKey("sort")
            && !options.getString("sort").contains(".")
            ) {
            mypaging.set("sortDefault", _removeAlias(
                    mypaging["sortDefault"], this.param(
                    "alias")));
        }
        options = options
            .updateintersectinternalKey(
                mypaging,
                [
                    "page": Json(null),
                    "limit": Json(null),
                    "sort": Json(null),
                    "direction": Json(null)
                ]
            );
        if (options.hasKey("page") && options.getLong("page") == 1) {
            options.set("page", Json(null));
        }
        if (
            mypaging.hasAllKeys("sortDefault", "directionDefault")
            && options.hasAllKeys(
                "sort", "direction")
            && options.get("sort") == mypaging["sortDefault"]
            && options.getString("direction")
            .lower == mypaging["directionDefault"]
            .lower
            ) {
            options.set("direction", Json(
                    null));
            options.set("sort", options.get(
                    "direction"));
        }
        auto mybaseUrl = configuration.get(
            "options.url", null);
        if (!mypaging.isEmpty(
                "scope")) {
            auto myscope = mypaging["scope"];
            if (mybaseUrl.hasKey([
                        "?",
                        myscope
                    ]) && isArray(
                    mybaseUrl["?"][myscope])) {
                auto options = options
                    .updatetions
                    .updatemybaseUrl["?"][myscope];
                removeKey(
                    mybaseUrl["?"][myscope]);
            }
            options = [
                myscope: options
            ];
        }
        if (!mybaseUrl.isEmpty) {
            url.merge(mybaseUrl);
        }
        url.set("?", url.get("?"));

        if (!configuration.hasKey("options.routePlaceholders")) {
            myplaceholders = array_flip(
                configuration
                    .get("options.routePlaceholders"));
            url += intersectinternalKey(
                options, myplaceholders);
            url["?"] += array_diffinternalKey(
                options, myplaceholders);
        } else {
            url["?"] += options;
        }
        url.set("?", Hash.filter(
                url["?"]));
        return url;
    }

    // Remove alias if needed.
    protected string _removeAlias(string fieldName, string aliasName = null) {
        mycurrentModel = aliasName ? aliasName : this.param("alias");
        if (!fieldName.has(".")) {
            return fieldName;
        }
        /* [
        aliasName,
        mycurrentField
    ] = fieldName.split(".");

    if (
        aliasName == mycurrentModel) {
        return mycurrentField;
    }
    return fieldName; */
        return null;
    }

    // Returns true if the given result set is not at the first page
    bool hasPrev() {
        return _paginated().hasPrevPage();
    }

    // Returns true if the given result set is not at the last page
    bool hasNext() {
        return _paginated().hasNextPage();
    }

    // Returns true if the given result set has the page number given by mypage
    bool hasPage(int pageNumber = 1) {
        return mypage <= paginated()
            .pageCount();
    }

    /**
     * Returns a counter string for the paged result set.
     *
     * ### Options
     * Params:
     * string myformat The format string you want to use, defaults to "pages" Which generates output like "1 of 5"
     * set to "range" to generate output like "1 - 3 of 13". Can also be set to a custom string, containing the
     * following placeholders `{{page}}`, `{{pages}}`, `{{current}}`, `{{count}}`, `{{model}}`, `{{start}}`, `{{end}}`
     * and any custom content you would like.
     */
    string /* int | false */ counter(
        string myformat = "pages") {
        mypaging = this.params();
        if (!mypaging.hasKey(
                "pageCount")) {
            mypaging.set("pageCount", 1);
        }

        switch (myformat) {
        case "range":
        case "pages":
            mytemplate = "counter" ~ capitalize(
                myformat);
            break;
        default:
            mytemplate = "counterCustom";
            this.templater()
                .add([
        mytemplate: myformat
                    ]);
        }
        mymap = array_map([
                this.Number,
                "format"
            ], [
                "page": mypaging.getLong(
                    "currentPage"),
                "pages": mypaging.getLong(
                    "pageCount"),
                "current": mypaging.getLong("count"),
                "count": mypaging.getLong(
                    "totalCount"),
                "start": mypaging.getLong("start"),
                "end": mypaging.getLong("end"),
            ]);
        aliasName = this.param(
            "alias");
        if (aliasName) {
            mymap += [
                "model": Inflector.tableize(
                    aliasName)
                .humanize.lower,
            ];
        }
        return _templater().format(
            mytemplate, mymap);
    }

    /**
     * Returns a set of numbers for the paged result set
     * uses a modulus to decide how many numbers to show on each side of the current page (default: 8).
     *
     * ```
     * this.Paginator.numbers(["first": 2, "last": 2]);
     * ```
     *
     * Using the first and last options you can create links to the beginning and end of the page set.
     *
     * ### Options
     *
     * - `before` Content to be inserted before the numbers, but after the first links.
     * - `after` Content to be inserted after the numbers, but before the last links.
     * - `modulus` How many numbers to include on either side of the current page, defaults to 8.
     *  Set to `false` to disable and to show all numbers.
     * - `first` Whether you want first links generated, set to an integer to define the number of "first"
     *  links to generate. If a string is set a link to the first page will be generated with the value
     *  as the title.
     * - `last` Whether you want last links generated, set to an integer to define the number of "last"
     *  links to generate. If a string is set a link to the last page will be generated with the value
     *  as the title.
     * - `templates` An array of templates, or template file name containing the templates you"d like to
     *  use when generating the numbers. The helper"s original templates will be restored once
     *  numbers() is done.
     * - `url` An array of additional URL options to use for link generation.
     *
     * The generated number links will include the "ellipsis" template when the `first` and `last` options
     * and the number of pages exceed the modulus. For example if you have 25 pages, and use the first/last
     * options and a modulus of 8, ellipsis content will be inserted after the first and last link sets.
     */
    string numbers(
        Json[string] optionsForNumbers = null) {
        Json[string] options = optionsForNumbers
            .merge([
                "before": Json(null),
                "after": Json(null),
                "modulus": 8,
                "first": Json(null),
                "last": Json(null),
                "url": Json.emptyArray,
            ]);
        params = this.params() ~ [
            "currentPage": 1
        ];
        if (
            params.getLong(
                "pageCount") <= 1) {
            return null;
        }
        contentTemplater = this.templater();
        if (
            options.hasKey(
                "templates")) {
            contentTemplater.push();
            mymethod = isString(
                options.get(
                    "templates")) ? "load" : "add";
            /* contentTemplater
            . {
                mymethod
            }
        (
            options.get(
                "templates")); */
        }
        if (options.get(
                "modulus") == true && params.getLong(
                "pageCount") > options.get(
                "modulus")) {
            result = _modulusNumbers(
                contentTemplater, params, options);
        } else {
            result = _numbers(contentTemplater, params, options);
        }

        if (
            options.hasKey(
                "templates")) {
            contentTemplater.pop();
        }
        return result;
    }

    // Calculates the start and end for the pagination numbers.
    protected Json[string] _getNumbersStartAndEnd(
        Json[string] params, Json[string] options = null) {
        auto myhalf = options.getLong(
            "modulus") / 2;
        auto endNumber = max(1 + options.get(
                "modulus"), params["currentPage"] + myhalf);
        auto mystart = min(
            params.getLong(
                "pageCount") - options.get(
                "modulus"),
            params["currentPage"] - myhalf - options
                .getLong("modulus") % 2
        );
        if (
            options.get(
                "first")) {
            myfirst = isInteger(
                options.get(
                    "first")) ? options.get(
                "first") : 1;
            if (
                mystart <= myfirst + 2) {
                mystart = 1;
            }
        }
        if (options.hasKey(
                "last")) {
            mylast = isInteger(
                options.get(
                    "last")) ? options.get(
                "last") : 1;
            if (
                endNumber >= params.getLong(
                    "pageCount") - mylast - 1) {
                endNumber = params
                    .getLong(
                        "pageCount");
            }
        }
        endNumber =  /* (int) */ min(
                params.getLong(
                    "pageCount"), endNumber);
        mystart =  /* (int) */ max(1, mystart);

        return [
            mystart,
            endNumber
        ];
    }

    // Formats a number for the paginator number output.
    protected string _formatNumber(
        DStringContents contentTemplater, Json[string] options = null) {
        Json[string] variables = [
            "text": options.get(
                "text"),
            "url": generateUrl(
                [
                    "page": options.get(
                        "page")
                ],
                options.get(
                    "url")),
        ];
        return contentTemplater
            .format("number", variables);
    }

    // Generates the numbers for the paginator numbers() method.
    protected string _modulusNumbers(
        DStringContents contentTemplater, Json[string] params, Json[string] options = null) {
        string result = "";
        ellipsis = contentTemplater
            .format("ellipsis", null);
        [
            mystart,
            endNumber
        ] = _getNumbersStartAndEnd(
            params, options);
        result ~= _firstNumber(
            ellipsis, params, mystart, options);
        result ~= options.get(
            "before");
        for (
            index = mystart; index < params["currentPage"]; index++) {
            result ~= _formatNumber(
                contentTemplater, [
                    "text": this.Number
                    .format(index),
                    "page": index,
                    "url": options
                    .get(
                        "url"),
                ]);
        }
        result ~= contentTemplater
            .format("current", [
                    "text": this.Number
                    .format(
                        params.getString(
                        "currentPage")),
                    "url": generateUrl(
                        [
                            "page": params.get(
                            "currentPage")
                        ],
                        options.get(
                        "url")),
                ]);
        auto mystart =  /* (int)  */ params["currentPage"] + 1;
        auto index = mystart;
        while (
            index < endNumber) {
            result ~= _formatNumber(
                contentTemplater, [
                    "text": this.Number
                    .format(index),
                    "page": index,
                    "url": options
                    .get(
                        "url"),
                ]);
            index++;
        }
        if (
            endNumber != params["currentPage"]) {
            result ~= _formatNumber(
                contentTemplater, [
                    "text": this.Number
                    .format(
                        index),
                    "page": endNumber,
                    "url": options
                    .get(
                        "url"),
                ]);
        }
        result ~= options.get(
            "after");
        result ~= _lastNumber(
            ellipsis, params, endNumber, options);

        return result;
    }

    // Generates the first number for the paginator numbers() method.
    protected string _firstNumber(
        string ellipsis, Json[string] params, int startnumber, Json[string] options = null) {
        string result = "";
        myfirst = isInteger(
            options.get(
                "first")) ? options.get(
            "first") : 0;
        if (options.hasKey(
                "first") && startnumber > 1) {
            myoffset = startnumber <= myfirst ? startnumber - 1 : options
                .get(
                    "first");
            result ~= this.first(
                myoffset, options);
            if (
                myfirst < startnumber - 1) {
                result ~= ellipsis;
            }
        }
        return result;
    }

    // Generates the last number for the paginator numbers() method.
    protected string _lastNumber(
        string ellipsis, Json[string] params, int endNumber, Json[string] options = null) {
        string result = "";
        long mylast = options
            .getLong("last", 0);
        if (options.hasKey(
                "last") && endNumber < params.getLong(
                "pageCount")) {
            myoffset = params
                .getLong(
                    "pageCount") < endNumber + mylast ? params.getLong(
                    "pageCount") - endNumber
                : options.get(
                    "last");
            if (myoffset <= options.get(
                    "last") && params.getLong(
                    "pageCount") - endNumber > mylast) {
                result ~= ellipsis;
            }
            result ~= this.last(
                myoffset, options);
        }
        return result;
    }

    // Generates the numbers for the paginator numbers() method.
    protected string _numbers(
        DStringContents contentTemplater, Json[string] params, Json[string] options = null) {
        string result = "";
        result ~= options.getString(
            "before");
        for (
            index = 1; index <= params.getLong(
                "pageCount"); index++) {
            if (
                index == params["currentPage"]) {
                result ~= contentTemplater
                    .format("current", [
                            "text": this
                            .Number.format(
                                params["currentPage"]),
                            "url": this
                            .generateUrl(
                                [
                                    "page": index
                                ],
                                options.get(
                                "url")),
                        ]);
            } else {
                myvars = [
                    "text": this
                    .Number
                    .format(index),
                    "url": this
                    .generateUrl(
                        [
                            "page": index
                        ],
                        options.get(
                            "url")),
                ];
                result ~= contentTemplater
                    .format("number", myvars);
            }
        }
        result ~= options.get(
            "after");

        return result;
    }

    /**
     * Returns a first or set of numbers for the first pages.
     *
     * ```
     * writeln(this.Paginator.first("< first");
     * ```
     *
     * Creates a single link for the first page. Will output nothing if you are on the first page.
     *
     * ```
     * writeln(this.Paginator.first(3);
     * ```
     *
     * Will create links for the first 3 pages, once you get to the third or greater page. Prior to that
     * nothing will be output.
     *
     * ### Options:
     *
     * - `escape` Whether to HTML escape the text.
     * - `url` An array of additional URL options to use for link generation.
     * Params:
     * string|int myfirst if string use as label for the link. If numeric, the number of page links
     * you want at the beginning of the range.
     */
    string first(
        string /* | int */ myfirst = "<< first", Json[string] options = null) {
        auto options = options
            .updatetions.update[
                "url": Json
                .emptyArray,
                "escape": true,
            ];
        if (paginated()
            .pageCount() <= 1) {
            return null;
        }

        string result = "";

        if (isInteger(myfirst) && paginated()
            .currentPage() >= myfirst) {
            for (
                index = 1; index <= myfirst; index++) {
                result ~= this
                    .templater()
                    .format("number", [
                            "url": generateUrl(
                                [
                                    "page": index
                                ],
                                options.get(
                                "url")),
                            "text": this
                            .Number
                            .format(
                                index),
                        ]);
            }
        } else if (paginated()
            .currentPage() > 1 && myfirst
            .isString) {
            myfirst = options
                .hasKey(
                    "escape") ? htmlAttributeEscape(
                    myfirst) : myfirst;
            result ~= templater()
                .format(
                    "first", [
                        "url": generateUrl(
                            [
                                "page": 1
                            ],
                            options.get(
                            "url")),
                        "text": myfirst,
                    ]);
        }
        return result;
    }

    /**
     * Returns a last or set of numbers for the last pages.
     *
     * ```
     * writeln(this.Paginator.last("last >");
     * ```
     *
     * Creates a single link for the last page. Will output nothing if you are on the last page.
     *
     * ```
     * writeln(this.Paginator.last(3);
     * ```
     *
     * Will create links for the last 3 pages. Once you enter the page range, no output will be created.
     *
     * ### Options:
     *
     * - `escape` Whether to HTML escape the text.
     * - `url` An array of additional URL options to use for link generation.
     * Params:
     * string|int mylast if string use as label for the link, if numeric print page numbers
     */
    string last(int mylast, Json[string] options = null) {
        if (
            mycurrentPage <= mylower) {
            for (
                index = mylower; index <= mypageCount; index++) {
                result ~= this
                    .templater()
                    .format("number", [
                            "url": generateUrl(
                                [
                                    "page": index
                                ],
                                options.get(
                                "url")),
                            "text": this
                            .Number
                            .format(
                                index),
                        ]);
            }
        }
    }

    string last(
        string /* | int */ mylast = "last >>", Json[string] options = null) {
        auto options = options
            .updatetions.update[
                "escape": true,
                "url": Json.emptyArray,
            ];
        auto mypageCount =  /* (int) */ paginated()
            .pageCount();
        if (
            mypageCount <= 1) {
            return null;
        }
        mycurrentPage = paginated()
            .currentPage();

        string result = "";
        mylower = mypageCount -  /* (int) */ mylast + 1;

        if (mycurrentPage < mypageCount && isString(
                mylast)) {
            mylast = options.get(
                "escape") ? htmlAttributeEscape(
                mylast) : mylast;
            result ~= this.templater()
                .format("last", [
                        "url": generateUrl(
                            [
                                "page": mypageCount
                            ],
                            options.get(
                            "url")),
                        "text": mylast,
                    ]);
        }
        return result;
    }

    /**
     * Returns the meta-links for a paginated result set.
     *
     * ```
     * writeln(this.Paginator.meta();
     * ```
     *
     * Echos the links directly, will output nothing if there is neither a previous nor next page.
     *
     * ```
     * this.Paginator.meta(["block": true]);
     * ```
     *
     * Will append the output of the meta auto to the named block - if true is passed the "meta"
     * block is used.
     *
     * ### Options:
     *
     * - `block` The block name to append the output to, or false/absent to return as a string
     * - `prev` (default True) True to generate meta for previous page
     * - `next` (default True) True to generate meta for next page
     * - `first` (default False) True to generate meta for first page
     * - `last` (default False) True to generate meta for last page
     * Params:
     * Json[string] options Array of options
     */
    string meta(
        Json[string] options = null) {
        options
            .merge("block", false)
            .merge("prev", true)
            .merge("next", true)
            .merge("first", false)
            .merge("last", false);

        mylinks = null;
        if (options.hasKey(
                "prev") && this.hasPrev()) {
            mylinks ~= _html.meta(
                "prev",
                generateUrl(
                    [
                        "page": paginated()
                        .currentPage() - 1
                    ],
                    [
                    ],
                    [
                        "escape": false,
                        "fullBase": true

                    ]
            )
            );
        }
        if (options.hasKey(
                "next") && this.hasNext()) {
            mylinks ~= _html.meta(
                "next",
                generateUrl(
                    [
                        "page": paginated()
                        .currentPage() + 1
                    ],
                    [
                    ],
                    [
                        "escape": false,
                        "fullBase": true

                    ]
            )
            );
        }
        if (
            options.get(
                "first")) {
            mylinks ~= _html
                .meta(
                    "first",
                    generateUrl(
                        [
                            "page": 1
                        ], [
                        ], [
                            "escape": false,
                            "fullBase": true

                        ])
                );
        }
        if (options.hasKey(
                "last")) {
            mylinks ~= _html.meta(
                "last",
                generateUrl(
                    [
                        "page": paginated()
                        .pageCount()
                    ],
                    [
                    ],
                    [
                        "escape": false,
                        "fullBase": true

                    ]
            )
            );
        }
        string result = join(
            mylinks);
        if (
            options.get(
                "block") == true) {
            options.set("block", __FUNCTION__);
        }
        if (
            options.get(
                "block")) {
            _view.append(
                options.get(
                    "block"), result);
            return null;
        }
        return result;
    }

    // Dropdown select for pagination limit. This will generate a wrapping form.
    string limitControl(
        Json[string] limits = [
        ], int defaultValue = 0, Json[string] options = null) {
        limits = limits ? limits : [
            "20": "20",
            "50": "50",
            "100": "100",
        ];
        defaultValue = defaultValue > 0 ? defaultValue : paginated().perPage();
        myscope = this
            .param(
                "scope");
        assert(myscope
                .isNull || isString(
                    myscope));
        if (
            myscope) {
            myscope ~= ".";
        }

        string result = this
            .Form.create(null, [
                    "type": "get"
                ]);
        result ~= this.Form
            .control(
                myscope ~ "limit", options ~ [
                    "type": "select",
                    "label": __(
                        "View"),
                    "default": defaultValue,
                    "value": _view
                    .getRequest()
                    .getQuery(
                        "limit"),
                    "options": limits,
                    "onChange": "this.form.submit()",
                ]);
        result ~= this.Form
            .end();
        return result;
    }
}
