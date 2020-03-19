/*
 * Copyright (c) 2019 United Technologies Corporation. All rights reserved.
 * See License.txt in the project root directory for license information. */
package com.utc.utrc.hermes.iml.custom

import com.utc.utrc.hermes.iml.iml.impl.ImlFactoryImpl
import com.utc.utrc.hermes.iml.iml.SymbolDeclaration
import com.utc.utrc.hermes.iml.iml.FolFormula
import com.utc.utrc.hermes.iml.iml.TermExpression
import com.utc.utrc.hermes.iml.iml.RelationKind
import com.utc.utrc.hermes.iml.iml.SimpleTypeReference
import com.utc.utrc.hermes.iml.iml.Symbol
import java.util.List
import com.utc.utrc.hermes.iml.iml.SymbolReferenceTerm
import com.utc.utrc.hermes.iml.iml.NamedType
import com.utc.utrc.hermes.iml.iml.ImlType
import com.utc.utrc.hermes.iml.iml.ExpressionTail
import com.utc.utrc.hermes.iml.iml.OptionalTermExpr
import com.utc.utrc.hermes.iml.iml.TermMemberSelection
import java.math.BigInteger
import java.math.BigDecimal

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
		createTermMemberSelection(receiver, createSymbolReferenceTerm(member))
	}
	
	def TermMemberSelection createTermMemberSelection(TermExpression receiver, TermExpression member) {
		if (member instanceof SymbolReferenceTerm) {
			return createTermMemberSelection(receiver, member as SymbolReferenceTerm);
		} else if (member instanceof TermMemberSelection) {
			return createTermMemberSelection(createTermMemberSelection(receiver, member.receiver), member.member);
		} else {
			throw new IllegalArgumentException("Creating TermMemberSelection with member other than simple TermMemberSelection!");
		}
	}

	def createTermMemberSelection(TermExpression receiver, SymbolReferenceTerm member) {
		createTermMemberSelection => [
			it.receiver = receiver;
			it.member = member;
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
		createOrExpression => [
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
	
	def createSymbolDeclaration(NamedType type, String name) {
		createSymbolDeclaration => [
			it.type = createSimpleTypeReference(type)
			it.name = name
		]
	}

	//TODO: Delete this function to refactor the call in other files
 	def SimpleTypeReference createSimpleTypeReference(NamedType type) {
		createSimpleTypeReference(type, true)
	}
	
	def SimpleTypeReference createSimpleTypeReference(NamedType type, Boolean inheritBinding) {
		createSimpleTypeReference => [
			it.type = type
			if (inheritBinding)
				it.typeBinding.addAll(type.typeParameter.map[createSimpleTypeReference(it, inheritBinding)])
		]
	}
	
	def createPackage(String name) {
		createModel => [ it.name = name]
	}
	
	def createImport(String qname) {
		createImport() => [it.importedNamespace = qname]	
	}
	
	def createNamedType(String name){
		createNamedType() => [it.name = name]
	}
	
	
	def createAtomicExpression(TermExpression left, RelationKind rel, TermExpression right){
		createAtomicExpression() => [
			it.left=left
			it.rel = rel 
			it.right = right;
		] ;
	}
	
	def createAnnotationProperty(NamedType t) {
		createProperty() => [
			it.ref = createSimpleTypeReference(t)
		]
	}
	
	def createTypeWithProperties(NamedType t) {
		createTypeWithProperties() => [
			it.type = createSimpleTypeReference(t)
		]
	}
	
	def createSymbolReferenceTerm(SimpleTypeReference bind, Symbol s, List<TermExpression> args ){
		var retval = createSymbolReferenceTerm;
		retval.symbol = s
		retval.typeBinding.add(bind)
		createTailedExpression(retval, args)
	}
	
	def createTailedExpression(TermExpression left, ExpressionTail tail) {
		createTailedExpression => [
			it.left = left
			it.tail = tail
		]
	}
	
	def createTailedExpression(TermExpression left, List<TermExpression> args) {
		val retval = createTailedExpression
		retval.left = left
		var tail = createTupleConstructor;
		for(te : args){
			var f = createSignedAtomicFormula
			f.left = te
			tail.elements.add(f)
		}
		retval.tail = tail
		return retval
	}
	
	def createProperty(NamedType propertyType) {
		createProperty => [
			ref = createSimpleTypeReference(propertyType);
		]
	} 
	
	def createPropertyList(List<com.utc.utrc.hermes.iml.iml.Property> properties) {
		createPropertyList => [
			it.properties.addAll(properties);
		]
	}
	
	def createSymbolDeclaration(String name) {
		createSymbolDeclaration => [
			it.name = name;
		]
	}
	
	def createInclusion(NamedType  extendedType) {
		createInclusion => [
			inclusions.add(createTypeWithProperties(extendedType))
		]
	}
	
	def createSignedAtomicFormula(boolean neg, FolFormula left) {
		createSignedAtomicFormula => [
			it.neg = neg
			it.left = left;
		]
	}
	
	def createQuantifiedFormula(String op, List<SymbolDeclaration> scope, FolFormula left) {
		createQuantifiedFormula => [
			it.op = op;
			it.scope += scope;
			it.left = createSequenceTerm(left);
		]
	}
	
	def createSequenceTerm(FolFormula returnFormula) {
		createSequenceTerm => [
			^return = returnFormula
		]
	}
	
	def createAddition(TermExpression left, String sign, TermExpression right) {
		createAddition => [
			it.left = left
			it.sign = sign
			it.right = right
		]
	}
	
	def createMultiplication(TermExpression left, String sign, TermExpression right) {
		createMultiplication => [
			it.left = left
			it.sign = sign
			it.right = right
		]
	}
	
	def createNumberLiteral(boolean neg, int value) {
		createNumberLiteral => [
			it.value = BigInteger.valueOf(value * (if (neg) -1 else 1))
		]
	}
	
	def createNumberLiteral(int value) {
		createNumberLiteral => [
			it.value = BigInteger.valueOf(value)
		]
	}
	
	def createNumberLiteral(BigInteger value) {
		createNumberLiteral => [
			it.value = value
		]
	}
	
	def createNumberLiteral(String value) {
		createNumberLiteral => [
			it.value = new BigInteger(value)
		]
	}
	
	def createFloatNumberLiteral(boolean neg, float value) {
		createFloatNumberLiteral => [
			it.value = BigDecimal.valueOf(value * (if (neg) -1 else 1))
		]
	}
	
	def createFloatNumberLiteral(float value) {
		createFloatNumberLiteral => [
			it.value = BigDecimal.valueOf(value)
		]
	}
	
	def createFloatNumberLiteral(BigDecimal value) {
		createFloatNumberLiteral => [
			it.value = value
		]
	}
	
	def createFloatNumberLiteral(String value) {
		createFloatNumberLiteral => [
			it.value = new BigDecimal(value)
		]
	}
	
	def createTupleConstructor(List<FolFormula> elements) {
		createTupleConstructor => [
			it.elements += elements
		]
	}
	
	def createArrayAccess(FolFormula index) {
		createArrayAccess => [
			it.index = index
		]
	}
	
	def createParenthesizedTerm(FolFormula subFormula) {
		createParenthesizedTerm => [
			it.sub = subFormula
		]
	}
	
	def createIteTermExpression(FolFormula condition, FolFormula left, FolFormula right) {
		createIteTermExpression => [
			it.condition = condition
			it.left = createSequenceTerm(left)
			if (right !== null) {
				it.right = createSequenceTerm(right)
			}
		]
	}
	
	def createTupleType(List<ImlType> types) {
		createTupleType => [
			it.types.addAll(types)
		]
	}
	
	def createSymbolDeclaration(String name, ImlType type) {
		createSymbolDeclaration => [
			it.name = name
			it.type = type
		]
	}
	
	def createArrayType(ImlType type, List<OptionalTermExpr> dim) {
		createArrayType =>[
			it.type = type
			it.dimensions.addAll(dim)
		]
	}
	
}