/*
 * Auto-Generated, please don't modify. Add your own logic to the child class {@link com.utc.utrc.hermes.iml.lib.Pc_hardwareServices} instead
 */
package com.utc.utrc.hermes.iml.example

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
class PcHardwareServices extends BasicServices
 {
	public static final String PACKAGE_NAME = "iml.pc_hardware"
	public static final String MOTHERBOARD = "Motherboard"	
	public static final String PERSONALCOMPUTER = "PersonalComputer"	
	public static final String PERSONALCOMPUTER_COMPONENTS_VAR = "components"
	public static final String PERSONALCOMPUTER_PERIPHERALS_VAR = "peripherals"
	public static final String STORAGE = "Storage"	
	public static final String STORAGE_SIZE_VAR = "size"
	public static final String STORAGE_SPEED_VAR = "speed"
	public static final String SSD = "SSD"	
	public static final String CANSTORE = "CanStore"	
	public static final String CANSTORE_STORAGE_VAR = "storage"
	public static final String COMPUTERWITHSSDSTORAGE = "ComputerWithSSDStorage"	
	public static final String PROCESSOR = "Processor"	
	public static final String PROCESSOR_CLOCK_SPEED_VAR = "clock_speed"
	public static final String PROCESSOR_CORE_COUNT_VAR = "core_count"
	public static final String PROCESSOR_L2_CACHE_VAR = "l2_cache"
	public static final String MONITOR = "Monitor"	
	public static final String MONITOR_RESOLUTION_VAR = "resolution"
	public static final String MONITOR_SIZE_VAR = "size"
	public static final String MONITOR_IDEAL_VIEW_VAR = "ideal_view"
	
	/**
	 * get ComputerWithSSDStorage type declaration
	 */
	def getComputerWithSSDStorageType() {
		return getType(COMPUTERWITHSSDSTORAGE)
	}
	
	/**
	 * check whether the given type is ComputerWithSSDStorage type
	 */
	def isComputerWithSSDStorage(NamedType type) {
		return getComputerWithSSDStorageType == type
	}
	
	/**
	 * Get all symbols inside the given type that are ComputerWithSSDStorage type. If recursive is true
	 * then it will search for symbols inside type's parents
	 */
	def getComputerWithSSDStorageSymbols(NamedType type, boolean recursive) {
		ImlUtil.getSymbolsWithType(type, getComputerWithSSDStorageType, recursive)
	}
	/**
	 * get PersonalComputer type declaration
	 */
	def getPersonalComputerType() {
		return getType(PERSONALCOMPUTER)
	}
	
	/**
	 * check whether the given type is PersonalComputer type
	 */
	def isPersonalComputer(NamedType type) {
		return getPersonalComputerType == type
	}
	
	/**
	 * Get all symbols inside the given type that are PersonalComputer type. If recursive is true
	 * then it will search for symbols inside type's parents
	 */
	def getPersonalComputerSymbols(NamedType type, boolean recursive) {
		ImlUtil.getSymbolsWithType(type, getPersonalComputerType, recursive)
	}
	/**
	 * Get the components symbol declaration inside the given PersonalComputer type. If recursive is true
	 * then it will search for symbols inside type's parents 
	 */
	def getPersonalComputerComponentsVar() {
		return ImlUtil.findSymbol(getType(PERSONALCOMPUTER), PERSONALCOMPUTER_COMPONENTS_VAR, true) as SymbolDeclaration;
	}
	/**
	 * Get the peripherals symbol declaration inside the given PersonalComputer type. If recursive is true
	 * then it will search for symbols inside type's parents 
	 */
	def getPersonalComputerPeripheralsVar() {
		return ImlUtil.findSymbol(getType(PERSONALCOMPUTER), PERSONALCOMPUTER_PERIPHERALS_VAR, true) as SymbolDeclaration;
	}
	/**
	 * get Storage trait declaration
	 */
	def getStorageTrait() {
		return getTrait(STORAGE)
	}
	
	/**
	 * check wether the given eObject refines or exhibits the Storage trait
	 */
	def isStorage(EObject eObject) {
		return ImlUtil.exhibitsOrRefines(eObject, getStorageTrait);
	}
	
	/**
	 * Get all symbols inside the given type that exhibits/refines the Storage trait. If recursive is true
	 * then it will search for symbols inside type's parents
	 */
	def getStorageSymbols(NamedType type, boolean recursive) {
		ImlUtil.getSymbolsWithTrait(type, getStorageTrait, recursive);
	}
	
	/**
	 * Get the size symbol declaration inside the given Storage type. If recursive is true
	 * then it will search for symbols inside type's parents 
	 */
	def getStorageSizeVar() {
		return ImlUtil.findSymbol(getType(STORAGE), STORAGE_SIZE_VAR, true) as SymbolDeclaration;
	}
	/**
	 * Get the speed symbol declaration inside the given Storage type. If recursive is true
	 * then it will search for symbols inside type's parents 
	 */
	def getStorageSpeedVar() {
		return ImlUtil.findSymbol(getType(STORAGE), STORAGE_SPEED_VAR, true) as SymbolDeclaration;
	}
	/**
	 * get Processor type declaration
	 */
	def getProcessorType() {
		return getType(PROCESSOR)
	}
	
	/**
	 * check whether the given type is Processor type
	 */
	def isProcessor(NamedType type) {
		return getProcessorType == type
	}
	
	/**
	 * Get all symbols inside the given type that are Processor type. If recursive is true
	 * then it will search for symbols inside type's parents
	 */
	def getProcessorSymbols(NamedType type, boolean recursive) {
		ImlUtil.getSymbolsWithType(type, getProcessorType, recursive)
	}
	/**
	 * Get the clock_speed symbol declaration inside the given Processor type. If recursive is true
	 * then it will search for symbols inside type's parents 
	 */
	def getProcessorClock_speedVar() {
		return ImlUtil.findSymbol(getType(PROCESSOR), PROCESSOR_CLOCK_SPEED_VAR, true) as SymbolDeclaration;
	}
	/**
	 * Get the core_count symbol declaration inside the given Processor type. If recursive is true
	 * then it will search for symbols inside type's parents 
	 */
	def getProcessorCore_countVar() {
		return ImlUtil.findSymbol(getType(PROCESSOR), PROCESSOR_CORE_COUNT_VAR, true) as SymbolDeclaration;
	}
	/**
	 * Get the l2_cache symbol declaration inside the given Processor type. If recursive is true
	 * then it will search for symbols inside type's parents 
	 */
	def getProcessorL2_cacheVar() {
		return ImlUtil.findSymbol(getType(PROCESSOR), PROCESSOR_L2_CACHE_VAR, true) as SymbolDeclaration;
	}
	/**
	 * get Monitor trait declaration
	 */
	def getMonitorTrait() {
		return getTrait(MONITOR)
	}
	
	/**
	 * check wether the given eObject refines or exhibits the Monitor trait
	 */
	def isMonitor(EObject eObject) {
		return ImlUtil.exhibitsOrRefines(eObject, getMonitorTrait);
	}
	
	/**
	 * Get all symbols inside the given type that exhibits/refines the Monitor trait. If recursive is true
	 * then it will search for symbols inside type's parents
	 */
	def getMonitorSymbols(NamedType type, boolean recursive) {
		ImlUtil.getSymbolsWithTrait(type, getMonitorTrait, recursive);
	}
	
	/**
	 * Get the resolution symbol declaration inside the given Monitor type. If recursive is true
	 * then it will search for symbols inside type's parents 
	 */
	def getMonitorResolutionVar() {
		return ImlUtil.findSymbol(getType(MONITOR), MONITOR_RESOLUTION_VAR, true) as SymbolDeclaration;
	}
	/**
	 * Get the size symbol declaration inside the given Monitor type. If recursive is true
	 * then it will search for symbols inside type's parents 
	 */
	def getMonitorSizeVar() {
		return ImlUtil.findSymbol(getType(MONITOR), MONITOR_SIZE_VAR, true) as SymbolDeclaration;
	}
	/**
	 * Get the ideal_view symbol declaration inside the given Monitor type. If recursive is true
	 * then it will search for symbols inside type's parents 
	 */
	def getMonitorIdeal_viewVar() {
		return ImlUtil.findSymbol(getType(MONITOR), MONITOR_IDEAL_VIEW_VAR, true) as SymbolDeclaration;
	}
	/**
	 * get SSD type declaration
	 */
	def getSSDType() {
		return getType(SSD)
	}
	
	/**
	 * check whether the given type is SSD type
	 */
	def isSSD(NamedType type) {
		return getSSDType == type
	}
	
	/**
	 * Get all symbols inside the given type that are SSD type. If recursive is true
	 * then it will search for symbols inside type's parents
	 */
	def getSSDSymbols(NamedType type, boolean recursive) {
		ImlUtil.getSymbolsWithType(type, getSSDType, recursive)
	}
	/**
	 * get Motherboard type declaration
	 */
	def getMotherboardType() {
		return getType(MOTHERBOARD)
	}
	
	/**
	 * check whether the given type is Motherboard type
	 */
	def isMotherboard(NamedType type) {
		return getMotherboardType == type
	}
	
	/**
	 * Get all symbols inside the given type that are Motherboard type. If recursive is true
	 * then it will search for symbols inside type's parents
	 */
	def getMotherboardSymbols(NamedType type, boolean recursive) {
		ImlUtil.getSymbolsWithType(type, getMotherboardType, recursive)
	}
	/**
	 * get CanStore trait declaration
	 */
	def getCanStoreTrait() {
		return getTrait(CANSTORE)
	}
	
	/**
	 * check wether the given eObject refines or exhibits the CanStore trait
	 */
	def isCanStore(EObject eObject) {
		return ImlUtil.exhibitsOrRefines(eObject, getCanStoreTrait);
	}
	
	/**
	 * Get all symbols inside the given type that exhibits/refines the CanStore trait. If recursive is true
	 * then it will search for symbols inside type's parents
	 */
	def getCanStoreSymbols(NamedType type, boolean recursive) {
		ImlUtil.getSymbolsWithTrait(type, getCanStoreTrait, recursive);
	}
	
	/**
	 * Get the storage symbol declaration inside the given CanStore type. If recursive is true
	 * then it will search for symbols inside type's parents 
	 */
	def getCanStoreStorageVar() {
		return ImlUtil.findSymbol(getType(CANSTORE), CANSTORE_STORAGE_VAR, true) as SymbolDeclaration;
	}
	
	override getPackageName() {
		PACKAGE_NAME
	}
	
	/**
	 * Checks if a symbol is defined inside Pc_hardware IML library
	 */
	def isPc_hardwareSymbol(Symbol symbol) {
		if (symbol !== null) {
			val containerModel = ImlUtil.getContainerOfType(symbol, Model)
			if (containerModel.name == getPackageName()) {
				return true;
			}
		}
		return false;
	}
}
