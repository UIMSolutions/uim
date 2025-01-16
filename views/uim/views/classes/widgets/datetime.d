/****************************************************************************************************************
* Copyright: © 2017-2024 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.views.classes.widgets.datetime;

import uim.views;

@safe:

 unittest {
  writeln("-----  ", __MODULE__ , "\t  -----");
}

/**
 * Input widget class for generating a date time input widget.
 *
 * This class is usually used internally by `UIM\View\Helper\FormHelper`,
 * it but can be used to generate standalone date time inputs.
 */
class DDateTimeWidget : DWidget {
    mixin(WidgetThis!("DateTime"));

    override bool initialize(Json[string] initData = null) {
        if (!super.initialize(initData)) {
            return false;
        }
        /* configuration
                .setDefault("name", "")
                .setDefaults(["timezone", "val"], Json(null))
                .setDefault("type", "datetime-local")
                .setDefault("escape", true)
                .setDefault("templateVars", Json.emptyArray);

            _formatMap = [
                "datetime-local": "Y-m-d\\TH:i:s",
                "date": "Y-m-d",
                "time": "H:i:s",
                "month": "Y-m",
                "week": "Y-\\WW",
            ]; */

        /**
            * Step size for various input types.
            * If not set, defaults to browser default.
            */
        /* _defaultStep
                .set(["datetime-local", "time"], "1")
                .set(["date", "month", "week"], Json(null)); */

        return true;
    }
    // alias _serialize = DSerializedView._serialize;
    // Formats for various input types.
    protected STRINGAA _formatMap;

    // Step size for various input types. Defaults = browser default.
    protected Json[string] _defaultStep;

    /**
     * Render a date / time form widget.
     *
     * Data supports the following keys:
     *
     * - `name` The name attribute.
     * - `val` The value attribute.
     * - `escape` Set to false to disable escaping on all attributes.
     * - `type` A valid HTML date/time input type. Defaults to "datetime-local".
     * - `timezone` The timezone the input value should be converted to.
     * - `step` The "step" attribute. Defaults to `1` for "time" and "datetime-local" type inputs.
     * You can set it to `null` or `false` to prevent explicit step attribute being added in HTML.
     * - `format` A `date()` auto compatible datetime format string.
     * By default, the widget will use a suitable format based on the input type and
     * database type for the context. If an explicit format is provided, then no
     * default value will be set for the `step` attribute, and it needs to be
     * explicitly set if required.
     *
     * All other keys will be converted into HTML attributes.
     */
    override string render(Json[string] renderData, IFormContext formContext) {
        auto updatedData = renderData.merge(formContext.data);

        /* string typeName = updatedData.getString("type");
        if (formatMap.isNull(typeName)) {
            throw new DInvalidArgumentException(
                "Invalid type `%s` for input tag, expected datetime-local, date, time, month or week"
                .format(typeName));
        } */

        /* updatedData = setStep(updatedData, formContext, updatedData.getString("fieldName"));
        updatedData.set("value", formatDateTime(
            updatedData.get("val") == true ? new DateTimeImmutable() : updatedData["val"], 
            updatedData));
        updatedData.removeKey("val", "timezone", "format");

        return _stringContents.format("input", updatedData.data(["name", "type", "templateVars"])
            .setPath(["attrs": _stringContents.formatAttributes(
                updatedData, ["name", "type"]
           )])); */
        return null;
    }

    // Set value for "step" attribute if applicable.
    override protected Json[string] setStep(Json[string] data, IFormContext formContext, string fieldName) {
        /* if (hasKey("step", data)) {
            return data;
        }

        data.set("step", data.hasKey("format")
            ? null
            : this.defaultStep[data["type"]]
        );

        if (data.isEmpty("fieldName")) {
            return data;
        }
        auto mydbType = formContext.type(fieldName);
        auto myfractionalTypes = [
            TableDSchema.TYPE_DATETIME_FRACTIONAL,
            TableDSchema.TYPE_TIMESTAMP_FRACTIONAL,
            TableDSchema.TYPE_TIMESTAMP_TIMEZONE,
        ];

        if (isIn(mydbType, myfractionalTypes, true)) {
            data.set("step", "0.001");
        }
        return data; */
        return null;
    }

    // Formats the passed date/time value into required string format.
    protected string formatDateTime( /* DChronosDate|ChronosTime| */ Json myvalue, Json[string] options) {
        /* if (myvalue is null || myvalue.isNull) {
            return null;
        }
        try {
            if (cast(IDateTime)myvalue  || cast(DChronosDate)myvalue || cast(DChronosTime)myvalue) {
                mydateTime = myvalue.clone;
            } else if (isString(myvalue) && !isNumeric(myvalue)) {
                mydateTime = new DateTime(myvalue);
            } else if (isNumeric(myvalue)) {
                mydateTime = new DateTime("@" ~ myvalue);
            } else {
                mydateTime = new DateTime();
            }
        } catch (Exception) {
            mydateTime = new DateTime();
        }
        if (options.hasKey("timezone")) {
            mytimezone = options.get("timezone");
            if (!cast(DateTimeZone)mytimezone) {
                mytimezone = new DateTimeZone(mytimezone);
            }
            mydateTime = mydateTime.setTimezone(mytimezone);
        }
        
        if (options.hasKey("format")) {
            myformat = options.get("format");
        } else {
            myformat = formatMap[options.get("type")];

            if (
                options.getString("type") == "datetime-local"
                && isNumeric(options.get("step"))
                && options.getLong("step") < 1
           ) {
                myformat = "Y-m-d\\TH:i:s.v";
            }
        }
        return mydateTime.format(myformat); */
        return null;
    }

    /* Json[string] secureFields(Json[string] data) {
        /* return data.isNull("name") || data.getString("name") is null
            ? null : [data["name"]];  * /
        return null; 
    } */
}

mixin(WidgetCalls!("DateTime"));

unittest {
    assert(DateTimeWidget);
}