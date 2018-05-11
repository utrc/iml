package com.utc.utrc.hermes.iml.generator.infra;

import java.util.ArrayList;
import java.util.List;

import org.eclipse.emf.ecore.EObject;
import org.eclipse.xtext.naming.IQualifiedNameProvider;

import com.google.inject.Inject;
import com.utc.utrc.hermes.iml.iml.ConstrainedType;
import com.utc.utrc.hermes.iml.iml.Model;

public class SrlModelSymbol extends SrlSymbol {

	private List<SrlTypeSymbol> types;
	private List<SrlObjectSymbol> symbols ;
	
	public SrlModelSymbol(IQualifiedNameProvider qnp)  {
		super(qnp);
		types = new ArrayList<SrlTypeSymbol>();
		symbols = new ArrayList<SrlObjectSymbol>();
	}
	

	public List<SrlTypeSymbol> getTypes() {
		return types ;
	}
	
	public List<SrlObjectSymbol> getSymbols(){
		return symbols;
	}
	
	
	

}
