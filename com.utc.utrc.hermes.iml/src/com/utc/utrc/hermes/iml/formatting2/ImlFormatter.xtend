/*
 * generated by Xtext 2.12.0
 */
package com.utc.utrc.hermes.iml.formatting2

import com.google.inject.Inject
import com.utc.utrc.hermes.iml.iml.Model
import com.utc.utrc.hermes.iml.iml.Symbol
import com.utc.utrc.hermes.iml.services.ImlGrammarAccess
import org.eclipse.xtext.formatting2.AbstractFormatter2
import org.eclipse.xtext.formatting2.IFormattableDocument
import com.utc.utrc.hermes.iml.iml.NamedType

class ImlFormatter extends AbstractFormatter2 {
	
	@Inject extension ImlGrammarAccess
	
	def dispatch void format(Model model, extension IFormattableDocument document) {
		// TODO: format HiddenRegions around keywords, attributes, cross references, etc. 
//		for (Import _import : model.getImports()) {
//			_import.format;
//			_import.append[newLine]
//		}
		for (Symbol element : model.symbols) {
			element.format;
			element.append[newLine]
		}
		model.allRegionsFor.keywords(";").forEach[it.append[newLine]]
	}

	def dispatch void format(NamedType constrainedType, extension IFormattableDocument document) {
		constrainedType.regionFor.keyword("{").append[newLine]
		constrainedType.regionFor.keyword("}").prepend[newLine].append[newLine]
		interior(
			constrainedType.regionFor.keyword(("{")), 
			constrainedType.regionFor.keyword(("}"))
		)[indent]
	}
	
	// TODO: implement for Alias, MetaRelaion, PropertyList, ConstrainedType, SymbolDeclaration, HigherOrderType, ArrayType, OptionalTermExpr, TupleType, SimpleTypeReference, FolFormula, OrExpression, AndExpression, SignedAtomicFormula, AtomicExpression, Addition, Multiplication, TermMemberSelection, LambdaExpression, TypeConstructor, TupleConstructor, SymbolReferenceTerm, ArrayAccess, IteTermExpression, Program
}
