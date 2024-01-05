/***********************************************************************************
*	Copyright: ©2015-2023 Ozan Nurettin Süel (sicherheitsschmiede)                   *
*	License  : Licensed under Apache 2 [https://apache.org/licenses/LICENSE-2.0.txt] *
*	Author   : Ozan Nurettin Süel (Sicherheitsschmiede)										           * 
***********************************************************************************/
/**
Source Wikipedia [EN]:
In software engineering, multitier architecture (often referred to as n-tier architecture) or multilayer architecture is a client–server architecture 
in which presentation, application processing and data management functions are physically separated. The most widespread use of multitier architecture 
is the three-tier architecture.

N-tier application architecture provides a model by which developers can create flexible and reusable applications. By segregating an application into 
tiers, developers acquire the option of modifying or adding a specific layer, instead of reworking the entire application. A three-tier architecture 
is typically composed of a presentation tier, a logic tier, and a data tier.

While the concepts of layer and tier are often used interchangeably, one fairly common point of view is that there is indeed a difference. This view 
holds that a layer is a logical structuring mechanism for the elements that make up the software solution, while a tier is a physical structuring 
mechanism for the system infrastructure. For example, a three-layer solution could easily be deployed on a single tier, such as a personal workstation.

In the web development field, three-tier is often used to refer to websites, commonly electronic commerce websites, which are built using three tiers:

- A front-end web server serving static content, and potentially some cached dynamic content. In web-based application, front end is the content 
rendered by the browser. The content may be static or generated dynamically.
- A middle dynamic content processing and generation level application server (e.g., Symfony, Spring, ASP.NET, Django, Rails, Node.js).
- A back-end database or data store, comprising both data sets and the database management system software that manages and provides access to the data.
**/
module uim.oop.patterns.architecturals.multitiers;

import uim.oop;
@safe:

