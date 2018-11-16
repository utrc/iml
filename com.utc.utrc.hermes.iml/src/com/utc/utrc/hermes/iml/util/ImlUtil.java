package com.utc.utrc.hermes.iml.util;

import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

import org.eclipse.emf.common.util.EList;
import org.eclipse.emf.common.util.URI;
import org.eclipse.emf.ecore.EObject;
import org.eclipse.xtext.naming.IQualifiedNameProvider;
import org.eclipse.xtext.resource.IResourceServiceProvider;
import org.eclipse.xtext.resource.XtextResource;
import org.eclipse.xtext.serializer.ISerializer;

import com.utc.utrc.hermes.iml.iml.ArrayType;
import com.utc.utrc.hermes.iml.iml.ConstrainedType;
import com.utc.utrc.hermes.iml.iml.Extension;
import com.utc.utrc.hermes.iml.iml.HigherOrderType;
import com.utc.utrc.hermes.iml.iml.ImplicitInstanceConstructor;
import com.utc.utrc.hermes.iml.iml.Model;
import com.utc.utrc.hermes.iml.iml.ParenthesizedType;
import com.utc.utrc.hermes.iml.iml.Property;
import com.utc.utrc.hermes.iml.iml.Relation;
import com.utc.utrc.hermes.iml.iml.SimpleTypeReference;
import com.utc.utrc.hermes.iml.iml.Symbol;
import com.utc.utrc.hermes.iml.iml.SymbolDeclaration;
import com.utc.utrc.hermes.iml.iml.TupleType;

public class ImlUtil {

	public static List<SymbolDeclaration> getSymbolsWithProperty(ConstrainedType type, String property,
			boolean considerParent) {
		List<SymbolDeclaration> symbolsWithTheProperty = new ArrayList<SymbolDeclaration>();
		if (considerParent) {
			for (ConstrainedType parent : getDirectParents(type)) {
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
		List<ConstrainedType> retval = new ArrayList<>();
		if (type.getRelations() != null) {
			for(Relation rel : type.getRelations()) {
				if(rel instanceof Extension) {
					retval.addAll(
							((Extension) rel).getExtensions().stream()
							.map(it -> ((SimpleTypeReference) it.getType()).getType())
							.collect(Collectors.toList())) ;
				}
			}
		}
		return retval;
	}

	public static boolean hasProperty(Symbol symbol, String property) {
		if (symbol.getPropertylist() == null)
			return false;
		for (ImplicitInstanceConstructor actualProperty : symbol.getPropertylist().getProperties()) {
			if (((SimpleTypeReference) actualProperty.getRef()).getType().getName().equals(property)) {
				return true;
			}
		}
		return false;
	}

	public static ConstrainedType getConstrainedTypeByName(Model model, String name) {
		return (ConstrainedType) model.getSymbols().stream()
				.filter(it -> it instanceof ConstrainedType && it.getName().equals(name)).findFirst().orElse(null);
	}

	public static List<ConstrainedType> getConstrainedTypes(Model model) {
		return model.getSymbols().stream().filter(it -> it instanceof ConstrainedType).map(ConstrainedType.class::cast)
				.collect(Collectors.toList());
	}

	/**
	 * Get the type declaration as a string
	 * 
	 * @param hot
	 * @return
	 */
	public static String getTypeName(HigherOrderType hot, IQualifiedNameProvider qnp) {
//		String typeAsString = getElementAsString(hot);
//		if (!typeAsString.isEmpty()) {
//			return typeAsString;
//		} else {
//			
//		}
		return getTypeNameManually(hot, qnp);
	}
	
	public static String getTypeNameManually(HigherOrderType hot, IQualifiedNameProvider qnp) {
		if (hot instanceof SimpleTypeReference) {
			String name = "";
			if (qnp != null) {
				name = qnp.getFullyQualifiedName(((SimpleTypeReference) hot).getType()).toString();
			} else {
				name = ((SimpleTypeReference) hot).getType().getName();
			}
			if (((SimpleTypeReference) hot).getTypeBinding().isEmpty()) {
				return name;
			} else {
				return name + "<" + ((SimpleTypeReference) hot).getTypeBinding().stream()
						.map(binding -> getTypeName(binding, qnp))
						.reduce((acc, current) -> acc + ", " + current).get() + ">";
			}
		} else if (hot instanceof ArrayType) {
			String name =  getTypeName(((ArrayType) hot).getType(), qnp);
			return name + ((ArrayType) hot).getDimensions().stream()
					.map(dim -> "[]")
					.reduce((accum, current) -> accum + current).get();
		} else if (hot instanceof TupleType) {
			return "(" + ((TupleType) hot).getSymbols().stream()
				.map(symbol -> getTypeName(symbol.getType(), qnp))
				.reduce((accum, current) -> accum + ", " + current).get() + ")";
		} else if (hot instanceof ParenthesizedType) {
			return "(" +  getTypeName(((ParenthesizedType) hot).getSubexpression(), qnp) + ")";
		} else {
			return getTypeName(hot.getDomain(), qnp) + "->" + getTypeName(hot.getRange(), qnp);
		}
	}

	/**
	 * Get the string representation of the object as it is in xtext file
	 * 
	 * @param element
	 * @return
	 */
	public static String getElementAsString(EObject element) {
		if (element != null && element.eResource() instanceof XtextResource && element.eResource().getURI() != null) {
			return ((XtextResource) element.eResource()).getSerializer().serialize(element);
		}
		return "";
	}

	public static boolean isNullOrEmpty(List list) {
		return list == null || list.isEmpty();
	}
	
	
}
