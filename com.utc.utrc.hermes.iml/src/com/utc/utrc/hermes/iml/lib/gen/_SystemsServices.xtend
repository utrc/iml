/*
 * Auto-Generated, please don't modify. Add your own logic to the child class {@link com.utc.utrc.hermes.iml.lib.SystemsServices} instead
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
class _SystemsServices extends BasicServices
 {
	public static final String PACKAGE_NAME = "iml.systems"
	public static final String CONNECTOR = "Connector"	
	public static final String CONNECTOR_SOURCE_VAR = "source"
	public static final String CONNECTOR_TARGET_VAR = "target"
	public static final String OUTEVENTPORT = "OutEventPort"	
	public static final String IN = "In"	
	public static final String PORT = "Port"	
	public static final String PORT_DIRECTION_VAR = "direction"
	public static final String INOUTEVENTPORT = "InOutEventPort"	
	public static final String CONNECTEQUAL_SYMBOL = "connectEqual"	
	public static final String DIRECTION = "Direction"	
	public static final String SYSTEM = "System"	
	public static final String DELEGATE_SYMBOL = "delegate"	
	public static final String CONNECTABLE = "Connectable"	
	public static final String INEVENTDATAPORT = "InEventDataPort"	
	public static final String COMPONENT = "Component"	
	public static final String CONNECT_SYMBOL = "connect"	
	public static final String INPORT = "InPort"	
	public static final String INEVENTPORT = "InEventPort"	
	public static final String INDATAPORT = "InDataPort"	
	public static final String DATACARRIER = "DataCarrier"	
	public static final String DATACARRIER_DATA_VAR = "data"
	public static final String EVENTCARRIER = "EventCarrier"	
	public static final String EVENTCARRIER_EVENT_VAR = "event"
	public static final String INOUTDATAPORT = "InOutDataPort"	
	public static final String INOUTEVENTDATAPORT = "InOutEventDataPort"	
	public static final String INOUTPORT = "InOutPort"	
	public static final String OUT = "Out"	
	public static final String EQUALITYCONNECTOR = "EqualityConnector"	
	public static final String EQUALITYCONNECTOR_SOURCE_VAR = "source"
	public static final String EQUALITYCONNECTOR_TARGET_VAR = "target"
	public static final String OUTEVENTDATAPORT = "OutEventDataPort"	
	public static final String OUTPORT = "OutPort"	
	public static final String OUTDATAPORT = "OutDataPort"	
	public static final String INOUT = "InOut"	
	
	/**
	 * get Connector type declaration
	 */
	def getConnectorType() {
		return getType(CONNECTOR)
	}
	
	/**
	 * check whether the given type is Connector type
	 */
	def isConnector(NamedType type) {
		return getConnectorType == type
	}
	
	/**
	 * Get all symbols inside the given type that are Connector type. If recursive is true
	 * then it will search for symbols inside type's parents
	 */
	def getConnectorSymbols(NamedType type, boolean recursive) {
		ImlUtil.getSymbolsWithType(type, getConnectorType, recursive)
	}
	/**
	 * Get the source symbol declaration inside the given Connector type. If recursive is true
	 * then it will search for symbols inside type's parents 
	 */
	def getConnectorSourceVar() {
		return ImlUtil.findSymbol(getType(CONNECTOR), CONNECTOR_SOURCE_VAR, true) as SymbolDeclaration;
	}
	/**
	 * Get the target symbol declaration inside the given Connector type. If recursive is true
	 * then it will search for symbols inside type's parents 
	 */
	def getConnectorTargetVar() {
		return ImlUtil.findSymbol(getType(CONNECTOR), CONNECTOR_TARGET_VAR, true) as SymbolDeclaration;
	}
	/**
	 * get OutEventPort type declaration
	 */
	def getOutEventPortType() {
		return getType(OUTEVENTPORT)
	}
	
	/**
	 * check whether the given type is OutEventPort type
	 */
	def isOutEventPort(NamedType type) {
		return getOutEventPortType == type
	}
	
	/**
	 * Get all symbols inside the given type that are OutEventPort type. If recursive is true
	 * then it will search for symbols inside type's parents
	 */
	def getOutEventPortSymbols(NamedType type, boolean recursive) {
		ImlUtil.getSymbolsWithType(type, getOutEventPortType, recursive)
	}
	/**
	 * get In trait declaration
	 */
	def getInTrait() {
		return getTrait(IN)
	}
	
	/**
	 * check wether the given eObject refines or exhibits the In trait
	 */
	def isIn(EObject eObject) {
		return ImlUtil.exhibitsOrRefines(eObject, getInTrait);
	}
	
	/**
	 * Get all symbols inside the given type that exhibits/refines the In trait. If recursive is true
	 * then it will search for symbols inside type's parents
	 */
	def getInSymbols(NamedType type, boolean recursive) {
		ImlUtil.getSymbolsWithTrait(type, getInTrait, recursive);
	}
	
	/**
	 * get Port trait declaration
	 */
	def getPortTrait() {
		return getTrait(PORT)
	}
	
	/**
	 * check wether the given eObject refines or exhibits the Port trait
	 */
	def isPort(EObject eObject) {
		return ImlUtil.exhibitsOrRefines(eObject, getPortTrait);
	}
	
	/**
	 * Get all symbols inside the given type that exhibits/refines the Port trait. If recursive is true
	 * then it will search for symbols inside type's parents
	 */
	def getPortSymbols(NamedType type, boolean recursive) {
		ImlUtil.getSymbolsWithTrait(type, getPortTrait, recursive);
	}
	
	/**
	 * Get the direction symbol declaration inside the given Port type. If recursive is true
	 * then it will search for symbols inside type's parents 
	 */
	def getPortDirectionVar() {
		return ImlUtil.findSymbol(getType(PORT), PORT_DIRECTION_VAR, true) as SymbolDeclaration;
	}
	/**
	 * get InOutEventPort type declaration
	 */
	def getInOutEventPortType() {
		return getType(INOUTEVENTPORT)
	}
	
	/**
	 * check whether the given type is InOutEventPort type
	 */
	def isInOutEventPort(NamedType type) {
		return getInOutEventPortType == type
	}
	
	/**
	 * Get all symbols inside the given type that are InOutEventPort type. If recursive is true
	 * then it will search for symbols inside type's parents
	 */
	def getInOutEventPortSymbols(NamedType type, boolean recursive) {
		ImlUtil.getSymbolsWithType(type, getInOutEventPortType, recursive)
	}
	/**
	 * Get ConnectEqualSymbol symbol declaration
	 */
	 def getConnectEqualSymbol() {
	 	return getSymbolDeclaration(CONNECTEQUAL_SYMBOL)
	 }
	/**
	 * get Direction type declaration
	 */
	def getDirectionType() {
		return getType(DIRECTION)
	}
	
	/**
	 * check whether the given type is Direction type
	 */
	def isDirection(NamedType type) {
		return getDirectionType == type
	}
	
	/**
	 * Get all symbols inside the given type that are Direction type. If recursive is true
	 * then it will search for symbols inside type's parents
	 */
	def getDirectionSymbols(NamedType type, boolean recursive) {
		ImlUtil.getSymbolsWithType(type, getDirectionType, recursive)
	}
	/**
	 * get System trait declaration
	 */
	def getSystemTrait() {
		return getTrait(SYSTEM)
	}
	
	/**
	 * check wether the given eObject refines or exhibits the System trait
	 */
	def isSystem(EObject eObject) {
		return ImlUtil.exhibitsOrRefines(eObject, getSystemTrait);
	}
	
	/**
	 * Get all symbols inside the given type that exhibits/refines the System trait. If recursive is true
	 * then it will search for symbols inside type's parents
	 */
	def getSystemSymbols(NamedType type, boolean recursive) {
		ImlUtil.getSymbolsWithTrait(type, getSystemTrait, recursive);
	}
	
	/**
	 * Get DelegateSymbol symbol declaration
	 */
	 def getDelegateSymbol() {
	 	return getSymbolDeclaration(DELEGATE_SYMBOL)
	 }
	/**
	 * get Connectable trait declaration
	 */
	def getConnectableTrait() {
		return getTrait(CONNECTABLE)
	}
	
	/**
	 * check wether the given eObject refines or exhibits the Connectable trait
	 */
	def isConnectable(EObject eObject) {
		return ImlUtil.exhibitsOrRefines(eObject, getConnectableTrait);
	}
	
	/**
	 * Get all symbols inside the given type that exhibits/refines the Connectable trait. If recursive is true
	 * then it will search for symbols inside type's parents
	 */
	def getConnectableSymbols(NamedType type, boolean recursive) {
		ImlUtil.getSymbolsWithTrait(type, getConnectableTrait, recursive);
	}
	
	/**
	 * get InEventDataPort type declaration
	 */
	def getInEventDataPortType() {
		return getType(INEVENTDATAPORT)
	}
	
	/**
	 * check whether the given type is InEventDataPort type
	 */
	def isInEventDataPort(NamedType type) {
		return getInEventDataPortType == type
	}
	
	/**
	 * Get all symbols inside the given type that are InEventDataPort type. If recursive is true
	 * then it will search for symbols inside type's parents
	 */
	def getInEventDataPortSymbols(NamedType type, boolean recursive) {
		ImlUtil.getSymbolsWithType(type, getInEventDataPortType, recursive)
	}
	/**
	 * get Component trait declaration
	 */
	def getComponentTrait() {
		return getTrait(COMPONENT)
	}
	
	/**
	 * check wether the given eObject refines or exhibits the Component trait
	 */
	def isComponent(EObject eObject) {
		return ImlUtil.exhibitsOrRefines(eObject, getComponentTrait);
	}
	
	/**
	 * Get all symbols inside the given type that exhibits/refines the Component trait. If recursive is true
	 * then it will search for symbols inside type's parents
	 */
	def getComponentSymbols(NamedType type, boolean recursive) {
		ImlUtil.getSymbolsWithTrait(type, getComponentTrait, recursive);
	}
	
	/**
	 * Get ConnectSymbol symbol declaration
	 */
	 def getConnectSymbol() {
	 	return getSymbolDeclaration(CONNECT_SYMBOL)
	 }
	/**
	 * get InPort type declaration
	 */
	def getInPortType() {
		return getType(INPORT)
	}
	
	/**
	 * check whether the given type is InPort type
	 */
	def isInPort(NamedType type) {
		return getInPortType == type
	}
	
	/**
	 * Get all symbols inside the given type that are InPort type. If recursive is true
	 * then it will search for symbols inside type's parents
	 */
	def getInPortSymbols(NamedType type, boolean recursive) {
		ImlUtil.getSymbolsWithType(type, getInPortType, recursive)
	}
	/**
	 * get InEventPort type declaration
	 */
	def getInEventPortType() {
		return getType(INEVENTPORT)
	}
	
	/**
	 * check whether the given type is InEventPort type
	 */
	def isInEventPort(NamedType type) {
		return getInEventPortType == type
	}
	
	/**
	 * Get all symbols inside the given type that are InEventPort type. If recursive is true
	 * then it will search for symbols inside type's parents
	 */
	def getInEventPortSymbols(NamedType type, boolean recursive) {
		ImlUtil.getSymbolsWithType(type, getInEventPortType, recursive)
	}
	/**
	 * get InDataPort type declaration
	 */
	def getInDataPortType() {
		return getType(INDATAPORT)
	}
	
	/**
	 * check whether the given type is InDataPort type
	 */
	def isInDataPort(NamedType type) {
		return getInDataPortType == type
	}
	
	/**
	 * Get all symbols inside the given type that are InDataPort type. If recursive is true
	 * then it will search for symbols inside type's parents
	 */
	def getInDataPortSymbols(NamedType type, boolean recursive) {
		ImlUtil.getSymbolsWithType(type, getInDataPortType, recursive)
	}
	/**
	 * get DataCarrier trait declaration
	 */
	def getDataCarrierTrait() {
		return getTrait(DATACARRIER)
	}
	
	/**
	 * check wether the given eObject refines or exhibits the DataCarrier trait
	 */
	def isDataCarrier(EObject eObject) {
		return ImlUtil.exhibitsOrRefines(eObject, getDataCarrierTrait);
	}
	
	/**
	 * Get all symbols inside the given type that exhibits/refines the DataCarrier trait. If recursive is true
	 * then it will search for symbols inside type's parents
	 */
	def getDataCarrierSymbols(NamedType type, boolean recursive) {
		ImlUtil.getSymbolsWithTrait(type, getDataCarrierTrait, recursive);
	}
	
	/**
	 * Get the data symbol declaration inside the given DataCarrier type. If recursive is true
	 * then it will search for symbols inside type's parents 
	 */
	def getDataCarrierDataVar() {
		return ImlUtil.findSymbol(getType(DATACARRIER), DATACARRIER_DATA_VAR, true) as SymbolDeclaration;
	}
	/**
	 * get EventCarrier trait declaration
	 */
	def getEventCarrierTrait() {
		return getTrait(EVENTCARRIER)
	}
	
	/**
	 * check wether the given eObject refines or exhibits the EventCarrier trait
	 */
	def isEventCarrier(EObject eObject) {
		return ImlUtil.exhibitsOrRefines(eObject, getEventCarrierTrait);
	}
	
	/**
	 * Get all symbols inside the given type that exhibits/refines the EventCarrier trait. If recursive is true
	 * then it will search for symbols inside type's parents
	 */
	def getEventCarrierSymbols(NamedType type, boolean recursive) {
		ImlUtil.getSymbolsWithTrait(type, getEventCarrierTrait, recursive);
	}
	
	/**
	 * Get the event symbol declaration inside the given EventCarrier type. If recursive is true
	 * then it will search for symbols inside type's parents 
	 */
	def getEventCarrierEventVar() {
		return ImlUtil.findSymbol(getType(EVENTCARRIER), EVENTCARRIER_EVENT_VAR, true) as SymbolDeclaration;
	}
	/**
	 * get InOutDataPort type declaration
	 */
	def getInOutDataPortType() {
		return getType(INOUTDATAPORT)
	}
	
	/**
	 * check whether the given type is InOutDataPort type
	 */
	def isInOutDataPort(NamedType type) {
		return getInOutDataPortType == type
	}
	
	/**
	 * Get all symbols inside the given type that are InOutDataPort type. If recursive is true
	 * then it will search for symbols inside type's parents
	 */
	def getInOutDataPortSymbols(NamedType type, boolean recursive) {
		ImlUtil.getSymbolsWithType(type, getInOutDataPortType, recursive)
	}
	/**
	 * get InOutEventDataPort type declaration
	 */
	def getInOutEventDataPortType() {
		return getType(INOUTEVENTDATAPORT)
	}
	
	/**
	 * check whether the given type is InOutEventDataPort type
	 */
	def isInOutEventDataPort(NamedType type) {
		return getInOutEventDataPortType == type
	}
	
	/**
	 * Get all symbols inside the given type that are InOutEventDataPort type. If recursive is true
	 * then it will search for symbols inside type's parents
	 */
	def getInOutEventDataPortSymbols(NamedType type, boolean recursive) {
		ImlUtil.getSymbolsWithType(type, getInOutEventDataPortType, recursive)
	}
	/**
	 * get InOutPort type declaration
	 */
	def getInOutPortType() {
		return getType(INOUTPORT)
	}
	
	/**
	 * check whether the given type is InOutPort type
	 */
	def isInOutPort(NamedType type) {
		return getInOutPortType == type
	}
	
	/**
	 * Get all symbols inside the given type that are InOutPort type. If recursive is true
	 * then it will search for symbols inside type's parents
	 */
	def getInOutPortSymbols(NamedType type, boolean recursive) {
		ImlUtil.getSymbolsWithType(type, getInOutPortType, recursive)
	}
	/**
	 * get Out trait declaration
	 */
	def getOutTrait() {
		return getTrait(OUT)
	}
	
	/**
	 * check wether the given eObject refines or exhibits the Out trait
	 */
	def isOut(EObject eObject) {
		return ImlUtil.exhibitsOrRefines(eObject, getOutTrait);
	}
	
	/**
	 * Get all symbols inside the given type that exhibits/refines the Out trait. If recursive is true
	 * then it will search for symbols inside type's parents
	 */
	def getOutSymbols(NamedType type, boolean recursive) {
		ImlUtil.getSymbolsWithTrait(type, getOutTrait, recursive);
	}
	
	/**
	 * get EqualityConnector type declaration
	 */
	def getEqualityConnectorType() {
		return getType(EQUALITYCONNECTOR)
	}
	
	/**
	 * check whether the given type is EqualityConnector type
	 */
	def isEqualityConnector(NamedType type) {
		return getEqualityConnectorType == type
	}
	
	/**
	 * Get all symbols inside the given type that are EqualityConnector type. If recursive is true
	 * then it will search for symbols inside type's parents
	 */
	def getEqualityConnectorSymbols(NamedType type, boolean recursive) {
		ImlUtil.getSymbolsWithType(type, getEqualityConnectorType, recursive)
	}
	/**
	 * Get the source symbol declaration inside the given EqualityConnector type. If recursive is true
	 * then it will search for symbols inside type's parents 
	 */
	def getEqualityConnectorSourceVar() {
		return ImlUtil.findSymbol(getType(EQUALITYCONNECTOR), EQUALITYCONNECTOR_SOURCE_VAR, true) as SymbolDeclaration;
	}
	/**
	 * Get the target symbol declaration inside the given EqualityConnector type. If recursive is true
	 * then it will search for symbols inside type's parents 
	 */
	def getEqualityConnectorTargetVar() {
		return ImlUtil.findSymbol(getType(EQUALITYCONNECTOR), EQUALITYCONNECTOR_TARGET_VAR, true) as SymbolDeclaration;
	}
	/**
	 * get OutEventDataPort type declaration
	 */
	def getOutEventDataPortType() {
		return getType(OUTEVENTDATAPORT)
	}
	
	/**
	 * check whether the given type is OutEventDataPort type
	 */
	def isOutEventDataPort(NamedType type) {
		return getOutEventDataPortType == type
	}
	
	/**
	 * Get all symbols inside the given type that are OutEventDataPort type. If recursive is true
	 * then it will search for symbols inside type's parents
	 */
	def getOutEventDataPortSymbols(NamedType type, boolean recursive) {
		ImlUtil.getSymbolsWithType(type, getOutEventDataPortType, recursive)
	}
	/**
	 * get OutPort type declaration
	 */
	def getOutPortType() {
		return getType(OUTPORT)
	}
	
	/**
	 * check whether the given type is OutPort type
	 */
	def isOutPort(NamedType type) {
		return getOutPortType == type
	}
	
	/**
	 * Get all symbols inside the given type that are OutPort type. If recursive is true
	 * then it will search for symbols inside type's parents
	 */
	def getOutPortSymbols(NamedType type, boolean recursive) {
		ImlUtil.getSymbolsWithType(type, getOutPortType, recursive)
	}
	/**
	 * get OutDataPort type declaration
	 */
	def getOutDataPortType() {
		return getType(OUTDATAPORT)
	}
	
	/**
	 * check whether the given type is OutDataPort type
	 */
	def isOutDataPort(NamedType type) {
		return getOutDataPortType == type
	}
	
	/**
	 * Get all symbols inside the given type that are OutDataPort type. If recursive is true
	 * then it will search for symbols inside type's parents
	 */
	def getOutDataPortSymbols(NamedType type, boolean recursive) {
		ImlUtil.getSymbolsWithType(type, getOutDataPortType, recursive)
	}
	/**
	 * get InOut trait declaration
	 */
	def getInOutTrait() {
		return getTrait(INOUT)
	}
	
	/**
	 * check wether the given eObject refines or exhibits the InOut trait
	 */
	def isInOut(EObject eObject) {
		return ImlUtil.exhibitsOrRefines(eObject, getInOutTrait);
	}
	
	/**
	 * Get all symbols inside the given type that exhibits/refines the InOut trait. If recursive is true
	 * then it will search for symbols inside type's parents
	 */
	def getInOutSymbols(NamedType type, boolean recursive) {
		ImlUtil.getSymbolsWithTrait(type, getInOutTrait, recursive);
	}
	
	
	override getPackageName() {
		PACKAGE_NAME
	}
	
	/**
	 * Checks if a symbol is defined inside Systems IML library
	 */
	def isSystemsSymbol(Symbol symbol) {
		if (symbol !== null) {
			val containerModel = ImlUtil.getContainerOfType(symbol, Model)
			if (containerModel.name == getPackageName()) {
				return true;
			}
		}
		return false;
	}
}
