/*
 * Auto-Generated, please don't modify. Add your own logic to the child class {@link com.utc.utrc.hermes.iml.lib.LangServices} instead
 */
package com.utc.utrc.hermes.iml.lib.gen

import com.google.inject.Singleton
import com.google.inject.Inject
import org.eclipse.emf.ecore.EObject
import com.utc.utrc.hermes.iml.iml.Trait
import com.utc.utrc.hermes.iml.iml.NamedType
import com.utc.utrc.hermes.iml.util.ImlUtil
import com.utc.utrc.hermes.iml.lib.BasicServices
import com.utc.utrc.hermes.iml.iml.SymbolDeclaration
import com.utc.utrc.hermes.iml.iml.Model
import com.utc.utrc.hermes.iml.iml.Symbol

@Singleton
class _LangServices extends BasicServices
 {
	public static final String PACKAGE_NAME = "iml.lang"
	public static final String INT2STR_SYMBOL = "int2str"	
	public static final String STR2RE_SYMBOL = "str2re"	
	public static final String RE2STR_SYMBOL = "re2str"	
	public static final String STR2INT_SYMBOL = "str2int"	
	public static final String BOOL = "Bool"	
	public static final String CHAR = "Char"	
	public static final String REAL = "Real"	
	public static final String INTRANGE = "IntRange"	
	public static final String INTRANGE_LB_VAR = "lb"
	public static final String INTRANGE_UB_VAR = "ub"
	public static final String INTRANGE_VALUE_VAR = "value"
	public static final String DOC = "Doc"	
	public static final String DOC_TEXT_VAR = "text"
	public static final String EMPTYSTRING_SYMBOL = "emptyString"	
	public static final String STRING = "String"	
	public static final String STRING_CONCAT_VAR = "concat"
	public static final String STRING_LENGTH_VAR = "length"
	public static final String STRING_CONTAINS_VAR = "contains"
	public static final String STRING_INDEXOF_VAR = "indexOf"
	public static final String STRING_REPLACE_VAR = "replace"
	public static final String STRING_REPLACEALL_VAR = "replaceAll"
	public static final String STRING_CHARAT_VAR = "charAt"
	public static final String STRING_SUBSTR_VAR = "subStr"
	public static final String STRING_PREFIXOF_VAR = "prefixOf"
	public static final String STRING_SUFFIXOF_VAR = "suffixOf"
	public static final String INT = "Int"	
	
	/**
	 * Get Int2strSymbol symbol declaration
	 */
	 def getInt2strSymbol() {
	 	return getSymbolDeclaration(INT2STR_SYMBOL)
	 }
	/**
	 * Get Str2reSymbol symbol declaration
	 */
	 def getStr2reSymbol() {
	 	return getSymbolDeclaration(STR2RE_SYMBOL)
	 }
	/**
	 * Get Re2strSymbol symbol declaration
	 */
	 def getRe2strSymbol() {
	 	return getSymbolDeclaration(RE2STR_SYMBOL)
	 }
	/**
	 * Get Str2intSymbol symbol declaration
	 */
	 def getStr2intSymbol() {
	 	return getSymbolDeclaration(STR2INT_SYMBOL)
	 }
	/**
	 * get Bool type declaration
	 */
	def getBoolType() {
		return getType(BOOL)
	}
	
	/**
	 * check whether the given type is Bool type
	 */
	def isBool(NamedType type) {
		return getBoolType == type
	}
	
	/**
	 * Get all symbols inside the given type that are Bool type. If recursive is true
	 * then it will search for symbols inside type's parents
	 */
	def getBoolSymbols(NamedType type, boolean recursive) {
		ImlUtil.getSymbolsWithType(type, getBoolType, recursive)
	}
	/**
	 * get Char type declaration
	 */
	def getCharType() {
		return getType(CHAR)
	}
	
	/**
	 * check whether the given type is Char type
	 */
	def isChar(NamedType type) {
		return getCharType == type
	}
	
	/**
	 * Get all symbols inside the given type that are Char type. If recursive is true
	 * then it will search for symbols inside type's parents
	 */
	def getCharSymbols(NamedType type, boolean recursive) {
		ImlUtil.getSymbolsWithType(type, getCharType, recursive)
	}
	/**
	 * get Real type declaration
	 */
	def getRealType() {
		return getType(REAL)
	}
	
	/**
	 * check whether the given type is Real type
	 */
	def isReal(NamedType type) {
		return getRealType == type
	}
	
	/**
	 * Get all symbols inside the given type that are Real type. If recursive is true
	 * then it will search for symbols inside type's parents
	 */
	def getRealSymbols(NamedType type, boolean recursive) {
		ImlUtil.getSymbolsWithType(type, getRealType, recursive)
	}
	/**
	 * get IntRange type declaration
	 */
	def getIntRangeType() {
		return getType(INTRANGE)
	}
	
	/**
	 * check whether the given type is IntRange type
	 */
	def isIntRange(NamedType type) {
		return getIntRangeType == type
	}
	
	/**
	 * Get all symbols inside the given type that are IntRange type. If recursive is true
	 * then it will search for symbols inside type's parents
	 */
	def getIntRangeSymbols(NamedType type, boolean recursive) {
		ImlUtil.getSymbolsWithType(type, getIntRangeType, recursive)
	}
	/**
	 * Get the lb symbol declaration inside the given IntRange type. If recursive is true
	 * then it will search for symbols inside type's parents 
	 */
	def getIntRangeLbVar() {
		return ImlUtil.findSymbol(getType(INTRANGE), INTRANGE_LB_VAR, true) as SymbolDeclaration;
	}
	/**
	 * Get the ub symbol declaration inside the given IntRange type. If recursive is true
	 * then it will search for symbols inside type's parents 
	 */
	def getIntRangeUbVar() {
		return ImlUtil.findSymbol(getType(INTRANGE), INTRANGE_UB_VAR, true) as SymbolDeclaration;
	}
	/**
	 * Get the value symbol declaration inside the given IntRange type. If recursive is true
	 * then it will search for symbols inside type's parents 
	 */
	def getIntRangeValueVar() {
		return ImlUtil.findSymbol(getType(INTRANGE), INTRANGE_VALUE_VAR, true) as SymbolDeclaration;
	}
	/**
	 * get Doc annotation declaration
	 */
	def getDocAnnotation() {
		return getAnnotation(DOC)
	}
	
	/**
	 * check whether the given type is Doc annotation
	 */
	def isDoc(NamedType annotation) {
		return getDocAnnotation == annotation
	}
	
	/**
	 * Get all symbols inside the given type that has the Doc annotation. If recursive is true
	 * then it will search for symbols inside type's parents
	 */
	def getDocSymbols(NamedType type, boolean recursive) {
		ImlUtil.getSymbolsWithProperty(type, getDocAnnotation, recursive);
	}		
	
	/**
	 * Get the text symbol declaration inside the given Doc type. If recursive is true
	 * then it will search for symbols inside type's parents 
	 */
	def getDocTextVar() {
		return ImlUtil.findSymbol(getType(DOC), DOC_TEXT_VAR, true) as SymbolDeclaration;
	}
	/**
	 * Get EmptyStringSymbol symbol declaration
	 */
	 def getEmptyStringSymbol() {
	 	return getSymbolDeclaration(EMPTYSTRING_SYMBOL)
	 }
	/**
	 * get String type declaration
	 */
	def getStringType() {
		return getType(STRING)
	}
	
	/**
	 * check whether the given type is String type
	 */
	def isString(NamedType type) {
		return getStringType == type
	}
	
	/**
	 * Get all symbols inside the given type that are String type. If recursive is true
	 * then it will search for symbols inside type's parents
	 */
	def getStringSymbols(NamedType type, boolean recursive) {
		ImlUtil.getSymbolsWithType(type, getStringType, recursive)
	}
	/**
	 * Get the concat symbol declaration inside the given String type. If recursive is true
	 * then it will search for symbols inside type's parents 
	 */
	def getStringConcatVar() {
		return ImlUtil.findSymbol(getType(STRING), STRING_CONCAT_VAR, true) as SymbolDeclaration;
	}
	/**
	 * Get the length symbol declaration inside the given String type. If recursive is true
	 * then it will search for symbols inside type's parents 
	 */
	def getStringLengthVar() {
		return ImlUtil.findSymbol(getType(STRING), STRING_LENGTH_VAR, true) as SymbolDeclaration;
	}
	/**
	 * Get the contains symbol declaration inside the given String type. If recursive is true
	 * then it will search for symbols inside type's parents 
	 */
	def getStringContainsVar() {
		return ImlUtil.findSymbol(getType(STRING), STRING_CONTAINS_VAR, true) as SymbolDeclaration;
	}
	/**
	 * Get the indexOf symbol declaration inside the given String type. If recursive is true
	 * then it will search for symbols inside type's parents 
	 */
	def getStringIndexOfVar() {
		return ImlUtil.findSymbol(getType(STRING), STRING_INDEXOF_VAR, true) as SymbolDeclaration;
	}
	/**
	 * Get the replace symbol declaration inside the given String type. If recursive is true
	 * then it will search for symbols inside type's parents 
	 */
	def getStringReplaceVar() {
		return ImlUtil.findSymbol(getType(STRING), STRING_REPLACE_VAR, true) as SymbolDeclaration;
	}
	/**
	 * Get the replaceAll symbol declaration inside the given String type. If recursive is true
	 * then it will search for symbols inside type's parents 
	 */
	def getStringReplaceAllVar() {
		return ImlUtil.findSymbol(getType(STRING), STRING_REPLACEALL_VAR, true) as SymbolDeclaration;
	}
	/**
	 * Get the charAt symbol declaration inside the given String type. If recursive is true
	 * then it will search for symbols inside type's parents 
	 */
	def getStringCharAtVar() {
		return ImlUtil.findSymbol(getType(STRING), STRING_CHARAT_VAR, true) as SymbolDeclaration;
	}
	/**
	 * Get the subStr symbol declaration inside the given String type. If recursive is true
	 * then it will search for symbols inside type's parents 
	 */
	def getStringSubStrVar() {
		return ImlUtil.findSymbol(getType(STRING), STRING_SUBSTR_VAR, true) as SymbolDeclaration;
	}
	/**
	 * Get the prefixOf symbol declaration inside the given String type. If recursive is true
	 * then it will search for symbols inside type's parents 
	 */
	def getStringPrefixOfVar() {
		return ImlUtil.findSymbol(getType(STRING), STRING_PREFIXOF_VAR, true) as SymbolDeclaration;
	}
	/**
	 * Get the suffixOf symbol declaration inside the given String type. If recursive is true
	 * then it will search for symbols inside type's parents 
	 */
	def getStringSuffixOfVar() {
		return ImlUtil.findSymbol(getType(STRING), STRING_SUFFIXOF_VAR, true) as SymbolDeclaration;
	}
	/**
	 * get Int type declaration
	 */
	def getIntType() {
		return getType(INT)
	}
	
	/**
	 * check whether the given type is Int type
	 */
	def isInt(NamedType type) {
		return getIntType == type
	}
	
	/**
	 * Get all symbols inside the given type that are Int type. If recursive is true
	 * then it will search for symbols inside type's parents
	 */
	def getIntSymbols(NamedType type, boolean recursive) {
		ImlUtil.getSymbolsWithType(type, getIntType, recursive)
	}
	
	override getPackageName() {
		PACKAGE_NAME
	}
	
	/**
	 * Checks if a symbol is defined inside Lang IML library
	 */
	def isLangSymbol(Symbol symbol) {
		if (symbol !== null) {
			val containerModel = ImlUtil.getContainerOfType(symbol, Model)
			if (containerModel.name == getPackageName()) {
				return true;
			}
		}
		return false;
	}
}
