package com.utc.utrc.hermes.iml.generator.infra;

import java.util.ArrayList;
import java.util.EnumSet;
import java.util.List;

import org.eclipse.xtext.naming.IQualifiedNameProvider;

import com.google.inject.Inject;
import com.utc.utrc.hermes.iml.iml.ConstrainedType;

public class SrlNamedTypeSymbol extends SrlTypeSymbol {

	@Inject IQualifiedNameProvider qnp;
	
	private List<SrlObjectSymbol> properties ;
	private List<SrlObjectSymbol> constants ;
	private List<SrlNamedTypeSymbol> parameters ;
	private List<SrlObjectSymbol> relations ;
	private List<SrlObjectSymbol> symbols ;
	private EnumSet<SrlTypeModifier> modifiers;
	
	public SrlNamedTypeSymbol(ConstrainedType t) throws SrlSymbolException {
		super(t);
		properties = new ArrayList<SrlObjectSymbol>();
		constants = new ArrayList<SrlObjectSymbol>() ;
		parameters = new ArrayList<SrlNamedTypeSymbol>();
		relations = new ArrayList<SrlObjectSymbol>();
		symbols = new ArrayList<SrlObjectSymbol>();
		modifiers = EnumSet.noneOf(SrlTypeModifier.class);
	}
	
	
	public boolean isMeta() {
		return modifiers.contains(SrlTypeModifier.META);
	}
	public boolean isFinite() {
		return modifiers.contains(SrlTypeModifier.FINITE);
	}
	public boolean isTemplate() {
		return modifiers.contains(SrlTypeModifier.TEMPLATE);
	}
	
	
	public List<SrlObjectSymbol> getProperties(){
		return properties;
	}
	
	
	public List<SrlObjectSymbol> getConstants() {
		return constants ;
	}
	
	
	public List<SrlNamedTypeSymbol> getParameters() {
		return parameters ;
	}
	
	public List<SrlObjectSymbol> getRelations(){
		return relations;
	}
	
	public List<SrlObjectSymbol> getSymbols(){
		return symbols;
	}
	
	public void addModifier(SrlTypeModifier t) {
		modifiers.add(t);
	}
	public void removeModifier(SrlTypeModifier t) {
		modifiers.remove(t);
	}
	public void assignModifiers(SrlTypeModifier ...modifiers ) {
		for(int i = 0; i < modifiers.length; i++) {
			addModifier(modifiers[i]);
		}
	}; 
	
	
	
	
}
