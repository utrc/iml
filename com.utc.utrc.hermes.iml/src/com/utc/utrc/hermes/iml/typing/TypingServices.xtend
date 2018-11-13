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
//		if (other !== null) {
//			if (other instanceof SimpleTypeReference) {
//				return clone(other as SimpleTypeReference)
//			}
//
//			if (other instanceof ArrayType) {
//				return clone(other as ArrayType)
//			}
//
//			if (other instanceof TupleType) {
//				return clone(other as TupleType)
//			}
//
//			// Not a leaf node
//			var ret = ImlFactory::eINSTANCE.createHigherOrderType();
//			// TODO We are not cloning the property list here
//			ret.domain = clone(other.domain);
//			if (other.range !== null) {
//				ret.range = clone(other.range);
//			}
//			return ret
//
//		} else {
//			return null
//		}

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

	/* Check whether two type references are the same */
	def static boolean isEqual(HigherOrderType left, HigherOrderType right) {
		if (left === null && right === null) {
			return true
		} else if (left === null || right === null) {
			return false
		}
		
		//remove aliases
		if (left instanceof SimpleTypeReference){
			if (left.isAlias){
				return isEqual(left.getAlias,right) 
			}
		}
		if (right instanceof SimpleTypeReference){
			if (right.isAlias){
				return isEqual(right.getAlias,right) 
			}
		}
		
		if (left.class != right.class) {
			return false
		}

		if (left instanceof SimpleTypeReference) {
			if (!isEqual(left as SimpleTypeReference, right as SimpleTypeReference)) {
				return false
			}
		}

		if (left instanceof ArrayType) {
			if (!isEqual(left as ArrayType, right as ArrayType)) {
				return false
			}
		}

		if (left instanceof TupleType) {
			if (!isEqual(left as TupleType, right as TupleType)) {
				return false
			}
		}

		if (!isEqual(left.domain, right.domain)) {
			return false
		}

		if (!isEqual(left.range, right.range)) {
			return false
		}

		return true
	}

	def static boolean isEqual(HigherOrderType left, HigherOrderType right, boolean checkProperties) {
		if (!isEqual(left, right)) {
			return false;
		}

//		if (checkProperties) {
//			if (!isEqual(left.propertylist, right.propertylist)) {
//				return false
//			}
//		}
		return true;
	}

	/* Check whether two type references are the same */
	def static boolean isEqual(ArrayType left, ArrayType right) {
		if (left === null && right === null) {
			return true
		} else if (left === null || right === null) {
			return false
		}

		if (!isEqual(left.type, right.type)) {
			return false
		}

		if (left.dimensions.size != right.dimensions.size) {
			return false
		}

		return true
	}

	def static boolean isEqual(TupleType left, TupleType right) {
		if (left.symbols.length != right.symbols.length) {
			return false
		} else {
			for (i : 0 ..< left.symbols.length) {
				if (!isEqual(left.symbols.get(i).type, right.symbols.get(i).type)) {
					return false
				}
			}
		}
		return true
	}

	//TODO Equal means that the definitions are also equal
	def static boolean isEqual(PropertyList left, PropertyList right) {
		if (left.properties.size != right.properties.size) {
			return false;
		}

		for (i : 0 ..< left.properties.size) {
			if (! isEqual(left.properties.get(i).ref, right.properties.get(i).ref)) {
				return false
			}
		}

		return true
	}

	/* Check whether two type references are the same */
	def static boolean isEqual(SimpleTypeReference left, SimpleTypeReference right) {
		// Check pre condition for primitives
		if (left.isPrimitive || right.isPrimitive) {
			return left.type.name.equals(right.type.name)
		}
		if (!left.type.isEqual(right.type)) {
			return false
		} // if (left.type.name != right.type.name || left.type.template != right.type.template || left.type.extends != right.type.extends ) {
		// return false
		else if (left.typeBinding.size != right.typeBinding.size) {
			return false
		} else {
			for (i : 0 ..< left.typeBinding.size) {
				if (! left.typeBinding.get(i).isEqual(right.typeBinding.get(i))) {
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

	/* Check whether actual paramemter's type is compatible with formal/signature parameter's type.
	 * If the flag checkStereotypes is true, then also compare stereotypes. 
	 * */
	def static boolean isCompatible(HigherOrderType actual, HigherOrderType sig) {
		/* 
		 * if (actual.array || sig.array) {
		 * 	if (actual.dimension.size != sig.dimension.size) {
		 * 		return false;
		 * 	}

		 * }
		 * if (sig.type.name == 'Any')
		 * 	return true
		 * if (sig.numeric && actual.numeric) {
		 * 	if ((sig.type.name == 'Real') || (sig.type.name == 'Int' && actual.type.name != 'Real'))
		 * 		return true
		 * 	else
		 * 		return false
		 * }
		 * if (sig.isEqual(actual))
		 * 	return true
		 * // if (checkStereotypes && ! actual.stereotypes.containsAll(sig.stereotypes))
		 * // return false
		 * if (! sig.type.isSuperType(actual.type))
		 * 	return false;

		 * var str = sig.allSuperTypesReferences;
		 * for (level : str) {
		 * 	for (tr : level) {
		 * 		if (tr.type == actual.type) {
		 * 			var TypeReference bounded = tr.bindTypeRefWith(sig)
		 * 			if (bounded.typeBinding.size != actual.typeBinding.size) {
		 * 				return false;
		 * 			}
		 * 			for (i : 0 ..< bounded.typeBinding.size) {
		 * 				if (! bounded.typeBinding.get(i).isEqual(actual.typeBinding.get(i))) {
		 * 					return false;
		 * 				}
		 * 			}
		 * 		}
		 * 	}
		 * }
		 */
		return isEqual(actual, sig);
	}

	// TODO
	def static boolean isSuperType(HigherOrderType t, HigherOrderType sub, boolean checkStereotypes) {
		var str = sub.allSuperTypes;
		for (level : str) {
			for (tr : level) {
//				if (tr.type == t.type) {
//					var TypeReference bounded = tr.bindTypeRefWith(sub)
//					if (bounded.typeBinding.size == t.typeBinding.size) {
//						var found = true;
//						for (i : 0 ..< bounded.typeBinding.size) {
//							if (! bounded.typeBinding.get(i).isEqual(t.typeBinding.get(i))) {
//								found = false;
//							}
//						}
//						if (found) {
//							return true;
//						}
//					}
//				}
			}
		}
		return false;
	}

	/* Check whether one ConstrainedType is a super type of the other */
	def static boolean isSuperType(ConstrainedType t, ConstrainedType sub) {

		if (t.name == 'Any')
			return true;
		if (t == sub)
			return true;

		val closed = <ConstrainedType>newArrayList()
		val retval = new ArrayList<List<ConstrainedType>>()
		retval.add(new ArrayList<ConstrainedType>());
		retval.get(0).add(sub);
		var index = 0;
		while (retval.get(index).size() > 0) {
			val toadd = <ConstrainedType>newArrayList();
			for (current : retval.get(index)) {
//				for (sup : current.superType) {
//					if (!closed.contains(sup.type)) {
//						if (sup.type.isEqual(t)) {
//							return true;
//						}
//						toadd.add(sup.type)
//					}
//				}
				closed.add(current)
			}
			if (toadd.size() > 0) {
				retval.add(toadd)
				index = index + 1
			} else {
				return false;
			}
		}
		return false
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
	def static HigherOrderType getAlias(SimpleTypeReference r){
		if (r.isAlias){
			var alias = r.type.relations.filter(Alias).get(0).type.type
			return ImlTypeProvider.bind(alias,r)
		}
		return null
	}

	// TODO
	def static boolean isTemplateParameter(HigherOrderType t) {
//		if (t.type.eContainer === null) {
//			return false
//		} else if (!(t.type.eContainer instanceof Model)) {
//			// We do not allow nested types
//			return true
//		}
		return false
	}

	/* Check whether a constrained type is a template  */
	def static boolean isTemplate(ConstrainedType ct) {
		return ct.template;
	}

	/* compute what type t is used to bind a term which is declared in parametric constrainedtype container and is being used in instantiated constrainedtype c */
	// TODO This cloning function should be revisited
	def static TermExpression cloneTermExpression(TermExpression te) {
		switch (te) {
			default:
				null
		}
	}

	def static boolean isTermExpressionLiteralPosInt(TermExpression te) {
		switch (te) {
			NumberLiteral: {
				return !te.neg
			}
			default:
				return false
		}
	}

	def static boolean isTermExpressionLiteralPosNum(TermExpression te) {
		switch (te) {
			NumberLiteral: {
				return !te.neg
			}
			FloatNumberLiteral: {
				return !te.neg
			}
			default:
				return false
		}
	}

	/* Print information of a type reference */
	def static String printType(HigherOrderType t) {
		var String s = ''

		return s
	}

	def static qualifiedName(Symbol elem) {
		var EObject e = elem.eContainer;
		var StringBuffer s = new StringBuffer()
		s.append(elem.name);
		while (e !== null) {
			if (e instanceof Model) {
				s.insert(0, e.name.replace('.', '::') + '::');
			} else if (e instanceof ConstrainedType) {
				s.insert(0, e.name + '::');
			}
			e = e.eContainer;
		}
		return s.toString
	}

	def static isExtension(ConstrainedType t, String qname) {
		if (qualifiedName(t).equals(qname)) {
			return true;
		}
		var extensions = getAllSuperTypes(t);
		for (l : extensions) {
			for (sup : l) {
				if (sup.qualifiedName.equals(qname)) {
					return true;
				}
			}
		}
		return false;
	}

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
