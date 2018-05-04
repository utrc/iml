package com.utc.utrc.hermes.iml.generator.strategies

import com.utc.utrc.hermes.iml.generator.infra.SExpr
import com.utc.utrc.hermes.iml.iml.Symbol
import com.utc.utrc.hermes.iml.iml.Model
import java.util.ArrayList
import com.utc.utrc.hermes.iml.iml.SymbolDeclaration
import com.utc.utrc.hermes.iml.iml.ConstrainedType
import com.utc.utrc.hermes.iml.generator.infra.SExprTokens
import com.google.inject.Inject
import org.eclipse.xtext.naming.IQualifiedNameProvider

//TODO Should implement an interface which we don't have yet
class RecordEncoder {
	
	@Inject extension IQualifiedNameProvider
	
	
	
	
	def public  encode(Model m) {
		var retval = new ArrayList<SExpr>();
		//TODO: do we need to define the package and the imports?
		
		//define all its symbols
		for(Symbol s  : m.getSymbols()) {
			retval.add(encode(s)) ;
		}
		return retval;
	}
	
	def public SExpr encode(Symbol s) {
		switch(s){
			SymbolDeclaration: {
				return encode(s)
			}
			ConstrainedType: {
				return encode(s)
			}
			
		}
		
		
		var SExpr retval = new SExpr.Token<String>("") ;
		return retval;
	
	}
	
	def public SExpr encode(SymbolDeclaration s) {
		
	}
	
	def public SExpr encode(ConstrainedType t) {
		//Can be a meta-type
		//Can have properties
		//can be finite
		//Can have template parameters
		//Can have relations to other types
		//Has a bunch of symbols
		
		if (! t.meta &&  t.propertylist === null && !t.finite && t.typeParameter.size === 0 && t.relations.size === 0){
			var retval = new SExpr.Seq() ;
			retval.sexprs.add(SExprTokens.DECLARE_SORT) ;
			val fqn = t.fullyQualifiedName ;
			retval.sexprs.add(SExprTokens.createToken(fqn.toString)) ;
			return retval ;
		}
		
	}
	
	
}