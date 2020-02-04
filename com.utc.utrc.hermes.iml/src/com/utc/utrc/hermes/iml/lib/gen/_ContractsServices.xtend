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
	public static final String PACKAGE_NAME = "iml.contracts"
	public static final String REFINES = "Refines"	
	public static final String REFINES_SPEC_VAR = "spec"
	public static final String REFINES_IMPL_VAR = "impl"
	public static final String IMPLEMENTS = "Implements"	
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
	def getRefinesSpecVar() {
		return ImlUtil.findSymbol(getType(REFINES), REFINES_SPEC_VAR, true) as SymbolDeclaration;
	}
	/**
	 * Get the impl symbol declaration inside the given Refines type. If recursive is true
	 * then it will search for symbols inside type's parents 
	 */
	def getRefinesImplVar() {
		return ImlUtil.findSymbol(getType(REFINES), REFINES_IMPL_VAR, true) as SymbolDeclaration;
	}
	/**
	 * get Implements trait declaration
	 */
	def getImplementsTrait() {
		return getTrait(IMPLEMENTS)
	}
	
	/**
	 * check wether the given eObject refines or exhibits the Implements trait
	 */
	def isImplements(EObject eObject) {
		return ImlUtil.exhibitsOrRefines(eObject, getImplementsTrait);
	}
	
	/**
	 * Get all symbols inside the given type that exhibits/refines the Implements trait. If recursive is true
	 * then it will search for symbols inside type's parents
	 */
	def getImplementsSymbols(NamedType type, boolean recursive) {
		ImlUtil.getSymbolsWithTrait(type, getImplementsTrait, recursive);
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
	def getAssumeCommentVar() {
		return ImlUtil.findSymbol(getType(ASSUME), ASSUME_COMMENT_VAR, true) as SymbolDeclaration;
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
	def getGuaranteeCommentVar() {
		return ImlUtil.findSymbol(getType(GUARANTEE), GUARANTEE_COMMENT_VAR, true) as SymbolDeclaration;
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
	def getContractAssumptionVar() {
		return ImlUtil.findSymbol(getType(CONTRACT), CONTRACT_ASSUMPTION_VAR, true) as SymbolDeclaration;
	}
	/**
	 * Get the guarantee symbol declaration inside the given Contract type. If recursive is true
	 * then it will search for symbols inside type's parents 
	 */
	def getContractGuaranteeVar() {
		return ImlUtil.findSymbol(getType(CONTRACT), CONTRACT_GUARANTEE_VAR, true) as SymbolDeclaration;
	}
	
	override getPackageName() {
		PACKAGE_NAME
	}
}
