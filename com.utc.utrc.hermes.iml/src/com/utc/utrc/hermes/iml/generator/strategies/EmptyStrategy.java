package com.utc.utrc.hermes.iml.generator.strategies;

import java.util.List;

import com.utc.utrc.hermes.iml.generator.infra.SExpr;
import com.utc.utrc.hermes.iml.generator.infra.SrlSymbolId;

public class EmptyStrategy extends AbstracIStrategy {

	public EmptyStrategy(SrlSymbolId srlObject) {
		super(srlObject);
	}

	@Override
	public List<SExpr> encode() {
		return null;
	}

}
