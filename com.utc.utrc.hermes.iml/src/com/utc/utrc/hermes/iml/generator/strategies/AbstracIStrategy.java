package com.utc.utrc.hermes.iml.generator.strategies;

import com.utc.utrc.hermes.iml.generator.infra.SrlSymbolId;

public abstract class AbstracIStrategy implements IStrategy {
	
	SrlSymbolId srlObject;
	
	public AbstracIStrategy(SrlSymbolId srlObject) {
		this.srlObject = srlObject;
	}
}
