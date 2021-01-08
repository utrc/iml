/*
 * Auto-Generated, please don't modify. Add your own logic to the child class {@link com.utc.utrc.hermes.iml.lib.SmsServices} instead
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
class _SmsServices extends BasicServices
 {
	public static final String PACKAGE_NAME = "iml.sms"
	public static final String TRACE = "Trace"	
	public static final String NULL_SYMBOL = ""	
	public static final String EMPTYSTATE = "EmptyState"	
	public static final String EXECUTION = "Execution"	
	public static final String VALIDTRANSITION = "ValidTransition"	
	public static final String VALIDTRANSITION_TIME_VAR = "time"
	public static final String VALIDTRANSITION_STATE_VAR = "state"
	public static final String VALIDTRANSITION_NEXT_VAR = "next"
	public static final String STATEMACHINE = "StateMachine"	
	public static final String STATEMACHINE_INIT_VAR = "init"
	public static final String STATEMACHINE_TRANSITION_VAR = "transition"
	public static final String STATETRACE_SYMBOL = "stateTrace"	
	public static final String SMSAT_SYMBOL = "smSat"	
	public static final String EXECSAT_SYMBOL = "execSat"	
	
	/**
	 * get Trace type declaration
	 */
	def getTraceType() {
		return getType(TRACE)
	}
	
	/**
	 * check whether the given type is Trace type
	 */
	def isTrace(NamedType type) {
		return getTraceType == type
	}
	
	/**
	 * Get all symbols inside the given type that are Trace type. If recursive is true
	 * then it will search for symbols inside type's parents
	 */
	def getTraceSymbols(NamedType type, boolean recursive) {
		ImlUtil.getSymbolsWithType(type, getTraceType, recursive)
	}
	/**
	 * get EmptyState type declaration
	 */
	def getEmptyStateType() {
		return getType(EMPTYSTATE)
	}
	
	/**
	 * check whether the given type is EmptyState type
	 */
	def isEmptyState(NamedType type) {
		return getEmptyStateType == type
	}
	
	/**
	 * Get all symbols inside the given type that are EmptyState type. If recursive is true
	 * then it will search for symbols inside type's parents
	 */
	def getEmptyStateSymbols(NamedType type, boolean recursive) {
		ImlUtil.getSymbolsWithType(type, getEmptyStateType, recursive)
	}
	/**
	 * get Execution type declaration
	 */
	def getExecutionType() {
		return getType(EXECUTION)
	}
	
	/**
	 * check whether the given type is Execution type
	 */
	def isExecution(NamedType type) {
		return getExecutionType == type
	}
	
	/**
	 * Get all symbols inside the given type that are Execution type. If recursive is true
	 * then it will search for symbols inside type's parents
	 */
	def getExecutionSymbols(NamedType type, boolean recursive) {
		ImlUtil.getSymbolsWithType(type, getExecutionType, recursive)
	}
	/**
	 * get ValidTransition trait declaration
	 */
	def getValidTransitionTrait() {
		return getTrait(VALIDTRANSITION)
	}
	
	/**
	 * check wether the given eObject refines or exhibits the ValidTransition trait
	 */
	def isValidTransition(EObject eObject) {
		return ImlUtil.exhibitsOrRefines(eObject, getValidTransitionTrait);
	}
	
	/**
	 * Get all symbols inside the given type that exhibits/refines the ValidTransition trait. If recursive is true
	 * then it will search for symbols inside type's parents
	 */
	def getValidTransitionSymbols(NamedType type, boolean recursive) {
		ImlUtil.getSymbolsWithTrait(type, getValidTransitionTrait, recursive);
	}
	
	/**
	 * Get the time symbol declaration inside the given ValidTransition type. If recursive is true
	 * then it will search for symbols inside type's parents 
	 */
	def getValidTransitionTimeVar() {
		return ImlUtil.findSymbol(getType(VALIDTRANSITION), VALIDTRANSITION_TIME_VAR, true) as SymbolDeclaration;
	}
	/**
	 * Get the state symbol declaration inside the given ValidTransition type. If recursive is true
	 * then it will search for symbols inside type's parents 
	 */
	def getValidTransitionStateVar() {
		return ImlUtil.findSymbol(getType(VALIDTRANSITION), VALIDTRANSITION_STATE_VAR, true) as SymbolDeclaration;
	}
	/**
	 * Get the next symbol declaration inside the given ValidTransition type. If recursive is true
	 * then it will search for symbols inside type's parents 
	 */
	def getValidTransitionNextVar() {
		return ImlUtil.findSymbol(getType(VALIDTRANSITION), VALIDTRANSITION_NEXT_VAR, true) as SymbolDeclaration;
	}
	/**
	 * get StateMachine trait declaration
	 */
	def getStateMachineTrait() {
		return getTrait(STATEMACHINE)
	}
	
	/**
	 * check wether the given eObject refines or exhibits the StateMachine trait
	 */
	def isStateMachine(EObject eObject) {
		return ImlUtil.exhibitsOrRefines(eObject, getStateMachineTrait);
	}
	
	/**
	 * Get all symbols inside the given type that exhibits/refines the StateMachine trait. If recursive is true
	 * then it will search for symbols inside type's parents
	 */
	def getStateMachineSymbols(NamedType type, boolean recursive) {
		ImlUtil.getSymbolsWithTrait(type, getStateMachineTrait, recursive);
	}
	
	/**
	 * Get the init symbol declaration inside the given StateMachine type. If recursive is true
	 * then it will search for symbols inside type's parents 
	 */
	def getStateMachineInitVar() {
		return ImlUtil.findSymbol(getType(STATEMACHINE), STATEMACHINE_INIT_VAR, true) as SymbolDeclaration;
	}
	/**
	 * Get the transition symbol declaration inside the given StateMachine type. If recursive is true
	 * then it will search for symbols inside type's parents 
	 */
	def getStateMachineTransitionVar() {
		return ImlUtil.findSymbol(getType(STATEMACHINE), STATEMACHINE_TRANSITION_VAR, true) as SymbolDeclaration;
	}
	/**
	 * Get StateTraceSymbol symbol declaration
	 */
	 def getStateTraceSymbol() {
	 	return getSymbolDeclaration(STATETRACE_SYMBOL)
	 }
	/**
	 * Get SmSatSymbol symbol declaration
	 */
	 def getSmSatSymbol() {
	 	return getSymbolDeclaration(SMSAT_SYMBOL)
	 }
	/**
	 * Get ExecSatSymbol symbol declaration
	 */
	 def getExecSatSymbol() {
	 	return getSymbolDeclaration(EXECSAT_SYMBOL)
	 }
	
	override getPackageName() {
		PACKAGE_NAME
	}
	
	/**
	 * Checks if a symbol is defined inside Sms IML library
	 */
	def isSmsSymbol(Symbol symbol) {
		if (symbol !== null) {
			val containerModel = ImlUtil.getContainerOfType(symbol, Model)
			if (containerModel.name == getPackageName()) {
				return true;
			}
		}
		return false;
	}
}
