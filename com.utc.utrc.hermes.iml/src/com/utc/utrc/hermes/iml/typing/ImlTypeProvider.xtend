/*
 * Copyright (c) 2019 United Technologies Corporation. All rights reserved.
 * See License.txt in the project root directory for license information. */
package com.utc.utrc.hermes.iml.typing

import com.google.inject.Inject
import com.utc.utrc.hermes.iml.custom.ImlCustomFactory
import com.utc.utrc.hermes.iml.iml.Addition
import com.utc.utrc.hermes.iml.iml.ArrayAccess
import com.utc.utrc.hermes.iml.iml.ArrayType
import com.utc.utrc.hermes.iml.iml.AtomicExpression
import com.utc.utrc.hermes.iml.iml.CaseTermExpression
import com.utc.utrc.hermes.iml.iml.CharLiteral
import com.utc.utrc.hermes.iml.iml.DatatypeConstructor
import com.utc.utrc.hermes.iml.iml.ExpressionTail
import com.utc.utrc.hermes.iml.iml.FloatNumberLiteral
import com.utc.utrc.hermes.iml.iml.FolFormula
import com.utc.utrc.hermes.iml.iml.FunctionType
import com.utc.utrc.hermes.iml.iml.ImlFactory
import com.utc.utrc.hermes.iml.iml.ImlType
import com.utc.utrc.hermes.iml.iml.InstanceConstructor
import com.utc.utrc.hermes.iml.iml.IteTermExpression
import com.utc.utrc.hermes.iml.iml.LambdaExpression
import com.utc.utrc.hermes.iml.iml.MatchExpression
import com.utc.utrc.hermes.iml.iml.MatchStatement
import com.utc.utrc.hermes.iml.iml.Multiplication
import com.utc.utrc.hermes.iml.iml.NamedType
import com.utc.utrc.hermes.iml.iml.NumberLiteral
import com.utc.utrc.hermes.iml.iml.ParenthesizedTerm
import com.utc.utrc.hermes.iml.iml.QuantifiedFormula
import com.utc.utrc.hermes.iml.iml.RecordConstructor
import com.utc.utrc.hermes.iml.iml.RecordType
import com.utc.utrc.hermes.iml.iml.SelfTerm
import com.utc.utrc.hermes.iml.iml.SelfType
import com.utc.utrc.hermes.iml.iml.SequenceTerm
import com.utc.utrc.hermes.iml.iml.SimpleTypeReference
import com.utc.utrc.hermes.iml.iml.StringLiteral
import com.utc.utrc.hermes.iml.iml.SymbolDeclaration
import com.utc.utrc.hermes.iml.iml.SymbolReferenceTerm
import com.utc.utrc.hermes.iml.iml.TailedExpression
import com.utc.utrc.hermes.iml.iml.TermExpression
import com.utc.utrc.hermes.iml.iml.TermMemberSelection
import com.utc.utrc.hermes.iml.iml.Trait
import com.utc.utrc.hermes.iml.iml.TraitExhibition
import com.utc.utrc.hermes.iml.iml.TruthValue
import com.utc.utrc.hermes.iml.iml.TupleConstructor
import com.utc.utrc.hermes.iml.iml.TupleType
import com.utc.utrc.hermes.iml.lib.ImlStdLib
import com.utc.utrc.hermes.iml.util.ImlUtil
import org.eclipse.emf.ecore.util.EcoreUtil
import org.eclipse.xtext.EcoreUtil2

import static extension org.eclipse.xtext.EcoreUtil2.*
import com.utc.utrc.hermes.iml.iml.Model
import com.utc.utrc.hermes.iml.iml.Inclusion
import com.utc.utrc.hermes.iml.iml.Refinement

class ImlTypeProvider {
	
	@Inject
	extension ImlStdLib
	
	@Inject 
	extension TypingServices

	def ImlType termExpressionType(FolFormula t) {
		val env = new TypingEnvironment(t.getContainerOfType(NamedType))
		termExpressionType(t, env)
	}

	def ImlType termExpressionType(TermExpression t) {
		val env = new TypingEnvironment(t.getContainerOfType(NamedType))
		termExpressionType(t, env)
	}
	
	def ImlType termExpressionType(FolFormula t, TypingEnvironment env) {
		if (t instanceof TermExpression) {
			return termExpressionType((t as TermExpression), env)
		}
		if (t instanceof AtomicExpression) {
			return createBoolRef
		}
		return t.left.termExpressionType(env);
	}
	
	def ImlType termExpressionType(TermExpression t, TypingEnvironment env) {
		return normalizeType(expressionType(t, env))
	}
	

	/* Compute the type of a TermExpression 
	 * This is the most important function in the type provider. 
	 * Given a term expression, this function returns a type reference
	 * that contains stereotypes, type and type binding information
	 * for the term. 
	 * */
	def private ImlType expressionType(TermExpression t, TypingEnvironment env) {

		switch (t) {
			// If the expression is "self", then its type is 
			// type of the container type.
			SelfTerm: {
				var typeContainer = t.getContainerOfType(NamedType);
				if (typeContainer instanceof Trait && env.selfType !== null) {
					return env.selfType
				} else {
					return env.bind(ImlCustomFactory.INST.createSimpleTypeReference(typeContainer))
				}
			}
			// Additions are among numeric types and the result is a numeric 
			// type. If one of the two terms is real, then the type is real
			// otherwise it is integer.
			Addition: {
				// note that in iml grammar, addition includes both "+" and "-".
				if (t.left.termExpressionType(env).isReal ||
					t.right.termExpressionType(env).isReal) {
					return createRealRef
				}
				return createIntRef
			}
			// For reminder and modulo, the result is integer
			// For multiplication and division, the result is numeric
			// Multiplication of integers is an integer, otherwise the result
			// is a real number.
			Multiplication: {
				if (t.sign == '%' || t.sign == 'mod') {
					return createIntRef;
				}

				// note that in iml grammar, multiplication includes both "x" and "/".
				if (t.left.termExpressionType(env).isReal ||
					t.right.termExpressionType(env).isReal || t.sign == '/') {
					return createRealRef
				}
				return createIntRef;
			}
			// Compute the actual type reference which 
			// depends on the types of the change of member selections
			TermMemberSelection: {
				val receiverType = termExpressionType(t.receiver, env)
				if (receiverType instanceof SimpleTypeReference) {
					return termExpressionType(t.member, env.clone.addContext(receiverType))
				} else if (receiverType instanceof RecordType) {
					return termExpressionType(t.member, env)
				} else if (receiverType instanceof SelfType) {
					return receiverType
				} else {
					throw new IllegalArgumentException("TermMemberSelection receiver should be simple type or record type only.")	
				}
			}
			TailedExpression: {
				var leftType = termExpressionType(t.left, env)
				return accessTail(leftType, t.tail)
			}
			SymbolReferenceTerm: {
				return getSymbolReferenceType(t, env)
			}
			// A number literal is always an integer
			NumberLiteral: {
				return createIntRef;

			}
			FloatNumberLiteral: {
				return createRealRef;

			}
			StringLiteral :{
				return createStringRef;
			}
			
			CharLiteral : {
				return createCharRef;
			}
			
			IteTermExpression: {
				return termExpressionType(t.left, env)
			}
			CaseTermExpression: {
				return termExpressionType(t.expressions.get(0), env)
			}
			
			TruthValue: {
				return createBoolRef;
			}
			LambdaExpression: {
				var retval = ImlFactory.eINSTANCE.createFunctionType
				if (t.parameters !== null && t.parameters.size === 1){
					retval.domain = env.bind(t.parameters.get(0).type)
				} else {
					retval.domain = ImlCustomFactory.INST.createTupleType(t.parameters.map[env.bind(type)])
				}
				retval.range = (t.definition as SequenceTerm).^return.termExpressionType(env)
				return retval
			}
			InstanceConstructor: {
				return  env.bind(t.ref.type)
			}
			TupleConstructor: {
				return ImlFactory.eINSTANCE.createTupleType => [
					types.addAll(t.elements.map[it.termExpressionType(env)]);
				]
			}
			RecordConstructor: {
				return ImlFactory.eINSTANCE.createRecordType => [
					symbols.addAll(t.elements.map[
						ImlCustomFactory.INST.createSymbolDeclaration(it.name, it.definition.termExpressionType(env))
					])
				]
			}
			SequenceTerm: {
				return t.^return.termExpressionType(env)
			}
			ParenthesizedTerm : {
				return t.sub.termExpressionType(env)
			} 
			QuantifiedFormula : {
				return createBoolRef
			}
			MatchExpression : {
				return t.matchStatements.get(0).^return.termExpressionType(env)
			}
			default: {
				return createNullRef
			}
		}
	}
	
	def accessTail(ImlType type, ExpressionTail tail) {
		if (tail instanceof ArrayAccess) {
			if (type instanceof ArrayType) {
				return accessArray(type as ArrayType, tail as ArrayAccess)
			} else if (type instanceof TupleType) {
				return accessTuple(type as TupleType, tail as ArrayAccess)
			}
		} else if (tail instanceof TupleConstructor) { // Method invocation using Tuple
			if (type instanceof FunctionType) {
				return type.range
			}  else if (type instanceof RecordType) {
				return accessRecord(type as RecordType, tail as TupleConstructor)
			}
		} else {
			throw new IllegalArgumentException("Unknown tail type: " + tail.class)
		}
		return type
	}

	def accessArray(ArrayType type, ArrayAccess arrayAccessTail) {
		type.dimensions.remove(type.dimensions.size - 1)
		if (type.dimensions.isEmpty) {
			return type.type
		} else {
			return type
		}
	}

	def accessTuple(TupleType type, ArrayAccess arrayAccessTail) {
		val index = arrayAccessTail.index // It should be integer or symbol a[0] or a[symbolName]
		if (index.left !== null) {
			val indexAtomic = index.left
			if (indexAtomic instanceof NumberLiteral) { // Specific index
				val indexValue = indexAtomic.value * (if(indexAtomic.neg) -1 else 1)
				if (indexValue >= 0 && indexValue < type.types.size) {
					return type.types.get(indexValue)
				}
			}
		}
		return type
	}
	
	def accessRecord(RecordType type, TupleConstructor accessTail) {
		if (accessTail.elements.size === 1) {
			val element = accessTail.elements.get(0)
			if (element.left !== null) {
				val atomic = element.left
				if (atomic instanceof SymbolReferenceTerm) { // Specific symbol
					for (symbol : type.symbols) {
						if (symbol.name !== null && symbol.name == atomic.symbol.name) {
							return symbol.type
						}
					}
				}
			}
		}
			return type
	}
	
	def getSymbolReferenceType(SymbolReferenceTerm sr, TypingEnvironment env) {
		if (sr.symbol instanceof NamedType) {
			var SimpleTypeReference retType = ImlCustomFactory.INST.createSimpleTypeReference=>[type = sr.symbol as NamedType];
			retType.typeBinding.addAll(sr.typeBinding.map[it.clone])
			return env.bind(retType)
		} else if (ImlUtil.isEnumLiteral(sr.symbol)) {
			// Accessing specific literal
			return env.bind(ImlCustomFactory.INST.createSimpleTypeReference(sr.symbol.getContainerOfType(NamedType)))
		} else if (sr.symbol.eContainer instanceof MatchStatement && 
					(sr.symbol.eContainer as MatchStatement).paramSymbols.contains(sr.symbol)) { // Datatype constructor symbol
			val matchStatment = sr.symbol.eContainer as MatchStatement
			val constructor = matchStatment.constructor
			val symbolType = constructor.parameters.get(matchStatment.paramSymbols.indexOf(sr.symbol))
			return env.bind(symbolType)
		} else if(sr.symbol instanceof DatatypeConstructor) {
			return env.typeContext
		}  else {
			// Reference to a symbol declaration
			return getSymbolType(sr, env);
		}
	}
	
	def ImlType getSymbolType(SymbolDeclaration s) {
		return getSymbolType(s, new TypingEnvironment(s.getContainerOfType(NamedType)))		
	}

	def ImlType getSymbolType(SymbolDeclaration s, TypingEnvironment env) {
		return getSymbolReferenceType(ImlCustomFactory.INST.createSymbolReferenceTerm(s), env)
	}

	def ImlType getSymbolType(SymbolReferenceTerm symbolRef, TypingEnvironment env) {
		if (symbolRef.symbol instanceof SymbolDeclaration) {
			if ((symbolRef.symbol.eContainer instanceof Model) || isSymbolLocalScope(symbolRef.symbol as SymbolDeclaration) || 
				(env.typeContext !== null && env.typeContext.type.symbols.contains(symbolRef.symbol as SymbolDeclaration))) {
				return env.bind(symbolRef)
			} else {
				// Collect related types from relations
				val relatedTypes = newArrayList
				for (rel : env.typeContext.type.relations) {
					switch (rel) {
						Inclusion: {
							for (twp : rel.inclusions) {
								relatedTypes.add(twp.type)
							}
						}
						Refinement: {
							for (twp : rel.refinements) {
								relatedTypes.add(twp.type)
							}
						}
						TraitExhibition: {
							for (twp : rel.exhibitions) {
								relatedTypes.add(twp.type)
							}
						}
					}
				}
				// Check if symbol referenced from one of the related types
				for (target : relatedTypes) {
					if (target instanceof SimpleTypeReference) {
						var sup = env.bind(target) as SimpleTypeReference
						var retval = getSymbolType(symbolRef, env.addContext(sup));
						if (retval !== null) {
							return retval;
						}
					}
				}
			}
		}
		
		return null;
	}
	
	def isSymbolLocalScope(SymbolDeclaration symbol) {
		val container = symbol.eContainer
		if (container instanceof RecordType || container instanceof QuantifiedFormula || container instanceof LambdaExpression
			|| container instanceof InstanceConstructor || container instanceof SequenceTerm
		) {
			return true
		}
		return false
	}
		
}
