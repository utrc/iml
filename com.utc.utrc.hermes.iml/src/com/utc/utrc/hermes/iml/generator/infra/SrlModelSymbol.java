package com.utc.utrc.hermes.iml.generator.infra;

import java.util.ArrayList;
import java.util.List;

import org.eclipse.emf.ecore.EObject;
import org.eclipse.xtext.naming.IQualifiedNameProvider;

import com.google.inject.Inject;
import com.utc.utrc.hermes.iml.iml.ConstrainedType;
import com.utc.utrc.hermes.iml.iml.Model;

public class SrlModelSymbol extends SrlSymbol {

	private List<SrlNamedTypeSymbol> types;
	private List<SrlObjectSymbol> symbols ;
	
	public SrlModelSymbol(Model m) throws SrlSymbolException {
		super(m);
		types = new ArrayList<SrlNamedTypeSymbol>();
		symbols = new ArrayList<SrlObjectSymbol>();
	}
	

	public List<SrlNamedTypeSymbol> getTypes() {
		return types ;
	}
	
	public List<SrlObjectSymbol> getSymbols(){
		return symbols;
	}
	
	
	

}
