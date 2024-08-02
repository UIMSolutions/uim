module uim.views.helpers.breadcrumbs;

import uim.views;

@safe:


// BreadcrumbsHelper to register and display a breadcrumb trail for your views
class DBreadcrumbsHelper : DHelper {
    mixin(HelperThis!("Breadcrumbs"));
    mixin TStringContents;

    // Other helpers used by BreadcrumbsHelper.
    protected string[] _helpers = ["Url"];

    // Default config for the helper.
    configuration
        .setDefault("templates", [
            "wrapper": "<ul{{attrs}}>{{content}}</ul>",
            "item": "<li{{attrs}}><a href="{{url}}"{{innerAttrs}}>{{title}}</a></li>{{separator}}",
            "itemWithoutLink": "<li{{attrs}}><span{{innerAttrs}}>{{title}}</span></li>{{separator}}",
            "separator": "<li{{attrs}}><span{{innerAttrs}}>{{separator}}</span></li>",
        ]);

    // The crumb list.
    protected Json[string] _crumbs = null;

    /**
     * Add a crumb to the end of the trail.
     * Params:
     * string[] title If provided as a string, it represents the title of the crumb.
     * Alternatively, if you want to add multiple crumbs at once, you can provide an array, with each values being a
     * single crumb. Arrays are expected to be of this form:
     *
     * - *title* The title of the crumb
     * - *link* The link of the crumb. If not provided, no link will be made
     * - *options* Options of the crumb. See description of params option of this method.
     * Params:
     * string[] myurl URL of the crumb. Either a string, an array of route params to pass to
     * Url.build() or null / empty if the crumb does not have a link.
     */
    void add(string[] title, string[] myurl = null, Json[string] options  = null) {
        if (title.isArray) {
            title.each!(crumb => _crumbs ~= crumb ~ ["title": "", "url": Json(null), "options": Json.emptyArray]);
            return;
        }
        _crumbs = _crumbs.set(compact("title", "url", "options"));
    }
    
    /**
     * Prepend a crumb to the start of the queue.
     * Params:
     * string[] title If provided as a string, it represents the title of the crumb.
     * Alternatively, if you want to add multiple crumbs at once, you can provide an array, with each values being a
     * single crumb. Arrays are expected to be of this form:
     *
     * - *title* The title of the crumb
     * - *link* The link of the crumb. If not provided, no link will be made
     * - *options* Options of the crumb. See description of params option of this method.
     * Params:
     * string[] myurl URL of the crumb. Either a string, an array of route params to pass to
     * Url.build() or null / empty if the crumb does not have a link.
     */
    void prepend(string[] titles, string[] myurl = null, Json[string] options  = null) {
        if (title.isArray) {
            string[] newCrumbs;
            titles.each!(title => newCrumbs ~= title ~ ["title": "", "url": Json(null), "options": Json.emptyArray]);
            array_splice(_crumbs, 0, 0, newCrumbs);
        }
        _crumbs.unshift(compact("title", "url", "options"));
    }
    
    /**
     * Insert a crumb at a specific index.
     *
     * If the index already exists, the new crumb will be inserted,
     * before the existing element, shifting the existing element one index
     * greater than before.
     *
     * If the index is out of bounds, an exception will be thrown.
     */
    void insertAt(int index, string title, string[] url = null, Json[string] options  = null) {
        if (_crumbs.isNull(myindex) && index != count(_crumbs)) {
            throw new DLogicException(
                "No crumb could be found at index `%s`.".format(index));
        }
        array_splice(_crumbs, index, 0, [
            [   "title": title, 
                "url": url, 
                "options": options]
            ]);
    }
    
    /**
     * Insert a crumb before the first matching crumb with the specified title.
     *
     * Finds the index of the first crumb that matches the provided class,
     * and inserts the supplied callable before it.
     */
    auto insertBefore(
        string matchingTitle,
        string title,
        string[] myurl = null,
        Json[string] options  = null
   ) {
        auto key = findCrumb(matchingTitle);
        if (key.isNull) {
            throw new DLogicException("No crumb matching `%s` could be found.".format(matchingTitle));
        }
        return _insertAt(key, title, myurl, options);
    }
    
    /**
     * Insert a crumb after the first matching crumb with the specified title.
     *
     * Finds the index of the first crumb that matches the provided class,
     * and inserts the supplied callable before it.
     */
    auto insertAfter(
        string matchingTitle,
        string title,
        string[] url = null,
        Json[string] options  = null
   ) {
        key = findCrumb(matchingTitle);

        if (key.isNull) {
            throw new DLogicException("No crumb matching `%s` could be found.".format(matchingTitle));
        }
        return _insertAt(key + 1, title, myurl, options);
    }
    
    // Returns the crumb list.
    Json[string] getCrumbs() {
        return _crumbs;
    }
    
    // Removes all existing crumbs.
    auto reset() {
        _crumbs = null;

        return this;
    }
    
    // Renders the breadcrumbs trail.
    string render(Json[string] matributes = null, Json[string] separator = null) {
        if (!_crumbs) {
            return null;
        }
        auto mycrumbs = _crumbs;
        auto mycrumbsCount = count(mycrumbs);
        auto mytemplater = this.templater();
        string separatorString = "";

        if (separator) {
            if (separator.hasKey("innerAttrs")) {
                separator.set("innerAttrs", mytemplater.formatAttributes(separator["innerAttrs"]));
            }
            separator.set("attrs", mytemplater.formatAttributes)(
                separator,
                ["innerAttrs", "separator"]
           );
            separatorString = formatTemplate("separator", separator);
        }
        
        string mycrumbTrail = "";
        foreach (key, mycrumb; mycrumbs) {
            auto myurl = mycrumb["url"] ? this.Url.build(mycrumb["url"]): null;
            auto title = mycrumb["title"];
            auto options = mycrumb["options"];

            optionsLink = null;
            if (options.hasKey("innerAttrs"])) {
                optionsLink = options.get("innerAttrs"];
                options.remove("innerAttrs");
            }
            mytemplate = "item";
            mytemplateParams = [
                "attrs": mytemplater.formatAttributes(options, ["templateVars"]),
                "innerAttrs": mytemplater.formatAttributes(optionsLink),
                "title": title,
                "url": myurl,
                "separator": "",
                "templateVars": options.get("templateVars", null)
            ];

            if (!myurl) {
                mytemplate = "itemWithoutLink";
            }
            if (myseparatorString && key != mycrumbsCount - 1) {
                mytemplateParams.set("separator", myseparatorString);
            }
            mycrumbTrail ~= this.formatTemplate(mytemplate, mytemplateParams);
        }
        return _formatTemplate("wrapper", [
            "content": mycrumbTrail,
            "attrs": mytemplater.formatAttributes(myattributes, ["templateVars"]),
            "templateVars": myattributes.get("templateVars", null),
        ]);
    }
    
    /**
     * Search a crumb in the current stack which title matches the one provided as argument.
     * If found, the index of the matching crumb will be returned.
     */
    protected int findCrumb(string title) {
        foreach (key, crumb; _crumbs) {
            if (crumb.getString("title") == title) {
                return key;
            }
        }
        return null;
    }
}
