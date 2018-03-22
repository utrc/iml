package com.utc.utrc.hermes.iml.typing

import com.utc.utrc.hermes.iml.iml.HigherOrderType
import com.utc.utrc.hermes.iml.iml.ImlFactory
import com.utc.utrc.hermes.iml.iml.ConstrainedType
import com.utc.utrc.hermes.iml.iml.ArrayType
import com.utc.utrc.hermes.iml.iml.SimpleTypeReference
import com.utc.utrc.hermes.iml.iml.TupleType
import com.utc.utrc.hermes.iml.iml.PropertyList
import com.utc.utrc.hermes.iml.iml.impl.TupleTypeImpl

public class TypingServices {

	def static HigherOrderType createBasicType(String n) {
		val ret = ImlFactory::eINSTANCE.createHigherOrderType => [
			domain = ImlFactory::eINSTANCE.createSimpleTypeReference => [
				ref = ImlFactory::eINSTANCE.createConstrainedType => [name = n]
			]
		];
		return ret
	}

	def static HigherOrderType createBasicType(ConstrainedType t) {
		val ret = ImlFactory::eINSTANCE.createHigherOrderType => [
			domain = ImlFactory::eINSTANCE.createSimpleTypeReference => [
				ref = t
			]
		];
		return ret
	}

	/* Check whether two type references are the same */
	def static boolean isEqual(HigherOrderType left, HigherOrderType right) {
		if (left === null && right === null) {
			return true
		} else if (left === null || right === null) {
			return false
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
		
		if (checkProperties) {
			if (!isEqual(left.propertylist, right.propertylist)) {
				return false
			}
		}
		
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
		
		if (left.dimension.size != right.dimension.size) {
			return false
		}
		
		return true
	}
	
	def static boolean isEqual(TupleType left, TupleType right) {
		if (left.types.length != right.types.length) {
			return false
		} else {
			for (i: 0 ..< left.types.length) {
				if (!isEqual(left.types.get(i), right.types.get(i))) {
					return false
				}
			}
		}
		return true
	}
	
	def static boolean isEqual(PropertyList left, PropertyList right) {
		if (left.properties.size != right.properties.size) {
			return false;
		}
		
		for (i:0 ..< left.properties.size) {
			if (! isEqual(left.properties.get(i).type, right.properties.get(i).type)) {
				return false
			}
		}
		
		return true
	}

	/* Check whether two type references are the same */
	def static boolean isEqual(SimpleTypeReference left, SimpleTypeReference right) {
		if (!left.ref.isEqual(right.ref)) {
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
	


}
