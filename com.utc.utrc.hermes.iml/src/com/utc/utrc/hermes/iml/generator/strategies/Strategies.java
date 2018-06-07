package com.utc.utrc.hermes.iml.generator.strategies;

import org.eclipse.xtext.validation.IConcreteSyntaxConstraintProvider.ConstraintType;

import com.utc.utrc.hermes.iml.generator.infra.SrlSymbol;

public class Strategies {
		
	// What should be the type of the keys?
	
	public Strategies() {

	}
		
	public IStrategy getStrategy(SrlSymbol ss) {
		String name = ss.getName();
		if (name.equals("Int") || name.equals("Real") || name.equals("Boolean")) {
			return primEncoder == null ? new PrimitiveEncodeStrategy() : primEncoder;
		} else {
			return funcEncoder == null ? new FunctionEncodeStrategy() : funcEncoder;
		}
	}
	
	private PrimitiveEncodeStrategy primEncoder = null;
	private FunctionEncodeStrategy funcEncoder = null;
	private RecordEncodeStrategy recEncoder = null;
	
}
