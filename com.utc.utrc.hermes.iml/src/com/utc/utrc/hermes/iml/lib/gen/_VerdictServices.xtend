/*
 * Auto-Generated, please don't modify. Add your own logic to the child class {@link com.utc.utrc.hermes.iml.lib.VerdictServices} instead
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
class _VerdictServices extends BasicServices
 {
	public static final String PACKAGE_NAME = "iml.verdict"
	public static final String CYBERREL = "CyberRel"	
	public static final String CYBERREL_COMMENT_VAR = "comment"
	public static final String CYBERREL_DESCRIPTION_VAR = "description"
	public static final String CYBERREL_PHASES_VAR = "phases"
	public static final String CYBERREL_EXTERNAL_VAR = "external"
	public static final String A_SYMBOL = "A"	
	public static final String C_SYMBOL = "C"	
	public static final String CYBERMISSION = "CyberMission"	
	public static final String CYBERMISSION_CYBERREQS_VAR = "cyberReqs"
	public static final String CYBERMISSION_DESCRIPTION_VAR = "description"
	public static final String CYBERMISSION_COMMENT_VAR = "comment"
	public static final String CYBERREQ = "CyberReq"	
	public static final String CYBERREQ_SEVERITY_VAR = "severity"
	public static final String CYBERREQ_CIA_VAR = "cia"
	public static final String CYBERREQ_COMMENT_VAR = "comment"
	public static final String CYBERREQ_DESCRIPTION_VAR = "description"
	public static final String CYBERREQ_PHASES_VAR = "phases"
	public static final String CYBERREQ_EXTERNAL_VAR = "external"
	public static final String CYBERREQ_TARGETLIKELIHOOD_VAR = "targetLikelihood"
	public static final String I_SYMBOL = "I"	
	public static final String TARGETLIKELIHOOD = "TargetLikelihood"	
	public static final String SEVERITY = "Severity"	
	public static final String EVENTAN = "EventAn"	
	public static final String EVENTAN_PROBABILITY_VAR = "probability"
	public static final String EVENTAN_COMMENT_VAR = "comment"
	public static final String EVENTAN_DESCRIPTION_VAR = "description"
	public static final String SAFETYREL = "SafetyRel"	
	public static final String SAFETYREL_ID_VAR = "id"
	public static final String SAFETYREL_COMMENT_VAR = "comment"
	public static final String SAFETYREL_DESCRIPTION_VAR = "description"
	public static final String EVENT = "Event"	
	public static final String CIA = "CIA"	
	public static final String SAFETYREQ = "SafetyReq"	
	public static final String SAFETYREQ_COMMENT_VAR = "comment"
	public static final String SAFETYREQ_DESCRIPTION_VAR = "description"
	public static final String HAPPENS_SYMBOL = "happens"	
	
	/**
	 * get CyberRel annotation declaration
	 */
	def getCyberRelAnnotation() {
		return getAnnotation(CYBERREL)
	}
	
	/**
	 * check whether the given type is CyberRel annotation
	 */
	def isCyberRel(NamedType annotation) {
		return getCyberRelAnnotation == annotation
	}
	
	/**
	 * Get all symbols inside the given type that has the CyberRel annotation. If recursive is true
	 * then it will search for symbols inside type's parents
	 */
	def getCyberRelSymbols(NamedType type, boolean recursive) {
		ImlUtil.getSymbolsWithProperty(type, getCyberRelAnnotation, recursive);
	}		
	
	/**
	 * Get the comment symbol declaration inside the given CyberRel type. If recursive is true
	 * then it will search for symbols inside type's parents 
	 */
	def getCyberRelCommentVar() {
		return ImlUtil.findSymbol(getType(CYBERREL), CYBERREL_COMMENT_VAR, true) as SymbolDeclaration;
	}
	/**
	 * Get the description symbol declaration inside the given CyberRel type. If recursive is true
	 * then it will search for symbols inside type's parents 
	 */
	def getCyberRelDescriptionVar() {
		return ImlUtil.findSymbol(getType(CYBERREL), CYBERREL_DESCRIPTION_VAR, true) as SymbolDeclaration;
	}
	/**
	 * Get the phases symbol declaration inside the given CyberRel type. If recursive is true
	 * then it will search for symbols inside type's parents 
	 */
	def getCyberRelPhasesVar() {
		return ImlUtil.findSymbol(getType(CYBERREL), CYBERREL_PHASES_VAR, true) as SymbolDeclaration;
	}
	/**
	 * Get the external symbol declaration inside the given CyberRel type. If recursive is true
	 * then it will search for symbols inside type's parents 
	 */
	def getCyberRelExternalVar() {
		return ImlUtil.findSymbol(getType(CYBERREL), CYBERREL_EXTERNAL_VAR, true) as SymbolDeclaration;
	}
	/**
	 * Get ASymbol symbol declaration
	 */
	 def getASymbol() {
	 	return getSymbolDeclaration(A_SYMBOL)
	 }
	/**
	 * Get CSymbol symbol declaration
	 */
	 def getCSymbol() {
	 	return getSymbolDeclaration(C_SYMBOL)
	 }
	/**
	 * get CyberMission annotation declaration
	 */
	def getCyberMissionAnnotation() {
		return getAnnotation(CYBERMISSION)
	}
	
	/**
	 * check whether the given type is CyberMission annotation
	 */
	def isCyberMission(NamedType annotation) {
		return getCyberMissionAnnotation == annotation
	}
	
	/**
	 * Get all symbols inside the given type that has the CyberMission annotation. If recursive is true
	 * then it will search for symbols inside type's parents
	 */
	def getCyberMissionSymbols(NamedType type, boolean recursive) {
		ImlUtil.getSymbolsWithProperty(type, getCyberMissionAnnotation, recursive);
	}		
	
	/**
	 * Get the cyberReqs symbol declaration inside the given CyberMission type. If recursive is true
	 * then it will search for symbols inside type's parents 
	 */
	def getCyberMissionCyberReqsVar() {
		return ImlUtil.findSymbol(getType(CYBERMISSION), CYBERMISSION_CYBERREQS_VAR, true) as SymbolDeclaration;
	}
	/**
	 * Get the description symbol declaration inside the given CyberMission type. If recursive is true
	 * then it will search for symbols inside type's parents 
	 */
	def getCyberMissionDescriptionVar() {
		return ImlUtil.findSymbol(getType(CYBERMISSION), CYBERMISSION_DESCRIPTION_VAR, true) as SymbolDeclaration;
	}
	/**
	 * Get the comment symbol declaration inside the given CyberMission type. If recursive is true
	 * then it will search for symbols inside type's parents 
	 */
	def getCyberMissionCommentVar() {
		return ImlUtil.findSymbol(getType(CYBERMISSION), CYBERMISSION_COMMENT_VAR, true) as SymbolDeclaration;
	}
	/**
	 * get CyberReq annotation declaration
	 */
	def getCyberReqAnnotation() {
		return getAnnotation(CYBERREQ)
	}
	
	/**
	 * check whether the given type is CyberReq annotation
	 */
	def isCyberReq(NamedType annotation) {
		return getCyberReqAnnotation == annotation
	}
	
	/**
	 * Get all symbols inside the given type that has the CyberReq annotation. If recursive is true
	 * then it will search for symbols inside type's parents
	 */
	def getCyberReqSymbols(NamedType type, boolean recursive) {
		ImlUtil.getSymbolsWithProperty(type, getCyberReqAnnotation, recursive);
	}		
	
	/**
	 * Get the severity symbol declaration inside the given CyberReq type. If recursive is true
	 * then it will search for symbols inside type's parents 
	 */
	def getCyberReqSeverityVar() {
		return ImlUtil.findSymbol(getType(CYBERREQ), CYBERREQ_SEVERITY_VAR, true) as SymbolDeclaration;
	}
	/**
	 * Get the cia symbol declaration inside the given CyberReq type. If recursive is true
	 * then it will search for symbols inside type's parents 
	 */
	def getCyberReqCiaVar() {
		return ImlUtil.findSymbol(getType(CYBERREQ), CYBERREQ_CIA_VAR, true) as SymbolDeclaration;
	}
	/**
	 * Get the comment symbol declaration inside the given CyberReq type. If recursive is true
	 * then it will search for symbols inside type's parents 
	 */
	def getCyberReqCommentVar() {
		return ImlUtil.findSymbol(getType(CYBERREQ), CYBERREQ_COMMENT_VAR, true) as SymbolDeclaration;
	}
	/**
	 * Get the description symbol declaration inside the given CyberReq type. If recursive is true
	 * then it will search for symbols inside type's parents 
	 */
	def getCyberReqDescriptionVar() {
		return ImlUtil.findSymbol(getType(CYBERREQ), CYBERREQ_DESCRIPTION_VAR, true) as SymbolDeclaration;
	}
	/**
	 * Get the phases symbol declaration inside the given CyberReq type. If recursive is true
	 * then it will search for symbols inside type's parents 
	 */
	def getCyberReqPhasesVar() {
		return ImlUtil.findSymbol(getType(CYBERREQ), CYBERREQ_PHASES_VAR, true) as SymbolDeclaration;
	}
	/**
	 * Get the external symbol declaration inside the given CyberReq type. If recursive is true
	 * then it will search for symbols inside type's parents 
	 */
	def getCyberReqExternalVar() {
		return ImlUtil.findSymbol(getType(CYBERREQ), CYBERREQ_EXTERNAL_VAR, true) as SymbolDeclaration;
	}
	/**
	 * Get the targetLikelihood symbol declaration inside the given CyberReq type. If recursive is true
	 * then it will search for symbols inside type's parents 
	 */
	def getCyberReqTargetLikelihoodVar() {
		return ImlUtil.findSymbol(getType(CYBERREQ), CYBERREQ_TARGETLIKELIHOOD_VAR, true) as SymbolDeclaration;
	}
	/**
	 * Get ISymbol symbol declaration
	 */
	 def getISymbol() {
	 	return getSymbolDeclaration(I_SYMBOL)
	 }
	/**
	 * get TargetLikelihood type declaration
	 */
	def getTargetLikelihoodType() {
		return getType(TARGETLIKELIHOOD)
	}
	
	/**
	 * check whether the given type is TargetLikelihood type
	 */
	def isTargetLikelihood(NamedType type) {
		return getTargetLikelihoodType == type
	}
	
	/**
	 * Get all symbols inside the given type that are TargetLikelihood type. If recursive is true
	 * then it will search for symbols inside type's parents
	 */
	def getTargetLikelihoodSymbols(NamedType type, boolean recursive) {
		ImlUtil.getSymbolsWithType(type, getTargetLikelihoodType, recursive)
	}
	/**
	 * get Severity type declaration
	 */
	def getSeverityType() {
		return getType(SEVERITY)
	}
	
	/**
	 * check whether the given type is Severity type
	 */
	def isSeverity(NamedType type) {
		return getSeverityType == type
	}
	
	/**
	 * Get all symbols inside the given type that are Severity type. If recursive is true
	 * then it will search for symbols inside type's parents
	 */
	def getSeveritySymbols(NamedType type, boolean recursive) {
		ImlUtil.getSymbolsWithType(type, getSeverityType, recursive)
	}
	/**
	 * get EventAn annotation declaration
	 */
	def getEventAnAnnotation() {
		return getAnnotation(EVENTAN)
	}
	
	/**
	 * check whether the given type is EventAn annotation
	 */
	def isEventAn(NamedType annotation) {
		return getEventAnAnnotation == annotation
	}
	
	/**
	 * Get all symbols inside the given type that has the EventAn annotation. If recursive is true
	 * then it will search for symbols inside type's parents
	 */
	def getEventAnSymbols(NamedType type, boolean recursive) {
		ImlUtil.getSymbolsWithProperty(type, getEventAnAnnotation, recursive);
	}		
	
	/**
	 * Get the probability symbol declaration inside the given EventAn type. If recursive is true
	 * then it will search for symbols inside type's parents 
	 */
	def getEventAnProbabilityVar() {
		return ImlUtil.findSymbol(getType(EVENTAN), EVENTAN_PROBABILITY_VAR, true) as SymbolDeclaration;
	}
	/**
	 * Get the comment symbol declaration inside the given EventAn type. If recursive is true
	 * then it will search for symbols inside type's parents 
	 */
	def getEventAnCommentVar() {
		return ImlUtil.findSymbol(getType(EVENTAN), EVENTAN_COMMENT_VAR, true) as SymbolDeclaration;
	}
	/**
	 * Get the description symbol declaration inside the given EventAn type. If recursive is true
	 * then it will search for symbols inside type's parents 
	 */
	def getEventAnDescriptionVar() {
		return ImlUtil.findSymbol(getType(EVENTAN), EVENTAN_DESCRIPTION_VAR, true) as SymbolDeclaration;
	}
	/**
	 * get SafetyRel annotation declaration
	 */
	def getSafetyRelAnnotation() {
		return getAnnotation(SAFETYREL)
	}
	
	/**
	 * check whether the given type is SafetyRel annotation
	 */
	def isSafetyRel(NamedType annotation) {
		return getSafetyRelAnnotation == annotation
	}
	
	/**
	 * Get all symbols inside the given type that has the SafetyRel annotation. If recursive is true
	 * then it will search for symbols inside type's parents
	 */
	def getSafetyRelSymbols(NamedType type, boolean recursive) {
		ImlUtil.getSymbolsWithProperty(type, getSafetyRelAnnotation, recursive);
	}		
	
	/**
	 * Get the id symbol declaration inside the given SafetyRel type. If recursive is true
	 * then it will search for symbols inside type's parents 
	 */
	def getSafetyRelIdVar() {
		return ImlUtil.findSymbol(getType(SAFETYREL), SAFETYREL_ID_VAR, true) as SymbolDeclaration;
	}
	/**
	 * Get the comment symbol declaration inside the given SafetyRel type. If recursive is true
	 * then it will search for symbols inside type's parents 
	 */
	def getSafetyRelCommentVar() {
		return ImlUtil.findSymbol(getType(SAFETYREL), SAFETYREL_COMMENT_VAR, true) as SymbolDeclaration;
	}
	/**
	 * Get the description symbol declaration inside the given SafetyRel type. If recursive is true
	 * then it will search for symbols inside type's parents 
	 */
	def getSafetyRelDescriptionVar() {
		return ImlUtil.findSymbol(getType(SAFETYREL), SAFETYREL_DESCRIPTION_VAR, true) as SymbolDeclaration;
	}
	/**
	 * get Event type declaration
	 */
	def getEventType() {
		return getType(EVENT)
	}
	
	/**
	 * check whether the given type is Event type
	 */
	def isEvent(NamedType type) {
		return getEventType == type
	}
	
	/**
	 * Get all symbols inside the given type that are Event type. If recursive is true
	 * then it will search for symbols inside type's parents
	 */
	def getEventSymbols(NamedType type, boolean recursive) {
		ImlUtil.getSymbolsWithType(type, getEventType, recursive)
	}
	/**
	 * get CIA type declaration
	 */
	def getCIAType() {
		return getType(CIA)
	}
	
	/**
	 * check whether the given type is CIA type
	 */
	def isCIA(NamedType type) {
		return getCIAType == type
	}
	
	/**
	 * Get all symbols inside the given type that are CIA type. If recursive is true
	 * then it will search for symbols inside type's parents
	 */
	def getCIASymbols(NamedType type, boolean recursive) {
		ImlUtil.getSymbolsWithType(type, getCIAType, recursive)
	}
	/**
	 * get SafetyReq annotation declaration
	 */
	def getSafetyReqAnnotation() {
		return getAnnotation(SAFETYREQ)
	}
	
	/**
	 * check whether the given type is SafetyReq annotation
	 */
	def isSafetyReq(NamedType annotation) {
		return getSafetyReqAnnotation == annotation
	}
	
	/**
	 * Get all symbols inside the given type that has the SafetyReq annotation. If recursive is true
	 * then it will search for symbols inside type's parents
	 */
	def getSafetyReqSymbols(NamedType type, boolean recursive) {
		ImlUtil.getSymbolsWithProperty(type, getSafetyReqAnnotation, recursive);
	}		
	
	/**
	 * Get the comment symbol declaration inside the given SafetyReq type. If recursive is true
	 * then it will search for symbols inside type's parents 
	 */
	def getSafetyReqCommentVar() {
		return ImlUtil.findSymbol(getType(SAFETYREQ), SAFETYREQ_COMMENT_VAR, true) as SymbolDeclaration;
	}
	/**
	 * Get the description symbol declaration inside the given SafetyReq type. If recursive is true
	 * then it will search for symbols inside type's parents 
	 */
	def getSafetyReqDescriptionVar() {
		return ImlUtil.findSymbol(getType(SAFETYREQ), SAFETYREQ_DESCRIPTION_VAR, true) as SymbolDeclaration;
	}
	/**
	 * Get HappensSymbol symbol declaration
	 */
	 def getHappensSymbol() {
	 	return getSymbolDeclaration(HAPPENS_SYMBOL)
	 }
	
	override getPackageName() {
		PACKAGE_NAME
	}
}
