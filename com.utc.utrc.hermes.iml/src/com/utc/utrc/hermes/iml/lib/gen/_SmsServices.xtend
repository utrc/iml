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
	def getStateMachineState(NamedType type, boolean recursive) {
		if (isStateMachine(type)) {
			return ImlUtil.findSymbol(type, STATEMACHINE_STATE_VAR, recursive) as SymbolDeclaration;
		}
		return null;
	}
	/**
	 * Get the next symbol declaration inside the given StateMachine type. If recursive is true
	 * then it will search for symbols inside type's parents 
	 */
	def getStateMachineNext(NamedType type, boolean recursive) {
		if (isStateMachine(type)) {
			return ImlUtil.findSymbol(type, STATEMACHINE_NEXT_VAR, recursive) as SymbolDeclaration;
		}
		return null;
	}
	/**
	 * Get the init symbol declaration inside the given StateMachine type. If recursive is true
	 * then it will search for symbols inside type's parents 
	 */
	def getStateMachineInit(NamedType type, boolean recursive) {
		if (isStateMachine(type)) {
			return ImlUtil.findSymbol(type, STATEMACHINE_INIT_VAR, recursive) as SymbolDeclaration;
		}
		return null;
	}
	/**
	 * Get the invariant symbol declaration inside the given StateMachine type. If recursive is true
	 * then it will search for symbols inside type's parents 
	 */
	def getStateMachineInvariant(NamedType type, boolean recursive) {
		if (isStateMachine(type)) {
			return ImlUtil.findSymbol(type, STATEMACHINE_INVARIANT_VAR, recursive) as SymbolDeclaration;
		}
		return null;
	}
	/**
	 * Get the transition symbol declaration inside the given StateMachine type. If recursive is true
	 * then it will search for symbols inside type's parents 
	 */
	def getStateMachineTransition(NamedType type, boolean recursive) {
		if (isStateMachine(type)) {
			return ImlUtil.findSymbol(type, STATEMACHINE_TRANSITION_VAR, recursive) as SymbolDeclaration;
		}
		return null;
	}
	
	override getPackageName() {
		PACKAGE_NAME
	}
}
