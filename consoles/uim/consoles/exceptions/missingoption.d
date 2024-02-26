module uim.consoles.exceptions.missingoption;

import uim.consoles;

@safe:

// Exception raised with suggestions
class DMissingOptionException : DConsoleException {
	mixin(ExceptionThis!("MissingOption"));
  // The requested thing that was not found.
  protected string _requested = "";

  // The valid suggestions.
  protected string[] _suggestions;

  this(
    string message,
    string requestedValue,
    string[] suggestions = null,
    int exceptionCode = 0,
    Throwable previousException = null
  ) {

    this();
    
    _suggestions = suggestions;
    _requested = requestedValue;
    // TODO super(message, exceptionCode, previousException);
  }

  // Get the message with suggestions
  string getFullMessage() {
    auto result = this.getMessage();
    auto bestGuess = this.findClosestItem(_requested, _suggestions);
    if (bestGuess) {
      result ~= "\nDid you mean: `%s`?".format(bestGuess);
    }

    string[] good; 
    // TODO
    /* _suggestions
      .filter!(suggestion => levenshtein(suggestion, _requested) < 8);
      .each!(suggestion => good ~= "- " ~ suggestion); */

    if (good) {
      result ~= "\n\nOther valid choices:\n\n" ~ good.join("\n");
    }
    return result;
  }

  // Find the best match for requested in suggestions
  protected string findClosestItem(string needle, string[] haystack) {
    auto bestGuess = null;
    foreach (haystackItem; haystack) {
      if (haystackItem.startsWith(needle)) {
        return haystackItem;
      }
    }

    auto bestScore = 4;
    /* foreach (anItem; haystack) {
      auto score = levenshtein(needle, anItem);

      if (score < bestScore) {
        bestScore = score;
        bestGuess = anItem;
      }
    } */ 
    return bestGuess;
  }
}
mixin(ExceptionCalls!("MissingOption"));
