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

import com.utc.utrc.hermes.iml.iml.impl.SimpleTypeReferenceImpl
import com.utc.utrc.hermes.iml.iml.impl.HigherOrderTypeImpl
import com.utc.utrc.hermes.iml.iml.impl.TupleTypeImpl
import com.utc.utrc.hermes.iml.iml.impl.ArrayTypeImpl
import com.utc.utrc.hermes.iml.iml.HigherOrderType

//TODO Should implement an interface which we don't have yet
class FunctionEncoder {
	
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
		// wangg: property list
		var retval = new SExpr.Seq()
		retval.sexprs.add(SExprTokens.DECLARE_FUN)
		retval.sexprs.add(SExprTokens.createToken(s.fullyQualifiedName.toString()))
		retval.sexprs.add(encode(s.type))
		return retval
	}

	def public SExpr encode(HigherOrderType hot) {		
		var retval = new SExpr.Seq() ;
		if (hot instanceof SimpleTypeReferenceImpl) {
			val fqn = (hot as SimpleTypeReferenceImpl).type.fullyQualifiedName
			retval.sexprs.add(SExprTokens.createToken(fqn.toString()))
		} else if (hot instanceof HigherOrderTypeImpl) {
			retval.sexprs.add(SExprTokens.HOT_ARROW)
			retval.sexprs.add(SExprTokens.createToken("("))
			// first process domain 
			if (hot.domain instanceof SimpleTypeReferenceImpl) {
				val fqn = (hot.domain as SimpleTypeReferenceImpl).type.fullyQualifiedName
				retval.sexprs.add(SExprTokens.createToken(fqn.toString()))				
			} else if (hot.domain instanceof TupleTypeImpl) {
				for (SymbolDeclaration sd : (hot.domain as TupleTypeImpl).symbols) {
					retval.sexprs.add(encode(sd.type))
				}			
			} else if (hot.domain instanceof ArrayTypeImpl) {
				println('domain is an ArrayTypeImpl')
				// need to add 
			}
			retval.sexprs.add(SExprTokens.createToken(")"))
			
			// then process range
			if (hot.range instanceof SimpleTypeReferenceImpl) {
				val fqn = (hot.range as SimpleTypeReferenceImpl).type.fullyQualifiedName
				retval.sexprs.add(SExprTokens.createToken(fqn.toString()))				
			} else {
				retval.sexprs.add(SExprTokens.createToken("("))
				if (hot.range instanceof TupleTypeImpl) {
					for (SymbolDeclaration sd : (hot.range as TupleTypeImpl).symbols) {
						retval.sexprs.add(encode(sd.type))
					}			
				} else if (hot.range instanceof ArrayTypeImpl) {
					println('domain is an ArrayTypeImpl')
					// need to add 
				}
				retval.sexprs.add(SExprTokens.createToken(")"))
			}
		}
		return retval ;
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