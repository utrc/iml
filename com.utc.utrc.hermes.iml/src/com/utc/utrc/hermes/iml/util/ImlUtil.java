/*
 * Copyright (c) 2019 United Technologies Corporation. All rights reserved.
 * See License.txt in the project root directory for license information. */
package com.utc.utrc.hermes.iml.util;

import java.util.ArrayList;
import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

import org.eclipse.emf.common.util.EList;
import org.eclipse.emf.ecore.EObject;
import org.eclipse.emf.ecore.resource.Resource;
import org.eclipse.emf.ecore.resource.ResourceSet;
import org.eclipse.xtext.EcoreUtil2;
import org.eclipse.xtext.naming.IQualifiedNameProvider;
import org.eclipse.xtext.resource.XtextResource;

import com.utc.utrc.hermes.iml.iml.Alias;
import com.utc.utrc.hermes.iml.iml.ArrayType;
import com.utc.utrc.hermes.iml.iml.EnumRestriction;
import com.utc.utrc.hermes.iml.iml.NamedType;
import com.utc.utrc.hermes.iml.iml.FolFormula;
import com.utc.utrc.hermes.iml.iml.FunctionType;
import com.utc.utrc.hermes.iml.iml.ImlType;
import com.utc.utrc.hermes.iml.iml.Inclusion;
import com.utc.utrc.hermes.iml.iml.Model;
import com.utc.utrc.hermes.iml.iml.ParenthesizedTerm;
import com.utc.utrc.hermes.iml.iml.Property;
import com.utc.utrc.hermes.iml.iml.RecordType;
import com.utc.utrc.hermes.iml.iml.Relation;
import com.utc.utrc.hermes.iml.iml.SelfType;
import com.utc.utrc.hermes.iml.iml.SignedAtomicFormula;
import com.utc.utrc.hermes.iml.iml.SimpleTypeReference;
import com.utc.utrc.hermes.iml.iml.Symbol;
import com.utc.utrc.hermes.iml.iml.SymbolDeclaration;
import com.utc.utrc.hermes.iml.iml.SymbolReferenceTerm;
import com.utc.utrc.hermes.iml.iml.TermExpression;
import com.utc.utrc.hermes.iml.iml.TraitExhibition;
import com.utc.utrc.hermes.iml.iml.TupleType;
import com.utc.utrc.hermes.iml.iml.TypeRestriction;
import com.utc.utrc.hermes.iml.iml.TypeWithProperties;

public class ImlUtil {

	public static List<SymbolDeclaration> getSymbolsWithProperty(NamedType type, String property,
			boolean considerParent) {
		List<SymbolDeclaration> symbolsWithTheProperty = new ArrayList<SymbolDeclaration>();
		if (considerParent) {
			for (NamedType parent : getDirectParents(type)) {
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

	public static List<NamedType> getDirectParents(NamedType type) {
		List<NamedType> retval = new ArrayList<>();
		if (type.getRelations() != null) {
			for(Relation rel : type.getRelations()) {
				if(rel instanceof Inclusion) {
					retval.addAll(
							((Inclusion) rel).getInclusions().stream()
							.map(it -> ((SimpleTypeReference) it.getType()).getType())
							.collect(Collectors.toList())) ;
				}
			}
		}
		return retval;
	}

	public static List<SimpleTypeReference> getDirectParentTypeRefs(NamedType type) {
		List<SimpleTypeReference> retval = new ArrayList<>();
		if (type.getRelations() != null) {
			for(Relation rel : type.getRelations()) {
				if(rel instanceof Inclusion) {
					retval.addAll(
							((Inclusion) rel).getInclusions().stream()
							.map(it -> ((SimpleTypeReference) it.getType()))
							.collect(Collectors.toList())) ;
				}
			}
		}
		return retval;
	}	
	
	public static boolean hasProperty(Symbol symbol, String property) {
		if (symbol.getPropertylist() == null)
			return false;
		for (Property actualProperty : symbol.getPropertylist().getProperties()) {
			if (((SimpleTypeReference) actualProperty.getRef()).getType().getName().equals(property)) {
				return true;
			}
		}
		return false;
	}

	public static NamedType getNamedTypeByName(Model model, String name) {
		return (NamedType) model.getSymbols().stream()
				.filter(it -> it instanceof NamedType && it.getName().equals(name)).findFirst().orElse(null);
	}

	public static List<NamedType> getNamedTypes(Model model) {
		return model.getSymbols().stream().filter(it -> it instanceof NamedType).map(NamedType.class::cast)
				.collect(Collectors.toList());
	}

	/**
	 * Get the type declaration as a string
	 */
	public static String getTypeName(ImlType imlType, IQualifiedNameProvider qnp) {
		return getTypeNameManually(imlType, qnp);
	}
	
	public static String getTypeNameManually(ImlType imlType, IQualifiedNameProvider qnp) {
		if (imlType instanceof SimpleTypeReference) {
			String name = "";
			if (qnp != null) {
				name = qnp.getFullyQualifiedName(((SimpleTypeReference) imlType).getType()).toString();
			} else {
				name = ((SimpleTypeReference) imlType).getType().getName();
			}
			if (((SimpleTypeReference) imlType).getTypeBinding().isEmpty()) {
				return name;
			} else {
				return name + "<" + ((SimpleTypeReference) imlType).getTypeBinding().stream()
						.map(binding -> getTypeName(binding, qnp))
						.reduce((acc, current) -> acc + ", " + current).get() + ">";
			}
		} else if (imlType instanceof ArrayType) {
			String name =  getTypeName(((ArrayType) imlType).getType(), qnp);
			return name + ((ArrayType) imlType).getDimensions().stream()
					.map(dim -> "[]")
					.reduce((accum, current) -> accum + current).get();
		} else if (imlType instanceof TupleType) {
			Optional<String> elements = ((TupleType) imlType).getTypes().stream()
				.map(symbol -> getTypeName(symbol, qnp))
				.reduce((accum, current) -> accum + ", " + current);
			return "(" + (elements.isPresent()? elements.get() : "") + ")";
		} else if (imlType instanceof RecordType) {
			Optional<String> elements = ((RecordType) imlType).getSymbols().stream()
				.map(symbol -> symbol.getName() + " : " + getTypeName(symbol.getType(), qnp))
				.reduce((accum, current) -> accum + ", " + current);
			return "(" + (elements.isPresent()? elements.get() : "") + ")";
		} else if (imlType instanceof FunctionType){
			return getTypeName(((FunctionType)imlType).getDomain(), qnp) + "->" + getTypeName(((FunctionType)imlType).getRange(), qnp);
		} else if (imlType instanceof SelfType) {
			return "Self";
		}
		else if (imlType == null) {
			return "NULL";
		}
		return "UNKNOWN_IML_TYPE";
	}
	
	public static List<TypeWithProperties> getRelationTypes(NamedType type) {
		List<TypeWithProperties> types = new ArrayList<>();
		EList<Relation> relations = type.getRelations();
		for (Relation relation : relations) {
			if (relation instanceof Inclusion) {
				types.addAll(((Inclusion) relation).getInclusions());
			} else if (relation instanceof Alias) {
				types.add(((Alias) relation).getType());
			} else {
				types.addAll(((TraitExhibition) relation).getExhibitions());
			}
		}
		return types;
	}
	
	public static List<TypeWithProperties> getRelationTypes(NamedType type, Class<? extends Relation> relationType) {
		List<TypeWithProperties> types = new ArrayList<>();
		for (Relation relation : type.getRelations()) {
			if (relationType.isInstance(relation)) {
				if (relation instanceof Inclusion) {
					types.addAll(((Inclusion) relation).getInclusions());
				} else if (relation instanceof Alias) {
					types.add(((Alias) relation).getType());
				} else if (relation instanceof TraitExhibition){
					types.addAll(((TraitExhibition) relation).getExhibitions());
				}
			}
		}
		return types;
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

	public static boolean isNullOrEmpty(List<?> list) {
		return list == null || list.isEmpty();
	}
	
	public static boolean isGlobalSymbol(Symbol symbol) {
		return symbol.eContainer() instanceof Model || symbol.eContainer() == null;
	}

	public static String getUnqualifiedName(String name) {
		String[] parts = name.split("\\.");
		return parts[parts.length - 1];
	}

	public static boolean isSubTypeOf(NamedType type, String ParentTypeName) {
		for (TypeWithProperties parent : getRelationTypes(type, Inclusion.class)) {
			NamedType parentCt = ((SimpleTypeReference)parent.getType()).getType();
			if (parentCt.getName().equals(ParentTypeName)) {
				return true;
			}
			if (isSubTypeOf(parentCt, ParentTypeName)) {
				return true;
			}
		}
		return false;
	}
	
	public static FolFormula purifyFormula(FolFormula formula) {
		if (formula instanceof SignedAtomicFormula && !((SignedAtomicFormula) formula).isNeg()) {
			return purifyFormula(formula.getLeft());
		} else if (formula instanceof ParenthesizedTerm) {
			return purifyFormula(((ParenthesizedTerm) formula).getSub());
		} else {
			return formula;
		}
	}

	public static Model getModelByName(ResourceSet rs, String modelName) {
		for (Resource res : rs.getResources()) {
			if (!res.getContents().isEmpty()) {
				EObject model = res.getContents().get(0);
				if (model instanceof Model && ((Model) model).getName().equals(modelName)) {
					return (Model) model;
				}
			}
		}
		return null;
	}
	
	public static Symbol findSymbol(Model model, String symbolName) {
		for (Symbol symbol : model.getSymbols()) {
			if (symbolName.equals(symbol.getName())) {
				return symbol;
			}
		}
		return null;
	}
	
	public static SymbolDeclaration findSymbol(NamedType type, String symbolName) {
		for (SymbolDeclaration symbol : type.getSymbols()) {
			if (symbolName.equals(symbol.getName())) {
				return symbol;
			}
		}
		return null;
	}
	
	public static Symbol findSymbol(ResourceSet rs, String symbolFQN) {
		if (rs == null || symbolFQN == null) {
			return null;
		}
		
		int dotIndex = symbolFQN.lastIndexOf('.');
		if (dotIndex < 0) { // Must include FQN
			return null;
		}
		String modelName = symbolFQN.substring(0, dotIndex);
		String typeName = symbolFQN.substring(dotIndex + 1);
		
		for (Resource res : rs.getResources()) {
			if (!res.getContents().isEmpty() && res.getContents().get(0) instanceof Model
					&& ((Model) res.getContents().get(0)).getName().equals(modelName)) {
				
				Symbol symbol = findSymbol((Model) res.getContents().get(0), typeName);
				if (symbol != null) {
					return symbol;
				}
			}
		}
		return null;
	}

	public static NamedType getContainerCt(EObject eObject) {
		return EcoreUtil2.getContainerOfType(eObject, NamedType.class);
	}
	
	public static <T extends EObject> T getContainerOfType(EObject eObject, Class<T> containerType) {
		return EcoreUtil2.getContainerOfType(eObject, containerType);
	}

	public static NamedType getSimpleSymbolType(FolFormula receiver) {
		return ((SimpleTypeReference)((SymbolDeclaration)((SymbolReferenceTerm) receiver).getSymbol()).getType()).getType();
	}

	public static SymbolDeclaration getSymbolRefSymbol(TermExpression receiver) {
		return (SymbolDeclaration)((SymbolReferenceTerm) receiver).getSymbol();
	}
	
	public static boolean isFirstOrderFunction(ImlType type) {
		if (type instanceof FunctionType) {
			if (containsFunctionType(((FunctionType)type).getDomain())) {
				return false;
			}
			if (containsFunctionType(((FunctionType)type).getRange())) {
				return false;
			}
			return true;
		}
		return !containsFunctionType(type);
	}

	private static boolean containsFunctionType(ImlType type) {
		if (type instanceof FunctionType) {
			return true;
		}
		if (type instanceof TupleType) {
			for (ImlType tupleElement : ((TupleType) type).getTypes()) {
				if (containsFunctionType(tupleElement)) {
					return true;
				}
			}
		}
		
		if (type instanceof RecordType) {
			for (SymbolDeclaration tupleElement : ((RecordType) type).getSymbols()) {
				if (containsFunctionType(tupleElement.getType())) {
					return true;
				}
			}
		}
		
		if (type instanceof ArrayType) {
			if (containsFunctionType(((ArrayType) type).getType())) {
				return true;
			}
		}
		
		return false;
	}
	
	/* Check whether a constrained type is a template  */
	public static boolean isTemplate(NamedType nt) {
		return nt.isTemplate();
	}

	public static boolean isSimpleTR(ImlType imlType) {
		return (imlType instanceof SimpleTypeReference);
	}

	public static SimpleTypeReference asSimpleTR(ImlType imlType) {
		if (isSimpleTR(imlType)) {
			return (SimpleTypeReference) imlType;
		}
		return null;
	}
	
	public static boolean isAlias(SimpleTypeReference r) {
		return isAlias(r.getType());
	}
	
	public static boolean isAlias(NamedType t) {
		if (t.getRelations().stream().anyMatch(it -> it instanceof Alias)) {
			return true;
		}
		return false;
	}
	
	public static boolean isEnumLiteral(Symbol s) {
		NamedType container = EcoreUtil2.getContainerOfType(s, NamedType.class);
		if (container != null) {
			return isLiteralOf(s, container);
		}
		return false;
	}

	public static boolean isLiteralOf(Symbol s, NamedType t) {
		for (TypeRestriction r : t.getRestrictions()) {
			if (r instanceof EnumRestriction) {
				if (((EnumRestriction) r).getLiterals().contains(s)) {
					return true;
				}
			}
		}
		return false;
	}
	
	public static boolean isPolymorphic(Symbol s){
		if (s instanceof NamedType) {
			return !((NamedType) s).getTypeParameter().isEmpty();
		}
		if (s instanceof SymbolDeclaration) {
			return !((SymbolDeclaration) s).getTypeParameter().isEmpty();
		}
		return false;
	}

}
