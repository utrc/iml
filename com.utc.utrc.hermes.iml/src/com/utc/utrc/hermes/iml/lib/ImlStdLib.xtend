package com.utc.utrc.hermes.iml.lib

import com.utc.utrc.hermes.iml.iml.NamedType
import com.utc.utrc.hermes.iml.custom.ImlCustomFactory
import com.utc.utrc.hermes.iml.iml.ImlType
import com.utc.utrc.hermes.iml.iml.SimpleTypeReference

class ImlStdLib {
	public static val INT = "Int";
	public static val REAL = "Real";
	public static val BOOL = "Bool";
	public static val STRING = "String";
	public static val NULL = "Null";
	
	// TODO maybe we need to add these types automatically to the global scope
	public static val INT_TYPE = ImlCustomFactory.INST.createNamedType(INT)
	public static val REAL_TYPE = ImlCustomFactory.INST.createNamedType(REAL)
	public static val BOOL_TYPE = ImlCustomFactory.INST.createNamedType(BOOL)
	public static val STRING_TYPE = ImlCustomFactory.INST.createNamedType(STRING)
	public static val NULL_TYPE = ImlCustomFactory.INST.createNamedType(NULL)
	
	def static boolean isPrimitive(ImlType t) {
		return t.isInt || t.isReal || t.isBool || t.isString
	}

	def static boolean isNumeric(ImlType t) {
		return t.isInt || t.isReal
	}
	
	def static boolean isPrimitive(NamedType t) {
		return t.isInt || t.isReal || t.isBool || t.isString
	}

	def static boolean isNumeric(NamedType t) {
		return t.isInt || t.isReal
	}
	
	def static boolean isInt(ImlType t) {
		if (t instanceof SimpleTypeReference) {
			return isInt(t.type)
		}
		return false
	}
	
	def static boolean isInt(NamedType t) {
		// FIXME we need to find better way to do this
		return INT == t.name
	}
	
	def static boolean isReal(ImlType t) {
		if (t instanceof SimpleTypeReference) {
			return isReal(t.type)
		}
		return false
	}
	
	def static boolean isReal(NamedType t) {
		return REAL == t.name
	}
	
	def static boolean isBool(ImlType t) {
		if (t instanceof SimpleTypeReference) {
			return isBool(t.type)
		}
		return false
	}
	
	def static boolean isBool(NamedType t) {
		return BOOL == t.name
	}
	
	def static boolean isString(ImlType t) {
		if (t instanceof SimpleTypeReference) {
			return isString(t.type)
		}
		return false
	}
	
	def static boolean isString(NamedType t) {
		return STRING == t.name
	}
	
	def static createIntRef() {
		return ImlCustomFactory.INST.createSimpleTypeReference(INT_TYPE);
	}
	
	def static createRealRef() {
		return ImlCustomFactory.INST.createSimpleTypeReference(REAL_TYPE);
	}
	
	def static createBoolRef() {
		return ImlCustomFactory.INST.createSimpleTypeReference(BOOL_TYPE);
	}
	
	def static createStringRef() {
		return ImlCustomFactory.INST.createSimpleTypeReference(STRING_TYPE);
	}

	def static createNullRef() {
		return ImlCustomFactory.INST.createSimpleTypeReference(NULL_TYPE);
	}
}