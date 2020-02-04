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
	public static final String TOREALSTREAM_SYMBOL = "toRealStream"	
	public static final String OR_SYMBOL = "or"	
	public static final String TOBOOLSTREAM_SYMBOL = "toBoolStream"	
	public static final String REALSTREAM = "RealStream"	
	public static final String TOSTREAM_SYMBOL = "toStream"	
	public static final String PLUS_SYMBOL = "plus"	
	public static final String SYNCHRONOUS = "Synchronous"	
	public static final String BOOLSTREAM = "BoolStream"	
	public static final String NOT_SYMBOL = "not"	
	public static final String AND_SYMBOL = "and"	
	public static final String LET = "Let"	
	public static final String STREAM = "Stream"	
	public static final String STREAM_PRE_VAR = "pre"
	public static final String STREAM_INIT_VAR = "init"
	public static final String STREAM_THEN_VAR = "then"
	public static final String STREAM_CURRENT_VAR = "current"
	public static final String STREAM_WHEN_VAR = "when"
	public static final String STREAM_VALUE_VAR = "value"
	public static final String STREAM_EQ_VAR = "eq"
	public static final String ITE_SYMBOL = "ite"	
	public static final String INTSTREAM = "IntStream"	
	public static final String TOINTSTREAM_SYMBOL = "toIntStream"	
	
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
	def getNumericTypePlusVar() {
		return ImlUtil.findSymbol(getType(NUMERICTYPE), NUMERICTYPE_PLUS_VAR, true) as SymbolDeclaration;
	}
	/**
	 * Get the minus symbol declaration inside the given NumericType type. If recursive is true
	 * then it will search for symbols inside type's parents 
	 */
	def getNumericTypeMinusVar() {
		return ImlUtil.findSymbol(getType(NUMERICTYPE), NUMERICTYPE_MINUS_VAR, true) as SymbolDeclaration;
	}
	/**
	 * Get the div symbol declaration inside the given NumericType type. If recursive is true
	 * then it will search for symbols inside type's parents 
	 */
	def getNumericTypeDivVar() {
		return ImlUtil.findSymbol(getType(NUMERICTYPE), NUMERICTYPE_DIV_VAR, true) as SymbolDeclaration;
	}
	/**
	 * Get the mult symbol declaration inside the given NumericType type. If recursive is true
	 * then it will search for symbols inside type's parents 
	 */
	def getNumericTypeMultVar() {
		return ImlUtil.findSymbol(getType(NUMERICTYPE), NUMERICTYPE_MULT_VAR, true) as SymbolDeclaration;
	}
	/**
	 * Get the leq symbol declaration inside the given NumericType type. If recursive is true
	 * then it will search for symbols inside type's parents 
	 */
	def getNumericTypeLeqVar() {
		return ImlUtil.findSymbol(getType(NUMERICTYPE), NUMERICTYPE_LEQ_VAR, true) as SymbolDeclaration;
	}
	/**
	 * Get the geq symbol declaration inside the given NumericType type. If recursive is true
	 * then it will search for symbols inside type's parents 
	 */
	def getNumericTypeGeqVar() {
		return ImlUtil.findSymbol(getType(NUMERICTYPE), NUMERICTYPE_GEQ_VAR, true) as SymbolDeclaration;
	}
	/**
	 * Get the le symbol declaration inside the given NumericType type. If recursive is true
	 * then it will search for symbols inside type's parents 
	 */
	def getNumericTypeLeVar() {
		return ImlUtil.findSymbol(getType(NUMERICTYPE), NUMERICTYPE_LE_VAR, true) as SymbolDeclaration;
	}
	/**
	 * Get the gr symbol declaration inside the given NumericType type. If recursive is true
	 * then it will search for symbols inside type's parents 
	 */
	def getNumericTypeGrVar() {
		return ImlUtil.findSymbol(getType(NUMERICTYPE), NUMERICTYPE_GR_VAR, true) as SymbolDeclaration;
	}
	/**
	 * Get ToRealStreamSymbol symbol declaration
	 */
	 def getToRealStreamSymbol() {
	 	return getSymbolDeclaration(TOREALSTREAM_SYMBOL)
	 }
	/**
	 * Get OrSymbol symbol declaration
	 */
	 def getOrSymbol() {
	 	return getSymbolDeclaration(OR_SYMBOL)
	 }
	/**
	 * Get ToBoolStreamSymbol symbol declaration
	 */
	 def getToBoolStreamSymbol() {
	 	return getSymbolDeclaration(TOBOOLSTREAM_SYMBOL)
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
	 * Get ToStreamSymbol symbol declaration
	 */
	 def getToStreamSymbol() {
	 	return getSymbolDeclaration(TOSTREAM_SYMBOL)
	 }
	/**
	 * Get PlusSymbol symbol declaration
	 */
	 def getPlusSymbol() {
	 	return getSymbolDeclaration(PLUS_SYMBOL)
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
	 * Get NotSymbol symbol declaration
	 */
	 def getNotSymbol() {
	 	return getSymbolDeclaration(NOT_SYMBOL)
	 }
	/**
	 * Get AndSymbol symbol declaration
	 */
	 def getAndSymbol() {
	 	return getSymbolDeclaration(AND_SYMBOL)
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
	def getStreamPreVar() {
		return ImlUtil.findSymbol(getType(STREAM), STREAM_PRE_VAR, true) as SymbolDeclaration;
	}
	/**
	 * Get the init symbol declaration inside the given Stream type. If recursive is true
	 * then it will search for symbols inside type's parents 
	 */
	def getStreamInitVar() {
		return ImlUtil.findSymbol(getType(STREAM), STREAM_INIT_VAR, true) as SymbolDeclaration;
	}
	/**
	 * Get the then symbol declaration inside the given Stream type. If recursive is true
	 * then it will search for symbols inside type's parents 
	 */
	def getStreamThenVar() {
		return ImlUtil.findSymbol(getType(STREAM), STREAM_THEN_VAR, true) as SymbolDeclaration;
	}
	/**
	 * Get the current symbol declaration inside the given Stream type. If recursive is true
	 * then it will search for symbols inside type's parents 
	 */
	def getStreamCurrentVar() {
		return ImlUtil.findSymbol(getType(STREAM), STREAM_CURRENT_VAR, true) as SymbolDeclaration;
	}
	/**
	 * Get the when symbol declaration inside the given Stream type. If recursive is true
	 * then it will search for symbols inside type's parents 
	 */
	def getStreamWhenVar() {
		return ImlUtil.findSymbol(getType(STREAM), STREAM_WHEN_VAR, true) as SymbolDeclaration;
	}
	/**
	 * Get the value symbol declaration inside the given Stream type. If recursive is true
	 * then it will search for symbols inside type's parents 
	 */
	def getStreamValueVar() {
		return ImlUtil.findSymbol(getType(STREAM), STREAM_VALUE_VAR, true) as SymbolDeclaration;
	}
	/**
	 * Get the eq symbol declaration inside the given Stream type. If recursive is true
	 * then it will search for symbols inside type's parents 
	 */
	def getStreamEqVar() {
		return ImlUtil.findSymbol(getType(STREAM), STREAM_EQ_VAR, true) as SymbolDeclaration;
	}
	/**
	 * Get IteSymbol symbol declaration
	 */
	 def getIteSymbol() {
	 	return getSymbolDeclaration(ITE_SYMBOL)
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
	/**
	 * Get ToIntStreamSymbol symbol declaration
	 */
	 def getToIntStreamSymbol() {
	 	return getSymbolDeclaration(TOINTSTREAM_SYMBOL)
	 }
	
	override getPackageName() {
		PACKAGE_NAME
	}
}
