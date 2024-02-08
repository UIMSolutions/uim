module uim.models.mixins.element;

import uim.models;
@safe:

template ElementThis(string name) {
  const char[] ElementThis = `
		this() { super(); }
		this(string myName) { this().name(myName); }
		this(Json aJson) { this().fromJson(aJson); }
		override DElement create() { return `~name~`; }
  `;
}

template ElementCalls(string name) {
  const char[] ElementCalls = `
		auto `~name~`() { return new D`~name~`; } 
		auto `~name~`(string myName) { return new D`~name~`(myName); } 
		auto `~name~`(Json json) { return new D`~name~`(json); } 
  `;
} 