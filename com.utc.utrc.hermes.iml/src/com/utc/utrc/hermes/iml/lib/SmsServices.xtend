package com.utc.utrc.hermes.iml.lib

import com.google.inject.Inject
import com.utc.utrc.hermes.iml.iml.Trait
import com.utc.utrc.hermes.iml.util.ImlUtil
import org.eclipse.emf.ecore.EObject
import com.utc.utrc.hermes.iml.iml.NamedType
import com.utc.utrc.hermes.iml.iml.SymbolDeclaration

class SmsServices {
	@Inject
	ImlStdLib stdLib;
	
	public static final String PACKAGE_NAME = "iml.sms"	
	
	public static final String STATELESS = "StateLess"
	public static final String STATE_MACHINE = "StateMachine"
	public static final String STATE = "state"
	public static final String NEXT = "next"
	public static final String INIT = "init"
	public static final String INVARIANT = "invariant"
	public static final String TRANSITION = "transition"
	
	def getStateMachineTrait() {
		return stdLib.getSymbol(PACKAGE_NAME, STATE_MACHINE, Trait)
	}
	
	def isStateMachine(EObject type) {
		return ImlUtil.exhibitsOrRefines(type, stateMachineTrait);
	}
	
	def getSmState(NamedType type, boolean recursive) {
		return ImlUtil.findSymbol(type, STATE, recursive) as SymbolDeclaration;
	}
	
	def getSmNext(NamedType type, boolean recursive) {
		return ImlUtil.findSymbol(type, NEXT, recursive) as SymbolDeclaration;
	}
	
	def getSmInit(NamedType type, boolean recursive) {
		return ImlUtil.findSymbol(type, INIT, recursive) as SymbolDeclaration;
	}
	
	def getSmInvariant(NamedType type, boolean recursive) {
		return ImlUtil.findSymbol(type, INVARIANT, recursive) as SymbolDeclaration;
	}
	
	def getSmTransition(NamedType type, boolean recursive) {
		return ImlUtil.findSymbol(type, TRANSITION, recursive) as SymbolDeclaration;
	}
}