//<<<<<<< HEAD
package com.utc.utrc.hermes.iml.generator.strategies;

import com.utc.utrc.hermes.iml.generator.infra.SExpr;
import com.utc.utrc.hermes.iml.generator.infra.SrlHigherOrderTypeSymbol;
import com.utc.utrc.hermes.iml.generator.infra.SrlNamedTypeSymbol;
import com.utc.utrc.hermes.iml.generator.infra.SrlObjectSymbol;
import com.utc.utrc.hermes.iml.generator.infra.SrlSymbol;
import com.utc.utrc.hermes.iml.generator.infra.SrlTypeSymbol;
import com.utc.utrc.hermes.iml.generator.infra.SymbolTable;

public interface IStrategy {
	
	public void encode(SymbolTable st);
	public SExpr encode (SrlSymbol s);
	public SExpr encode (SrlObjectSymbol s); 
	public SExpr encode (SrlTypeSymbol t);
	public SExpr encode (SrlNamedTypeSymbol t, String name);
	public SExpr encode (SrlHigherOrderTypeSymbol hot);

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
