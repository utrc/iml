package com.utc.utrc.hermes.iml;

import java.util.ArrayList;
import java.util.List;

import com.utc.utrc.hermes.iml.iml.ConstrainedType;
import com.utc.utrc.hermes.iml.iml.SimpleTypeReference;
import com.utc.utrc.hermes.iml.iml.SymbolDeclaration;

public class ImlUtils {

	public static List<SymbolDeclaration> getSymbolsWithProperty(ConstrainedType type, String property) {
		List<SymbolDeclaration> symbolsWithTheProperty = new ArrayList<SymbolDeclaration>();
		for (SymbolDeclaration symbol : type.getSymbols()) {
			if (hasProperty(symbol, property)) {
				symbolsWithTheProperty.add(symbol);
			}
		}
		return symbolsWithTheProperty;
	}

	public static boolean hasProperty(SymbolDeclaration symbol, String property) {
		for (SymbolDeclaration actualProperty: symbol.getPropertylist().getProperties()) {
			if (((SimpleTypeReference)actualProperty.getType()).getType().getName().equals(property)) {
				return true;
			}
		}
		return false;
	}

}
