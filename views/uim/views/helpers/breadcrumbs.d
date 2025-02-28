module uim.views.helpers.breadcrumbs;

import uim.views;
@safe:

version (test_uim_views) {
  unittest {
    writeln("-----  ", __MODULE__, "\t  -----");
  }
} 

// BreadcrumbsHelper to register and display a breadcrumb trail for your views
class BreadcrumbsHelper : DHelper {
    mixin(HelperThis!("Breadcrumbs"));
    mixin TStringContents;
}