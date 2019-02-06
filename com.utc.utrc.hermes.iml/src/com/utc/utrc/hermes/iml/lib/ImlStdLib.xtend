package com.utc.utrc.hermes.iml.lib

import com.utc.utrc.hermes.iml.iml.ConstrainedType
import com.utc.utrc.hermes.iml.custom.ImlCustomFactory
import com.utc.utrc.hermes.iml.iml.HigherOrderType
import com.utc.utrc.hermes.iml.iml.SimpleTypeReference

class ImlStdLib {
	public static val INT = "Int";
	public static val REAL = "Real";
	public static val BOOL = "Bool";
	public static val STRING = "String";
	public static val NULL = "Null";
	
	// TODO maybe we need to add these types automatically to the global scope
	public static val INT_TYPE = ImlCustomFactory.INST.createConstrainedType(INT)
	public static val REAL_TYPE = ImlCustomFactory.INST.createConstrainedType(REAL)
	public static val BOOL_TYPE = ImlCustomFactory.INST.createConstrainedType(BOOL)
	public static val STRING_TYPE = ImlCustomFactory.INST.createConstrainedType(STRING)
	public static val NULL_TYPE = ImlCustomFactory.INST.createConstrainedType(NULL)
	
	public static val INT_REF = ImlCustomFactory.INST.createSimpleTypeReference(INT_TYPE)
	public static val REAL_REF = ImlCustomFactory.INST.createSimpleTypeReference(REAL_TYPE)
	public static val BOOL_REF = ImlCustomFactory.INST.createSimpleTypeReference(BOOL_TYPE)
	public static val STRING_REF = ImlCustomFactory.INST.createSimpleTypeReference(STRING_TYPE)
	public static val NULL_REF = ImlCustomFactory.INST.createSimpleTypeReference(NULL_TYPE)
	
	def static boolean isPrimitive(HigherOrderType t) {
		return t.isInt || t.isReal || t.isBool || t.isString
	}

	def static boolean isNumeric(HigherOrderType t) {
		return t.isInt || t.isReal
	}
	
	def static boolean isPrimitive(ConstrainedType t) {
		return t.isInt || t.isReal || t.isBool || t.isString
	}

	def static boolean isNumeric(ConstrainedType t) {
		return t.isInt || t.isReal
	}
	
	def static boolean isInt(HigherOrderType t) {
		if (t instanceof SimpleTypeReference) {
			return isInt(t.type)
		}
		return false
	}
	
	def static boolean isInt(ConstrainedType t) {
		// FIXME we need to find better way to do this
		return INT == t.name
	}
	
	def static boolean isReal(HigherOrderType t) {
		if (t instanceof SimpleTypeReference) {
			return isReal(t.type)
		}
		return false
	}
	
	def static boolean isReal(ConstrainedType t) {
		return REAL == t.name
	}
	
	def static boolean isBool(HigherOrderType t) {
		if (t instanceof SimpleTypeReference) {
			return isBool(t.type)
		}
		return false
	}
	
	def static boolean isBool(ConstrainedType t) {
		return BOOL == t.name
	}
	
	def static boolean isString(HigherOrderType t) {
		if (t instanceof SimpleTypeReference) {
			return isString(t.type)
		}
		return false
	}
	
	def static boolean isString(ConstrainedType t) {
		return STRING == t.name
	}
}