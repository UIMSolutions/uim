module uim.cake.core;

import uim.cake;

@safe:

// Dependency Injection container
class Container : LeagueContainer, IContainer {
  	override bool initialize(IData[string] initData = null) {
		if (!super.initialize(initData)) { return false; }
		
		return true;
	}
}
