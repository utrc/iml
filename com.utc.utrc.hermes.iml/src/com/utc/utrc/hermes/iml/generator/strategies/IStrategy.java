package com.utc.utrc.hermes.iml.generator.strategies;

import com.utc.utrc.hermes.iml.generator.infra.SExpr;
import com.utc.utrc.hermes.iml.generator.infra.SrlHigherOrderTypeSymbol;
import com.utc.utrc.hermes.iml.generator.infra.SrlNamedTypeSymbol;
import com.utc.utrc.hermes.iml.generator.infra.SrlObjectSymbol;
import com.utc.utrc.hermes.iml.generator.infra.SrlSymbol;

public interface IStrategy {
	
	public SExpr encode (SrlSymbol s);
	public SExpr encode (SrlObjectSymbol s); 
	public SExpr encode (SrlNamedTypeSymbol t);
	public SExpr encode (SrlHigherOrderTypeSymbol hot);

}
