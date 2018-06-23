package com.utc.utrc.hermes.iml.generator.strategies;

import java.util.List;

import com.utc.utrc.hermes.iml.generator.infra.SExpr;
import com.utc.utrc.hermes.iml.generator.infra.SrlHigherOrderTypeSymbol;
import com.utc.utrc.hermes.iml.generator.infra.SrlNamedTypeSymbol;
import com.utc.utrc.hermes.iml.generator.infra.SrlObjectSymbol;
import com.utc.utrc.hermes.iml.generator.infra.SrlSymbol;
import com.utc.utrc.hermes.iml.generator.infra.SrlSymbolId;
import com.utc.utrc.hermes.iml.generator.infra.SrlTypeSymbol;
import com.utc.utrc.hermes.iml.generator.infra.SymbolTable;

public class EmptyStrategy extends AbstracIStrategy {

	public EmptyStrategy(SrlSymbolId srlObject) {
		super(srlObject);
	}

//	@Override
//	public List<SExpr> encode() {
//		return null;
//	}

	@Override
	public void encode(SymbolTable st) {
		// TODO Auto-generated method stub
	}
	
	@Override
	public SExpr encode(SrlSymbol s) {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public SExpr encode(SrlObjectSymbol s) {
		// TODO Auto-generated method stub
		return null;
	}
	
	@Override
	public SExpr encode(SrlTypeSymbol t) {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public SExpr encode(SrlNamedTypeSymbol t, String name) {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public SExpr encode(SrlHigherOrderTypeSymbol hot) {
		// TODO Auto-generated method stub
		return null;
	}	
	
}
