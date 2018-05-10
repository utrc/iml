package com.utc.utrc.hermes.iml.generator.infra;

import java.util.HashMap;
import java.util.Map;

import org.eclipse.xtext.naming.IQualifiedNameProvider;
import org.eclipse.xtext.naming.QualifiedName;

import com.google.inject.Inject;
import com.utc.utrc.hermes.iml.iml.Symbol;

public class SymbolTable {
	
	@Inject IQualifiedNameProvider qn ;
	
	private Map<QualifiedName, EncodedSymbol> symbols;
	
	public SymbolTable() {
		symbols = new HashMap<>();
	}
	
	public SymbolTable(SymbolTable other) {
		symbols = new HashMap<>();
		symbols.putAll(other.getSymbols());
	}
	
	public Map<QualifiedName,EncodedSymbol> getSymbols(){
		return symbols;
	}
	
	public boolean isDefined(Symbol s) {
		if (symbols.containsKey(qn.getFullyQualifiedName(s)))
			return true ;
		return false;
	}
	
	public void add(Symbol s, EncodedSymbol se) {
		symbols.put(qn.getFullyQualifiedName(s), se);
	}
	
	public void add(SymbolTable s) {
		symbols.putAll(s.getSymbols());
	}
	
	
}
