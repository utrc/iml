package com.utc.utrc.hermes.iml.lib

import com.google.inject.Inject
import com.utc.utrc.hermes.iml.iml.NamedType
import com.utc.utrc.hermes.iml.util.ImlUtil
import com.utc.utrc.hermes.iml.iml.Trait
import com.utc.utrc.hermes.iml.iml.Symbol
import com.utc.utrc.hermes.iml.iml.Annotation
import com.utc.utrc.hermes.iml.iml.SymbolDeclaration
import org.eclipse.emf.ecore.EObject
import java.util.List

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
	
	def equalOrSameQn(EObject o1, EObject o2) {
		return o1 == o2 || (o2 !== null && o2 !== null && stdLib.getFqn(o1) == stdLib.getFqn(o2)) 
	}
	
	def containsSameQn(List items, EObject toCheck) {
		for (item : items) {
			if (item instanceof EObject && (item as EObject).equalOrSameQn(toCheck)) {
				return true;
			}
		}
		return false
	}
}