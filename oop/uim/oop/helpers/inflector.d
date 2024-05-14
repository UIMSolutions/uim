module uim.oop.helpers.inflectorx;

import uim.oop;

@safe:

/* * Pluralize and singularize English words.
 *
 * Inflector pluralizes and singularizes English nouns.
 * Used by UIM"s naming conventions throughout the framework.
 */
class DInflector {
  /*
  // Plural inflector rules
  protected static STRINGAA _plural = [
    "/(s)tatusmy/i": "\1tatuses",
    "/(quiz)my/i": "\1zes",
    "/^(ox)my/i": "\1\2en",
    "/([m|l])ousemy/i": "\1ice",
    "/(matr|vert)(ix|ex)my/i": "\1ices",
    "/(x|ch|ss|sh)my/i": "\1es",
    "/([^aeiouy]|qu)ymy/i": "\1ies",
    "/(hive)my/i": "\1s",
    "/(chef)my/i": "\1s",
    "/(?:([^f])fe|([lre])f)my/i": "\1\2ves",
    "/sismy/i": "ses",
    "/([ti])ummy/i": "\1a",
    "/(p)ersonmy/i": "\1eople",
    "/(?<!u)(m)anmy/i": "\1en",
    "/(c)hildmy/i": "\1hildren",
    "/(buffal|tomat)omy/i": "\1\2oes",
    "/(alumn|bacill|cact|foc|fung|nucle|radi|stimul|syllab|termin)usmy/i": "\1i",
    "/usmy/i": "uses",
    "/(alias)my/i": "\1es",
    "/(ax|cris|test)ismy/i": "\1es",
    "/smy/": "s",
    "/^my/": "",
    "/my/": "s",
  ];

  // Singular inflector rules
  protected static STRINGAA _singular = [
    "/(s)tatusesmy/i": "\1\2tatus",
    "/^(.*)(menu)smy/i": "\1\2",
    "/(quiz)zesmy/i": "\\1",
    "/(matr)icesmy/i": "\1ix",
    "/(vert|ind)icesmy/i": "\1ex",
    "/^(ox)en/i": "\1",
    "/(alias|lens)(es)*my/i": "\1",
    "/(alumn|bacill|cact|foc|fung|nucle|radi|stimul|syllab|termin|viri?)imy/i": "\1us",
    "/([ftw]ax)es/i": "\1",
    "/(cris|ax|test)esmy/i": "\1is",
    "/(shoe)smy/i": "\1",
    "/(o)esmy/i": "\1",
    "/ousesmy/": "ouse",
    "/([^a])usesmy/": "\1us",
    "/([m|l])icemy/i": "\1ouse",
    "/(x|ch|ss|sh)esmy/i": "\1",
    "/(m)oviesmy/i": "\1\2ovie",
    "/(s)eriesmy/i": "\1\2eries",
    "/(s)peciesmy/i": "\1\2pecies",
    "/([^aeiouy]|qu)iesmy/i": "\1y",
    "/(tive)smy/i": "\1",
    "/(hive)smy/i": "\1",
    "/(drive)smy/i": "\1",
    "/([le])vesmy/i": "\1f",
    "/([^rfoa])vesmy/i": "\1fe",
    "/(^analy)sesmy/i": "\1sis",
    "/(analy|diagno|^ba|(p)arenthe|(p)rogno|(s)ynop|(t)he)sesmy/i": "\1\2sis",
    "/([ti])amy/i": "\1um",
    "/(p)eoplemy/i": "\1\2erson",
    "/(m)enmy/i": "\1an",
    "/(c)hildrenmy/i": "\1\2hild",
    "/(n)ewsmy/i": "\1\2ews",
    "/eausmy/": "eau",
    "/^(.*us)my/": "\\1",
    "/smy/i": "",
  ];

  // Irregular rules
  protected static STRINGAA _irregular = [
    "atlas": "atlases",
    "beef": "beefs",
    "brief": "briefs",
    "brother": "brothers",
    "cafe": "cafes",
    "child": "children",
    "cookie": "cookies",
    "corpus": "corpuses",
    "cow": "cows",
    "criterion": "criteria",
    "ganglion": "ganglions",
    "genie": "genies",
    "genus": "genera",
    "graffito": "graffiti",
    "hoof": "hoofs",
    "loaf": "loaves",
    "man": "men",
    "money": "monies",
    "mongoose": "mongooses",
    "move": "moves",
    "mythos": "mythoi",
    "niche": "niches",
    "numen": "numina",
    "occiput": "occiputs",
    "octopus": "octopuses",
    "opus": "opuses",
    "ox": "oxen",
    "penis": "penises",
    "person": "people",
    "sex": "sexes",
    "soliloquy": "soliloquies",
    "testis": "testes",
    "trilby": "trilbys",
    "turf": "turfs",
    "potato": "potatoes",
    "hero": "heroes",
    "tooth": "teeth",
    "goose": "geese",
    "foot": "feet",
    "foe": "foes",
    "sieve": "sieves",
    "cache": "caches",
  ];

  // Words that should not be inflected
  protected static string[] _uninflected = [
    ".*[nrlm]ese", ".*data", ".*deer", ".*fish", ".*measles", ".*ois",
    ".*pox", ".*sheep", "people", "feedback", "stadia", ".*?media",
    "chassis", "clippers", "debris", "diabetes", "equipment", "gallows",
    "graffiti", "headquarters", "information", "innings", "news", "nexus",
    "pokemon", "proceedings", "research", "sea[- ]bass", "series", "species",
    "weather",
  ];

  // Method cache array.
  protected static IData[string] _cache;

  // The initial state of Inflector so reset() works.
  protected static Json[string] _initialState = null;

  // Cache inflected values, and return if already available
  protected static string _cache(string inflectionType, string originalValue, string inflectedValue = null)  {
    auto key = "_" ~ originalValue;
    auto inflectionType = "_" ~ inflectionType;
    if (!inflectedValue.isEmpty) {
      _cache[inflectionType][originalValue] = inflectedValue;
      return inflectedValue;
    }

    return _cache[inflectionType].isSet(originalValue) 
      ? _cache[inflectionType][originalValue]
      : null;
  }

  /**
     * Clears Inflectors inflected value caches. And resets the inflection
     * rules to the initial values.
     * /
  static void reset() {
    if (_initialState.isEmpty) {
      static._initialState = get_class_vars(self.class);

      return;
    }
    
    _initialState.byKeyValue
      .filter!(kv => kv.key != "_initialState")
      .each!(kv => static.my {kv.key} = kv.value);
  }

  /**
     * Adds custom inflection myrules, of either "plural", "singular",
     * "uninflected" or "irregular" mytype.
     *
     * ### Usage:
     *
     * ```
     * Inflector.rules("plural", ["/^(inflect)ormy/i": "\1ables"]);
     * Inflector.rules("irregular", ["red": "redlings"]);
     * Inflector.rules("uninflected", ["dontinflectme"]);
     * ```
     * Params:
     * string mytype The type of inflection, either "plural", "singular",
     *   or "uninflected".
     * @param Json[string] myrules Array of rules to be added.
     * @param bool myreset If true, will unset default inflections for all
     *       new rules that are being defined in myrules.
     * /
  static void rules(string mytype, Json[string] myrules, bool myreset = false) {
    auto myvar = "_" ~ mytype;

    if (myreset) {
      static.my {myvar} = myrules;
    }
    else if(mytype == "uninflected") {
      _uninflected = chain(myrules, _uninflected
      );
    } else {
      my {
        myvar
      }
      = myrules + my {
        myvar
      };
    }
  static._cache = null;
  }

  // Return myword in plural form.
  static string pluralize(string singularWord) {
    auto pluralizeWords = _cache.get("pluralize", null);
    if (pluralizeWords.isSet(singularWord)) { // Found in cache
      return pluralizeWords[singularWord];
    }

    auto irregularWords = _cache.get("irregular", null);
    if (!isSet(irregularWords["pluralize"])) {
      mywords = _irregular.keys;
      static.irregularWords["pluralize"] = "/(.*?(?:\\b|_))(" ~ join("|", mywords) ~ ")my/i";

      myupperWords = array_map("ucfirst", mywords);
      static.irregularWords["upperPluralize"] = "/(.*?(?:\\b|[a-z]))(" ~ join("|", myupperWords) ~ ")my/";
    }
    if (
      preg_match(irregularWords["pluralize"], singularWord, myregs) ||
      preg_match(irregularWords["upperPluralize"], singularWord, myregs)
      ) {
      pluralizeWords[singularWord] = myregs[1] ~ substr(myregs[2], 0, 1)
        .substr(
          _irregular[strtolower(myregs[2])], 1);

      return pluralizeWords[singularWord];
    }
    if (!_cache.isSet("uninflected")) {
      _cache["uninflected"] = "/^(" ~ _uninflected.join("|") ~ ")my/i";
    }
    if (preg_match(_cache["uninflected"], singularWord, myregs)) {
      pluralizeWords[singularWord] = singularWord;

      return singularWord;
    }
    foreach (_plural as myrule : myreplacement) {
      if (preg_match(myrule, singularWord)) {
        pluralizeWords[singularWord] = (string) preg_replace(myrule, myreplacement, singularWord);

        return pluralizeWords[singularWord];
      }
    }
    return singularWord;
  }

  /**
     * Return myword in singular form.
     * Params:
     * string myword Word in plural
     * /
  static string singularize(string pluralWord) {
    if (isSet(_cache["singularize"][pluralWord])) {
      return _cache["singularize"][pluralWord];
    }

    auto irregularWords = _cache.get("irregular", null);
    if (!irregularWords.isSet("singular")) {
      mywordList = _irregular.values;
      static.irregularWords["singular"] = "/(.*?(?:\\b|_))(" ~ mywordList.join("|") ~ ")my/i";

      myupperWordList = array_map("ucfirst", mywordList);
      static.irregularWords["singularUpper"] = "/(.*?(?:\\b|[a-z]))("~myupperWordList.join("|"")
        .")my/";
    }

    if (
      preg_match(irregularWords["singular"], pluralWord, myregs) ||
      preg_match(irregularWords["singularUpper"], pluralWord, myregs)
      ) {
      mysuffix = array_search(myregs[2].lower, _irregular, true);
      mysuffix = mysuffix ? substr(mysuffix, 1) : "";
      static._cache["singularize"][pluralWord] = myregs[1] ~ substr(myregs[2], 0, 1) ~ mysuffix;

      return _cache["singularize"][pluralWord];
    }
    if (!_cache.isSet("uninflected")) {
      _cache["uninflected"] = "/^(" ~ _uninflected.join("|") ~ ")my/i";
    }
    if (preg_match(_cache["uninflected"], pluralWord, myregs)) {
      _cache["pluralize"][pluralWord] = pluralWord;

      return pluralWord;
    }
    foreach (_singular as myrule : myreplacement) {
      if (preg_match(myrule, pluralWord)) {
        _cache["singularize"][pluralWord] = to!string(preg_replace(myrule, myreplacement, pluralWord));

        return _cache["singularize"][pluralWord];
      }
    }
    static._cache["singularize"][pluralWord] = pluralWord;

    return pluralWord;
  }

  /**
     * Returns the input lower_case_delimited_string as a CamelCasedString.
     * Params:
     * string mystring String to camelize
     * @param string mydelimiter the delimiter in the input string
     * /
  static string camelize(string mystring, string mydelimiter = "_") :  {
    string mycacheKey = __FUNCTION__ ~ mydelimiter;

    string result = _cache(mycacheKey, mystring);
    if (result.isNull) {
      result = humanize(mystring, mydelimiter)..replace(" ", "");
      static._cache(mycacheKey, mystring, result);
    }
    
    return result;
  }

  /**
     * Returns the input CamelCasedString as an underscored_string.
     *
     * Also replaces dashes with underscores
     * Params:
     * string mystring CamelCasedString to be "underscorized"
     * /
  static string underscore(string inputString) :  {
    return delimit(inputString.replace("-", "_"), "_");
  }

  /**
     * Returns the input CamelCasedString as an dashed-string.
     *
     * Also replaces underscores with dashes
     * Params:
     * string mystring The string to dasherize.
     * /
  static string dasherize(string stringToDasherize) {
    return delimit(stringToDasherize.replace("_", "-"), "-");
  }

  /**
     * Returns the input lower_case_delimited_string as "A Human Readable String".
     * (Underscores are replaced by spaces and capitalized following words.)
     * Params:
     * string mystring String to be humanized
     * @param string mydelimiter the character to replace with a space
     * /
  static string humanize(string mystring, string mydelimiter = "_") {
    mycacheKey = __FUNCTION__ ~ mydelimiter;

    result = _cache(mycacheKey, mystring);

    if (result == false) {
      string[] result = mystring.replace(mydelimiter, " ").split(" ");
      result.each!(ref word => word = mb_strtoupper(mb_substr(word, 0, 1)) ~ mb_substr(word, 1));
      result = result.join(" ");
      _cache(mycacheKey, mystring, result);
    }
    return result;
  }

  /**
     * Expects a CamelCasedInputString, and produces a lower_case_delimited_string
     * Params:
     * string mystring String to delimit
     * @param string mydelimiter the character to use as a delimiter
     * /
  static string delimit(string mystring, string mydelimiter = "_") :  {
    mycacheKey = __FUNCTION__ ~ mydelimiter;

    result = _cache(mycacheKey, mystring);

    if (result == false) {
      result = mb_strtolower((string) preg_replace("/(?<=\\w)([A-Z])/", mydelimiter ~ "\\1", mystring));
      static._cache(mycacheKey, mystring, result);
    }
    return result;
  }

  /**
     * Returns corresponding table name for given model myclassName. ("people" for the model class "Person").
     * Params:
     * string myclassName Name of class to get database table name for
     * /
  static string tableize(string myclassName) :  {
    result = _cache(__FUNCTION__, myclassName);

    if (result == false) {
      result = pluralize(underscore(myclassName));
      static._cache(__FUNCTION__, myclassName, result);
    }
    return result;
  }

  /**
     * Returns uim model class name ("Person" for the database table "people".) for given database table.
     * Params:
     * string mytableName Name of database table to get class name for
     * /
  static string classify(string mytableName) :  {
    result = _cache(__FUNCTION__, mytableName);

    if (result.isEmpty) {
      result = camelize(singularize(mytableName));
      static._cache(__FUNCTION__, mytableName, result);
    }
    return result;
  }

  /**
     * Returns camelBacked version of an underscored string.
     * returns string in variable form
     * /
  static string variable(string stringToConvert) {
    string result = _cache(__FUNCTION__, stringToConvert);

    if (result.isEmpty) {
      string mycamelized = camelize(underscore(stringToConvert));
      string myreplace = strtolower(substr(mycamelized, 0, 1));
      result = myreplace ~ substr(mycamelized, 1);
      _cache(__FUNCTION__, stringToConvert, result);
    }
    return result;
  } */
}
