/*
 * Auto-Generated, please don't modify. Add your own logic to the child class {@link com.utc.utrc.hermes.iml.lib.SmsServices} instead
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
class _SmsServices extends BasicServices
 {
	public static final String PACKAGE_NAME = "iml.sms"
	public static final String STATELESS = "StateLess"	
	public static final String STATEMACHINE = "StateMachine"	
	public static final String STATEMACHINE_STATE_VAR = "state"
	public static final String STATEMACHINE_NEXT_VAR = "next"
	public static final String STATEMACHINE_INIT_VAR = "init"
	public static final String STATEMACHINE_INVARIANT_VAR = "invariant"
	public static final String STATEMACHINE_TRANSITION_VAR = "transition"
	
	/**
	 * get StateLess type declaration
	 */
	def getStateLessType() {
		return getType(STATELESS)
	}
	
	/**
	 * check whether the given type is StateLess type
	 */
	def isStateLess(NamedType type) {
		return getStateLessType == type
	}
	
	/**
	 * Get all symbols inside the given type that are StateLess type. If recursive is true
	 * then it will search for symbols inside type's parents
	 */
	def getStateLessSymbols(NamedType type, boolean recursive) {
		ImlUtil.getSymbolsWithType(type, getStateLessType, recursive)
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
	 * Get the state symbol declaration inside the given StateMachine type. If recursive is true
	 * then it will search for symbols inside type's parents 
	 */
	def getStateMachineStateVar() {
		return ImlUtil.findSymbol(getType(STATEMACHINE), STATEMACHINE_STATE_VAR, true) as SymbolDeclaration;
	}
	/**
	 * Get the next symbol declaration inside the given StateMachine type. If recursive is true
	 * then it will search for symbols inside type's parents 
	 */
	def getStateMachineNextVar() {
		return ImlUtil.findSymbol(getType(STATEMACHINE), STATEMACHINE_NEXT_VAR, true) as SymbolDeclaration;
	}
	/**
	 * Get the init symbol declaration inside the given StateMachine type. If recursive is true
	 * then it will search for symbols inside type's parents 
	 */
	def getStateMachineInitVar() {
		return ImlUtil.findSymbol(getType(STATEMACHINE), STATEMACHINE_INIT_VAR, true) as SymbolDeclaration;
	}
	/**
	 * Get the invariant symbol declaration inside the given StateMachine type. If recursive is true
	 * then it will search for symbols inside type's parents 
	 */
	def getStateMachineInvariantVar() {
		return ImlUtil.findSymbol(getType(STATEMACHINE), STATEMACHINE_INVARIANT_VAR, true) as SymbolDeclaration;
	}
	/**
	 * Get the transition symbol declaration inside the given StateMachine type. If recursive is true
	 * then it will search for symbols inside type's parents 
	 */
	def getStateMachineTransitionVar() {
		return ImlUtil.findSymbol(getType(STATEMACHINE), STATEMACHINE_TRANSITION_VAR, true) as SymbolDeclaration;
	}
	
	override getPackageName() {
		PACKAGE_NAME
	}
}
