package com.utc.utrc.hermes.iml.generator.strategies;

import java.util.List;

import com.utc.utrc.hermes.iml.generator.infra.SExpr;
import com.utc.utrc.hermes.iml.generator.infra.SrlSymbolId;

public class NoStrategy extends AbstracIStrategy{

	String message;
	
	public NoStrategy(SrlSymbolId srlObject, String message) {
		super(srlObject);
		this.message = message;
	}

	@Override
	public List<SExpr> encode() {
		throw new IllegalArgumentException(message);
	}

}

