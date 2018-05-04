package com.utc.utrc.hermes.iml.generator.infra;

import java.util.HashMap;
import java.util.Map;

import com.utc.utrc.hermes.iml.iml.Symbol;

public class SymbolTable {
	private Map<Symbol, EncodedSymbol> symbols;
	
	public SymbolTable() {
		symbols = new HashMap<>();
	}
	
	public SymbolTable(SymbolTable other) {
		symbols = new HashMap<>();
		symbols.putAll(other.getSymbols());
	}
	
	public Map<Symbol,EncodedSymbol> getSymbols(){
		return symbols;
	}
	
	public boolean isDefined(Symbol s) {
		if (symbols.containsKey(s))
			return true ;
		return false;
	}
	
	public void add(Symbol s, EncodedSymbol se) {
		symbols.put(s, se);
	}
	
	public void add(SymbolTable s) {
		symbols.putAll(s.getSymbols());
	}
	
	
}
