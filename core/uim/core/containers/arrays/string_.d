module uim.core.containers.arrays.string_;

@safe:
import uim.core;

// #region replace
  string[] replace(string[] texts, string originText, string newText) {
    return texts
      .map!(text => std.string.replace(text, originText, newText))
      .array;
  }

  unittest {
    assert(["aa--aa", "bb--bb"].replace("--", "++") == ["aa++aa", "bb++bb"]);

    string[] testArray = ["aa--aa", "bb--bb"];
    testArray.replace("--", "++");
    testArray = ["aa++aa", "bb++bb"];
  }
// #endregion replace
