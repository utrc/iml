package com.utc.utrc.hermes.iml.example.validator

import com.utc.utrc.hermes.iml.validation.AbstractImlValidator
import org.eclipse.xtext.naming.IQualifiedNameProvider
import com.google.inject.Inject
import com.utc.utrc.hermes.iml.lib.ImlStdLib
import org.eclipse.xtext.validation.Check
import com.utc.utrc.hermes.iml.iml.NamedType
import com.utc.utrc.hermes.iml.example.PcHardwareServices
import com.utc.utrc.hermes.iml.iml.Assertion
import com.utc.utrc.hermes.iml.util.SymbolExtractor
import com.utc.utrc.hermes.iml.iml.Symbol
import java.util.ArrayList
import com.utc.utrc.hermes.iml.iml.ImlPackage
import com.utc.utrc.hermes.iml.iml.SymbolDeclaration
import java.util.HashSet

class ExampleValidator extends AbstractImlValidator {
	
	public static val UNDEFINED_SYMBOL_ERROR = 'com.utc.utrc.hermes.iml.example.validation.UndefinedSymbolError'
	
	
	@Inject IQualifiedNameProvider qnp ;
	
	@Inject ImlStdLib stdLib
	
	@Inject PcHardwareServices pcServices
	
	@Check
	def checkMonitorShouldHaveResolutionAndSizeSet(NamedType e) {
		if (pcServices.isMonitor(e)) {
			val usedSymbols = getUsedSymbols(e);
			usedSymbols.addAll(getUsedSymbols(pcServices.monitorTrait))
			for (symbol : pcServices.monitorTrait.symbols) {
				if (symbol instanceof SymbolDeclaration && symbol.name !== null && 
					symbol.definition === null && !usedSymbols.contains(symbol)
				) {
					error('''Symbol '«symbol.name»' is not defined anywhere. Please constrain the symbol inside an assertion or a formula'''
						, ImlPackage::eINSTANCE.symbol_Name, UNDEFINED_SYMBOL_ERROR
					)
				}
			}
		}
	}
	
	def getUsedSymbols(NamedType type) {
		val usedSymbols = new HashSet<Symbol>()
		for (symbol : type.symbols) {
			if (symbol instanceof Assertion) {
				val symbols = SymbolExtractor.extractFrom(symbol.definition, stdLib);
				usedSymbols.addAll(symbols);
			}
		}
		return usedSymbols
	}
	
}