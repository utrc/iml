package com.utc.utrc.hermes.iml.lib

import com.utc.utrc.hermes.iml.iml.Trait
import com.utc.utrc.hermes.iml.util.ImlUtil
import com.google.inject.Inject
import com.utc.utrc.hermes.iml.iml.NamedType
import com.google.inject.Singleton
import com.utc.utrc.hermes.iml.iml.Annotation
import com.utc.utrc.hermes.iml.iml.SymbolDeclaration
import com.utc.utrc.hermes.iml.iml.SimpleTypeReference
import com.utc.utrc.hermes.iml.iml.SequenceTerm
import com.utc.utrc.hermes.iml.iml.StringLiteral
import org.eclipse.emf.ecore.EObject

@Singleton
class ContractsServices {
	
	@Inject
	ImlStdLib stdLib;
	
	public static final String PACKAGE_NAME = "iml.contracts"
	
	public static final String ASSUME_ANNOT = "Assume";
	public static final String GUARANTEE_ANNOT = "Guarantee";
	public static final String CONTRACT = "Contract";
	public static final String ASSUMPTION = "assumption";
	public static final String GUARANTEE = "guarantee";
	public static final String REFINES = "Refines";
	public static final String SPEC = "spec";
	public static final String IMPL = "impl";
	
	def getContractTrait() {
		return stdLib.getSymbol(PACKAGE_NAME, CONTRACT, Trait)
	}
	
	def getAssumeAnnotation() {
		return stdLib.getSymbol(PACKAGE_NAME, ASSUME_ANNOT, Annotation)
	}
	
	def getGuaranteeAnnotation() {
		return stdLib.getSymbol(PACKAGE_NAME, GUARANTEE, Annotation)
	}
	
	def isContract(EObject type) {
		ImlUtil.exhibitsOrRefines(type, contractTrait);
	}
	
	def getContractAssumption(NamedType type, boolean recursive) {
		if (isContract(type)) {
			return ImlUtil.findSymbol(type, ASSUMPTION, recursive) as SymbolDeclaration;
		}
		return null;
	}
	
	def getContractGuarantee(NamedType type, boolean recursive) {
		if (isContract(type)) {
			return ImlUtil.findSymbol(type, GUARANTEE, recursive) as SymbolDeclaration;
		}
		return null;
	}
	
	/**
	 * Return symbols with Assume annotations
	 */
	def getAssumptionSymbols(NamedType type, boolean recursive) {
		return ImlUtil.getSymbolsWithProperty(type, ASSUME_ANNOT, recursive);
	}
	
	/**
	 * Return symbols with Guarantee annotations
	 */
	def getGuaranteeSymbols(NamedType type, boolean recursive) {
		return ImlUtil.getSymbolsWithProperty(type, GUARANTEE_ANNOT, recursive);
	}
	
	def getAnnotationComment(SymbolDeclaration symbol) {
		symbol.propertylist.properties.filter[#[ASSUME_ANNOT, GUARANTEE_ANNOT].contains((it.ref as SimpleTypeReference).type.name)]
			.map[((it.definition as SequenceTerm).^return.left.right as StringLiteral).value];
	}
	
}