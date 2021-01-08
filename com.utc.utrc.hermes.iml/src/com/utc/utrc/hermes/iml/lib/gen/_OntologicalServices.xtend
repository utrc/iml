/*
 * Auto-Generated, please don't modify. Add your own logic to the child class {@link com.utc.utrc.hermes.iml.lib.OntologicalServices} instead
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
class _OntologicalServices extends BasicServices
 {
	public static final String PACKAGE_NAME = "iml.synchdf.ontological"
	public static final String SYNCHRONOUS = "Synchronous"	
	public static final String INIT_SYMBOL = "init"	
	public static final String PRE_SYMBOL = "pre"	
	public static final String CURRENT_SYMBOL = "current"	
	public static final String LET = "Let"	
	public static final String WHEN_SYMBOL = "when"	
	
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
	 * Get InitSymbol symbol declaration
	 */
	 def getInitSymbol() {
	 	return getSymbolDeclaration(INIT_SYMBOL)
	 }
	/**
	 * Get PreSymbol symbol declaration
	 */
	 def getPreSymbol() {
	 	return getSymbolDeclaration(PRE_SYMBOL)
	 }
	/**
	 * Get CurrentSymbol symbol declaration
	 */
	 def getCurrentSymbol() {
	 	return getSymbolDeclaration(CURRENT_SYMBOL)
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
	 * Get WhenSymbol symbol declaration
	 */
	 def getWhenSymbol() {
	 	return getSymbolDeclaration(WHEN_SYMBOL)
	 }
	
	override getPackageName() {
		PACKAGE_NAME
	}
	
	/**
	 * Checks if a symbol is defined inside Ontological IML library
	 */
	def isOntologicalSymbol(Symbol symbol) {
		if (symbol !== null) {
			val containerModel = ImlUtil.getContainerOfType(symbol, Model)
			if (containerModel.name == getPackageName()) {
				return true;
			}
		}
		return false;
	}
}
