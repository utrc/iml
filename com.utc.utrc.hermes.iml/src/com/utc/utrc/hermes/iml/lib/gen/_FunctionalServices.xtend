/*
 * Auto-Generated, please don't modify. Add your own logic to the child class {@link com.utc.utrc.hermes.iml.lib.FunctionalServices} instead
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
class _FunctionalServices extends BasicServices
 {
	public static final String PACKAGE_NAME = "iml.synchrony.functional"
	public static final String SYNCHRONOUS = "Synchronous"	
	public static final String BOOLSTREAM = "BoolStream"	
	public static final String PRE_SYMBOL = "pre"	
	public static final String CONST_SYMBOL = "const"	
	public static final String STREAM_SYMBOL = "stream"	
	public static final String LIFT1_SYMBOL = "lift1"	
	public static final String STREAM = "Stream"	
	public static final String EQ_SYMBOL = "eq"	
	public static final String REALSTREAM = "RealStream"	
	public static final String INTSTREAM = "IntStream"	
	
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
	 * Get PreSymbol symbol declaration
	 */
	 def getPreSymbol() {
	 	return getSymbolDeclaration(PRE_SYMBOL)
	 }
	/**
	 * Get ConstSymbol symbol declaration
	 */
	 def getConstSymbol() {
	 	return getSymbolDeclaration(CONST_SYMBOL)
	 }
	/**
	 * Get StreamSymbol symbol declaration
	 */
	 def getStreamSymbol() {
	 	return getSymbolDeclaration(STREAM_SYMBOL)
	 }
	/**
	 * Get Lift1Symbol symbol declaration
	 */
	 def getLift1Symbol() {
	 	return getSymbolDeclaration(LIFT1_SYMBOL)
	 }
	/**
	 * get Stream type declaration
	 */
	def getStreamType() {
		return getType(STREAM)
	}
	
	/**
	 * check whether the given type is Stream type
	 */
	def isStream(NamedType type) {
		return getStreamType == type
	}
	
	/**
	 * Get all symbols inside the given type that are Stream type. If recursive is true
	 * then it will search for symbols inside type's parents
	 */
	def getStreamSymbols(NamedType type, boolean recursive) {
		ImlUtil.getSymbolsWithType(type, getStreamType, recursive)
	}
	/**
	 * Get EqSymbol symbol declaration
	 */
	 def getEqSymbol() {
	 	return getSymbolDeclaration(EQ_SYMBOL)
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
