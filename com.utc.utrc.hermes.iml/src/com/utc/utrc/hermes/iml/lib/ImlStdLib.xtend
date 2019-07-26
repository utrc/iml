/*
 * Copyright (c) 2019 United Technologies Corporation. All rights reserved.
 * See License.txt in the project root directory for license information. */
package com.utc.utrc.hermes.iml.lib

import com.utc.utrc.hermes.iml.iml.NamedType
import com.utc.utrc.hermes.iml.custom.ImlCustomFactory
import com.utc.utrc.hermes.iml.iml.ImlType
import com.utc.utrc.hermes.iml.iml.SimpleTypeReference
import java.util.Map
import com.utc.utrc.hermes.iml.iml.Symbol
import com.utc.utrc.hermes.iml.iml.Model
import org.eclipse.emf.ecore.resource.ResourceSet
import com.google.inject.Singleton
import com.google.inject.Inject
import org.eclipse.xtext.naming.IQualifiedNameProvider
import org.eclipse.xtext.naming.QualifiedName

@Singleton
class ImlStdLib {
	
	@Inject extension private IQualifiedNameProvider qnp ;

	private Map<String, Map<String, Symbol>> imlStdSymbols = newHashMap;
	
	public val INT = "Int";
	public val REAL = "Real";
	public val BOOL = "Bool";
	public val STRING = "String";
	public val CHAR = "Char" ;
	public val NULL = "Null";
	
	public val IML_LANG = "iml.lang"
	
	def getIntType() {
		getLangType(INT)
	}
	
	def getRealType() {
		getLangType(REAL)
	}
	
	def getBoolType() {
		getLangType(BOOL)
	}
	
	def getStringType() {
		getLangType(STRING)
	}
	
	def getCharType() {
		getLangType(CHAR)
	}
	
	def getNullType() {
		getLangType(NULL)
	}
	
	def boolean isPrimitive(ImlType t) {
		return t.isInt || t.isReal || t.isBool || t.isString || t.isChar
	}

	def boolean isNumeric(ImlType t) {
		return t.isInt || t.isReal
	}
	
	def boolean isPrimitive(NamedType t) {
		return t.isInt || t.isReal || t.isBool || t.isString || t.isChar
	}

	def boolean isNumeric(NamedType t) {
		return t.isInt || t.isReal
	}
	
	def boolean isInt(ImlType t) {
		if (t instanceof SimpleTypeReference) {
			return isInt(t.type)
		}
		return false
	}
	
	def boolean isInt(NamedType t) {
		return intType == t || (t !== null && intType.fullyQualifiedName.equals(t.fullyQualifiedName))
	}
	
	def boolean isReal(ImlType t) {
		if (t instanceof SimpleTypeReference) {
			return isReal(t.type)
		}
		return false
	}
	
	def boolean isReal(NamedType t) {
		return realType == t || (t !== null && realType.fullyQualifiedName.equals(t.fullyQualifiedName))
	}
	
	def boolean isBool(ImlType t) {
		if (t instanceof SimpleTypeReference) {
			return isBool(t.type)
		}
		return false
	}
	
	def boolean isBool(NamedType t) {
		return boolType == t || (t !== null && boolType.fullyQualifiedName.equals(t.fullyQualifiedName))
	}
	
	def boolean isString(ImlType t) {
		if (t instanceof SimpleTypeReference) {
			return isString(t.type)
		}
		return false
	}
	
	def boolean isString(NamedType t) {
		return stringType == t || (t !== null && stringType.fullyQualifiedName.equals(t.fullyQualifiedName))
	}
	
	def boolean isChar(ImlType t) {
		if (t instanceof SimpleTypeReference) {
			return isChar(t.type)
		}
		return false
	}
	
	def boolean isChar(NamedType t) {
		return charType == t || (t !== null && charType.fullyQualifiedName.equals(t.fullyQualifiedName))
	}
	
	def createIntRef() {
		return ImlCustomFactory.INST.createSimpleTypeReference(intType);
	}
	
	def createRealRef() {
		return ImlCustomFactory.INST.createSimpleTypeReference(realType);
	}
	
	def createBoolRef() {
		return ImlCustomFactory.INST.createSimpleTypeReference(boolType);
	}
	
	def createStringRef() {
		return ImlCustomFactory.INST.createSimpleTypeReference(stringType);
	}
	
	def createCharRef() {
		return ImlCustomFactory.INST.createSimpleTypeReference(charType);
	}

	def createNullRef() {
		return ImlCustomFactory.INST.createSimpleTypeReference(nullType);
	}
	
	def getLangType(String typeName) {
		getNamedType(IML_LANG, typeName)
	}
	
	def getNamedType(String modelName, String typeName) {
		return getSymbol(modelName, typeName, NamedType)
	}
	
	def getSymbol(String modelName, String typeName) {
		if (imlStdSymbols.containsKey(modelName)) {
			return imlStdSymbols.get(modelName).get(typeName)
		}
		return null
	}
	
	def <T extends Symbol> T getSymbol(String modelName, String typeName, Class<T> symbolClass) {
		val symbol = getSymbol(modelName, typeName)
		if (symbol  !== null && symbolClass.isInstance(symbol)) {
			return symbolClass.cast(symbol)
		}
		return null
	}
	
	def populateLibrary(ResourceSet rs) {
		for (resource : rs.resources) {
			if (resource.contents.get(0) instanceof Model) {
				populate(resource.contents.get(0) as Model)
			}
		}
	}
	
	def populate(Model model) {
		if (model.stdLib) {
			if (!imlStdSymbols.containsKey(model.name)) {
				imlStdSymbols.put(model.name, newHashMap)
			}
			for (symbol : model.symbols) {
				imlStdSymbols.get(model.name).put(symbol.name, symbol)
			}
		}
	}
	
	def boolean isStdLib(Model model) {
		return model.name !== null && model.name.startsWith("iml.")
	}

	
}