/*
 * Auto-Generated, please don't modify. Add your own logic to the child class {@link com.utc.utrc.hermes.iml.lib.LangServices} instead
 */
package com.utc.utrc.hermes.iml.lib.gen

import com.google.inject.Singleton
import com.google.inject.Inject
import com.utc.utrc.hermes.iml.iml.Trait
import com.utc.utrc.hermes.iml.iml.NamedType
import com.utc.utrc.hermes.iml.util.ImlUtil
import com.utc.utrc.hermes.iml.lib.BasicServices
import org.eclipse.emf.ecore.EObject
import com.utc.utrc.hermes.iml.iml.SymbolDeclaration

@Singleton
class _LangServices extends BasicServices
 {
	public static final String PACKAGE_NAME = "iml.lang"
	public static final String INT2STR_VAR = "int2str"	
	public static final String STR2RE_VAR = "str2re"	
	public static final String RE2STR_VAR = "re2str"	
	public static final String STR2INT_VAR = "str2int"	
	public static final String BOOL = "Bool"	
	public static final String CHAR = "Char"	
	public static final String REAL = "Real"	
	public static final String DOC = "Doc"	
	public static final String DOC_TEXT_VAR = "text"
	public static final String EMPTYSTRING_VAR = "emptyString"	
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
	def getDocText(NamedType type, boolean recursive) {
		if (isDoc(type)) {
			return ImlUtil.findSymbol(type, DOC_TEXT_VAR, recursive) as SymbolDeclaration;
		}
		return null;
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
	def getStringConcat(NamedType type, boolean recursive) {
		if (isString(type)) {
			return ImlUtil.findSymbol(type, STRING_CONCAT_VAR, recursive) as SymbolDeclaration;
		}
		return null;
	}
	/**
	 * Get the length symbol declaration inside the given String type. If recursive is true
	 * then it will search for symbols inside type's parents 
	 */
	def getStringLength(NamedType type, boolean recursive) {
		if (isString(type)) {
			return ImlUtil.findSymbol(type, STRING_LENGTH_VAR, recursive) as SymbolDeclaration;
		}
		return null;
	}
	/**
	 * Get the contains symbol declaration inside the given String type. If recursive is true
	 * then it will search for symbols inside type's parents 
	 */
	def getStringContains(NamedType type, boolean recursive) {
		if (isString(type)) {
			return ImlUtil.findSymbol(type, STRING_CONTAINS_VAR, recursive) as SymbolDeclaration;
		}
		return null;
	}
	/**
	 * Get the indexOf symbol declaration inside the given String type. If recursive is true
	 * then it will search for symbols inside type's parents 
	 */
	def getStringIndexOf(NamedType type, boolean recursive) {
		if (isString(type)) {
			return ImlUtil.findSymbol(type, STRING_INDEXOF_VAR, recursive) as SymbolDeclaration;
		}
		return null;
	}
	/**
	 * Get the replace symbol declaration inside the given String type. If recursive is true
	 * then it will search for symbols inside type's parents 
	 */
	def getStringReplace(NamedType type, boolean recursive) {
		if (isString(type)) {
			return ImlUtil.findSymbol(type, STRING_REPLACE_VAR, recursive) as SymbolDeclaration;
		}
		return null;
	}
	/**
	 * Get the replaceAll symbol declaration inside the given String type. If recursive is true
	 * then it will search for symbols inside type's parents 
	 */
	def getStringReplaceAll(NamedType type, boolean recursive) {
		if (isString(type)) {
			return ImlUtil.findSymbol(type, STRING_REPLACEALL_VAR, recursive) as SymbolDeclaration;
		}
		return null;
	}
	/**
	 * Get the charAt symbol declaration inside the given String type. If recursive is true
	 * then it will search for symbols inside type's parents 
	 */
	def getStringCharAt(NamedType type, boolean recursive) {
		if (isString(type)) {
			return ImlUtil.findSymbol(type, STRING_CHARAT_VAR, recursive) as SymbolDeclaration;
		}
		return null;
	}
	/**
	 * Get the subStr symbol declaration inside the given String type. If recursive is true
	 * then it will search for symbols inside type's parents 
	 */
	def getStringSubStr(NamedType type, boolean recursive) {
		if (isString(type)) {
			return ImlUtil.findSymbol(type, STRING_SUBSTR_VAR, recursive) as SymbolDeclaration;
		}
		return null;
	}
	/**
	 * Get the prefixOf symbol declaration inside the given String type. If recursive is true
	 * then it will search for symbols inside type's parents 
	 */
	def getStringPrefixOf(NamedType type, boolean recursive) {
		if (isString(type)) {
			return ImlUtil.findSymbol(type, STRING_PREFIXOF_VAR, recursive) as SymbolDeclaration;
		}
		return null;
	}
	/**
	 * Get the suffixOf symbol declaration inside the given String type. If recursive is true
	 * then it will search for symbols inside type's parents 
	 */
	def getStringSuffixOf(NamedType type, boolean recursive) {
		if (isString(type)) {
			return ImlUtil.findSymbol(type, STRING_SUFFIXOF_VAR, recursive) as SymbolDeclaration;
		}
		return null;
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
}
