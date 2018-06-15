package com.utc.utrc.hermes.iml.generator.strategies

import com.utc.utrc.hermes.iml.generator.infra.SrlSymbolId
import com.utc.utrc.hermes.iml.generator.infra.SrlNamedTypeSymbol

class RecordEncoderStrategy implements StrategyMap {
	String[] basicTypes = #["Int", "Real", "Boolean"];
	
	override getStrategy(SrlSymbolId srlObject) {
		if (srlObject instanceof SrlNamedTypeSymbol) {
			if (basicTypes.contains(srlObject.name)) {
				return new EmptyStrategy(srlObject)
			} else {
				
			}
		}
	}
	
}