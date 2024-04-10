module controllers.uim.controllers.classes.components.checkhttpcache;

import uim.controllers;

@safe:

/* * Use HTTP caching headers to see if rendering can be skipped.
 *
 * Checks if the response can be considered different according to the request
 * headers, and caching headers in the response. If the response was not modified,
 * then the controller and view render process is skipped. And the client will get a
 * response with an empty body and a "304 Not Modified" header.
 *
 * To use this component your controller actions must set either the `Last-Modified`
 * or `Etag` header. Without one of these headers being set this component
 * will have no effect.
 */
class DCheckHttpCacheComponent : DComponent {
  // Before Render hook
  void beforeRender(IEvent beforeRenderEvent) {
    auto controller = this.getController();
    auto controllerResponse = controller.getResponse();
    auto controllerRequest = controller.getRequest();
    if (!controllerResponse.isNotModified(controllerRequest)) {
      return;
    }
    controller.setResponse(controllerResponse.withNotModified());
    beforeRenderEvent.stopPropagation();
  }
}
