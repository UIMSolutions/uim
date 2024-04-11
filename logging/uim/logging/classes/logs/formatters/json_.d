module uim.logs.Formatter;

class DJsonFormatter : DAbstractFormatter {
    protected IData[string] configuration.updateDefaults([
        "dateFormat": DATE_ATOM,
        "flags": IData_UNESCAPED_UNICODE | IData_UNESCAPED_SLASHES,
        "appendNewline": BooleanData(true),
    ];

    // configData - Formatter config
    this(IData[string] configData = null) {
        configuration.update(configData);
    }
 
    string|int|false format(level, string amessage, array context = []) {
        auto log = ["date": date(configuration["dateFormat"]), "level": to!string(level), "message": message];
        auto IData = IData_encode(log, IData_THROW_ON_ERROR | configuration["flags"]);

        return configuration["appendNewline"] ? IData ~ "\n" : IData;
    }
}
