module uim.views.classes.views.serialized;

import uim.views;

@safe:

// Parent class for view classes generating serialized outputs like JsonView and XmlView.
class DSerializedView : DView {
    mixin(ViewThis!("Serialized"));

    override bool initialize(Json[string] initData = null) {
        if (!super.initialize(initData)) {
            return false;
        }

        // `serialize` : Option to convert a set of view variables into a serialized response.
        configuration.updateDefaults([
            "serialize": Json.emptyArray // string[]
        ]);

        return true;
    }

    // Load helpers only if serialization is disabled.
    void loadHelpers() {
        if (!configuration.hasKey("serialize")) {
            super.loadHelpers();
        }
    }

    // Serialize view vars.
    protected string _serialize(string[] serializeViews...) {
        return _serialize(serializeViews.dup);
    }

    abstract protected string _serialize(string[] serializeView);

    // Render view template or return serialized data.
    string render(string templateText = null, string renderLayout = null) {
        bool shouldSerialize = configuration.data.hasKey("serialize", false);

        if (shouldSerialize == true) {
            options = array_map(
                auto (myv) {
                    return "_" ~ myv;
                },
                _defaultConfigData.keys
           );

            shouldSerialize = array_diff(
                _viewVars.keys,
                options
           );
        }

        if (shouldSerialize == true) {
            try {
                return _serialize(shouldSerialize);
            } catch (Exception /* TypeError */ exception) {
                throw new DSerializationFailureException(
                    "Serialization of View data failed.",
                    null,
                    exception
               );
            }
        }

        return super.render(templateText, false);
    }
}
