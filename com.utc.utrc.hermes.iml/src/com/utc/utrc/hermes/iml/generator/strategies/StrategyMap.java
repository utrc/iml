package com.utc.utrc.hermes.iml.generator.strategies;

import com.utc.utrc.hermes.iml.generator.infra.SrlSymbolId;

public interface StrategyMap {
	
	IStrategy getStrategy(SrlSymbolId srlObject);

}
