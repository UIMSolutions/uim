# Package 📦 uim.models.classes.elements

In **programming**, an **entity** refers to a specific object or concept that holds information or data.

**Definition**:

- An **entity** (German: I**nformationsobjekt**) is a term used in **data modeling**.
- It represents a **distinct object** about which information needs to be stored or processed.
- Entities can be **material** (physical) or **immaterial** (abstract), **concrete** or **abstract**.
- Examples of entities include **vehicles**, **bank accounts**, **people**, and **states**1.

**Attributes and Types**:

- Each entity can have **individual properties** (attributes), such as color, birthdate, height, or temperature.
- By recognizing similar attributes across entities, we can derive **entity types** (sometimes called **entity classes**). For example, multiple individuals become the entity type **CUSTOMERS**.
- Each individual customer is an **entity instance**, and they have a unique identity.
- The set of entities of the same type is called an **entity set**, which can include all, specific, or no entities1.

**Identification and Relationships**:

- Entities are uniquely identified by a value of an **identifying attribute** (or a combination of attributes). For instance, a vehicle’s chassis number or a license plate.
- Entities can be related to other entities through **relationships** (e.g., “Person X owns Vehicle Y” or “Person A is the supervisor of Person B”).
- DAbstraction helps distinguish between instances (individual entities) and types (entity types), leading to a **data model**.
- In data models, entities become **entity types**, and relationships become **relationship types**, visually represented in **Entity-Relationship Diagrams**1.

**Programming Context**:

- In **object-oriented programming (OOP)**, an **entity** corresponds to an **object instance**.
- In **data modeling**, it represents a **unit of data** rather than necessarily having a physical presence.
- For example, in a **relational database**, an entity typically corresponds to a **table**, and each entity instance corresponds to a **row** in that table.
- The primary programming artifact for an entity is the **entity class** (though entities can use helper classes)[2](https://stackoverflow.com/questions/48074263/c-what-is-an-entity)[3](https://stackoverflow.com/questions/2550197/whats-the-difference-between-entity-and-class).

---

## Packages:

Contains no packages

## Modules:

- uim.models.classes.entities.entity
