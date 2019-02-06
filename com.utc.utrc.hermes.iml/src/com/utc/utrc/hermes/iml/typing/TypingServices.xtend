package com.utc.utrc.hermes.iml.typing

import com.utc.utrc.hermes.iml.iml.HigherOrderType
import com.utc.utrc.hermes.iml.iml.ImlFactory
import com.utc.utrc.hermes.iml.iml.ConstrainedType
import com.utc.utrc.hermes.iml.iml.ArrayType
import com.utc.utrc.hermes.iml.iml.SimpleTypeReference
import com.utc.utrc.hermes.iml.iml.TupleType
import com.utc.utrc.hermes.iml.iml.PropertyList
import com.utc.utrc.hermes.iml.iml.SymbolDeclaration
import java.util.List
import java.util.ArrayList
import com.utc.utrc.hermes.iml.iml.TermExpression
import com.utc.utrc.hermes.iml.iml.NumberLiteral
import com.utc.utrc.hermes.iml.iml.FloatNumberLiteral
import com.utc.utrc.hermes.iml.iml.Symbol
import org.eclipse.emf.ecore.EObject
import com.utc.utrc.hermes.iml.iml.Model
import static extension com.utc.utrc.hermes.iml.typing.ImlTypeProvider.*
import com.utc.utrc.hermes.iml.iml.Alias
import com.utc.utrc.hermes.iml.iml.TraitExhibition
import com.utc.utrc.hermes.iml.iml.ImplicitInstanceConstructor
import org.eclipse.emf.ecore.util.EcoreUtil
import com.utc.utrc.hermes.iml.custom.ImlCustomFactory
import static extension com.utc.utrc.hermes.iml.lib.ImlStdLib.*

public class TypingServices {

	def static createBasicType(String n) {
		val ret = ImlFactory::eINSTANCE.createSimpleTypeReference => [
			type = ImlFactory::eINSTANCE.createConstrainedType => [name = n]
		];
		return ret
	}

	def static createBasicType(ConstrainedType t) {
		val ret = ImlFactory::eINSTANCE.createSimpleTypeReference => [
			type = t
		];
		return ret
	}


	def static SimpleTypeReference createSimpleTypeRef(ConstrainedType t) {
		ImlFactory::eINSTANCE.createSimpleTypeReference => [
			type = t
		]
	}

	def static clone(PropertyList pl) {
		var ret = ImlFactory::eINSTANCE.createPropertyList;
		for (p : pl.properties) {
			ret.properties.add(clone(p))
		}
	}

	def static clone(ImplicitInstanceConstructor c){
		var ret = ImlFactory::eINSTANCE.createProperty
		ret.ref = clone(c.ref)
		ret.definition = EcoreUtil.copy(c.definition)
		return ret
	}

	// TODO Are we going to have cloning functions for everything?
	// What do we actually need to clone? What can instead just
	// be copied as reference?
	def static clone(SymbolDeclaration v) {
		var ret = ImlFactory::eINSTANCE.createSymbolDeclaration;
		// Following added By Ayman for 4-higher-order-types-only
		ret.name = v.name
		// TODO Do we need to copy the property list?
		ret.type = clone(v.type)
		// TODO What to do with the definition?
		return ret
	}

	def static HigherOrderType clone(HigherOrderType other) {
		return EcoreUtil.copy(other)

	}

	def static clone(SimpleTypeReference tr) {
		var ret = ImlFactory::eINSTANCE.createSimpleTypeReference();
		ret.type = tr.type;
		for (t : tr.typeBinding) {
			ret.typeBinding.add(clone(t))
		}
		return ret;
	}

	def static clone(TupleType tt) {
		var ret = ImlFactory::eINSTANCE.createTupleType();

		for (s : tt.symbols) {
			ret.symbols.add(clone(s))
		}
		return ret
	}

	def static clone(ArrayType at) {
		var ret = ImlFactory::eINSTANCE.createArrayType();
		ret.type = clone(at.type)
		for (d : at.dimensions) {
			// TODO : Should we clone the term expressions?
			ret.dimensions.add(ImlFactory::eINSTANCE.createOptionalTermExpr => [
				term = ImlFactory::eINSTANCE.createNumberLiteral => [value = 0];
			])
		}
		return ret
	}

	def static HigherOrderType accessArray(ArrayType type, int dim) {
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
	
	def static boolean isEqual(HigherOrderType left, HigherOrderType right) {
		// We almost always wants to resolve aliases
		return isEqual(resolveAliases(left), resolveAliases(right), false);
	}

	/**
	 * Check whether two type are the same or at least are compatible if compatiblityCheck was true
	 */
	def static boolean isEqual(HigherOrderType left, HigherOrderType right, boolean compatibilityCheck) {
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

		if (!isEqual(left.domain, right.domain, compatibilityCheck)) {
			return false
		}

		if (!isEqual(left.range, right.range, compatibilityCheck)) {
			return false
		}

		return true
	}

	/* Check whether two type references are the same */
	def static boolean isEqual(ArrayType left, ArrayType right, boolean compatibilityCheck) {
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

	def static boolean isEqual(TupleType left, TupleType right, boolean compatibilityCheck) {
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
	def static boolean isEqual(PropertyList left, PropertyList right, boolean compatibilityCheck) {
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
	def static boolean isEqual(SimpleTypeReference left, SimpleTypeReference right, boolean compatibilityCheck) {
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
	def static boolean isEqual(ConstrainedType left, ConstrainedType right) {
		if (left == right)
			return true;
		return false;
	}

	// TODO 
	def static getAllDeclarations(HigherOrderType ctx) {
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
	def static getAllSuperTypes(ConstrainedType ct) {
		getSuperTypes(createSimpleTypeRef(ct)).map[it.map[it.type]]
	}

	/* Compute all super type references of a TypeReference */
	def static getAllSuperTypes(HigherOrderType hot) {
		if (hot instanceof SimpleTypeReference) {
			return getSuperTypes(hot)
		} else {
			return new ArrayList<List<SimpleTypeReference>>()
		}
	}

	def static getSuperTypes(SimpleTypeReference tf) {
		val closed = <ConstrainedType>newArrayList()
		val retVal = new ArrayList<List<SimpleTypeReference>>()
		retVal.add(new ArrayList<SimpleTypeReference>());
		retVal.get(0).add(tf); // A type is a super type of itself
		var index = 0;
		while (retVal.get(index).size() > 0) {
			val toAdd = <SimpleTypeReference>newArrayList();
			for (current : retVal.get(index)) {
				val ctype = current.type
				if (ctype.relations != null) {
					for (rel : ctype.relations.filter(com.utc.utrc.hermes.iml.iml.Extension)) {
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
	def static boolean isCompatible(HigherOrderType expected, HigherOrderType actual) {
		return isEqual(resolveAliases(expected), resolveAliases(actual), true)
	}

	def static isSingleElementTuple(HigherOrderType type) {
		return type instanceof TupleType && (type as TupleType).symbols.size == 0
	}

	/* A non-template type without stereotype is a pure type */
	def static boolean isPureType(HigherOrderType t) {
		if (t instanceof SimpleTypeReference && (t as SimpleTypeReference).typeBinding.size == 0) {
			return true;
		}
		return false;
	}
	
	def static boolean isAlias(ConstrainedType t) {
		if (t.relations.filter(Alias).size > 0) {
			return true
		}
		return false
	}
	def static boolean isAlias(SimpleTypeReference r){
		return r.type.isAlias
	}
	def static getAliasType(ConstrainedType type) {
		com.utc.utrc.hermes.iml.typing.TypingServices.getAliasType(ImlCustomFactory.INST.createSimpleTypeReference(type))
	}
	def static HigherOrderType getAliasType(SimpleTypeReference r){
		if (r.isAlias){
			var alias = r.type.relations.filter(Alias).get(0).type.type
			return ImlTypeProvider.bind(alias,r)
		}
		return r // if it is not alias return the original type
	}
	
	def static HigherOrderType resolveAliases(HigherOrderType type) {
		if (type instanceof SimpleTypeReference) {
			if (type.isAlias) {
				return com.utc.utrc.hermes.iml.typing.TypingServices.resolveAliases(com.utc.utrc.hermes.iml.typing.TypingServices.getAliasType(type))
			} else {
				return type
			}
		}
		if (type instanceof TupleType) {
			return ImlCustomFactory.INST.createTupleType(type.symbols.map[
				ImlCustomFactory.INST.createSymbolDeclaration(it.name, clone(com.utc.utrc.hermes.iml.typing.TypingServices.resolveAliases(it.type)))	
			])
		}
		if (type instanceof ArrayType) {
			return ImlCustomFactory.INST.createArrayType => [
				it.type = clone(resolveAliases(type.type))
				it.dimensions.addAll(type.dimensions.map[ImlCustomFactory.INST.createOptionalTermExpr])
			]
		}
		return ImlCustomFactory.INST.createHigherOrderType => [
			domain = clone(resolveAliases(type.domain))
			range = clone(resolveAliases(type.range))
		]
		
	}
	
	/* Check whether a constrained type is a template  */
	def static boolean isTemplate(ConstrainedType ct) {
		return ct.template;
	}

//	def static boolean isTermExpressionLiteralPosInt(TermExpression te) {
//		switch (te) {
//			NumberLiteral: {
//				return !te.neg
//			}
//			default:
//				return false
//		}
//	}
//
//	def static boolean isTermExpressionLiteralPosNum(TermExpression te) {
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
//	def static qualifiedName(Symbol elem) {
//		var EObject e = elem.eContainer;
//		var StringBuffer s = new StringBuffer()
//		s.append(elem.name);
//		while (e !== null) {
//			if (e instanceof Model) {
//				s.insert(0, e.name.replace('.', '::') + '::');
//			} else if (e instanceof ConstrainedType) {
//				s.insert(0, e.name + '::');
//			}
//			e = e.eContainer;
//		}
//		return s.toString
//	}
//
//	def static isExtension(ConstrainedType t, String qname) {
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

	def static isSimpleTR(HigherOrderType hot) {
		return hot instanceof SimpleTypeReference
	}

	def static asSimpleTR(HigherOrderType hot) {
		if (isSimpleTR(hot)) {
			return hot as SimpleTypeReference
		}
		return null;
	}

}
