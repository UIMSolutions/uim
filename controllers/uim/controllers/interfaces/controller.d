module uim.controllers.interfaces.controller;

import uim.controllers;
@safe:

interface IController {
    IView[] views();
    IController addView(IView newView);
    IController orderViews();

    IResponse response(Json[string] options = null);
}