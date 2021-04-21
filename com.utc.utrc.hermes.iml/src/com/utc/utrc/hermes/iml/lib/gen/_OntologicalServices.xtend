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
import com.utc.utrc.hermes.iml.iml.TypeWithProperties
import com.utc.utrc.hermes.iml.iml.SimpleTypeReference

@Singleton
class _OntologicalServices extends BasicServices
 {
	public static final String PACKAGE_NAME = "iml.synchdf.ontological"
	public static final String SYNCHRONOUS = "Synchronous"	
	public static final String INIT_SYMBOL = "init"	
	public static final String PRE_SYMBOL = "pre"	
	public static final String CURRENT_SYMBOL = "current"	
	public static final String OUTPUTVAR = "OutputVar"	
	public static final String LET = "Let"	
	public static final String LOCALVAR = "LocalVar"	
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
	 * get OutputVar annotation declaration
	 */
	def getOutputVarAnnotation() {
		return getAnnotation(OUTPUTVAR)
	}
	
	/**
	 * check whether the given type is OutputVar annotation
	 */
	def isOutputVar(NamedType annotation) {
		return getOutputVarAnnotation == annotation
	}
	
	/**
	 * check whether the given symbol is annotated with OutputVar annotation
	 */
	def hasOutputVarAnnotation(Symbol symbol) {
		if (symbol.propertylist !== null) {
			return symbol.propertylist.properties.map[(it.ref as SimpleTypeReference).type].contains(getOutputVarAnnotation())	
		}
		return false;
	}
	
	/**
	 * check whether the given type is annotated with OutputVar annotation
	 */
	def hasOutputVarAnnotation(TypeWithProperties type) {
		if (type.properties !== null) {
			return type.properties.properties.map[(it.ref as SimpleTypeReference).type].contains(getOutputVarAnnotation())	
		}
		return false;
	}
	
	/**
	 * Get all symbols inside the given type that has the OutputVar annotation. If recursive is true
	 * then it will search for symbols inside type's parents
	 */
	def getOutputVarSymbols(NamedType type, boolean recursive) {
		ImlUtil.getSymbolsWithProperty(type, getOutputVarAnnotation, recursive);
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
	 * check whether the given symbol is annotated with Let annotation
	 */
	def hasLetAnnotation(Symbol symbol) {
		if (symbol.propertylist !== null) {
			return symbol.propertylist.properties.map[(it.ref as SimpleTypeReference).type].contains(getLetAnnotation())	
		}
		return false;
	}
	
	/**
	 * check whether the given type is annotated with Let annotation
	 */
	def hasLetAnnotation(TypeWithProperties type) {
		if (type.properties !== null) {
			return type.properties.properties.map[(it.ref as SimpleTypeReference).type].contains(getLetAnnotation())	
		}
		return false;
	}
	
	/**
	 * Get all symbols inside the given type that has the Let annotation. If recursive is true
	 * then it will search for symbols inside type's parents
	 */
	def getLetSymbols(NamedType type, boolean recursive) {
		ImlUtil.getSymbolsWithProperty(type, getLetAnnotation, recursive);
	}		
	
	/**
	 * get LocalVar annotation declaration
	 */
	def getLocalVarAnnotation() {
		return getAnnotation(LOCALVAR)
	}
	
	/**
	 * check whether the given type is LocalVar annotation
	 */
	def isLocalVar(NamedType annotation) {
		return getLocalVarAnnotation == annotation
	}
	
	/**
	 * check whether the given symbol is annotated with LocalVar annotation
	 */
	def hasLocalVarAnnotation(Symbol symbol) {
		if (symbol.propertylist !== null) {
			return symbol.propertylist.properties.map[(it.ref as SimpleTypeReference).type].contains(getLocalVarAnnotation())	
		}
		return false;
	}
	
	/**
	 * check whether the given type is annotated with LocalVar annotation
	 */
	def hasLocalVarAnnotation(TypeWithProperties type) {
		if (type.properties !== null) {
			return type.properties.properties.map[(it.ref as SimpleTypeReference).type].contains(getLocalVarAnnotation())	
		}
		return false;
	}
	
	/**
	 * Get all symbols inside the given type that has the LocalVar annotation. If recursive is true
	 * then it will search for symbols inside type's parents
	 */
	def getLocalVarSymbols(NamedType type, boolean recursive) {
		ImlUtil.getSymbolsWithProperty(type, getLocalVarAnnotation, recursive);
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
