/***********************************************************************************
*	Copyright: ©2015-2024 Ozan Nurettin Süel (sicherheitsschmiede)                   *
*	License  : Licensed under Apache 2 [https://apache.org/licenses/LICENSE-2.0.txt] *
*	Author   : Ozan Nurettin Süel (Sicherheitsschmiede)										           * 
***********************************************************************************/
module uim.oop.patterns.architecturals.entity_components;

import uim.oop;
@safe:

/**
Source Wikipedia [EN]:
Entity–component–system (ECS) is a software architectural pattern that is mostly used in video game development. 
ECS follows the principle of composition over inheritance, meaning that every entity is defined not by a "type" assigned to it, 
but by named sets of data, called "components", that are associated to it, which allows greater flexibility. 
In an ECS, processes called "systems" determine which entities have certain desired components, and act on all of those entities, 
using the information contained in the components. For example a physics system may query for entities having mass, velocity and 
position components, and then iterate over all of them and do physics calculations. The behavior of an entity can therefore be 
changed at runtime by systems that add, remove or mutate components. This eliminates the ambiguity problems of deep and wide inheritance 
hierarchies that are difficult to understand, maintain, and extend. Common ECS approaches are highly compatible, and are often combined 
with data-oriented design techniques. Although an entity is associated with its components, those components are typically not necessarily 
stored in proximity to each other in physical memory. It is notable that an ECS resembles the design of databases and, as such, can be 
referred to as an in memory database.
**/