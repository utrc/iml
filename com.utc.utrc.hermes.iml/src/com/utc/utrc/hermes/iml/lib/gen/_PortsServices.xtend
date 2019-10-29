/*
 * Auto-Generated, please don't modify. Add your own logic to the child class {@link com.utc.utrc.hermes.iml.lib.PortsServices} instead
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
class _PortsServices extends BasicServices
 {
	public static final String PACKAGE_NAME = "iml.ports"
	public static final String ENDTOENDFLOW = "EndToEndFlow"	
	public static final String ENDTOENDFLOW_START_VAR = "start"
	public static final String ENDTOENDFLOW_END_VAR = "end"
	public static final String ENDTOENDFLOW_APPEND_VAR = "append"
	public static final String FLOWCONNECTOR = "FlowConnector"	
	public static final String FLOWCONNECTOR_CONNECTOR_VAR = "connector"
	public static final String FLOWCONNECTOR_FLOW_VAR = "flow"
	public static final String FLOWPATHSPEC_VAR = "flowpathspec"	
	public static final String PORT = "Port"	
	public static final String SOURCE_VAR = "source"	
	public static final String DATAPORT = "DataPort"	
	public static final String DATAPORT_DATA_VAR = "data"
	public static final String DATAPORT_FLOWPOINT_VAR = "flowpoint"
	public static final String FLOWDELAYBOUND_VAR = "flowdelaybound"	
	public static final String THREESTATE = "ThreeState"	
	public static final String DELAYSTATE = "DelayState"	
	public static final String DELAYSTATE_STATE_VAR = "state"
	public static final String DELAYSTATE_I_VAR = "i"
	public static final String DELAY = "delay"	
	public static final String DELAY_F_VAR = "f"
	public static final String DELAY_N_VAR = "n"
	public static final String DELAY_HOLDS_VAR = "holds"
	public static final String DELAY_INIT_VAR = "init"
	public static final String DELAY_TRANSITION_VAR = "transition"
	public static final String DELAY_INVARIANT_VAR = "invariant"
	public static final String EVENTPORT = "EventPort"	
	public static final String EVENTPORT_EVENT_VAR = "event"
	public static final String EVENTPORT_FLOWPOINT_VAR = "flowpoint"
	public static final String FLOWPOINT = "FlowPoint"	
	public static final String FLOWPOINT_EVENT_VAR = "event"
	public static final String FLOWPOINT_UPPERBOUND_VAR = "upperBound"
	public static final String FLOWPOINT_LOWERBOUND_VAR = "lowerBound"
	public static final String FLOWPATH_VAR = "flowpath"	
	public static final String FLOWCONNECT_VAR = "flowconnect"	
	public static final String FLOWPATH = "FlowPath"	
	public static final String FLOWPATH_START_VAR = "start"
	public static final String FLOWPATH_END_VAR = "end"
	public static final String FLOWPATH_UPPERBOUND_VAR = "upperBound"
	public static final String FLOWPATH_LOWERBOUND_VAR = "lowerBound"
	public static final String EVENTDATAPORT = "EventDataPort"	
	public static final String EVENTDATAPORT_EVENT_VAR = "event"
	public static final String EVENTDATAPORT_DATA_VAR = "data"
	public static final String EVENTDATAPORT_FLOWPOINT_VAR = "flowpoint"
	
	/**
	 * get EndToEndFlow type declaration
	 */
	def getEndToEndFlowType() {
		return getType(ENDTOENDFLOW)
	}
	
	/**
	 * check whether the given type is EndToEndFlow type
	 */
	def isEndToEndFlow(NamedType type) {
		return getEndToEndFlowType == type
	}
	
	/**
	 * Get all symbols inside the given type that are EndToEndFlow type. If recursive is true
	 * then it will search for symbols inside type's parents
	 */
	def getEndToEndFlowSymbols(NamedType type, boolean recursive) {
		ImlUtil.getSymbolsWithType(type, getEndToEndFlowType, recursive)
	}
	/**
	 * Get the start symbol declaration inside the given EndToEndFlow type. If recursive is true
	 * then it will search for symbols inside type's parents 
	 */
	def getEndToEndFlowStart(NamedType type, boolean recursive) {
		if (isEndToEndFlow(type)) {
			return ImlUtil.findSymbol(type, ENDTOENDFLOW_START_VAR, recursive) as SymbolDeclaration;
		}
		return null;
	}
	/**
	 * Get the end symbol declaration inside the given EndToEndFlow type. If recursive is true
	 * then it will search for symbols inside type's parents 
	 */
	def getEndToEndFlowEnd(NamedType type, boolean recursive) {
		if (isEndToEndFlow(type)) {
			return ImlUtil.findSymbol(type, ENDTOENDFLOW_END_VAR, recursive) as SymbolDeclaration;
		}
		return null;
	}
	/**
	 * Get the append symbol declaration inside the given EndToEndFlow type. If recursive is true
	 * then it will search for symbols inside type's parents 
	 */
	def getEndToEndFlowAppend(NamedType type, boolean recursive) {
		if (isEndToEndFlow(type)) {
			return ImlUtil.findSymbol(type, ENDTOENDFLOW_APPEND_VAR, recursive) as SymbolDeclaration;
		}
		return null;
	}
	/**
	 * get FlowConnector type declaration
	 */
	def getFlowConnectorType() {
		return getType(FLOWCONNECTOR)
	}
	
	/**
	 * check whether the given type is FlowConnector type
	 */
	def isFlowConnector(NamedType type) {
		return getFlowConnectorType == type
	}
	
	/**
	 * Get all symbols inside the given type that are FlowConnector type. If recursive is true
	 * then it will search for symbols inside type's parents
	 */
	def getFlowConnectorSymbols(NamedType type, boolean recursive) {
		ImlUtil.getSymbolsWithType(type, getFlowConnectorType, recursive)
	}
	/**
	 * Get the connector symbol declaration inside the given FlowConnector type. If recursive is true
	 * then it will search for symbols inside type's parents 
	 */
	def getFlowConnectorConnector(NamedType type, boolean recursive) {
		if (isFlowConnector(type)) {
			return ImlUtil.findSymbol(type, FLOWCONNECTOR_CONNECTOR_VAR, recursive) as SymbolDeclaration;
		}
		return null;
	}
	/**
	 * Get the flow symbol declaration inside the given FlowConnector type. If recursive is true
	 * then it will search for symbols inside type's parents 
	 */
	def getFlowConnectorFlow(NamedType type, boolean recursive) {
		if (isFlowConnector(type)) {
			return ImlUtil.findSymbol(type, FLOWCONNECTOR_FLOW_VAR, recursive) as SymbolDeclaration;
		}
		return null;
	}
	/**
	 * get Port type declaration
	 */
	def getPortType() {
		return getType(PORT)
	}
	
	/**
	 * check whether the given type is Port type
	 */
	def isPort(NamedType type) {
		return getPortType == type
	}
	
	/**
	 * Get all symbols inside the given type that are Port type. If recursive is true
	 * then it will search for symbols inside type's parents
	 */
	def getPortSymbols(NamedType type, boolean recursive) {
		ImlUtil.getSymbolsWithType(type, getPortType, recursive)
	}
	/**
	 * get DataPort type declaration
	 */
	def getDataPortType() {
		return getType(DATAPORT)
	}
	
	/**
	 * check whether the given type is DataPort type
	 */
	def isDataPort(NamedType type) {
		return getDataPortType == type
	}
	
	/**
	 * Get all symbols inside the given type that are DataPort type. If recursive is true
	 * then it will search for symbols inside type's parents
	 */
	def getDataPortSymbols(NamedType type, boolean recursive) {
		ImlUtil.getSymbolsWithType(type, getDataPortType, recursive)
	}
	/**
	 * Get the data symbol declaration inside the given DataPort type. If recursive is true
	 * then it will search for symbols inside type's parents 
	 */
	def getDataPortData(NamedType type, boolean recursive) {
		if (isDataPort(type)) {
			return ImlUtil.findSymbol(type, DATAPORT_DATA_VAR, recursive) as SymbolDeclaration;
		}
		return null;
	}
	/**
	 * Get the flowpoint symbol declaration inside the given DataPort type. If recursive is true
	 * then it will search for symbols inside type's parents 
	 */
	def getDataPortFlowpoint(NamedType type, boolean recursive) {
		if (isDataPort(type)) {
			return ImlUtil.findSymbol(type, DATAPORT_FLOWPOINT_VAR, recursive) as SymbolDeclaration;
		}
		return null;
	}
	/**
	 * get ThreeState type declaration
	 */
	def getThreeStateType() {
		return getType(THREESTATE)
	}
	
	/**
	 * check whether the given type is ThreeState type
	 */
	def isThreeState(NamedType type) {
		return getThreeStateType == type
	}
	
	/**
	 * Get all symbols inside the given type that are ThreeState type. If recursive is true
	 * then it will search for symbols inside type's parents
	 */
	def getThreeStateSymbols(NamedType type, boolean recursive) {
		ImlUtil.getSymbolsWithType(type, getThreeStateType, recursive)
	}
	/**
	 * get DelayState type declaration
	 */
	def getDelayStateType() {
		return getType(DELAYSTATE)
	}
	
	/**
	 * check whether the given type is DelayState type
	 */
	def isDelayState(NamedType type) {
		return getDelayStateType == type
	}
	
	/**
	 * Get all symbols inside the given type that are DelayState type. If recursive is true
	 * then it will search for symbols inside type's parents
	 */
	def getDelayStateSymbols(NamedType type, boolean recursive) {
		ImlUtil.getSymbolsWithType(type, getDelayStateType, recursive)
	}
	/**
	 * Get the state symbol declaration inside the given DelayState type. If recursive is true
	 * then it will search for symbols inside type's parents 
	 */
	def getDelayStateState(NamedType type, boolean recursive) {
		if (isDelayState(type)) {
			return ImlUtil.findSymbol(type, DELAYSTATE_STATE_VAR, recursive) as SymbolDeclaration;
		}
		return null;
	}
	/**
	 * Get the i symbol declaration inside the given DelayState type. If recursive is true
	 * then it will search for symbols inside type's parents 
	 */
	def getDelayStateI(NamedType type, boolean recursive) {
		if (isDelayState(type)) {
			return ImlUtil.findSymbol(type, DELAYSTATE_I_VAR, recursive) as SymbolDeclaration;
		}
		return null;
	}
	/**
	 * get delay type declaration
	 */
	def getdelayType() {
		return getType(DELAY)
	}
	
	/**
	 * check whether the given type is delay type
	 */
	def isdelay(NamedType type) {
		return getdelayType == type
	}
	
	/**
	 * Get all symbols inside the given type that are delay type. If recursive is true
	 * then it will search for symbols inside type's parents
	 */
	def getdelaySymbols(NamedType type, boolean recursive) {
		ImlUtil.getSymbolsWithType(type, getdelayType, recursive)
	}
	/**
	 * Get the f symbol declaration inside the given delay type. If recursive is true
	 * then it will search for symbols inside type's parents 
	 */
	def getdelayF(NamedType type, boolean recursive) {
		if (isdelay(type)) {
			return ImlUtil.findSymbol(type, DELAY_F_VAR, recursive) as SymbolDeclaration;
		}
		return null;
	}
	/**
	 * Get the n symbol declaration inside the given delay type. If recursive is true
	 * then it will search for symbols inside type's parents 
	 */
	def getdelayN(NamedType type, boolean recursive) {
		if (isdelay(type)) {
			return ImlUtil.findSymbol(type, DELAY_N_VAR, recursive) as SymbolDeclaration;
		}
		return null;
	}
	/**
	 * Get the holds symbol declaration inside the given delay type. If recursive is true
	 * then it will search for symbols inside type's parents 
	 */
	def getdelayHolds(NamedType type, boolean recursive) {
		if (isdelay(type)) {
			return ImlUtil.findSymbol(type, DELAY_HOLDS_VAR, recursive) as SymbolDeclaration;
		}
		return null;
	}
	/**
	 * Get the init symbol declaration inside the given delay type. If recursive is true
	 * then it will search for symbols inside type's parents 
	 */
	def getdelayInit(NamedType type, boolean recursive) {
		if (isdelay(type)) {
			return ImlUtil.findSymbol(type, DELAY_INIT_VAR, recursive) as SymbolDeclaration;
		}
		return null;
	}
	/**
	 * Get the transition symbol declaration inside the given delay type. If recursive is true
	 * then it will search for symbols inside type's parents 
	 */
	def getdelayTransition(NamedType type, boolean recursive) {
		if (isdelay(type)) {
			return ImlUtil.findSymbol(type, DELAY_TRANSITION_VAR, recursive) as SymbolDeclaration;
		}
		return null;
	}
	/**
	 * Get the invariant symbol declaration inside the given delay type. If recursive is true
	 * then it will search for symbols inside type's parents 
	 */
	def getdelayInvariant(NamedType type, boolean recursive) {
		if (isdelay(type)) {
			return ImlUtil.findSymbol(type, DELAY_INVARIANT_VAR, recursive) as SymbolDeclaration;
		}
		return null;
	}
	/**
	 * get EventPort type declaration
	 */
	def getEventPortType() {
		return getType(EVENTPORT)
	}
	
	/**
	 * check whether the given type is EventPort type
	 */
	def isEventPort(NamedType type) {
		return getEventPortType == type
	}
	
	/**
	 * Get all symbols inside the given type that are EventPort type. If recursive is true
	 * then it will search for symbols inside type's parents
	 */
	def getEventPortSymbols(NamedType type, boolean recursive) {
		ImlUtil.getSymbolsWithType(type, getEventPortType, recursive)
	}
	/**
	 * Get the event symbol declaration inside the given EventPort type. If recursive is true
	 * then it will search for symbols inside type's parents 
	 */
	def getEventPortEvent(NamedType type, boolean recursive) {
		if (isEventPort(type)) {
			return ImlUtil.findSymbol(type, EVENTPORT_EVENT_VAR, recursive) as SymbolDeclaration;
		}
		return null;
	}
	/**
	 * Get the flowpoint symbol declaration inside the given EventPort type. If recursive is true
	 * then it will search for symbols inside type's parents 
	 */
	def getEventPortFlowpoint(NamedType type, boolean recursive) {
		if (isEventPort(type)) {
			return ImlUtil.findSymbol(type, EVENTPORT_FLOWPOINT_VAR, recursive) as SymbolDeclaration;
		}
		return null;
	}
	/**
	 * get FlowPoint type declaration
	 */
	def getFlowPointType() {
		return getType(FLOWPOINT)
	}
	
	/**
	 * check whether the given type is FlowPoint type
	 */
	def isFlowPoint(NamedType type) {
		return getFlowPointType == type
	}
	
	/**
	 * Get all symbols inside the given type that are FlowPoint type. If recursive is true
	 * then it will search for symbols inside type's parents
	 */
	def getFlowPointSymbols(NamedType type, boolean recursive) {
		ImlUtil.getSymbolsWithType(type, getFlowPointType, recursive)
	}
	/**
	 * Get the event symbol declaration inside the given FlowPoint type. If recursive is true
	 * then it will search for symbols inside type's parents 
	 */
	def getFlowPointEvent(NamedType type, boolean recursive) {
		if (isFlowPoint(type)) {
			return ImlUtil.findSymbol(type, FLOWPOINT_EVENT_VAR, recursive) as SymbolDeclaration;
		}
		return null;
	}
	/**
	 * Get the upperBound symbol declaration inside the given FlowPoint type. If recursive is true
	 * then it will search for symbols inside type's parents 
	 */
	def getFlowPointUpperBound(NamedType type, boolean recursive) {
		if (isFlowPoint(type)) {
			return ImlUtil.findSymbol(type, FLOWPOINT_UPPERBOUND_VAR, recursive) as SymbolDeclaration;
		}
		return null;
	}
	/**
	 * Get the lowerBound symbol declaration inside the given FlowPoint type. If recursive is true
	 * then it will search for symbols inside type's parents 
	 */
	def getFlowPointLowerBound(NamedType type, boolean recursive) {
		if (isFlowPoint(type)) {
			return ImlUtil.findSymbol(type, FLOWPOINT_LOWERBOUND_VAR, recursive) as SymbolDeclaration;
		}
		return null;
	}
	/**
	 * get FlowPath type declaration
	 */
	def getFlowPathType() {
		return getType(FLOWPATH)
	}
	
	/**
	 * check whether the given type is FlowPath type
	 */
	def isFlowPath(NamedType type) {
		return getFlowPathType == type
	}
	
	/**
	 * Get all symbols inside the given type that are FlowPath type. If recursive is true
	 * then it will search for symbols inside type's parents
	 */
	def getFlowPathSymbols(NamedType type, boolean recursive) {
		ImlUtil.getSymbolsWithType(type, getFlowPathType, recursive)
	}
	/**
	 * Get the start symbol declaration inside the given FlowPath type. If recursive is true
	 * then it will search for symbols inside type's parents 
	 */
	def getFlowPathStart(NamedType type, boolean recursive) {
		if (isFlowPath(type)) {
			return ImlUtil.findSymbol(type, FLOWPATH_START_VAR, recursive) as SymbolDeclaration;
		}
		return null;
	}
	/**
	 * Get the end symbol declaration inside the given FlowPath type. If recursive is true
	 * then it will search for symbols inside type's parents 
	 */
	def getFlowPathEnd(NamedType type, boolean recursive) {
		if (isFlowPath(type)) {
			return ImlUtil.findSymbol(type, FLOWPATH_END_VAR, recursive) as SymbolDeclaration;
		}
		return null;
	}
	/**
	 * Get the upperBound symbol declaration inside the given FlowPath type. If recursive is true
	 * then it will search for symbols inside type's parents 
	 */
	def getFlowPathUpperBound(NamedType type, boolean recursive) {
		if (isFlowPath(type)) {
			return ImlUtil.findSymbol(type, FLOWPATH_UPPERBOUND_VAR, recursive) as SymbolDeclaration;
		}
		return null;
	}
	/**
	 * Get the lowerBound symbol declaration inside the given FlowPath type. If recursive is true
	 * then it will search for symbols inside type's parents 
	 */
	def getFlowPathLowerBound(NamedType type, boolean recursive) {
		if (isFlowPath(type)) {
			return ImlUtil.findSymbol(type, FLOWPATH_LOWERBOUND_VAR, recursive) as SymbolDeclaration;
		}
		return null;
	}
	/**
	 * get EventDataPort type declaration
	 */
	def getEventDataPortType() {
		return getType(EVENTDATAPORT)
	}
	
	/**
	 * check whether the given type is EventDataPort type
	 */
	def isEventDataPort(NamedType type) {
		return getEventDataPortType == type
	}
	
	/**
	 * Get all symbols inside the given type that are EventDataPort type. If recursive is true
	 * then it will search for symbols inside type's parents
	 */
	def getEventDataPortSymbols(NamedType type, boolean recursive) {
		ImlUtil.getSymbolsWithType(type, getEventDataPortType, recursive)
	}
	/**
	 * Get the event symbol declaration inside the given EventDataPort type. If recursive is true
	 * then it will search for symbols inside type's parents 
	 */
	def getEventDataPortEvent(NamedType type, boolean recursive) {
		if (isEventDataPort(type)) {
			return ImlUtil.findSymbol(type, EVENTDATAPORT_EVENT_VAR, recursive) as SymbolDeclaration;
		}
		return null;
	}
	/**
	 * Get the data symbol declaration inside the given EventDataPort type. If recursive is true
	 * then it will search for symbols inside type's parents 
	 */
	def getEventDataPortData(NamedType type, boolean recursive) {
		if (isEventDataPort(type)) {
			return ImlUtil.findSymbol(type, EVENTDATAPORT_DATA_VAR, recursive) as SymbolDeclaration;
		}
		return null;
	}
	/**
	 * Get the flowpoint symbol declaration inside the given EventDataPort type. If recursive is true
	 * then it will search for symbols inside type's parents 
	 */
	def getEventDataPortFlowpoint(NamedType type, boolean recursive) {
		if (isEventDataPort(type)) {
			return ImlUtil.findSymbol(type, EVENTDATAPORT_FLOWPOINT_VAR, recursive) as SymbolDeclaration;
		}
		return null;
	}
	
	override getPackageName() {
		PACKAGE_NAME
	}
}
