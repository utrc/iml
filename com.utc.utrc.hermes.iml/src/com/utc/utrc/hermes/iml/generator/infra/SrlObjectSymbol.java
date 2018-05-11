package com.utc.utrc.hermes.iml.generator.infra;

import java.util.ArrayList;
import java.util.List;

import org.eclipse.emf.ecore.EObject;
import org.eclipse.xtext.naming.IQualifiedNameProvider;

import com.utc.utrc.hermes.iml.iml.SymbolDeclaration;

public class SrlObjectSymbol extends SrlSymbol {

	
	private SrlTypeSymbol type;
	private List<SrlObjectSymbol> properties;
	private SrlTerm definition;
	
	
	public SrlObjectSymbol(IQualifiedNameProvider qnp) {
		super(qnp);
		properties = new ArrayList<SrlObjectSymbol>();
		type = null;
		definition = null ;
	}
	
	public SrlTypeSymbol getType() {
		return type;
	}

	public void setType(SrlTypeSymbol type) {
		this.type = type;
	}

	public SrlTerm getDefinition() {
		return definition;
	}

	public void setDefinition(SrlTerm definition) {
		this.definition = definition;
	}

	public List<SrlObjectSymbol> getProperties() {
		return properties;
	}
	
}
