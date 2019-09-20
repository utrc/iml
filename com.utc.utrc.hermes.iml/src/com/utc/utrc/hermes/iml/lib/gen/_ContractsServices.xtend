/*
 * Auto-Generated, please don't modify. Add your own logic to the child class {@link com.utc.utrc.hermes.iml.lib.ContractsServices} instead
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
class _ContractsServices extends BasicServices
 {
	public static final String PACKAGE_NAME = "iml.contracts.gen"
	public static final String REFINES = "Refines"	
	public static final String REFINES_SPEC_VAR = "spec"
	public static final String REFINES_IMPL_VAR = "impl"
	public static final String ASSUME = "Assume"	
	public static final String ASSUME_COMMENT_VAR = "comment"
	public static final String GUARANTEE = "Guarantee"	
	public static final String GUARANTEE_COMMENT_VAR = "comment"
	public static final String CONTRACT = "Contract"	
	public static final String CONTRACT_ASSUMPTION_VAR = "assumption"
	public static final String CONTRACT_GUARANTEE_VAR = "guarantee"
	
	/**
	 * get Refines type declaration
	 */
	def getRefinesType() {
		return getType(REFINES)
	}
	
	/**
	 * check whether the given type is Refines type
	 */
	def isRefines(NamedType type) {
		return getRefinesType == type
	}
	
	/**
	 * Get all symbols inside the given type that are Refines type. If recursive is true
	 * then it will search for symbols inside type's parents
	 */
	def getRefinesSymbols(NamedType type, boolean recursive) {
		ImlUtil.getSymbolsWithType(type, getRefinesType, recursive)
	}
	/**
	 * Get the spec symbol declaration inside the given Refines type. If recursive is true
	 * then it will search for symbols inside type's parents 
	 */
	def getRefinesSpec(NamedType type, boolean recursive) {
		if (isRefines(type)) {
			return ImlUtil.findSymbol(type, REFINES_SPEC_VAR, recursive) as SymbolDeclaration;
		}
		return null;
	}
	/**
	 * Get the impl symbol declaration inside the given Refines type. If recursive is true
	 * then it will search for symbols inside type's parents 
	 */
	def getRefinesImpl(NamedType type, boolean recursive) {
		if (isRefines(type)) {
			return ImlUtil.findSymbol(type, REFINES_IMPL_VAR, recursive) as SymbolDeclaration;
		}
		return null;
	}
	/**
	 * get Assume annotation declaration
	 */
	def getAssumeAnnotation() {
		return getAnnotation(ASSUME)
	}
	
	/**
	 * check whether the given type is Assume annotation
	 */
	def isAssume(NamedType annotation) {
		return getAssumeAnnotation == annotation
	}
	
	/**
	 * Get all symbols inside the given type that has the Assume annotation. If recursive is true
	 * then it will search for symbols inside type's parents
	 */
	def getAssumeSymbols(NamedType type, boolean recursive) {
		ImlUtil.getSymbolsWithProperty(type, getAssumeAnnotation, recursive);
	}		
	
	/**
	 * Get the comment symbol declaration inside the given Assume type. If recursive is true
	 * then it will search for symbols inside type's parents 
	 */
	def getAssumeComment(NamedType type, boolean recursive) {
		if (isAssume(type)) {
			return ImlUtil.findSymbol(type, ASSUME_COMMENT_VAR, recursive) as SymbolDeclaration;
		}
		return null;
	}
	/**
	 * get Guarantee annotation declaration
	 */
	def getGuaranteeAnnotation() {
		return getAnnotation(GUARANTEE)
	}
	
	/**
	 * check whether the given type is Guarantee annotation
	 */
	def isGuarantee(NamedType annotation) {
		return getGuaranteeAnnotation == annotation
	}
	
	/**
	 * Get all symbols inside the given type that has the Guarantee annotation. If recursive is true
	 * then it will search for symbols inside type's parents
	 */
	def getGuaranteeSymbols(NamedType type, boolean recursive) {
		ImlUtil.getSymbolsWithProperty(type, getGuaranteeAnnotation, recursive);
	}		
	
	/**
	 * Get the comment symbol declaration inside the given Guarantee type. If recursive is true
	 * then it will search for symbols inside type's parents 
	 */
	def getGuaranteeComment(NamedType type, boolean recursive) {
		if (isGuarantee(type)) {
			return ImlUtil.findSymbol(type, GUARANTEE_COMMENT_VAR, recursive) as SymbolDeclaration;
		}
		return null;
	}
	/**
	 * get Contract trait declaration
	 */
	def getContractTrait() {
		return getTrait(CONTRACT)
	}
	
	/**
	 * check wether the given eObject refines or exhibits the Contract trait
	 */
	def isContract(EObject eObject) {
		return ImlUtil.exhibitsOrRefines(eObject, getContractTrait);
	}
	
	/**
	 * Get all symbols inside the given type that exhibits/refines the Contract trait. If recursive is true
	 * then it will search for symbols inside type's parents
	 */
	def getContractSymbols(NamedType type, boolean recursive) {
		ImlUtil.getSymbolsWithTrait(type, getContractTrait, recursive);
	}
	
	/**
	 * Get the assumption symbol declaration inside the given Contract type. If recursive is true
	 * then it will search for symbols inside type's parents 
	 */
	def getContractAssumption(NamedType type, boolean recursive) {
		if (isContract(type)) {
			return ImlUtil.findSymbol(type, CONTRACT_ASSUMPTION_VAR, recursive) as SymbolDeclaration;
		}
		return null;
	}
	/**
	 * Get the guarantee symbol declaration inside the given Contract type. If recursive is true
	 * then it will search for symbols inside type's parents 
	 */
	def getContractGuarantee(NamedType type, boolean recursive) {
		if (isContract(type)) {
			return ImlUtil.findSymbol(type, CONTRACT_GUARANTEE_VAR, recursive) as SymbolDeclaration;
		}
		return null;
	}
	
	override getPackageName() {
		PACKAGE_NAME
	}
}
