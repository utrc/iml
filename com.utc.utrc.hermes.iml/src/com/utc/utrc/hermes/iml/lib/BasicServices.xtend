package com.utc.utrc.hermes.iml.lib

import com.google.inject.Inject
import com.utc.utrc.hermes.iml.iml.NamedType
import com.utc.utrc.hermes.iml.util.ImlUtil
import com.utc.utrc.hermes.iml.iml.Trait
import com.utc.utrc.hermes.iml.iml.Symbol
import com.utc.utrc.hermes.iml.iml.Annotation
import com.utc.utrc.hermes.iml.iml.SymbolDeclaration

// WIP FIXME we need to make other services extend this one and refactor accordingly
abstract class BasicServices {
	@Inject
	ImlStdLib stdLib;
	
	def String getPackageName();
	
	def findSymbol(NamedType type, String symbolName, boolean recursive) {
		return ImlUtil.findSymbol(type, symbolName, recursive)
	}
		
	def getTrait(String traitName) {
		return getDeclaredSymbol(traitName, Trait)
	}
	
	def getType(String typeName) {
		return getDeclaredSymbol(typeName, NamedType)
	}
	
	def getAnnotation(String annotName) {
		return getDeclaredSymbol(annotName, Annotation)
	}
	
	def getSymbolDeclaration(String symbolName) {
		return getDeclaredSymbol(symbolName, SymbolDeclaration)
	}
	
	def private <T extends Symbol> getDeclaredSymbol(String symbolName, Class<T> symbolClass) {
		return stdLib.getSymbol(packageName, symbolName, symbolClass)
	}
}