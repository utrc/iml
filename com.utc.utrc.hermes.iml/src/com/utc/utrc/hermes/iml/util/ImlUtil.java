/*
 * Copyright (c) 2019 United Technologies Corporation. All rights reserved.
 * See License.txt in the project root directory for license information. */
package com.utc.utrc.hermes.iml.util;

import java.util.ArrayList;
import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;
import java.util.stream.Stream;

import org.eclipse.emf.common.util.EList;
import org.eclipse.emf.ecore.EObject;
import org.eclipse.emf.ecore.resource.Resource;
import org.eclipse.emf.ecore.resource.ResourceSet;
import org.eclipse.emf.ecore.util.EcoreUtil;
import org.eclipse.xtext.EcoreUtil2;
import org.eclipse.xtext.naming.IQualifiedNameProvider;
import org.eclipse.xtext.resource.XtextResource;

import com.utc.utrc.hermes.iml.iml.Alias;
import com.utc.utrc.hermes.iml.iml.Annotation;
import com.utc.utrc.hermes.iml.iml.ArrayType;
import com.utc.utrc.hermes.iml.iml.Assertion;
import com.utc.utrc.hermes.iml.iml.Datatype;
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
import com.utc.utrc.hermes.iml.iml.Refinement;
import com.utc.utrc.hermes.iml.iml.Relation;
import com.utc.utrc.hermes.iml.iml.SelfType;
import com.utc.utrc.hermes.iml.iml.SignedAtomicFormula;
import com.utc.utrc.hermes.iml.iml.SimpleTypeReference;
import com.utc.utrc.hermes.iml.iml.Symbol;
import com.utc.utrc.hermes.iml.iml.SymbolDeclaration;
import com.utc.utrc.hermes.iml.iml.SymbolReferenceTerm;
import com.utc.utrc.hermes.iml.iml.TermExpression;
import com.utc.utrc.hermes.iml.iml.Trait;
import com.utc.utrc.hermes.iml.iml.TraitExhibition;
import com.utc.utrc.hermes.iml.iml.TupleType;
import com.utc.utrc.hermes.iml.iml.TypeRestriction;
import com.utc.utrc.hermes.iml.iml.TypeWithProperties;

public class ImlUtil {

	public static List<SymbolDeclaration> getSymbolsWithProperty(NamedType type, NamedType property,
			boolean recursive) {
		List<SymbolDeclaration> symbolsWithTheProperty = new ArrayList<SymbolDeclaration>();
		if (recursive) {
			for (SimpleTypeReference parent : getRelatedTypes(type)) {
				symbolsWithTheProperty.addAll(getSymbolsWithProperty(parent.getType(), property, recursive));
			}
		}
		for (SymbolDeclaration symbol : type.getSymbols()) {
			if (hasProperty(symbol, property)) {
				symbolsWithTheProperty.add(symbol);
			}
		}
		return symbolsWithTheProperty;
	}
	
	public static List<SymbolDeclaration> getSymbolsWithTrait(NamedType type, Trait trait, boolean recursive) {
		List<SymbolDeclaration> symbolsWithTheTrait = new ArrayList<SymbolDeclaration>();
		if (recursive) {
			for (SimpleTypeReference parent : getRelatedTypes(type)) {
				symbolsWithTheTrait.addAll(getSymbolsWithTrait(parent.getType(), trait, recursive));
			}
		}
		for (SymbolDeclaration symbol : type.getSymbols()) {
			if (exhibitsOrRefines(symbol, trait)) {
				symbolsWithTheTrait.add(symbol);
			}
		}
		return symbolsWithTheTrait;
	}
	
	public static List<SymbolDeclaration> getSymbolsWithType(NamedType type, NamedType symbolType, boolean recursive) {
		List<SymbolDeclaration> symbolsWithType = new ArrayList<SymbolDeclaration>();
		if (recursive) {
			for (SimpleTypeReference parent : getRelatedTypes(type)) {
				symbolsWithType.addAll(getSymbolsWithType(parent.getType(), symbolType, recursive));
			}
		}
		for (SymbolDeclaration symbol : type.getSymbols()) {
			if (EcoreUtil.equals(symbol, symbolType)) {
				symbolsWithType.add(symbol);
			}
		}
		return symbolsWithType;
	}
	
	public static boolean hasProperty(Symbol symbol, NamedType property) {
		if (symbol.getPropertylist() == null)
			return false;
		for (Property actualProperty : symbol.getPropertylist().getProperties()) {
			if (EcoreUtil.equals(((SimpleTypeReference) actualProperty.getRef()).getType(), property)) {
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
	

	/**
	 * Get all related type recursively and store them by level
	 * @return
	 */
	public static List<List<TypeWithProperties>> getAllRelationTypes(NamedType type) {
		List<List<TypeWithProperties>> types = new ArrayList<>();
		throw new IllegalStateException("Unimplemented method!");
	}
	
	/**
	 * Get related types that are SimpleTypeReferece
	 */
	public static List<SimpleTypeReference> getRelatedTypes(NamedType type) {
		return getRelatedTypesWithProp(type).stream().filter(twp -> twp.getType() instanceof SimpleTypeReference)
			.map(twp -> (SimpleTypeReference)twp.getType())
			.collect(Collectors.toList());
	}
	
	public static List<TypeWithProperties> getRelatedTypesWithProp(NamedType type) {
		List<TypeWithProperties> types = new ArrayList<>();
		EList<Relation> relations = type.getRelations();
		for (Relation relation : relations) {
			if (relation instanceof Inclusion) {
				types.addAll(((Inclusion) relation).getInclusions());
			} else if (relation instanceof Alias) {
				types.add(((Alias) relation).getType());
			} else if (relation instanceof Refinement) {
				types.addAll(((Refinement) relation).getRefinements());
			} else if (relation instanceof TraitExhibition) {
				types.addAll(((TraitExhibition) relation).getExhibitions());
			} else {
				throw new IllegalArgumentException("Unknown relation type: " + relation.getClass());
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
				} else if (relation instanceof Refinement) {
					types.addAll(((Refinement) relation).getRefinements());
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
	
	public static SymbolDeclaration findSymbol(NamedType type, String symbolName, boolean recursive) {
		SymbolDeclaration symbol = findSymbol(type, symbolName);
		if (symbol != null) {
			return symbol;
		} else if (recursive) {
			for (TypeWithProperties relatedtype : getRelatedTypesWithProp(type)) {
				if (relatedtype.getType() instanceof SimpleTypeReference) {
					symbol = findSymbol(((SimpleTypeReference) relatedtype.getType()).getType(), symbolName, recursive);
					if (symbol != null) {
						return symbol;
					}
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
		if (t.getRestriction() instanceof EnumRestriction) {
			if (((EnumRestriction) t.getRestriction()).getLiterals().contains(s)) {
				return true;
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

	public static boolean hasType(ImlType imlType, NamedType namedType) {
		if (imlType instanceof SimpleTypeReference &&
				EcoreUtil.equals(((SimpleTypeReference)imlType).getType(), namedType)) {
			return true ;
		}
		return false;
	}
	
	public static boolean exhibitsOrRefines(EObject symbol, Trait trait) {
		if (symbol instanceof Trait) {
			return refines((Trait) symbol, trait);
		} else if (symbol instanceof NamedType){
			return exhibits((NamedType) symbol, trait);
		} else if (symbol instanceof SimpleTypeReference) {
			return exhibits(((SimpleTypeReference) symbol).getType(), trait);
		} else if (symbol instanceof SymbolDeclaration) {
			return exhibitsOrRefines(((SymbolDeclaration) symbol).getType(), trait);
		} else {
			return false;
		}
	}
	
	public static boolean exhibits(NamedType type, Trait trait) {
		if (type instanceof Trait) {
			return refines((Trait) type, trait);
		}
		
		List<TypeWithProperties> traits = getRelationTypes(type, TraitExhibition.class);
		if (traits.size() == 0)
			return false;
		return traits.stream()
				.filter(twp -> twp.getType() instanceof SimpleTypeReference && ((SimpleTypeReference) twp.getType()).getType() instanceof Trait)
				.map(twp -> (Trait) ((SimpleTypeReference) twp.getType()).getType() )
				.anyMatch(t -> EcoreUtil.equals(t, trait) || refines(t, trait)) ;
		
	}

	public static boolean exhibits(ImlType type, Trait trait) {
		if (type instanceof SimpleTypeReference) {
			return exhibits( ((SimpleTypeReference) type).getType() , trait) ;
		}
		return false;
	}
	
	public static boolean refines(Trait type, Trait trait) {
		
		List<TypeWithProperties> traits = getRelationTypes(type, Refinement.class);
		if (traits.size() == 0)
			return false;
		return traits.stream()
				.filter(twp -> twp.getType() instanceof SimpleTypeReference)
				.map(twp -> (Trait) ((SimpleTypeReference) twp.getType()).getType() )
				.anyMatch(t -> EcoreUtil.equals(t, trait) || refines(t, trait)) ;
		
		
	}
	
	public static boolean hasAnnotation(SymbolDeclaration s, Annotation a) {
		return hasProperty(s, a);
	}

	public static boolean hasAnnotation(ImlType t, Annotation a) {
		if (t instanceof NamedType) {
			return hasProperty((NamedType) t, a);
		} else {
			return false;
		}
	}
	
	public static boolean hasAnnotation(NamedType t, Annotation a) {
		return hasProperty(t, a);
	}
	
	public static boolean isEnum(NamedType t) {
		if (t.getRelations() == null) {
			return false;
		}
		if (t.getRestriction() instanceof EnumRestriction) {
			return true;
		}
		return false;
	}
	
	public static List<String> getLiterals(NamedType t) {
		List<String> retval = new ArrayList<String>();
		if (t.getRestriction() != null) {
			TypeRestriction r = t.getRestriction();
			if (r instanceof EnumRestriction) {
				for(SymbolDeclaration sd : ((EnumRestriction) r).getLiterals()) {
					retval.add(sd.getName());
				}
			}
		}
		return retval;
	}
	
	public static boolean isEqual(FolFormula left, FolFormula right) {
		if (left == null && right == null) return true;
		if (left == null || right == null) return false;
 		if (left.getClass() != right.getClass()) return false;
		
 		if (!isEqual(left.getLeft(), right.getLeft())) return false;
 		if (left.getOp() != right.getOp()) return false;
 		
		
		return true;
	}

	public static boolean isActualNamedType(NamedType type) {
		return !(type instanceof Annotation || type instanceof Trait ||
				type instanceof Datatype);
	}
	
	public static List<SymbolDeclaration> getAllSymbols(NamedType type, boolean recursive) {
		List<SymbolDeclaration> symbols = new ArrayList<SymbolDeclaration>();
		if (recursive) {
			for (SimpleTypeReference parent : getRelatedTypes(type)) {
				symbols.addAll(getAllSymbols(parent.getType(), recursive));
			}
		}
		for (SymbolDeclaration symbol : type.getSymbols()) {
				symbols.add(symbol);
		}
		return symbols;
	}

}
