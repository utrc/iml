/*
 * Auto-Generated, please don't modify. Add your own logic to the child class {@link com.utc.utrc.hermes.iml.lib.PortsServices} instead
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
	public static final String FLOWPATHSPEC_SYMBOL = "flowpathspec"	
	public static final String PORT = "Port"	
	public static final String SOURCE_SYMBOL = "source"	
	public static final String DATAPORT = "DataPort"	
	public static final String DATAPORT_DATA_VAR = "data"
	public static final String DATAPORT_FLOWPOINT_VAR = "flowpoint"
	public static final String FLOWDELAYBOUND_SYMBOL = "flowdelaybound"	
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
	public static final String FLOWPATH_SYMBOL = "flowpath"	
	public static final String FLOWCONNECT_SYMBOL = "flowconnect"	
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
	def getEndToEndFlowStartVar() {
		return ImlUtil.findSymbol(getType(ENDTOENDFLOW), ENDTOENDFLOW_START_VAR, true) as SymbolDeclaration;
	}
	/**
	 * Get the end symbol declaration inside the given EndToEndFlow type. If recursive is true
	 * then it will search for symbols inside type's parents 
	 */
	def getEndToEndFlowEndVar() {
		return ImlUtil.findSymbol(getType(ENDTOENDFLOW), ENDTOENDFLOW_END_VAR, true) as SymbolDeclaration;
	}
	/**
	 * Get the append symbol declaration inside the given EndToEndFlow type. If recursive is true
	 * then it will search for symbols inside type's parents 
	 */
	def getEndToEndFlowAppendVar() {
		return ImlUtil.findSymbol(getType(ENDTOENDFLOW), ENDTOENDFLOW_APPEND_VAR, true) as SymbolDeclaration;
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
	def getFlowConnectorConnectorVar() {
		return ImlUtil.findSymbol(getType(FLOWCONNECTOR), FLOWCONNECTOR_CONNECTOR_VAR, true) as SymbolDeclaration;
	}
	/**
	 * Get the flow symbol declaration inside the given FlowConnector type. If recursive is true
	 * then it will search for symbols inside type's parents 
	 */
	def getFlowConnectorFlowVar() {
		return ImlUtil.findSymbol(getType(FLOWCONNECTOR), FLOWCONNECTOR_FLOW_VAR, true) as SymbolDeclaration;
	}
	/**
	 * Get FlowpathspecSymbol symbol declaration
	 */
	 def getFlowpathspecSymbol() {
	 	return getSymbolDeclaration(FLOWPATHSPEC_SYMBOL)
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
	 * Get SourceSymbol symbol declaration
	 */
	 def getSourceSymbol() {
	 	return getSymbolDeclaration(SOURCE_SYMBOL)
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
	def getDataPortDataVar() {
		return ImlUtil.findSymbol(getType(DATAPORT), DATAPORT_DATA_VAR, true) as SymbolDeclaration;
	}
	/**
	 * Get the flowpoint symbol declaration inside the given DataPort type. If recursive is true
	 * then it will search for symbols inside type's parents 
	 */
	def getDataPortFlowpointVar() {
		return ImlUtil.findSymbol(getType(DATAPORT), DATAPORT_FLOWPOINT_VAR, true) as SymbolDeclaration;
	}
	/**
	 * Get FlowdelayboundSymbol symbol declaration
	 */
	 def getFlowdelayboundSymbol() {
	 	return getSymbolDeclaration(FLOWDELAYBOUND_SYMBOL)
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
	def getDelayStateStateVar() {
		return ImlUtil.findSymbol(getType(DELAYSTATE), DELAYSTATE_STATE_VAR, true) as SymbolDeclaration;
	}
	/**
	 * Get the i symbol declaration inside the given DelayState type. If recursive is true
	 * then it will search for symbols inside type's parents 
	 */
	def getDelayStateIVar() {
		return ImlUtil.findSymbol(getType(DELAYSTATE), DELAYSTATE_I_VAR, true) as SymbolDeclaration;
	}
	/**
	 * get Delay type declaration
	 */
	def getDelayType() {
		return getType(DELAY)
	}
	
	/**
	 * check whether the given type is Delay type
	 */
	def isDelay(NamedType type) {
		return getDelayType == type
	}
	
	/**
	 * Get all symbols inside the given type that are Delay type. If recursive is true
	 * then it will search for symbols inside type's parents
	 */
	def getDelaySymbols(NamedType type, boolean recursive) {
		ImlUtil.getSymbolsWithType(type, getDelayType, recursive)
	}
	/**
	 * Get the f symbol declaration inside the given delay type. If recursive is true
	 * then it will search for symbols inside type's parents 
	 */
	def getDelayFVar() {
		return ImlUtil.findSymbol(getType(DELAY), DELAY_F_VAR, true) as SymbolDeclaration;
	}
	/**
	 * Get the n symbol declaration inside the given delay type. If recursive is true
	 * then it will search for symbols inside type's parents 
	 */
	def getDelayNVar() {
		return ImlUtil.findSymbol(getType(DELAY), DELAY_N_VAR, true) as SymbolDeclaration;
	}
	/**
	 * Get the holds symbol declaration inside the given delay type. If recursive is true
	 * then it will search for symbols inside type's parents 
	 */
	def getDelayHoldsVar() {
		return ImlUtil.findSymbol(getType(DELAY), DELAY_HOLDS_VAR, true) as SymbolDeclaration;
	}
	/**
	 * Get the init symbol declaration inside the given delay type. If recursive is true
	 * then it will search for symbols inside type's parents 
	 */
	def getDelayInitVar() {
		return ImlUtil.findSymbol(getType(DELAY), DELAY_INIT_VAR, true) as SymbolDeclaration;
	}
	/**
	 * Get the transition symbol declaration inside the given delay type. If recursive is true
	 * then it will search for symbols inside type's parents 
	 */
	def getDelayTransitionVar() {
		return ImlUtil.findSymbol(getType(DELAY), DELAY_TRANSITION_VAR, true) as SymbolDeclaration;
	}
	/**
	 * Get the invariant symbol declaration inside the given delay type. If recursive is true
	 * then it will search for symbols inside type's parents 
	 */
	def getDelayInvariantVar() {
		return ImlUtil.findSymbol(getType(DELAY), DELAY_INVARIANT_VAR, true) as SymbolDeclaration;
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
	def getEventPortEventVar() {
		return ImlUtil.findSymbol(getType(EVENTPORT), EVENTPORT_EVENT_VAR, true) as SymbolDeclaration;
	}
	/**
	 * Get the flowpoint symbol declaration inside the given EventPort type. If recursive is true
	 * then it will search for symbols inside type's parents 
	 */
	def getEventPortFlowpointVar() {
		return ImlUtil.findSymbol(getType(EVENTPORT), EVENTPORT_FLOWPOINT_VAR, true) as SymbolDeclaration;
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
	def getFlowPointEventVar() {
		return ImlUtil.findSymbol(getType(FLOWPOINT), FLOWPOINT_EVENT_VAR, true) as SymbolDeclaration;
	}
	/**
	 * Get the upperBound symbol declaration inside the given FlowPoint type. If recursive is true
	 * then it will search for symbols inside type's parents 
	 */
	def getFlowPointUpperBoundVar() {
		return ImlUtil.findSymbol(getType(FLOWPOINT), FLOWPOINT_UPPERBOUND_VAR, true) as SymbolDeclaration;
	}
	/**
	 * Get the lowerBound symbol declaration inside the given FlowPoint type. If recursive is true
	 * then it will search for symbols inside type's parents 
	 */
	def getFlowPointLowerBoundVar() {
		return ImlUtil.findSymbol(getType(FLOWPOINT), FLOWPOINT_LOWERBOUND_VAR, true) as SymbolDeclaration;
	}
	/**
	 * Get FlowpathSymbol symbol declaration
	 */
	 def getFlowpathSymbol() {
	 	return getSymbolDeclaration(FLOWPATH_SYMBOL)
	 }
	/**
	 * Get FlowconnectSymbol symbol declaration
	 */
	 def getFlowconnectSymbol() {
	 	return getSymbolDeclaration(FLOWCONNECT_SYMBOL)
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
	def getFlowPathStartVar() {
		return ImlUtil.findSymbol(getType(FLOWPATH), FLOWPATH_START_VAR, true) as SymbolDeclaration;
	}
	/**
	 * Get the end symbol declaration inside the given FlowPath type. If recursive is true
	 * then it will search for symbols inside type's parents 
	 */
	def getFlowPathEndVar() {
		return ImlUtil.findSymbol(getType(FLOWPATH), FLOWPATH_END_VAR, true) as SymbolDeclaration;
	}
	/**
	 * Get the upperBound symbol declaration inside the given FlowPath type. If recursive is true
	 * then it will search for symbols inside type's parents 
	 */
	def getFlowPathUpperBoundVar() {
		return ImlUtil.findSymbol(getType(FLOWPATH), FLOWPATH_UPPERBOUND_VAR, true) as SymbolDeclaration;
	}
	/**
	 * Get the lowerBound symbol declaration inside the given FlowPath type. If recursive is true
	 * then it will search for symbols inside type's parents 
	 */
	def getFlowPathLowerBoundVar() {
		return ImlUtil.findSymbol(getType(FLOWPATH), FLOWPATH_LOWERBOUND_VAR, true) as SymbolDeclaration;
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
	def getEventDataPortEventVar() {
		return ImlUtil.findSymbol(getType(EVENTDATAPORT), EVENTDATAPORT_EVENT_VAR, true) as SymbolDeclaration;
	}
	/**
	 * Get the data symbol declaration inside the given EventDataPort type. If recursive is true
	 * then it will search for symbols inside type's parents 
	 */
	def getEventDataPortDataVar() {
		return ImlUtil.findSymbol(getType(EVENTDATAPORT), EVENTDATAPORT_DATA_VAR, true) as SymbolDeclaration;
	}
	/**
	 * Get the flowpoint symbol declaration inside the given EventDataPort type. If recursive is true
	 * then it will search for symbols inside type's parents 
	 */
	def getEventDataPortFlowpointVar() {
		return ImlUtil.findSymbol(getType(EVENTDATAPORT), EVENTDATAPORT_FLOWPOINT_VAR, true) as SymbolDeclaration;
	}
	
	override getPackageName() {
		PACKAGE_NAME
	}
	
	/**
	 * Checks if a symbol is defined inside Ports IML library
	 */
	def isPortsSymbol(Symbol symbol) {
		if (symbol !== null) {
			val containerModel = ImlUtil.getContainerOfType(symbol, Model)
			if (containerModel.name == getPackageName()) {
				return true;
			}
		}
		return false;
	}
}
