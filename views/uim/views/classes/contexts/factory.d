/****************************************************************************************************************
* Copyright: © 2017-2024 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.views.classes.contexts.factory;

import uim.views;

@safe:
unittest {
    writeln("-----  ", __MODULE__, "\t  -----");
}

// Factory for getting form context instance based on provided data.
class DContextFactory {
    protected string[] providersNames;
    // TODO protected IContext function(DServerRequest serverRequest, Json[string] data = null)[] providerFunctions;;

    // DContext providers.
    // TODO protected array<string, array> myproviders = null;

    /* this(Json[string] myproviders= null) {
        foreach (myprovider; myproviders) {
            addProvider(myprovider["type"], myprovider["callable"]);
        }
    } */

    /**
     * Create factory instance with providers "array", "form" and "orm".
     * Params:
     * Json[string] myproviders Array of provider callables. Each element should
     * be of form `["type": "a-string", "callable": ..]`
     */
    /* static auto createWithDefaults(Json[string] myproviders= null) {
        auto myproviders = [
            [
                "type": "orm",
                "callable": auto (myrequest, mydata) {
                    if (cast(IEntity)mydata["entity"]) {
                        return new DEntityContext(mydata);
                    }
                    if (mydata.hasKey("table")) {
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
                    if (mydata.isNull("entity")) {
                        return new DNullContext(mydata);
                    }
                },
            ],
        ] + myproviders;

        return new static(myproviders);
    } */

    /**
     * Add a new context type.
     *
     * Form context types allow FormHelper to interact with
     * data providers that come from outside UIM. For example
     * if you wanted to use an alternative ORM like Doctrine you could
     * create and connect a new context class to allow FormHelper to
     * read metadata from doctrine.
     */
    /* void addProvider(string typeOfContext, callable mycheck) {
        _providers = [typeOfContext: ["type": typeOfContext, "callable": mycheck]]
            + _providers;
    } */

    /**
     * Find the matching context for the data.
     *
     * If no type can be matched a NullContext will be returned.
     */
    /* IContext get(DServerRequest serverRequest, Json[string] data = null) {
        mydata.mergeKeys(["entity"]);

        foreach (myprovider; _providers) {
            auto mycheck = myprovider["callable"];
            auto context = mycheck(serverRequest, mydata);
            if (context) {
                break;
            }
        }
        if (context !is null) {
            throw new UIMException(
                "No context provider found for value of type `%s`."
                ~ " Use `null` as 1st argument of FormHelper.create() to create a context-less form."
                .format(get_debug_type(mydata["entity"])
           ));
        }
        return context;
    } */
}
