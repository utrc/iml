//<<<<<<< HEAD
package com.utc.utrc.hermes.iml.generator.strategies;

import java.util.List;

import com.utc.utrc.hermes.iml.generator.infra.SExpr;
import com.utc.utrc.hermes.iml.generator.infra.SExpr.Seq;
import com.utc.utrc.hermes.iml.generator.infra.SrlHigherOrderTypeSymbol;
import com.utc.utrc.hermes.iml.generator.infra.SrlNamedTypeSymbol;
import com.utc.utrc.hermes.iml.generator.infra.SrlObjectSymbol;
import com.utc.utrc.hermes.iml.generator.infra.SrlSymbol;
import com.utc.utrc.hermes.iml.generator.infra.SrlTypeSymbol;
import com.utc.utrc.hermes.iml.generator.infra.SymbolTable;

public interface IStrategy {
	
	public void encode(SymbolTable st);
	public void encode (SrlObjectSymbol s, Seq seq); 
	public SExpr encode (SrlNamedTypeSymbol t, String name);
}
//=======
//package com.utc.utrc.hermes.iml.generator.strategies;
//
//import java.util.List;
//
//import com.utc.utrc.hermes.iml.generator.infra.SExpr;
//
//public interface IStrategy {
//	
//	List<SExpr> encode();
//
//}
//>>>>>>> master
