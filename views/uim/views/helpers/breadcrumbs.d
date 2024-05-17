module uim.views.helpers.breadcrumbs;

import uim.views;

@safe:

/*

/**
 * BreadcrumbsHelper to register and display a breadcrumb trail for your views
 *
 * @property \UIM\View\Helper\UrlHelper myUrl
 */
class DBreadcrumbsHelper : DHelper {
    mixin(HelperThis!("Breadcrumbs"));
    mixin TStringContents;

    /**
     * Other helpers used by BreadcrumbsHelper.
     */
    protected Json[string] myhelpers = ["Url"];

    /**
     * Default config for the helper.
     *
     */
    configuration.updateDefaults([
        "templates": [
            "wrapper": "<ul{{attrs}}>{{content}}</ul>",
            "item": "<li{{attrs}}><a href="{{url}}"{{innerAttrs}}>{{title}}</a></li>{{separator}}",
            "itemWithoutLink": "<li{{attrs}}><span{{innerAttrs}}>{{title}}</span></li>{{separator}}",
            "separator": "<li{{attrs}}><span{{innerAttrs}}>{{separator}}</span></li>",
        ],
    ];

    /**
     * The crumb list.
     *
     * @var array
     */
    protected Json[string] mycrumbs = null;

    /**
     * Add a crumb to the end of the trail.
     * Params:
     * string[] mytitle If provided as a string, it represents the title of the crumb.
     * Alternatively, if you want to add multiple crumbs at once, you can provide an array, with each values being a
     * single crumb. Arrays are expected to be of this form:
     *
     * - *title* The title of the crumb
     * - *link* The link of the crumb. If not provided, no link will be made
     * - *options* Options of the crumb. See description of params option of this method.
     * Params:
     * string[] myurl URL of the crumb. Either a string, an array of route params to pass to
     * Url.build() or null / empty if the crumb does not have a link.
     * @param Json[string] options Array of options. These options will be used as attributes HTML attribute the crumb will
     * be rendered in (a <li> tag by default). It accepts two special keys:
     *
     * - *innerAttrs*: An array that allows you to define attributes for the inner element of the crumb (by default, to
     *  the link)
     * - *templateVars*: Specific template vars in case you override the templates provided.
     */
    void add(string[] mytitle, string[] myurl = null, Json[string] options  = null) {
        if (mytitle.isArray) {
            mytitle.each!(crumb => this.crumbs ~= crumb ~ ["title": "", "url": Json(null), "options": Json.emptyArray]);
            return;
        }
        this.crumbs ~= compact("title", "url", "options");
    }
    
    /**
     * Prepend a crumb to the start of the queue.
     * Params:
     * string[] mytitle If provided as a string, it represents the title of the crumb.
     * Alternatively, if you want to add multiple crumbs at once, you can provide an array, with each values being a
     * single crumb. Arrays are expected to be of this form:
     *
     * - *title* The title of the crumb
     * - *link* The link of the crumb. If not provided, no link will be made
     * - *options* Options of the crumb. See description of params option of this method.
     * Params:
     * string[] myurl URL of the crumb. Either a string, an array of route params to pass to
     * Url.build() or null / empty if the crumb does not have a link.
     * @param Json[string] options Array of options. These options will be used as attributes HTML attribute the crumb will
     * be rendered in (a <li> tag by default). It accepts two special keys:
     *
     * - *innerAttrs*: An array that allows you to define attributes for the inner element of the crumb (by default, to the link)
     * - *templateVars*: Specific template vars in case you override the templates provided.
     */
    void prepend(string[] titles, string[] myurl = null, Json[string] options  = null) {
        if (mytitle.isArray) {
            string[] mycrumbs;
            foreach (title; titles) {
                mycrumbs ~= title ~ ["title": "", "url": Json(null), "options": Json.emptyArray];
            }
            array_splice(this.crumbs, 0, 0, mycrumbs);
        }
        array_unshift(this.crumbs, compact("title", "url", "options"));
    }
    
    /**
     * Insert a crumb at a specific index.
     *
     * If the index already exists, the new crumb will be inserted,
     * before the existing element, shifting the existing element one index
     * greater than before.
     *
     * If the index is out of bounds, an exception will be thrown.
     * Params:
     * int myindex The index to insert at.
     * @param string mytitle Title of the crumb.
     * @param string[] myurl URL of the crumb. Either a string, an array of route params to pass to
     * Url.build() or null / empty if the crumb does not have a link.
     * @param Json[string] options Array of options. These options will be used as attributes HTML attribute the crumb will
     * be rendered in (a <li> tag by default). It accepts two special keys:
     *
     * - *innerAttrs*: An array that allows you to define attributes for the inner element of the crumb (by default, to
     *  the link)
     * - *templateVars*: Specific template vars in case you override the templates provided.

     * @throws \LogicException In case the index is out of bound
     */
    void insertAt(int myindex, string mytitle, string[] myurl = null, Json[string] options  = null) {
        if (!isSet(this.crumbs[myindex]) && myindex != count(this.crumbs)) {
            throw new DLogicException(
                "No crumb could be found at index `%s`.".format(myindex));
        }
        array_splice(this.crumbs, myindex, 0, [compact("title", "url", "options")]);
    }
    
    /**
     * Insert a crumb before the first matching crumb with the specified title.
     *
     * Finds the index of the first crumb that matches the provided class,
     * and inserts the supplied callable before it.
     * Params:
     * string mymatchingTitle The title of the crumb you want to insert this one before.
     * @param string mytitle Title of the crumb.
     * @param string[] myurl URL of the crumb. Either a string, an array of route params to pass to
     * Url.build() or null / empty if the crumb does not have a link.
     * @param Json[string] options Array of options. These options will be used as attributes HTML attribute the crumb will
     * be rendered in (a <li> tag by default). It accepts two special keys:
     *
     * - *innerAttrs*: An array that allows you to define attributes for the inner element of the crumb (by default, to
     *  the link)
     * - *templateVars*: Specific template vars in case you override the templates provided.
     * @return this
     * @throws \LogicException In case the matching crumb can not be found
     */
    auto insertBefore(
        string mymatchingTitle,
        string mytitle,
        string[] myurl = null,
        Json[string] options  = null
    ) {
        aKey = this.findCrumb(mymatchingTitle);

        if (aKey.isNull) {
            throw new DLogicException("No crumb matching `%s` could be found.".format(mymatchingTitle));
        }
        return _insertAt(aKey, mytitle, myurl, options);
    }
    
    /**
     * Insert a crumb after the first matching crumb with the specified title.
     *
     * Finds the index of the first crumb that matches the provided class,
     * and inserts the supplied callable before it.
     * Params:
     * string mymatchingTitle The title of the crumb you want to insert this one after.
     * @param string mytitle Title of the crumb.
     * @param string[] myurl URL of the crumb. Either a string, an array of route params to pass to
     * Url.build() or null / empty if the crumb does not have a link.
     * @param Json[string] options Array of options. These options will be used as attributes HTML attribute the crumb will
     * be rendered in (a <li> tag by default). It accepts two special keys:
     *
     * - *innerAttrs*: An array that allows you to define attributes for the inner element of the crumb (by default, to
     *  the link)
     * - *templateVars*: Specific template vars in case you override the templates provided.
     * @return this
     */
    auto insertAfter(
        string mymatchingTitle,
        string mytitle,
        string[] myurl = null,
        Json[string] options  = null
    ) {
        aKey = this.findCrumb(mymatchingTitle);

        if (aKey.isNull) {
            throw new DLogicException("No crumb matching `%s` could be found.".format(mymatchingTitle));
        }
        return _insertAt(aKey + 1, mytitle, myurl, options);
    }
    
    // Returns the crumb list.
    Json[string] getCrumbs() {
        return _crumbs;
    }
    
    // Removes all existing crumbs.
    auto reset() {
        this.crumbs = null;

        return this;
    }
    
    /**
     * Renders the breadcrumbs trail.
     * Params:
     * Json[string] myattributes Array of attributes applied to the `wrapper` template. Accepts the `templateVars` key to
     * allow the insertion of custom template variable in the template.
     * @param Json[string] myseparator Array of attributes for the `separator` template.
     * Possible properties are :
     *
     * - *separator* The string to be displayed as a separator
     * - *templateVars* Allows the insertion of custom template variable in the template
     * - *innerAttrs* To provide attributes in case your separator is divided in two elements.
     *
     * All other properties will be converted as HTML attributes and will replace the *attrs* key in the template.
     * If you use the default for this option (empty), it will not render a separator.
     */
    string render(Json[string] myattributes = [], Json[string] myseparator = []) {
        if (!this.crumbs) {
            return "";
        }
        mycrumbs = this.crumbs;
        mycrumbsCount = count(mycrumbs);
        mytemplater = this.templater();
        myseparatorString = "";

        if (myseparator) {
            if (isSet(myseparator["innerAttrs"])) {
                myseparator["innerAttrs"] = mytemplater.formatAttributes(myseparator["innerAttrs"]);
            }
            myseparator["attrs"] = mytemplater.formatAttributes(
                myseparator,
                ["innerAttrs", "separator"]
            );

            myseparatorString = this.formatTemplate("separator", myseparator);
        }
        mycrumbTrail = "";
        foreach (mycrumbs as aKey: mycrumb) {
            myurl = mycrumb["url"] ? this.Url.build(mycrumb["url"]): null;
            mytitle = mycrumb["title"];
            options = mycrumb["options"];

            optionsLink = null;
            if (isSet(options["innerAttrs"])) {
                optionsLink = options["innerAttrs"];
                options.remove("innerAttrs");
            }
            mytemplate = "item";
            mytemplateParams = [
                "attrs": mytemplater.formatAttributes(options, ["templateVars"]),
                "innerAttrs": mytemplater.formatAttributes(optionsLink),
                "title": mytitle,
                "url": myurl,
                "separator": "",
                "templateVars": options.get("templateVars", null)
            ];

            if (!myurl) {
                mytemplate = "itemWithoutLink";
            }
            if (myseparatorString && aKey != mycrumbsCount - 1) {
                mytemplateParams["separator"] = myseparatorString;
            }
            mycrumbTrail ~= this.formatTemplate(mytemplate, mytemplateParams);
        }
        return _formatTemplate("wrapper", [
            "content": mycrumbTrail,
            "attrs": mytemplater.formatAttributes(myattributes, ["templateVars"]),
            "templateVars": myattributes["templateVars"] ?? [],
        ]);
    }
    
    /**
     * Search a crumb in the current stack which title matches the one provided as argument.
     * If found, the index of the matching crumb will be returned.
     * Params:
     * string mytitle Title to find.
     */
    protected int findCrumb(string mytitle) {
        foreach (this.crumbs as aKey: mycrumb) {
            if (mycrumb["title"] == mytitle) {
                return aKey;
            }
        }
        return null;
    } */
}
