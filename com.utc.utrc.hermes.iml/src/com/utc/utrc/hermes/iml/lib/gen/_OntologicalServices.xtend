/*
 * Auto-Generated, please don't modify. Add your own logic to the child class {@link com.utc.utrc.hermes.iml.lib.OntologicalServices} instead
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
class _OntologicalServices extends BasicServices
 {
	public static final String PACKAGE_NAME = "iml.synchdf.ontological.gen"
	public static final String SYNCHRONOUS = "Synchronous"	
	public static final String INIT_VAR = "init"	
	public static final String PRE_VAR = "pre"	
	public static final String CURRENT_VAR = "current"	
	public static final String LET = "Let"	
	public static final String WHEN_VAR = "when"	
	
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
	
	
	override getPackageName() {
		PACKAGE_NAME
	}
}
