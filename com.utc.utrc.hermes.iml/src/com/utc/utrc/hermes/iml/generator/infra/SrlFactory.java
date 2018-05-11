package com.utc.utrc.hermes.iml.generator.infra;

import org.eclipse.emf.ecore.EObject;
import org.eclipse.xtext.naming.IQualifiedNameProvider;

import com.google.inject.Inject;
import com.utc.utrc.hermes.iml.iml.ConstrainedType;
import com.utc.utrc.hermes.iml.iml.HigherOrderType;
import com.utc.utrc.hermes.iml.iml.Model;
import com.utc.utrc.hermes.iml.iml.SymbolDeclaration;

public class SrlFactory {
	
	@Inject IQualifiedNameProvider qnp ;

	
	public SrlFactory() {
		
	}
	
	public SrlSymbolId createSymbolId() {
		SrlSymbolId retval = new SrlSymbolId(qnp);
		return retval;
	}
	
	public SrlSymbolId createSymbolId(EObject o) {
		SrlSymbolId retval = new SrlSymbolId(qnp);
		retval.setId(o);
		return retval;
	}
	
	public SrlSymbol createSymbol() {
		SrlSymbol retval = new SrlSymbol(qnp) ;
		return retval;
	}
	
	public SrlModelSymbol createModelSymbol() {
		SrlModelSymbol retval = new SrlModelSymbol(qnp);
		return retval;
	}
	public SrlModelSymbol createModelSymbol(Model m) {
		SrlModelSymbol retval = new SrlModelSymbol(qnp);
		retval.setId(m);
		return retval;
	}
	
	
	public SrlTypeSymbol createTypeSymbol() {
		SrlTypeSymbol retval = new SrlTypeSymbol(qnp);
		return retval;
	}
	
	public SrlNamedTypeSymbol createNamedTypeSymbol() {
		SrlNamedTypeSymbol retval = new SrlNamedTypeSymbol(qnp) ;
		return retval;
	}
	
	public SrlNamedTypeSymbol createNamedTypeSymbol(ConstrainedType t) {
		SrlNamedTypeSymbol retval = new SrlNamedTypeSymbol(qnp) ;
		retval.setId(t);
		return retval;
	}
	
	public SrlHigherOrderTypeSymbol createHigherOrderTypeSymbol() {
		SrlHigherOrderTypeSymbol retval = new SrlHigherOrderTypeSymbol(qnp) ;
		return retval;
	}
	
	public SrlHigherOrderTypeSymbol createHigherOrderTypeSymbol(HigherOrderType t) {
		SrlHigherOrderTypeSymbol retval = new SrlHigherOrderTypeSymbol(qnp) ;
		retval.setId(t);
		return retval;
	}
	
	public SrlObjectSymbol createObjectSymbol() {
		SrlObjectSymbol retval = new SrlObjectSymbol(qnp);
		return retval;
	}
	
	public SrlObjectSymbol createObjectSymbol(SymbolDeclaration d) {
		SrlObjectSymbol retval = new SrlObjectSymbol(qnp);
		retval.setId(d);
		return retval;
	}
		
	public SrlTerm createTerm() {
		SrlTerm retval = new SrlTerm(qnp);
		return retval;
	}
	public SrlTerm createTerm(EObject o) {
		SrlTerm retval = new SrlTerm(qnp);
		return retval;
	}
	
	
	
	
	
	
}
