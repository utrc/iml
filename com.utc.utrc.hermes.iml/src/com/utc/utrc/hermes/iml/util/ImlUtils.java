package com.utc.utrc.hermes.iml.util;

import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

import com.utc.utrc.hermes.iml.iml.ConstrainedType;
import com.utc.utrc.hermes.iml.iml.Extension;
import com.utc.utrc.hermes.iml.iml.Model;
import com.utc.utrc.hermes.iml.iml.SimpleTypeReference;
import com.utc.utrc.hermes.iml.iml.Symbol;
import com.utc.utrc.hermes.iml.iml.SymbolDeclaration;

public class ImlUtils {

	public static List<SymbolDeclaration> getSymbolsWithProperty(ConstrainedType type, String property, boolean considerParent) {
		List<SymbolDeclaration> symbolsWithTheProperty = new ArrayList<SymbolDeclaration>();
		if (considerParent) {
			for (ConstrainedType parent: getDirectParents(type)) {
				symbolsWithTheProperty.addAll(getSymbolsWithProperty(parent, property, true));
			}
		}
		for (SymbolDeclaration symbol : type.getSymbols()) {
			if (hasProperty(symbol, property)) {
				symbolsWithTheProperty.add(symbol);
			}
		}
		return symbolsWithTheProperty;
	}

	public static List<ConstrainedType> getDirectParents(ConstrainedType type) {
		if (type.getRelations() == null) return new ArrayList<>(); // Precondition
		
		return type.getRelations().stream()
			.filter(it -> it instanceof Extension)
			.map(it -> ((SimpleTypeReference) it.getTarget()).getType())
			.collect(Collectors.toList());
	}

	public static boolean hasProperty(Symbol symbol, String property) {
		if (symbol.getPropertylist() == null) return false;
		for (SymbolDeclaration actualProperty: symbol.getPropertylist().getProperties()) {
			if (((SimpleTypeReference)actualProperty.getType()).getType().getName().equals(property)) {
				return true;
			}
		}
		return false;
	}

	public static ConstrainedType getConstrainedTypeByName(Model model, String name) {
		return (ConstrainedType) model.getSymbols().stream()
			.filter(it -> it instanceof ConstrainedType && it.getName().equals(name))
			.findFirst().orElse(null);
	}

	public static List<ConstrainedType> getConstrainedTypes(Model model) {
		return model.getSymbols().stream()
			.filter(it -> it instanceof ConstrainedType)
			.map(ConstrainedType.class::cast)
			.collect(Collectors.toList());
	}

}
