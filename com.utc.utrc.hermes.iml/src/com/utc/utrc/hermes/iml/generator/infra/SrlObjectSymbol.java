package com.utc.utrc.hermes.iml.generator.infra;

import java.util.ArrayList;
import java.util.List;

import org.eclipse.emf.ecore.EObject;

import com.utc.utrc.hermes.iml.iml.SymbolDeclaration;

public class SrlObjectSymbol extends SrlSymbol {

	
	private SrlHigherOrderTypeSymbol type;
	private List<SrlObjectSymbol> properties;
	private SrlTerm definition;
	
	
	public SrlObjectSymbol() {
		super();
		properties = new ArrayList<SrlObjectSymbol>();
		type = null;
		definition = null ;
	}
	public SrlObjectSymbol(SymbolDeclaration imlObject) {
		super(imlObject);
		properties = new ArrayList<SrlObjectSymbol>();
		type = null;
		definition = null ;
	}

	public SrlHigherOrderTypeSymbol getType() {
		return type;
	}

	public void setType(SrlHigherOrderTypeSymbol type) {
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
