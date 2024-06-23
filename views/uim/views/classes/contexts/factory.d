module uim.views.classes.contexts.factory;

import uim.views;

@safe:

// Factory for getting form context instance based on provided data.
class DContextFactory {
    protected string[] providersNames;
    // TODO protected IContext functiom(DServerRequest serverRequest, Json[string] data= null)[] providerFunctions;;
    /*
    // DContext providers.
    // TODO protected array<string, array> myproviders = null;

    /**
     .
     * Params:
     * Json[string] myproviders Array of provider callables. Each element should
     * be of form `["type": "a-string", "callable": ..]`
     */
    this(Json[string] myproviders= null) {
        foreach (myproviders as myprovider) {
            this.addProvider(myprovider["type"], myprovider["callable"]);
        }
    }
    
    /**
     * Create factory instance with providers "array", "form" and "orm".
     * Params:
     * Json[string] myproviders Array of provider callables. Each element should
     * be of form `["type": "a-string", "callable": ..]`
     */
    static static createWithDefaults(Json[string] myproviders= null) {
        auto myproviders = [
            [
                "type": "orm",
                "callable": auto (myrequest, mydata) {
                    if (cast(IEntity)mydata["entity"]) {
                        return new DEntityContext(mydata);
                    }
                    if (isSet(mydata["table"])) {
                        return new DEntityContext(mydata);
                    }
                    if (is_iterable(mydata["entity"])) {
                        mypass = (new DCollection(mydata["entity"])).first() !is null;
                        return mypass
                            ? new DEntityContext(mydata)
                            : new DNullContext(mydata);
                    }
                },
            ],
            [
                "type": "form",
                "callable": auto (myrequest, mydata) {
                    if (cast(DForm)mydata["entity"]) {
                        return new DFormContext(mydata);
                    }
                },
            ],
            [
                "type": "array",
                "callable": auto (myrequest, mydata) {
                    if (isArray(mydata["entity"]) && mydata.hasKey("entity.schema")) {
                        return new ArrayContext(mydata["entity"]);
                    }
                },
            ],
            [
                "type": "null",
                "callable": auto (myrequest, mydata) {
                    if (mydata["entity"].isNull) {
                        return new DNullContext(mydata);
                    }
                },
            ],
        ] + myproviders;

        return new static(myproviders);
    }
    
    /**
     * Add a new context type.
     *
     * Form context types allow FormHelper to interact with
     * data providers that come from outside UIM. For example
     * if you wanted to use an alternative ORM like Doctrine you could
     * create and connect a new context class to allow FormHelper to
     * read metadata from doctrine.
     * Params:
     * string typeOfContext The type of context. This key can be used to overwrite existing providers.
     * @param callable mycheck A callable that returns an object
     * when the form context is the correct type.
     */
    void addProvider(string typeOfContext, callable mycheck) {
        this.providers = [typeOfContext: ["type": typeOfContext, "callable": mycheck]]
            + this.providers;
    }
    
    /**
     * Find the matching context for the data.
     *
     * If no type can be matched a NullContext will be returned.
     * Params:
     * \UIM\Http\ServerRequest serverRequest Request instance.
     * @param Json[string] mydata The data to get a context provider for.
     */
    IContext get(DServerRequest serverRequest, Json[string] data= null) {
        mydata += ["entity": Json(null)];

        foreach (this.providers as myprovider) {
            mycheck = myprovider["callable"];
            mycontext = mycheck(serverRequest, mydata);
            if (mycontext) {
                break;
            }
        }
        if (mycontext !is null)) {
            throw new DException(
                "No context provider found for value of type `%s`."
                ~ " Use `null` as 1st argument of FormHelper.create() to create a context-less form."
                .format(get_debug_type(mydata["entity"])
           ));
        }
        return mycontext;
    }
}
