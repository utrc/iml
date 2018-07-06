package com.utc.utrc.hermes.iml.generator.strategies;

import java.util.List;

import com.utc.utrc.hermes.iml.generator.infra.SrlHigherOrderTypeSymbol;
import com.utc.utrc.hermes.iml.generator.infra.SrlNamedTypeSymbol;
import com.utc.utrc.hermes.iml.generator.infra.SrlObjectSymbol;
import com.utc.utrc.hermes.iml.generator.infra.SrlSymbol;
import com.utc.utrc.hermes.iml.generator.infra.SrlSymbolId;
import com.utc.utrc.hermes.iml.generator.infra.SrlTypeSymbol;
import com.utc.utrc.hermes.iml.generator.infra.SymbolTable;
import com.utc.utrc.hermes.iml.sexpr.SExpr;
import com.utc.utrc.hermes.iml.sexpr.SExpr.Seq;

public class NoStrategy extends AbstracIStrategy{

	String message;
	
	public NoStrategy(SrlSymbolId srlObject, String message) {
		super(srlObject);
		this.message = message;
	}

	@Override
	public void encode(SymbolTable st) {
		// TODO Auto-generated method stub
	}
	
	@Override
	public List<Seq> encode (SrlObjectSymbol s) { 
		// TODO Auto-generated method stub
		return null;
	}
	
	@Override
	public List<Seq> encode(SrlNamedTypeSymbol t, String name) {
		// TODO Auto-generated method stub
		return null;
	}
	
}

