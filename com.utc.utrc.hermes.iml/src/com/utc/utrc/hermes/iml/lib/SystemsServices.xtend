package com.utc.utrc.hermes.iml.lib

import com.google.inject.Singleton
import com.google.inject.Inject
import com.utc.utrc.hermes.iml.iml.Trait
import com.utc.utrc.hermes.iml.iml.NamedType
import com.utc.utrc.hermes.iml.util.ImlUtil
import org.eclipse.emf.ecore.EObject

@Singleton
class SystemsServices {
	@Inject
	ImlStdLib stdLib;
	
	public static final String PACKAGE_NAME = "iml.systems"
	
	public static final String PORT = "Port";
	public static final String COMPONENT = "Component";
	public static final String SYSTEM = "System";
	public static final String CONNECTOR = "Connector";
	public static final String EQUALITY_CONNECTOR = "EqualityConnector";
	public static final String CONNECT = "connect";
	public static final String CONNECT_EQUAL = "connectEqual";
	
	def getPortTrait() {
		return stdLib.getSymbol(PACKAGE_NAME, PORT, Trait)
	}
	
	def getCompoentTrait() {
		return stdLib.getSymbol(PACKAGE_NAME, COMPONENT, Trait)
	}
	
	def getSystemTrait() {
		return stdLib.getSymbol(PACKAGE_NAME, SYSTEM, Trait)
	}
	
	def isPort(EObject type) {
		return ImlUtil.exhibitsOrRefines(type, portTrait);
	}
	
	def isComponent(EObject type) {
		return ImlUtil.exhibitsOrRefines(type, compoentTrait)
	}
	
	def isSystem(EObject type) {
		return ImlUtil.exhibitsOrRefines(type, systemTrait)
	}
	
	def getPorts(NamedType type, boolean recursive) {
//		type.symbols.filter[it.isPort].toList
		ImlUtil.getSymbolsWithTrait(type, portTrait, recursive);
	}
	
	def getComponents(NamedType type, boolean recursive) {
		ImlUtil.getSymbolsWithTrait(type, compoentTrait, recursive);
	}
}