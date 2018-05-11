package com.utc.utrc.hermes.iml.generator.infra;

import java.util.HashMap;
import java.util.Map;

import org.eclipse.xtext.naming.IQualifiedNameProvider;
import org.eclipse.xtext.naming.QualifiedName;

import com.google.inject.Inject;
import com.utc.utrc.hermes.iml.iml.Symbol;

public class SymbolTable {
	
	private Map<SrlSymbolId, EncodedSymbol> symbols;
	
	public SymbolTable() {
		symbols = new HashMap<>();
	}
	
	public SymbolTable(SymbolTable other) {
		symbols = new HashMap<>();
		symbols.putAll(other.getSymbols());
	}
	
	public Map<SrlSymbolId,EncodedSymbol> getSymbols(){
		return symbols;
	}
	
	public boolean isDefined(SrlSymbolId s) {
		if (symbols.containsKey(s))
			return true ;
		return false;
	}
	
	public void add(SrlSymbolId s, EncodedSymbol se) {
		symbols.put(s, se);
	}
	
	public void add(SymbolTable s) {
		symbols.putAll(s.getSymbols());
	}
	
	
}
