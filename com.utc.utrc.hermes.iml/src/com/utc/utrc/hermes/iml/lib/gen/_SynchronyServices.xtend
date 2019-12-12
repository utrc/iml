/*
 * Auto-Generated, please don't modify. Add your own logic to the child class {@link com.utc.utrc.hermes.iml.lib.SynchronyServices} instead
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
class _SynchronyServices extends BasicServices
 {
	public static final String PACKAGE_NAME = "iml.synchrony"
	public static final String NUMERICTYPE = "NumericType"	
	public static final String NUMERICTYPE_PLUS_VAR = "plus"
	public static final String NUMERICTYPE_MINUS_VAR = "minus"
	public static final String NUMERICTYPE_DIV_VAR = "div"
	public static final String NUMERICTYPE_MULT_VAR = "mult"
	public static final String NUMERICTYPE_LEQ_VAR = "leq"
	public static final String NUMERICTYPE_GEQ_VAR = "geq"
	public static final String NUMERICTYPE_LE_VAR = "le"
	public static final String NUMERICTYPE_GR_VAR = "gr"
	public static final String TOREALSTREAM_VAR = "toRealStream"	
	public static final String OR_VAR = "or"	
	public static final String TOBOOLSTREAM_VAR = "toBoolStream"	
	public static final String REALSTREAM = "RealStream"	
	public static final String TOSTREAM_VAR = "toStream"	
	public static final String PLUS_VAR = "plus"	
	public static final String SYNCHRONOUS = "Synchronous"	
	public static final String BOOLSTREAM = "BoolStream"	
	public static final String NOT_VAR = "not"	
	public static final String AND_VAR = "and"	
	public static final String LET = "Let"	
	public static final String STREAM = "Stream"	
	public static final String STREAM_PRE_VAR = "pre"
	public static final String STREAM_INIT_VAR = "init"
	public static final String STREAM_THEN_VAR = "then"
	public static final String STREAM_CURRENT_VAR = "current"
	public static final String STREAM_WHEN_VAR = "when"
	public static final String STREAM_VALUE_VAR = "value"
	public static final String STREAM_EQ_VAR = "eq"
	public static final String ITE_VAR = "ite"	
	public static final String INTSTREAM = "IntStream"	
	public static final String TOINTSTREAM_VAR = "toIntStream"	
	
	/**
	 * get NumericType trait declaration
	 */
	def getNumericTypeTrait() {
		return getTrait(NUMERICTYPE)
	}
	
	/**
	 * check wether the given eObject refines or exhibits the NumericType trait
	 */
	def isNumericType(EObject eObject) {
		return ImlUtil.exhibitsOrRefines(eObject, getNumericTypeTrait);
	}
	
	/**
	 * Get all symbols inside the given type that exhibits/refines the NumericType trait. If recursive is true
	 * then it will search for symbols inside type's parents
	 */
	def getNumericTypeSymbols(NamedType type, boolean recursive) {
		ImlUtil.getSymbolsWithTrait(type, getNumericTypeTrait, recursive);
	}
	
	/**
	 * Get the plus symbol declaration inside the given NumericType type. If recursive is true
	 * then it will search for symbols inside type's parents 
	 */
	def getNumericTypePlus(NamedType type, boolean recursive) {
		if (isNumericType(type)) {
			return ImlUtil.findSymbol(type, NUMERICTYPE_PLUS_VAR, recursive) as SymbolDeclaration;
		}
		return null;
	}
	/**
	 * Get the minus symbol declaration inside the given NumericType type. If recursive is true
	 * then it will search for symbols inside type's parents 
	 */
	def getNumericTypeMinus(NamedType type, boolean recursive) {
		if (isNumericType(type)) {
			return ImlUtil.findSymbol(type, NUMERICTYPE_MINUS_VAR, recursive) as SymbolDeclaration;
		}
		return null;
	}
	/**
	 * Get the div symbol declaration inside the given NumericType type. If recursive is true
	 * then it will search for symbols inside type's parents 
	 */
	def getNumericTypeDiv(NamedType type, boolean recursive) {
		if (isNumericType(type)) {
			return ImlUtil.findSymbol(type, NUMERICTYPE_DIV_VAR, recursive) as SymbolDeclaration;
		}
		return null;
	}
	/**
	 * Get the mult symbol declaration inside the given NumericType type. If recursive is true
	 * then it will search for symbols inside type's parents 
	 */
	def getNumericTypeMult(NamedType type, boolean recursive) {
		if (isNumericType(type)) {
			return ImlUtil.findSymbol(type, NUMERICTYPE_MULT_VAR, recursive) as SymbolDeclaration;
		}
		return null;
	}
	/**
	 * Get the leq symbol declaration inside the given NumericType type. If recursive is true
	 * then it will search for symbols inside type's parents 
	 */
	def getNumericTypeLeq(NamedType type, boolean recursive) {
		if (isNumericType(type)) {
			return ImlUtil.findSymbol(type, NUMERICTYPE_LEQ_VAR, recursive) as SymbolDeclaration;
		}
		return null;
	}
	/**
	 * Get the geq symbol declaration inside the given NumericType type. If recursive is true
	 * then it will search for symbols inside type's parents 
	 */
	def getNumericTypeGeq(NamedType type, boolean recursive) {
		if (isNumericType(type)) {
			return ImlUtil.findSymbol(type, NUMERICTYPE_GEQ_VAR, recursive) as SymbolDeclaration;
		}
		return null;
	}
	/**
	 * Get the le symbol declaration inside the given NumericType type. If recursive is true
	 * then it will search for symbols inside type's parents 
	 */
	def getNumericTypeLe(NamedType type, boolean recursive) {
		if (isNumericType(type)) {
			return ImlUtil.findSymbol(type, NUMERICTYPE_LE_VAR, recursive) as SymbolDeclaration;
		}
		return null;
	}
	/**
	 * Get the gr symbol declaration inside the given NumericType type. If recursive is true
	 * then it will search for symbols inside type's parents 
	 */
	def getNumericTypeGr(NamedType type, boolean recursive) {
		if (isNumericType(type)) {
			return ImlUtil.findSymbol(type, NUMERICTYPE_GR_VAR, recursive) as SymbolDeclaration;
		}
		return null;
	}
	/**
	 * get RealStream type declaration
	 */
	def getRealStreamType() {
		return getType(REALSTREAM)
	}
	
	/**
	 * check whether the given type is RealStream type
	 */
	def isRealStream(NamedType type) {
		return getRealStreamType == type
	}
	
	/**
	 * Get all symbols inside the given type that are RealStream type. If recursive is true
	 * then it will search for symbols inside type's parents
	 */
	def getRealStreamSymbols(NamedType type, boolean recursive) {
		ImlUtil.getSymbolsWithType(type, getRealStreamType, recursive)
	}
	/**
	 * get Synchronous trait declaration
	 */
	def getSynchronousTrait() {
		return getTrait(SYNCHRONOUS)
	}
	
	/**
	 * check wether the given eObject refines or exhibits the Synchronous trait
	 */
	def isSynchronous(EObject eObject) {
		return ImlUtil.exhibitsOrRefines(eObject, getSynchronousTrait);
	}
	
	/**
	 * Get all symbols inside the given type that exhibits/refines the Synchronous trait. If recursive is true
	 * then it will search for symbols inside type's parents
	 */
	def getSynchronousSymbols(NamedType type, boolean recursive) {
		ImlUtil.getSymbolsWithTrait(type, getSynchronousTrait, recursive);
	}
	
	/**
	 * get BoolStream type declaration
	 */
	def getBoolStreamType() {
		return getType(BOOLSTREAM)
	}
	
	/**
	 * check whether the given type is BoolStream type
	 */
	def isBoolStream(NamedType type) {
		return getBoolStreamType == type
	}
	
	/**
	 * Get all symbols inside the given type that are BoolStream type. If recursive is true
	 * then it will search for symbols inside type's parents
	 */
	def getBoolStreamSymbols(NamedType type, boolean recursive) {
		ImlUtil.getSymbolsWithType(type, getBoolStreamType, recursive)
	}
	/**
	 * get Let annotation declaration
	 */
	def getLetAnnotation() {
		return getAnnotation(LET)
	}
	
	/**
	 * check whether the given type is Let annotation
	 */
	def isLet(NamedType annotation) {
		return getLetAnnotation == annotation
	}
	
	/**
	 * Get all symbols inside the given type that has the Let annotation. If recursive is true
	 * then it will search for symbols inside type's parents
	 */
	def getLetSymbols(NamedType type, boolean recursive) {
		ImlUtil.getSymbolsWithProperty(type, getLetAnnotation, recursive);
	}		
	
	/**
	 * get Stream trait declaration
	 */
	def getStreamTrait() {
		return getTrait(STREAM)
	}
	
	/**
	 * check wether the given eObject refines or exhibits the Stream trait
	 */
	def isStream(EObject eObject) {
		return ImlUtil.exhibitsOrRefines(eObject, getStreamTrait);
	}
	
	/**
	 * Get all symbols inside the given type that exhibits/refines the Stream trait. If recursive is true
	 * then it will search for symbols inside type's parents
	 */
	def getStreamSymbols(NamedType type, boolean recursive) {
		ImlUtil.getSymbolsWithTrait(type, getStreamTrait, recursive);
	}
	
	/**
	 * Get the pre symbol declaration inside the given Stream type. If recursive is true
	 * then it will search for symbols inside type's parents 
	 */
	def getStreamPre(NamedType type, boolean recursive) {
		if (isStream(type)) {
			return ImlUtil.findSymbol(type, STREAM_PRE_VAR, recursive) as SymbolDeclaration;
		}
		return null;
	}
	/**
	 * Get the init symbol declaration inside the given Stream type. If recursive is true
	 * then it will search for symbols inside type's parents 
	 */
	def getStreamInit(NamedType type, boolean recursive) {
		if (isStream(type)) {
			return ImlUtil.findSymbol(type, STREAM_INIT_VAR, recursive) as SymbolDeclaration;
		}
		return null;
	}
	/**
	 * Get the then symbol declaration inside the given Stream type. If recursive is true
	 * then it will search for symbols inside type's parents 
	 */
	def getStreamThen(NamedType type, boolean recursive) {
		if (isStream(type)) {
			return ImlUtil.findSymbol(type, STREAM_THEN_VAR, recursive) as SymbolDeclaration;
		}
		return null;
	}
	/**
	 * Get the current symbol declaration inside the given Stream type. If recursive is true
	 * then it will search for symbols inside type's parents 
	 */
	def getStreamCurrent(NamedType type, boolean recursive) {
		if (isStream(type)) {
			return ImlUtil.findSymbol(type, STREAM_CURRENT_VAR, recursive) as SymbolDeclaration;
		}
		return null;
	}
	/**
	 * Get the when symbol declaration inside the given Stream type. If recursive is true
	 * then it will search for symbols inside type's parents 
	 */
	def getStreamWhen(NamedType type, boolean recursive) {
		if (isStream(type)) {
			return ImlUtil.findSymbol(type, STREAM_WHEN_VAR, recursive) as SymbolDeclaration;
		}
		return null;
	}
	/**
	 * Get the value symbol declaration inside the given Stream type. If recursive is true
	 * then it will search for symbols inside type's parents 
	 */
	def getStreamValue(NamedType type, boolean recursive) {
		if (isStream(type)) {
			return ImlUtil.findSymbol(type, STREAM_VALUE_VAR, recursive) as SymbolDeclaration;
		}
		return null;
	}
	/**
	 * Get the eq symbol declaration inside the given Stream type. If recursive is true
	 * then it will search for symbols inside type's parents 
	 */
	def getStreamEq(NamedType type, boolean recursive) {
		if (isStream(type)) {
			return ImlUtil.findSymbol(type, STREAM_EQ_VAR, recursive) as SymbolDeclaration;
		}
		return null;
	}
	/**
	 * get IntStream type declaration
	 */
	def getIntStreamType() {
		return getType(INTSTREAM)
	}
	
	/**
	 * check whether the given type is IntStream type
	 */
	def isIntStream(NamedType type) {
		return getIntStreamType == type
	}
	
	/**
	 * Get all symbols inside the given type that are IntStream type. If recursive is true
	 * then it will search for symbols inside type's parents
	 */
	def getIntStreamSymbols(NamedType type, boolean recursive) {
		ImlUtil.getSymbolsWithType(type, getIntStreamType, recursive)
	}
	
	override getPackageName() {
		PACKAGE_NAME
	}
}
