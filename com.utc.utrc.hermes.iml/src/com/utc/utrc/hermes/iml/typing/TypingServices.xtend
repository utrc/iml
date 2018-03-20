package com.utc.utrc.hermes.iml.typing

import com.utc.utrc.hermes.iml.iml.HigherOrderType
import com.utc.utrc.hermes.iml.iml.ImlFactory
import com.utc.utrc.hermes.iml.iml.ConstrainedType
import com.utc.utrc.hermes.iml.iml.ArrayType
import com.utc.utrc.hermes.iml.iml.SimpleTypeReference
import com.utc.utrc.hermes.iml.iml.TupleType

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
		//TODO
		return true
	}


	/* Check whether two type references are the same */
	def static boolean isEqual(ArrayType left, ArrayType right) {
		//TODO
		return true
	}
	
	def static boolean isEqual(TupleType left, TupleType right) {
		//TODO
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
