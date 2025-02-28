/****************************************************************************************************************
* Copyright: © 2017-2024 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.views.classes.views.ajax;

import uim.views;
@safe:

version (test_uim_views) {
  unittest {
    writeln("-----  ", __MODULE__, "\t  -----");
  }
}


/**
 * A view class that is used for AJAX responses.
 * Currently, only switches the default layout and sets the response type - which just maps to
 * text/html by default.
 */
class DAjaxView : DView {
    mixin(ViewThis!("Ajax"));

    protected string _layout = "ajax";

    // Get content type for this view.
    static string contentType() {
        return "text/html";
    }
}

mixin(ViewCalls!("Ajax"));
