package com.utc.utrc.hermes.iml.custom

import com.utc.utrc.hermes.iml.iml.impl.ImlFactoryImpl
import com.utc.utrc.hermes.iml.iml.TermMemberSelection
import com.utc.utrc.hermes.iml.iml.SymbolDeclaration
import com.utc.utrc.hermes.iml.iml.FolFormula
import com.utc.utrc.hermes.iml.iml.TermExpression
import com.utc.utrc.hermes.iml.iml.ConstrainedType
import com.utc.utrc.hermes.iml.iml.RelationKind
import com.utc.utrc.hermes.iml.iml.SimpleTypeReference
import com.utc.utrc.hermes.iml.iml.Symbol
import java.util.List

public class ImlCustomFactory extends ImlFactoryImpl {
	
	public static ImlCustomFactory INST = new ImlCustomFactory();
	
	def createSymbolReferenceTerm(SymbolDeclaration symbol) {
		createSymbolReferenceTerm => [
			it.symbol = symbol;
		]
	}
	
	def createTermMemberSelection(SymbolDeclaration receiver, SymbolDeclaration member) {
		createTermMemberSelection(createSymbolReferenceTerm(receiver), member);
	}

	def createTermMemberSelection(TermExpression receiver, SymbolDeclaration member) {
		createTermMemberSelection => [
			it.receiver = receiver;
			it.member = createSymbolReferenceTerm(member);
		]
	}

	def createTruthValue(boolean value) {
		createTruthValue => [
			if (value) it.TRUE = true else it.FALSE = true;
		]
	}
	
	def createAndExpression(FolFormula left, FolFormula right) {
		createAndExpression => [
			it.left = left;
			it.right = right;
			it.op = "&&"; // FIXME is there an enum better to use?
		]
	}
	def createOrExpression(FolFormula left, FolFormula right) {
		createAndExpression => [
			it.left = left;
			it.right = right;
			it.op = "||"; // FIXME is there an enum better to use?
		]
	}
	
	def createFolFormula(FolFormula left, String op, FolFormula right) {
		createFolFormula => [
			it.left = left;
			it.op = op;
			it.right = right;
		]
	}
	
	def createSymbolDeclaration(ConstrainedType type, String name) {
		createSymbolDeclaration => [
			it.type = createSimpleTypeReference(type)
			it.name = name
		]
	}
	
	def createSimpleTypeReference(ConstrainedType type) {
		createSimpleTypeReference => [
			it.type = type
		]
	}
	
	def createPackage(String name) {
		createModel => [ it.name = name]
	}
	
	def createImport(String qname) {
		createImport() => [it.importedNamespace = qname]	
	}
	
	def createNamedType(String name){
		createConstrainedType() => [it.name = name]
	}
	
	
	def createAtomicExpression(TermExpression left, RelationKind rel, TermExpression right){
		createAtomicExpression() => [
			it.left=left
			it.rel = rel 
			it.right = right;
		] ;
	}
	
	def createAnnotationProperty(ConstrainedType t) {
		createProperty() => [
			it.ref = createSimpleTypeReference(t)
		]
	}
	
	def createTypeWithProperties(ConstrainedType t) {
		createTypeWithProperties() => [
			it.type = createSimpleTypeReference(t)
		]
	}
	
	def createSymbolReferenceTerm(SimpleTypeReference bind, Symbol s, List<TermExpression> args ){
		var retval = createSymbolReferenceTerm;
		retval.symbol = s
		retval.typeBinding.add(bind)
		var tail = createTupleConstructor;
		for(te : args){
			var f = createSignedAtomicFormula
			f.left = te
			tail.elements.add(f)
		}
		retval.tails.add(tail)
		retval
	}
	
	
}