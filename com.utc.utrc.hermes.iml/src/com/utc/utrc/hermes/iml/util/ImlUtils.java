package com.utc.utrc.hermes.iml.util;

import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

import org.eclipse.emf.common.util.URI;
import org.eclipse.emf.ecore.EObject;
import org.eclipse.xtext.resource.IResourceServiceProvider;
import org.eclipse.xtext.resource.XtextResource;
import org.eclipse.xtext.serializer.ISerializer;

import com.utc.utrc.hermes.iml.iml.ArrayType;
import com.utc.utrc.hermes.iml.iml.ConstrainedType;
import com.utc.utrc.hermes.iml.iml.Extension;
import com.utc.utrc.hermes.iml.iml.HigherOrderType;
import com.utc.utrc.hermes.iml.iml.Model;
import com.utc.utrc.hermes.iml.iml.SimpleTypeReference;
import com.utc.utrc.hermes.iml.iml.Symbol;
import com.utc.utrc.hermes.iml.iml.SymbolDeclaration;
import com.utc.utrc.hermes.iml.iml.TupleType;

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
	
	/**
	 * Get the type declaration as a string
	 * @param hot
	 * @return
	 */
	public static String getTypeName(HigherOrderType hot) {
		String typeAsString = getElementAsString(hot);
		if (!typeAsString.isEmpty()) {
			return typeAsString;
		} else {
			return getTypeNameManually(hot);
		}
	}
	
	public static String getTypeNameManually(HigherOrderType hot) {
		if (hot instanceof SimpleTypeReference) {
			String name = ((SimpleTypeReference) hot).getType().getName();
			if (((SimpleTypeReference) hot).getTypeBinding().isEmpty()) {
				return name;
			} else {
				return name + "<" + ((SimpleTypeReference) hot).getTypeBinding().stream()
						.map(binding -> getTypeName(binding))
						.reduce((acc, current) -> acc + ", " + current).get() + ">";
			}
		} else if (hot instanceof ArrayType) {
			String name =  getTypeName(((ArrayType) hot).getType());
			return name + ((ArrayType) hot).getDimensions().stream()
					.map(dim -> "[]")
					.reduce((accum, current) -> accum + current).get();
		} else if (hot instanceof TupleType) {
			return "(" + ((TupleType) hot).getSymbols().stream()
				.map(symbol -> getTypeName(symbol.getType()))
				.reduce((accum, current) -> accum + ", " + current).get() + ")";
		} else {
			return getTypeName(hot.getDomain()) + "~>" + getTypeName(hot.getRange());
		}
	}

	/**
	 * Get the string representation of the object as it is in xtext file
	 * @param element 
	 * @return
	 */
	public static String getElementAsString(EObject element) {
    	if (element != null && element.eResource() instanceof XtextResource
				&& element.eResource().getURI() != null) {
    		return ((XtextResource)element.eResource()).getSerializer().serialize(element);
    	}
    	return "";
	}

}
