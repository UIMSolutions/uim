module uim.core.containers.arrays.string_;

import uim.core;
@safe:

unittest {
  writeln("-----  ", __MODULE__ , "\t  -----");
}

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
