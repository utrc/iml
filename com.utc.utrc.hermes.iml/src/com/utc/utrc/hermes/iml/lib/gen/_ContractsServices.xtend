/*
 * Auto-Generated, please don't modify. Add your own logic to the child class {@link com.utc.utrc.hermes.iml.lib.ContractsServices} instead
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
class _ContractsServices extends BasicServices
 {
	public static final String PACKAGE_NAME = "iml.contracts"
	public static final String REFINEMENTRELATION = "RefinementRelation"	
	public static final String REFINEMENTRELATION_SPEC_VAR = "spec"
	public static final String REFINEMENTRELATION_IMPL_VAR = "impl"
	public static final String IMPLEMENTS = "Implements"	
	public static final String ASSUME = "Assume"	
	public static final String ASSUME_COMMENT_VAR = "comment"
	public static final String ISREFINEMENT_SYMBOL = "isRefinement"	
	public static final String REFINEMENT_SYMBOL = "refinement"	
	public static final String GUARANTEE = "Guarantee"	
	public static final String GUARANTEE_COMMENT_VAR = "comment"
	public static final String CONTRACT = "Contract"	
	public static final String CONTRACT_ASSUMPTION_VAR = "assumption"
	public static final String CONTRACT_GUARANTEE_VAR = "guarantee"
	public static final String CONTRACT_CONTRACT_VAR = "contract"
	
	/**
	 * get RefinementRelation type declaration
	 */
	def getRefinementRelationType() {
		return getType(REFINEMENTRELATION)
	}
	
	/**
	 * check whether the given type is RefinementRelation type
	 */
	def isRefinementRelation(NamedType type) {
		return equalOrSameQn(getRefinementRelationType, type)
	}
	
	/**
	 * Get all symbols inside the given type that are RefinementRelation type. If recursive is true
	 * then it will search for symbols inside type's parents
	 */
	def getRefinementRelationSymbols(NamedType type, boolean recursive) {
		ImlUtil.getSymbolsWithType(type, getRefinementRelationType, recursive)
	}
	/**
	 * Get the spec symbol declaration inside the given RefinementRelation type. If recursive is true
	 * then it will search for symbols inside type's parents 
	 */
	def getRefinementRelationSpecVar() {
		return ImlUtil.findSymbol(getType(REFINEMENTRELATION), REFINEMENTRELATION_SPEC_VAR, true) as SymbolDeclaration;
	}
	/**
	 * Get the impl symbol declaration inside the given RefinementRelation type. If recursive is true
	 * then it will search for symbols inside type's parents 
	 */
	def getRefinementRelationImplVar() {
		return ImlUtil.findSymbol(getType(REFINEMENTRELATION), REFINEMENTRELATION_IMPL_VAR, true) as SymbolDeclaration;
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
		return equalOrSameQn(getAssumeAnnotation, annotation)
	}
	
	/**
	 * check whether the given symbol is annotated with Assume annotation
	 */
	def hasAssumeAnnotation(Symbol symbol) {
		if (symbol.propertylist !== null) {
			return symbol.propertylist.properties.map[(it.ref as SimpleTypeReference).type].containsSameQn(getAssumeAnnotation())	
		}
		return false;
	}
	
	/**
	 * check whether the given type is annotated with Assume annotation
	 */
	def hasAssumeAnnotation(TypeWithProperties type) {
		if (type.properties !== null) {
			return type.properties.properties.map[(it.ref as SimpleTypeReference).type].containsSameQn(getAssumeAnnotation())	
		}
		return false;
	}
	
	/**
	 * check whether the given model is annotated with Assume annotation
	 */
	def hasAssumeAnnotation(Model model) {
		if (model.propertylist !== null) {
			return model.propertylist.properties.map[(it.ref as SimpleTypeReference).type].containsSameQn(getAssumeAnnotation())	
		}
		return false;
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
	 * Get IsRefinementSymbol symbol declaration
	 */
	 def getIsRefinementSymbol() {
	 	return getSymbolDeclaration(ISREFINEMENT_SYMBOL)
	 }
	/**
	 * Get RefinementSymbol symbol declaration
	 */
	 def getRefinementSymbol() {
	 	return getSymbolDeclaration(REFINEMENT_SYMBOL)
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
		return equalOrSameQn(getGuaranteeAnnotation, annotation)
	}
	
	/**
	 * check whether the given symbol is annotated with Guarantee annotation
	 */
	def hasGuaranteeAnnotation(Symbol symbol) {
		if (symbol.propertylist !== null) {
			return symbol.propertylist.properties.map[(it.ref as SimpleTypeReference).type].containsSameQn(getGuaranteeAnnotation())	
		}
		return false;
	}
	
	/**
	 * check whether the given type is annotated with Guarantee annotation
	 */
	def hasGuaranteeAnnotation(TypeWithProperties type) {
		if (type.properties !== null) {
			return type.properties.properties.map[(it.ref as SimpleTypeReference).type].containsSameQn(getGuaranteeAnnotation())	
		}
		return false;
	}
	
	/**
	 * check whether the given model is annotated with Guarantee annotation
	 */
	def hasGuaranteeAnnotation(Model model) {
		if (model.propertylist !== null) {
			return model.propertylist.properties.map[(it.ref as SimpleTypeReference).type].containsSameQn(getGuaranteeAnnotation())	
		}
		return false;
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
	/**
	 * Get the contract symbol declaration inside the given Contract type. If recursive is true
	 * then it will search for symbols inside type's parents 
	 */
	def getContractContractVar() {
		return ImlUtil.findSymbol(getType(CONTRACT), CONTRACT_CONTRACT_VAR, true) as SymbolDeclaration;
	}
	
	override getPackageName() {
		PACKAGE_NAME
	}
	
	/**
	 * Checks if a symbol is defined inside Contracts IML library
	 */
	def isContractsSymbol(Symbol symbol) {
		if (symbol !== null) {
			val containerModel = ImlUtil.getContainerOfType(symbol, Model)
			if (containerModel.name == getPackageName()) {
				return true;
			}
		}
		return false;
	}
}
