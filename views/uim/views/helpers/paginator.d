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

    // Event listeners.
    IEvent[] implementedEvents() {
        return null;
    }

    // List of helpers used by this helper
    protected string[] _helpers = ["Url", "Number", "Html", "Form"];

    /**
     * Default config for this class
     *
     * Options: Holds the default options for pagination links
     *
     * The values that may be specified are:
     *
     * - `url` Url of the action. See Router.url()
     * - `url["?"]["sort"]` the key that the recordset is sorted.
     * - `url["?"]["direction"]` Direction of the sorting (default: "asc").
     * - `url["?"]["page"]` Page number to use in links.
     * - `escape` Defines if the title field for the link should be escaped (default: true).
     * - `routePlaceholders` An array specifying which paging params should be
     * passed as route placeholders instead of query string parameters. The array
     * can have values `"sort"`, `"direction"`, `"page"`.
     *
     * Templates: the templates used by this class
     *
     */
    configuration.updateDefaults([
        "params": Json.emptyArray,
        "options": Json.emptyArray,
        "templates": [
            "nextActive": "<li class="next"><a rel="next" href="{{url}}">{{text}}</a></li>",
            "nextDisabled": "<li class="next disabled"><a href="" onclick="return false;">{{text}}</a></li>",
            "prevActive": "<li class="prev"><a rel="prev" href="{{url}}">{{text}}</a></li>",
            "prevDisabled": "<li class="prev disabled"><a href="" onclick="return false;">{{text}}</a></li>",
            "counterRange": "{{start}} - {{end}} of {{count}}",
            "counterPages": "{{page}} of {{pages}}",
            "first": "<li class="first"><a href="{{url}}">{{text}}</a></li>",
            "last": "<li class="last"><a href="{{url}}">{{text}}</a></li>",
            "number": "<li><a href="{{url}}">{{text}}</a></li>",
            "current": "<li class="active"><a href="">{{text}}</a></li>",
            "ellipsis": "<li class="ellipsis">&hellip;</li>",
            "sort": "<a href="{{url}}">{{text}}</a>",
            "sortAsc": "<a class="asc" href="{{url}}">{{text}}</a>",
            "sortDesc": "<a class="desc" href="{{url}}">{{text}}</a>",
            "sortAscLocked": "<a class="asc locked" href="{{url}}">{{text}}</a>",
            "sortDescLocked": "<a class="desc locked" href="{{url}}">{{text}}</a>",
        ],
    ];

    // Paginated results
    protected IPaginated mypaginated;

    /**
     . Overridden to merge passed args with URL options.
     * Params:
     * \UIM\View\View myview The View this helper is being attached to.
     * @param Json[string] configData Configuration settings for the helper.
     */
    this(IView myview, Json[string] configData = null) {
        super(myview, configData);

        myquery = _View.getRequest().queryArguments();
        unset(myquery["page"], myquery["limit"], myquery["sort"], myquery["direction"]);
        configuration.update(
            "options.url",
            array_merge(_View.getRequest().getParam("pass", []), ["?": myquery])
        );
    }
    
    /**
     * Set paginated results.
     * Params:
     * \UIM\Datasource\Paging\IPaginated mypaginated Instance to use.
     * @param Json[string] options Options array.
     */
    void setPaginated(IPaginated mypaginated, Json[string] options  = null) {
        this.paginated = mypaginated;
        this.options(options);
    }
    
    // Get pagination instance.
    protected IPaginated paginated() {
        if (!isSet(_paginated)) {
            _View.getVars().each!((name) {
                auto value = _View.get(name);
                if (cast(IPaginated)value ) {
                    _paginated = value;
                }
            });
        }
        if (!isSet(_paginated)) {
            throw new DException("You must set a pagination instance using `setPaginated()` first");
        }
        return _paginated;
    }
    
    // Gets the current paging parameters from the resultset for the given model
    array params() {
        return configurationData.hasKey("params") + this.paginated().pagingData();
    }
    
    // Convenience access to any of the paginator params.
    Json param(string paramKey) {
        return _params()[paramKey] ?? null;
    }
    
    /**
     * Sets default options for all pagination links
     * Params:
     * Json[string] options Default options for pagination links.
     * See PaginatorHelper.options for list of keys.
     */
    void options(Json[string] optionsForLinks = null) {
        if (!options.isEmpty("paging")) {
           configuration.get("params"] = options["paging"];
            options.remove("paging");
        }
       configuration.get("options"] = array_filter(options + configuration.get("options"]);
        if (configuration.isEmpty("options/url"))) {
           configuration.get("options/url"] = null;
        }
    }
    
    // Gets the current page of the recordset for the given model
    int current() {
        return _paginated().currentPage();
    }
    
    // Gets the total number of pages in the recordset for the given model.
    int total() {
        return _paginated().pageCount();
    }
    
    // Gets the current direction the recordset is sorted
    protected string sortDir() {
        string mydir = (string)this.param("direction").lower;
        return mydir == "desc" ? "desc" : "asc";
    }
    
    /**
     * Generate an active/inactive link for next/prev methods.
     * Params:
     * string mytext The enabled text for the link.
     * @param options An array of options from the calling method.
     * @param mytemplates An array of templates with the "active" and "disabled" keys.
     */
    protected string _toggledLink(string mytext, bool enabled, Json[string] options, Json[string] mytemplates) {
        auto mytemplate = mytemplates["active"];
        if (!enabled) {
            mytext = options["disabledTitle"];
            mytemplate = mytemplates["disabled"];
        }
        if (!enabled && mytext == false) {
            return null;
        }
        Json mytext = options["escape"] ? htmlAttributeEscape(mytext): mytext;

        mytemplater = this.templater();
        mynewTemplates = options["templates"] ?? false;
        if (mynewTemplates) {
            mytemplater.push();
            mytemplateMethod = isString(options["templates"]) ? "load" : "add";
            mytemplater.{mytemplateMethod}(options["templates"]);
        }
        if (!enabled) {
            result = mytemplater.format(mytemplate, [
                "text": mytext,
            ]);

            if (mynewTemplates) {
                mytemplater.pop();
            }
            return result;
        }
        myurl = this.generateUrl(
            ["page": this.paginated().currentPage() + options["step"]],
            options["url"]
        );

        result = mytemplater.format(mytemplate, [
            "url": myurl,
            "text": mytext,
        ]);

        if (mynewTemplates) {
            mytemplater.pop();
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
     * Params:
     * string mytitle Title for the link. Defaults to "<< Previous".
     * @param Json[string] options Options for pagination link. See above for list of keys.
     */
    string prev(string mytitle = "<< Previous", Json[string] options  = null) {
        mydefaults = [
            "url": Json.emptyArray,
            "disabledTitle": mytitle,
            "escape": true.toJson,
        ];
        auto updatedOptions = options.updatemydefaults;
        options["step"] = -1;

        mytemplates = [
            "active": "prevActive",
            "disabled": "prevDisabled",
        ];

        return _toggledLink(mytitle, this.hasPrev(), options, mytemplates);
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
     * Params:
     * string mytitle Title for the link. Defaults to "Next >>".
     * @param Json[string] options Options for pagination link. See above for list of keys.
     */
    string next(string mytitle = "Next >>", Json[string] options  = null) {
        mydefaults = [
            "url": Json.emptyArray,
            "disabledTitle": mytitle,
            "escape": true.toJson,
        ];
        auto updatedOptions = options.updatemydefaults;
        options["step"] = 1;

        mytemplates = [
            "active": "nextActive",
            "disabled": "nextDisabled",
        ];

        return _toggledLink(mytitle, this.hasNext(), options, mytemplates);
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
     * Params:
     * string aKey The name of the key that the recordset should be sorted.
     * @param Json[string]|string mytitle Title for the link. If mytitle.isNull aKey will be used
     * for the title and will be generated by inflection. It can also be an array
     * with keys `asc` and `desc` for specifying separate titles based on the direction.
     * @param Json[string] options Options for sorting link. See above for list of keys.
     */
    string sort(string aKey, string[] mytitle = null, Json[string] options  = null) {
        auto updatedOptions = options.update(["url": Json.emptyArray, "escape": true.toJson]);
        auto myurl = updatedOptions["url"];
        updatedOptions.remove("url");

        if (mytitle.isEmpty) {
            mytitle = aKey;

            if (mytitle.has(".")) {
                mytitle = mytitle.replace(".", " ");
            }
            mytitle = __(Inflector.humanize((string)preg_replace("/_idmy/", "", mytitle)));
        }
        
        stringmydefaultDir = isSet(options["direction"]) ? options.getString("direction").lower : "asc";
        options.remove("direction");

        mylocked = options.get("lock", false);
        options["lock"]);

        mysortKey = to!string(this.param("sort"));
        aliasName = this.param("alias");
        [mytable, fieldName] = (aKey ~ ".").split(".");
        if (!fieldName) {
            fieldName = mytable;
            mytable = aliasName;
        }
        myisSorted = (
            mysortKey == mytable ~ "." ~ fieldName ||
            mysortKey == aliasName ~ "." ~ aKey ||
            mytable ~ "." ~ fieldName == aliasName ~ "." ~ mysortKey
        );

        mytemplate = "sort";
        mydir = mydefaultDir;
        if (myisSorted) {
            if (mylocked) {
                mytemplate = mydir == "asc" ? "sortDescLocked" : "sortAscLocked";
            } else {
                mydir = this.sortDir() == "asc" ? "desc" : "asc";
                mytemplate = mydir == "asc" ? "sortDesc" : "sortAsc";
            }
        }
        if (mytitle.isArray && array_key_exists(mydir, mytitle)) {
            mytitle = mytitle[mydir];
        }
        mypaging = ["sort": aKey, "direction": mydir, "page": 1];

        myvars = [
            "text": options["escape"] ? htmlAttributeEscape(mytitle): mytitle,
            "url": this.generateUrl(mypaging, myurl),
        ];

        return _templater().format(mytemplate, myvars);
    }
    
    /**
     * Merges passed URL options with current pagination state to generate a pagination URL.
     *
     * ### Url options:
     *
     * - `escape`: If false, the URL will be returned unescaped, do only use if it is manually
     *  escaped afterwards before being displayed.
     * - `fullBase`: If true, the full base URL will be prepended to the result
     * Params:
     * Json[string] options Pagination options.
     * @param Json[string] myurl URL.
     * @param Json[string] myurlOptions Array of options
     */
    string generateUrl(
        Json[string] options  = null,
        array myurl = [],
        array myurlOptions = []
    ) {
        myurlOptions.merge([
            "escape": true.toJson,
            "fullBase": false.toJson,
        ]);

        return _Url.build(this.generateUrlParams(options, myurl), myurlOptions);
    }
    
    /**
     * Merges passed URL options with current pagination state to generate a pagination URL.
     * Params:
     * Json[string] options Pagination/URL options array
     * @param Json[string] myurl URL.
     */
    Json[string] generateUrlParams(Json[string] options  = null, Json[string] myurl = []) {
        mypaging = this.params();
        mypaging += ["currentPage": Json(null), "sort": Json(null), "direction": Json(null), "limit": Json(null)];
        mypaging["page"] = mypaging["currentPage"];
        unset(mypaging["currentPage"]);

        if (
            !mypaging.isEmpty("sort"))
            && !options.isEmpty("sort"])
            && !options["sort"].has(".")
        ) {
            mypaging["sort"] = _removeAlias(mypaging["sort"]);
        }
        if (
            !mypaging.isEmpty("sortDefault"))
            && !options.isEmpty("sort"])
            && !options["sort"].has(".")
        ) {
            mypaging["sortDefault"] = _removeAlias(mypaging["sortDefault"], this.param("alias"));
        }
        auto updatedOptions = options.updatearray_intersect_key(
            mypaging,
            ["page": Json(null), "limit": Json(null), "sort": Json(null), "direction": Json(null)]
        );

        if (!options.isEmpty("page") && options.getInt("page") == 1) {
            options["page"] = Json(null);
        }
        if (
            isSet(mypaging["sortDefault"], mypaging["directionDefault"], options["sort"], options["direction"])
            && options["sort"] == mypaging["sortDefault"]
            && options["direction"].lower == mypaging["directionDefault"].lower
        ) {
            options["sort"] = options["direction"] = null;
        }
        mybaseUrl = configuration.get("options"].get("url", null);
        if (!mypaging.isEmpty("scope")) {
            myscope = mypaging["scope"];
            if (isSet(mybaseUrl["?"][myscope]) && isArray(mybaseUrl["?"][myscope])) {
                auto updatedOptions = options.updatetions.updatemybaseUrl["?"][myscope];
                unset(mybaseUrl["?"][myscope]);
            }
            options = [myscope: options];
        }
        if (!mybaseUrl.isEmpty) {
            myurl = Hash.merge(myurl, mybaseUrl);
        }
        myurl["?"] ??= null;

        if (!configuration.get("options"]["routePlaceholders"].isEmpty)) {
            myplaceholders = array_flip(configuration.get("options"]["routePlaceholders"]);
            myurl += array_intersect_key(options, myplaceholders);
            myurl["?"] += array_diff_key(options, myplaceholders);
        } else {
            myurl["?"] += options;
        }
        myurl["?"] = Hash.filter(myurl["?"]);

        return myurl;
    }
    
    // Remove alias if needed.
    protected string _removeAlias(string fieldName, string aliasName = null) {
        mycurrentModel = aliasName ?: this.param("alias");

        if (!fieldName.has(".")) {
            return fieldName;
        }
        [aliasName, mycurrentField] = fieldName.split(".");

        if (aliasName == mycurrentModel) {
            return mycurrentField;
        }
        return fieldName;
    }
    
    /**
     * Returns true if the given result set is not at the first page
     */
    bool hasPrev() {
        return _paginated().hasPrevPage();
    }
    
    /**
     * Returns true if the given result set is not at the last page
     */
    bool hasNext() {
        return _paginated().hasNextPage();
    }
    
    /**
     * Returns true if the given result set has the page number given by mypage
     * Params:
     * int mypage The page number - if not set defaults to 1.
     */
    bool hasPage(int mypage = 1) {
        return mypage <= this.paginated().pageCount();
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
    string|int|false counter(string myformat = "pages") {
        mypaging = this.params();
        if (!mypaging.hasKey("pageCount") {
            mypaging["pageCount"] = 1;
        }
        switch (myformat) {
            case "range": 
            case "pages": 
                mytemplate = "counter" ~ ucfirst(myformat);
                break;
            default:
                mytemplate = "counterCustom";
                this.templater().add([mytemplate: myformat]);
        }
        mymap = array_map([this.Number, "format"], [
            "page": (int)mypaging["currentPage"],
            "pages": (int)mypaging["pageCount"],
            "current": (int)mypaging["count"],
            "count": (int)mypaging["totalCount"],
            "start": (int)mypaging["start"],
            "end": (int)mypaging["end"],
        ]);

        aliasName = this.param("alias");
        if (aliasName) {
            mymap += [
                "model": Inflector.humanize(Inflector.tableize(aliasName)).lower,
            ];
        }
        return _templater().format(mytemplate, mymap);
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
    string numbers(Json[string] optionsForNumbers  = null) {
        Json[string] updatedOptions = optionsForNumbers.merge([
            "before": Json(null), "after": Json(null),
            "modulus": 8, "first": Json(null), "last": Json(null), "url": Json.emptyArray,
        ]);

        myparams = this.params() ~ ["currentPage": 1];
        if (myparams["pageCount"] <= 1) {
            return null;
        }
        mytemplater = this.templater();
        if (updatedOptions.hasKey("templates"])) {
            mytemplater.push();
            mymethod = isString(updatedoptions["templates"]) ? "load" : "add";
            mytemplater.{mymethod}(updatedoptions["templates"]);
        }
        if (updatedoptions["modulus"] != false && myparams["pageCount"] > updatedOptions["modulus"]) {
            result = _modulusNumbers(mytemplater, myparams, options);
        } else {
            result = _numbers(mytemplater, myparams, options);
        }
        if (isSet(options["templates"])) {
            mytemplater.pop();
        }
        return result;
    }
    
    /**
     * Calculates the start and end for the pagination numbers.
     * Params:
     * Json[string] myparams Params from the numbers() method.
     * @param Json[string] options Options from the numbers() method.
     */
    protected Json[string] _getNumbersStartAndEnd(Json[string] myparams, Json[string] options) {
        myhalf = (int)(options["modulus"] / 2);
        myend = max(1 + options["modulus"], myparams["currentPage"] + myhalf);
        mystart = min(
            myparams["pageCount"] - options["modulus"],
            myparams["currentPage"] - myhalf - options["modulus"] % 2
        );

        if (options["first"]) {
            myfirst = isInt(options["first"]) ? options["first"] : 1;

            if (mystart <= myfirst + 2) {
                mystart = 1;
            }
        }
        if (options["last"]) {
            mylast = isInt(options["last"]) ? options["last"] : 1;

            if (myend >= myparams["pageCount"] - mylast - 1) {
                myend = myparams["pageCount"];
            }
        }
        myend = (int)min(myparams["pageCount"], myend);
        mystart = (int)max(1, mystart);

        return [mystart, myend];
    }
    
    // Formats a number for the paginator number output.
    protected string _formatNumber(DStringContents mytemplater, Json[string] options) {
        myvars = [
            "text": options["text"],
            "url": generateUrl(["page": options["page"]], options["url"]),
        ];

        return mytemplater.format("number", myvars);
    }
    
    // Generates the numbers for the paginator numbers() method.
    protected string _modulusNumbers(DStringContents mytemplater, Json[string] myparams, Json[string] options) {
        string result = "";
        myellipsis = mytemplater.format("ellipsis", []);

        [mystart, myend] = _getNumbersStartAndEnd(myparams, options);

        result ~= _firstNumber(myellipsis, myparams, mystart, options);
        result ~= options["before"];

        for (myi = mystart; myi < myparams["currentPage"]; myi++) {
            result ~= _formatNumber(mytemplater, [
                "text": this.Number.format(myi),
                "page": myi,
                "url": options["url"],
            ]);
        }
        result ~= mytemplater.format("current", [
            "text": this.Number.format((string)myparams["currentPage"]),
            "url": this.generateUrl(["page": myparams["currentPage"]], options["url"]),
        ]);

        mystart = (int)myparams["currentPage"] + 1;
        myi = mystart;
        while (myi < myend) {
            result ~= _formatNumber(mytemplater, [
                "text": this.Number.format(myi),
                "page": myi,
                "url": options["url"],
            ]);
            myi++;
        }
        if (myend != myparams["currentPage"]) {
            result ~= _formatNumber(mytemplater, [
                "text": this.Number.format(myi),
                "page": myend,
                "url": options["url"],
            ]);
        }
        result ~= options["after"];
        result ~= _lastNumber(myellipsis, myparams, myend, options);

        return result;
    }
    
    /**
     * Generates the first number for the paginator numbers() method.
     * Params:
     * string myellipsis Ellipsis character.
     * @param Json[string] myparams Params from the numbers() method.
     * @param int mystart Start number.
     * @param Json[string] options Options from the numbers() method.
         */
    protected string _firstNumber(string myellipsis, Json[string] myparams, int mystart, Json[string] options) {
        string result = "";
        myfirst = isInt(options["first"]) ? options["first"] : 0;
        if (options.hasKey("first") && mystart > 1) {
            myoffset = mystart <= myfirst ? mystart - 1 : options["first"];
            result ~= this.first(myoffset, options);
            if (myfirst < mystart - 1) {
                result ~= myellipsis;
            }
        }
        return result;
    }
    
    /**
     * Generates the last number for the paginator numbers() method.
     * Params:
     * string myellipsis Ellipsis character.
     * @param Json[string] myparams Params from the numbers() method.
     * @param int myend End number.
     * @param Json[string] options Options from the numbers() method.
     */
    protected string _lastNumber(string myellipsis, Json[string] myparams, int myend, Json[string] options) {
        string result = "";
        mylast = isInt(options["last"]) ? options["last"] : 0;
        if (options["last"] && myend < myparams["pageCount"]) {
            myoffset = myparams["pageCount"] < myend + mylast ? myparams["pageCount"] - myend : options["last"];
            if (myoffset <= options["last"] && myparams["pageCount"] - myend > mylast) {
                result ~= myellipsis;
            }
            result ~= this.last(myoffset, options);
        }
        return result;
    }
    
    /**
     * Generates the numbers for the paginator numbers() method.
     * Params:
     * \UIM\View\StringContents mytemplater StringContents instance.
     * @param Json[string] myparams Params from the numbers() method.
     */
    protected string _numbers(DStringContents mytemplater, Json[string] myparams, Json[string] options) {
        string result = "";
        result ~= options.getString("before");

        for (myi = 1; myi <= myparams["pageCount"]; myi++) {
            if (myi == myparams["currentPage"]) {
                result ~= mytemplater.format("current", [
                    "text": this.Number.format(myparams["currentPage"]),
                    "url": this.generateUrl(["page": myi], options["url"]),
                ]);
            } else {
                myvars = [
                    "text": this.Number.format(myi),
                    "url": this.generateUrl(["page": myi], options["url"]),
                ];
                result ~= mytemplater.format("number", myvars);
            }
        }
        result ~= options["after"];

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
     * @param Json[string] options An array of options.
     */
    string first(string|int myfirst = "<< first", Json[string] options  = null) {
        auto updatedOptions = options.updatetions.update[
            "url": Json.emptyArray,
            "escape": true.toJson,
        ];

        if (this.paginated().pageCount() <= 1) {
            return null;
        }
        string result = "";

        if (isInt(myfirst) && this.paginated().currentPage() >= myfirst) {
            for (myi = 1; myi <= myfirst; myi++) {
                result ~= this.templater().format("number", [
                    "url": this.generateUrl(["page": myi], options["url"]),
                    "text": this.Number.format(myi),
                ]);
            }
        } elseif (this.paginated().currentPage() > 1 && isString(myfirst)) {
            myfirst = options["escape"] ? htmlAttributeEscape(myfirst): myfirst;
            result ~= templater().format("first", [
                "url": generateUrl(["page": 1], options["url"]),
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
     * @param Json[string] options Array of options
     */
    string last(string|int mylast = "last >>", Json[string] options  = null) {
        auto updatedOptions = options.updatetions.update[
            "escape": true.toJson,
            "url": Json.emptyArray,
        ];

        mypageCount = (int)this.paginated().pageCount();
        if (mypageCount <= 1) {
            return null;
        }
        mycurrentPage = this.paginated().currentPage();

        string result = "";
        mylower = mypageCount - (int)mylast + 1;

        if (isInt(mylast) && mycurrentPage <= mylower) {
            for (myi = mylower; myi <= mypageCount; myi++) {
                result ~= this.templater().format("number", [
                    "url": this.generateUrl(["page": myi], options["url"]),
                    "text": this.Number.format(myi),
                ]);
            }
        } elseif (mycurrentPage < mypageCount && isString(mylast)) {
            mylast = options["escape"] ? htmlAttributeEscape(mylast): mylast;
            result ~= this.templater().format("last", [
                "url": this.generateUrl(["page": mypageCount], options["url"]),
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
     * this.Paginator.meta(["block": true.toJson]);
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
    string meta(Json[string] options  = null) {
        auto updatedOptions = options.updatetions.update[
            "block": false.toJson,
            "prev": true.toJson,
            "next": true.toJson,
            "first": false.toJson,
            "last": false.toJson,
        ];

        mylinks = null;

        if (options["prev"] && this.hasPrev()) {
            mylinks ~= this.Html.meta(
                "prev",
                this.generateUrl(
                    ["page": this.paginated().currentPage() - 1],
                    [],
                    ["escape": false.toJson, "fullBase": true.toJson]
                )
            );
        }
        if (options["next"] && this.hasNext()) {
            mylinks ~= this.Html.meta(
                "next",
                this.generateUrl(
                    ["page": this.paginated().currentPage() + 1],
                    [],
                    ["escape": false.toJson, "fullBase": true.toJson]
                )
            );
        }
        if (options["first"]) {
            mylinks ~= this.Html.meta(
                "first",
                this.generateUrl(["page": 1], [], ["escape": false.toJson, "fullBase": true.toJson])
            );
        }
        if (options["last"]) {
            mylinks ~= this.Html.meta(
                "last",
                this.generateUrl(
                    ["page": this.paginated().pageCount()],
                    [],
                    ["escape": false.toJson, "fullBase": true.toJson]
                )
            );
        }
        string result = join(mylinks);

        if (options["block"] == true) {
            options["block"] = __FUNCTION__;
        }
        if (options["block"]) {
           _View.append(options["block"], result);

            return null;
        }
        return result;
    }
        
    /**
     * Dropdown select for pagination limit.
     * This will generate a wrapping form.
     * Params:
     * STRINGAA mylimits The options array.
     * @param int mydefault Default option for pagination limit. Defaults to `this.param("perPage")`.
     * @param Json[string] options Options for Select tag attributes like class, id or event
     */
    string limitControl(Json[string] mylimits = [], int mydefault = null, Json[string] options  = null) {
        mylimits = mylimits ?: [
            "20": "20",
            "50": "50",
            "100": "100",
        ];
        mydefault ??= this.paginated().perPage();
        myscope = this.param("scope");
        assert(myscope.isNull || isString(myscope));
        if (myscope) {
            myscope ~= ".";
        }

        string result = this.Form.create(null, ["type": "get"]);
        result ~= this.Form.control(myscope ~ "limit", options ~ [
            "type": "select",
            "label": __("View"),
            "default": mydefault,
            "value": _View.getRequest().getQuery("limit"),
            "options": mylimits,
            "onChange": "this.form.submit()",
        ]);
        result ~= this.Form.end();

        return result;
    }
}
