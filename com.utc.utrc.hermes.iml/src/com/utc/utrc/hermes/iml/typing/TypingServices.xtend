package com.utc.utrc.hermes.iml.typing

import com.utc.utrc.hermes.iml.custom.ImlCustomFactory
import com.utc.utrc.hermes.iml.iml.Alias
import com.utc.utrc.hermes.iml.iml.ArrayType
import com.utc.utrc.hermes.iml.iml.Extension
import com.utc.utrc.hermes.iml.iml.FunctionType
import com.utc.utrc.hermes.iml.iml.ImlFactory
import com.utc.utrc.hermes.iml.iml.ImlType
import com.utc.utrc.hermes.iml.iml.NamedType
import com.utc.utrc.hermes.iml.iml.PropertyList
import com.utc.utrc.hermes.iml.iml.SimpleTypeReference
import com.utc.utrc.hermes.iml.iml.SymbolDeclaration
import com.utc.utrc.hermes.iml.iml.TraitExhibition
import com.utc.utrc.hermes.iml.iml.TupleType
import java.util.ArrayList
import java.util.List
import org.eclipse.emf.ecore.EObject
import org.eclipse.emf.ecore.util.EcoreUtil
import com.google.inject.Inject
import com.utc.utrc.hermes.iml.lib.ImlStdLib

public class TypingServices {
	
	@Inject
	extension private ImlStdLib
	
	@Inject
	private ImlTypeProvider typeProvider

	def <T extends EObject> T clone(T eObject) {
	  	return EcoreUtil.copy(eObject)
	}


	def ImlType accessArray(ArrayType type, int dim) {
		if (dim == type.dimensions.size) {
			return type.type
		} else {
			var ret = ImlFactory::eINSTANCE.createArrayType();
			// TODO We are not cloning the property list here
			ret.type = clone(type.type);

			for (i : 0 ..< (type.dimensions.size() - dim)) {
				// TODO : Should we clone the term expressions?
				ret.dimensions.add(ImlFactory::eINSTANCE.createOptionalTermExpr => [
					term = ImlFactory::eINSTANCE.createNumberLiteral => [value = 0];
				])
			}
			return ret
		}
	}
	
	def boolean isEqual(ImlType left, ImlType right) {
		// We almost always wants to resolve aliases
		return isEqual(resolveAliases(left), resolveAliases(right), false);
	}

	/**
	 * Check whether two type are the same or at least are compatible if compatiblityCheck was true
	 */
	def boolean isEqual(ImlType left, ImlType right, boolean compatibilityCheck) {
		if (left === null && right === null) {
			return true
		} else if (left === null || right === null) {
			return false
		}
				
		if (left instanceof TupleType && (left as TupleType).symbols.size == 1) {
			return isEqual((left as TupleType).symbols.get(0).type, right, compatibilityCheck)
		}
		
		if (right instanceof TupleType && (right as TupleType).symbols.size == 1) {
			return isEqual(left, (right as TupleType).symbols.get(0).type, compatibilityCheck)
		}
		
		if (left.class != right.class) {
			return false
		}

		if (left instanceof SimpleTypeReference) {
			if (!isEqual(left as SimpleTypeReference, right as SimpleTypeReference, compatibilityCheck)) {
				return false
			}
		}

		if (left instanceof ArrayType) {
			if (!isEqual(left as ArrayType, right as ArrayType, compatibilityCheck)) {
				return false
			}
		}

		if (left instanceof TupleType) {
			if (!isEqual(left as TupleType, right as TupleType, compatibilityCheck)) {
				return false
			}
		}
		
		if (left instanceof FunctionType) {
			if (!isEqual(left.domain, (right as FunctionType).domain, compatibilityCheck)) {
				return false
			}
	
			if (!isEqual(left.range, (right as FunctionType).range, compatibilityCheck)) {
				return false
			}
		}
		

		return true
	}

	/* Check whether two type references are the same */
	def boolean isEqual(ArrayType left, ArrayType right, boolean compatibilityCheck) {
		if (left === null && right === null) {
			return true
		} else if (left === null || right === null) {
			return false
		}

		if (!isEqual(left.type, right.type, compatibilityCheck)) {
			return false
		}

		if (left.dimensions.size != right.dimensions.size) {
			return false
		}

		return true
	}

	def boolean isEqual(TupleType left, TupleType right, boolean compatibilityCheck) {
		if (left.symbols.length != right.symbols.length) {
			return false
		} else {
			for (i : 0 ..< left.symbols.length) {
				if (!isEqual(left.symbols.get(i).type, right.symbols.get(i).type, compatibilityCheck)) {
					return false
				}
			}
		}
		return true
	}

	//TODO Equal means that the definitions are also equal
	def boolean isEqual(PropertyList left, PropertyList right, boolean compatibilityCheck) {
		if (left.properties.size != right.properties.size) {
			return false;
		}

		for (i : 0 ..< left.properties.size) {
			if (! isEqual(left.properties.get(i).ref, right.properties.get(i).ref, compatibilityCheck)) {
				return false
			}
		}

		return true
	}

	/* Check whether two type references are the same */
	def boolean isEqual(SimpleTypeReference left, SimpleTypeReference right, boolean compatibilityCheck) {
		// Check pre condition for primitives
		if (compatibilityCheck) {
			if (left.isNumeric && right.isNumeric) {
				if (left.isReal || (left.isInt && right.isInt)) {
					return true;
				}
			}
			if (right.allSuperTypes.flatten.exists[isEqual(it, left)]) {
				return true; // Found compatible super type
			}
		}
		
		if (left.isPrimitive || right.isPrimitive) {
			return left.type.name.equals(right.type.name)
		}
		
		if (!left.type.isEqual(right.type)) {
			return false
		} else if (left.typeBinding.size != right.typeBinding.size) {
			return false
		} else {
			for (i : 0 ..< left.typeBinding.size) {
				if (! left.typeBinding.get(i).isEqual(right.typeBinding.get(i), compatibilityCheck)) {
					return false
				}
			}
		}
		return true
	}

	// Checks whether two types are equal
	def boolean isEqual(NamedType left, NamedType right) {
		if (left == right)
			return true;
		return false;
	}

	// TODO 
	def getAllDeclarations(ImlType ctx) {
		var List<SymbolDeclaration> tlist = <SymbolDeclaration>newArrayList()
		var List<List<SimpleTypeReference>> hierarchy = ctx.allSuperTypes;
		for (level : hierarchy) {
			for (st : level) {
//				for (Element e : st.type.elements) {
//					if (e instanceof TermSymbol) {
//						tlist.add(e);
//					}
//				}
			}
		}
		ImlFactory::eINSTANCE.createInstanceConstructor
		return tlist;
	}

	/* Compute all super types of a ContrainedType  */
	def getAllSuperTypes(NamedType ct) {
		getSuperTypes(ImlCustomFactory.INST.createSimpleTypeReference(ct)).map[it.map[it.type]]
	}

	/* Compute all super type references of a TypeReference */
	def getAllSuperTypes(ImlType hot) {
		if (hot instanceof SimpleTypeReference) {
			return getSuperTypes(hot)
		} else {
			return new ArrayList<List<SimpleTypeReference>>()
		}
	}

	def getSuperTypes(SimpleTypeReference tf) {
		val closed = <NamedType>newArrayList()
		val retVal = new ArrayList<List<SimpleTypeReference>>()
		retVal.add(new ArrayList<SimpleTypeReference>());
		retVal.get(0).add(tf); // A type is a super type of itself
		var index = 0;
		while (retVal.get(index).size() > 0) {
			val toAdd = <SimpleTypeReference>newArrayList();
			for (current : retVal.get(index)) {
				val ctype = current.type
				if (ctype.relations != null) {
					for (rel : ctype.relations.filter(Extension)) {
							for(twp : rel.extensions){
							if (twp.type instanceof SimpleTypeReference) {
								if (! closed.contains((twp.type as SimpleTypeReference).type)) {
									toAdd.add(twp.type as SimpleTypeReference)
								}
							}
							}
						
					}
					for (rel : ctype.relations.filter(Alias)) {
							if (rel.type.type instanceof SimpleTypeReference) {
								if (! closed.contains((rel.type.type as SimpleTypeReference).type)) {
									toAdd.add(rel.type.type as SimpleTypeReference)
								}
							}
					}
					for (rel : ctype.relations.filter(TraitExhibition)) {
							for(twp : rel.exhibitions){
							if (twp.type instanceof SimpleTypeReference) {
								if (! closed.contains((twp.type as SimpleTypeReference).type)) {
									toAdd.add(twp.type as SimpleTypeReference)
								}
							}
							}
						
					}
				}

				closed.add(current.type)
			}
			if (toAdd.size() > 0) {
				retVal.add(toAdd)
				index = index + 1
			} else {
				return retVal;
			}
		}
		return retVal
	}

	/* Check if two types are compatible or not
	 * */
	def boolean isCompatible(ImlType expected, ImlType actual) {
		return isEqual(resolveAliases(expected), resolveAliases(actual), true)
	}

	def isSingleElementTuple(ImlType type) {
		return type instanceof TupleType && (type as TupleType).symbols.size == 0
	}

	/* A non-template type without stereotype is a pure type */
	def boolean isPureType(ImlType t) {
		if (t instanceof SimpleTypeReference && (t as SimpleTypeReference).typeBinding.size == 0) {
			return true;
		}
		return false;
	}
	
	def boolean isAlias(NamedType t) {
		if (t.relations.filter(Alias).size > 0) {
			return true
		}
		return false
	}
	def boolean isAlias(SimpleTypeReference r){
		return r.type.isAlias
	}
	def getAliasType(NamedType type) {
		getAliasType(ImlCustomFactory.INST.createSimpleTypeReference(type))
	}
	def ImlType getAliasType(SimpleTypeReference r){
		if (r.isAlias){
			var alias = r.type.relations.filter(Alias).get(0).type.type
			return typeProvider.bind(alias,r)
		}
		return r // if it is not alias return the original type
	}
	
	def ImlType resolveAliases(ImlType type) {
		if (type instanceof SimpleTypeReference) {
			if (type.isAlias) {
				return resolveAliases(getAliasType(type))
			} else {
				return type
			}
		}
		if (type instanceof TupleType) {
			return ImlCustomFactory.INST.createTupleType(type.symbols.map[
				ImlCustomFactory.INST.createSymbolDeclaration(it.name, clone(resolveAliases(it.type)))	
			])
		}
		if (type instanceof ArrayType) {
			return ImlCustomFactory.INST.createArrayType => [
				it.type = clone(resolveAliases(type.type))
				it.dimensions.addAll(type.dimensions.map[ImlCustomFactory.INST.createOptionalTermExpr])
			]
		}
		if (type instanceof FunctionType) {
			return ImlCustomFactory.INST.createFunctionType => [
				domain = clone(resolveAliases(type.domain))
				range = clone(resolveAliases(type.range))
			]
		}
	}
	
	/* Check whether a constrained type is a template  */
	def boolean isTemplate(NamedType ct) {
		return ct.template;
	}

//	def boolean isTermExpressionLiteralPosInt(TermExpression te) {
//		switch (te) {
//			NumberLiteral: {
//				return !te.neg
//			}
//			default:
//				return false
//		}
//	}
//
//	def boolean isTermExpressionLiteralPosNum(TermExpression te) {
//		switch (te) {
//			NumberLiteral: {
//				return !te.neg
//			}
//			FloatNumberLiteral: {
//				return !te.neg
//			}
//			default:
//				return false
//		}
//	}
//
//	def qualifiedName(Symbol elem) {
//		var EObject e = elem.eContainer;
//		var StringBuffer s = new StringBuffer()
//		s.append(elem.name);
//		while (e !== null) {
//			if (e instanceof Model) {
//				s.insert(0, e.name.replace('.', '::') + '::');
//			} else if (e instanceof NamedType) {
//				s.insert(0, e.name + '::');
//			}
//			e = e.eContainer;
//		}
//		return s.toString
//	}
//
//	def isExtension(NamedType t, String qname) {
//		if (qualifiedName(t).equals(qname)) {
//			return true;
//		}
//		var extensions = getAllSuperTypes(t);
//		for (l : extensions) {
//			for (sup : l) {
//				if (sup.qualifiedName.equals(qname)) {
//					return true;
//				}
//			}
//		}
//		return false;
//	}

	def isSimpleTR(ImlType hot) {
		return hot instanceof SimpleTypeReference
	}

	def asSimpleTR(ImlType hot) {
		if (isSimpleTR(hot)) {
			return hot as SimpleTypeReference
		}
		return null;
	}

}
