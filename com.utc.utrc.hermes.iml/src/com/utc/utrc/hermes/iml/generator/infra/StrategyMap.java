package com.utc.utrc.hermes.iml.generator.infra;

import java.util.HashMap;
import java.util.Map;

import com.utc.utrc.hermes.iml.iml.PropertyList;
import com.utc.utrc.hermes.iml.iml.Symbol;

public class StrategyMap {
		
	private Map<Pair<Symbol, PropertyList>, IStrategy> strategies;
	
	public StrategyMap() {
		strategies = new HashMap<>();
	}
	
	public Map<Pair<Symbol, PropertyList>, IStrategy> getStrategies() {
		return strategies;
	}
	
	public void add(Pair<Symbol, PropertyList> sap, IStrategy sttg) {
		strategies.put(sap, sttg);
	}
	

}
