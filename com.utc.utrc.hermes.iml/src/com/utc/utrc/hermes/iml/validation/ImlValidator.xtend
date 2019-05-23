/*
 * Copyright (c) 2019 United Technologies Corporation. All rights reserved.
 * See License.txt in the project root directory for license information. */
/*
 * generated by Xtext 2.9.1
 */
package com.utc.utrc.hermes.iml.validation

import com.google.inject.Inject
import com.utc.utrc.hermes.iml.iml.Assertion
import com.utc.utrc.hermes.iml.iml.AtomicExpression
import com.utc.utrc.hermes.iml.iml.NamedType
import com.utc.utrc.hermes.iml.iml.Extension
import com.utc.utrc.hermes.iml.iml.FolFormula
import com.utc.utrc.hermes.iml.iml.ImlType
import com.utc.utrc.hermes.iml.iml.ImlPackage
import com.utc.utrc.hermes.iml.iml.Multiplication
import com.utc.utrc.hermes.iml.iml.SequenceTerm
import com.utc.utrc.hermes.iml.iml.SimpleTypeReference
import com.utc.utrc.hermes.iml.iml.Symbol
import com.utc.utrc.hermes.iml.iml.SymbolDeclaration
import com.utc.utrc.hermes.iml.iml.SymbolReferenceTerm
import com.utc.utrc.hermes.iml.typing.ImlTypeProvider
import com.utc.utrc.hermes.iml.typing.TypingServices
import java.util.ArrayList
import java.util.List
import org.eclipse.core.runtime.Platform
import org.eclipse.emf.ecore.EPackage
import org.eclipse.xtext.validation.AbstractDeclarativeValidator
import org.eclipse.xtext.validation.Check
import org.eclipse.xtext.validation.EValidatorRegistrar

import static extension com.utc.utrc.hermes.iml.util.ImlUtil.*

import com.utc.utrc.hermes.iml.iml.Alias
import org.eclipse.xtext.EcoreUtil2
import com.utc.utrc.hermes.iml.iml.ArrayType
import com.utc.utrc.hermes.iml.iml.ArrayAccess
import com.utc.utrc.hermes.iml.iml.TupleConstructor
import com.utc.utrc.hermes.iml.iml.TupleType
import com.utc.utrc.hermes.iml.iml.NumberLiteral
import org.eclipse.xtext.naming.IQualifiedNameProvider
import com.utc.utrc.hermes.iml.iml.QuantifiedFormula
import com.utc.utrc.hermes.iml.util.ImlUtil
import com.utc.utrc.hermes.iml.iml.SignedAtomicFormula
import com.utc.utrc.hermes.iml.iml.RelationKind
import com.utc.utrc.hermes.iml.iml.CardinalityRestriction
import com.utc.utrc.hermes.iml.iml.TailedExpression
import com.utc.utrc.hermes.iml.iml.FunctionType
import com.utc.utrc.hermes.iml.iml.ExpressionTail
import com.utc.utrc.hermes.iml.lib.ImlStdLib
import com.utc.utrc.hermes.iml.iml.RecordType
import com.utc.utrc.hermes.iml.iml.Datatype
import com.utc.utrc.hermes.iml.iml.MatchExpression
import com.utc.utrc.hermes.iml.iml.MatchStatement
import com.utc.utrc.hermes.iml.iml.TermMemberSelection
import com.utc.utrc.hermes.iml.iml.DatatypeConstructor
import com.utc.utrc.hermes.iml.typing.TypingEnvironment

/**
 * This class contains custom validation rules. 
 * 
 * See https://www.eclipse.org/Xtext/documentation/303_runtime_concepts.html#validation
 */
class ImlValidator extends AbstractImlValidator {
	
	@Inject IQualifiedNameProvider qnp ;
	
	@Inject extension ImlTypeProvider
	
	@Inject extension TypingServices
	
	@Inject extension ImlStdLib

	static final String DOMAIN_EXTENSION_ID = "com.utc.utrc.hermes.iml.validation.domaindefinition";
	// FIXME these constants need to be moved to another class and their names and usage need to be reviewed
	public static val INVALID_PARAMETER_LIST = 'com.utc.utrc.hermes.iml.validation.InvalidParameterList'
	public static val METHOD_INVOCATION_ON_VARIABLE = 'com.utc.utrc.hermes.iml.validation.MethodInvocationOnVariable'
	public static val METHOD_INVOCATION_ON_ASSERTION= 'com.utc.utrc.hermes.iml.validation.MethodInvocationOnAssertion'
	public static val METHOD_INVOCATION_ON_NAMEDTYPE= 'com.utc.utrc.hermes.iml.validation.MethodInvocationOnNamedType'
	public static val METHOD_INVOCATION_ON_ARRAY = 'com.utc.utrc.hermes.iml.validation.MethodInvocationOnArray'
	public static val METHOD_INVOCATION_ON_TUPLE = 'com.utc.utrc.hermes.iml.validation.MethodInvocationOnTuple'
	public static val METHOD_INVOCATION_ON_RECORD = 'com.utc.utrc.hermes.iml.validation.MethodInvocationOnRecord'
	public static val MISSING_METHOD_INVOCATION = 'com.utc.utrc.hermes.iml.validation.MissingMethodInvocation'
	public static val TYPE_MISMATCH_IN_TERM_EXPRESSION = 'com.utc.utrc.hermes.iml.validation.TypeMismatchInTermExpression'
	public static val TYPE_MISMATCH_IN_TERM_RELATION = 'com.utc.utrc.hermes.iml.validation.TypeMismatchInTermRelation'
	public static val INVALID_STEREOTYPE_HIERARCHY = 'com.utc.utrc.hermes.iml.validation.InvalidStereotypeHierarchy'
	public static val CYCLIC_NAMEDTYPE_HIERARCHY = 'com.utc.utrc.hermes.iml.validation.CyclicNamedTypeHierarchy'
	public static val DUPLICATE_ELEMENT = 'com.utc.utrc.hermes.iml.validation.DuplicateElement'
	public static val INVALID_STEREOTYPE = 'com.utc.utrc.hermes.iml.validation.InvalidStereotype';
	public static val ELEMENTS_IN_STATIC_TYPES = 'com.utc.utrc.hermes.iml.validation.ElementsInStaticTypes';
	public static val INVALID_TYPE_PARAMETER = 'com.utc.utrc.hermes.iml.validation.InvalidTypeParameter';
	public static val INVALID_TYPE_DECLARATION = 'com.utc.utrc.hermes.iml.validation.InvalidTypeDeclaration';
	public static val INVALID_ELEMENT = 'com.utc.utrc.hermes.iml.validation.InvalidElement';
	public static val INVALID_RELATION = 'com.utc.utrc.hermes.iml.validation.InvalidRelation';
	public static val INVALID_SYMBOL_DECLARATION = 'com.utc.utrc.hermes.iml.validation.InvalidSymbolDeclaration';
	public static val INVALID_INDEX_ACCESS = 'com.utc.utrc.hermes.iml.validation.InvalidIndexAccess';
	public static val ARRAY_ACCESS_ON_FUNCTIONTYPE = 'com.utc.utrc.hermes.iml.validation.ArrayAccessOnFunctionType';
	public static val INCOMPATIBLE_TYPES = 'com.utc.utrc.hermes.iml.validation.IncompatibleTypes';
	public static val INVALID_RECORD_ACCESS = 'com.utc.utrc.hermes.iml.validation.InvalidRecordAccess'
	public static val MATCH_NOT_DATATYPE = 'com.utc.utrc.hermes.iml.validation.MatchNotDatatype'
	
	@Inject
	override void register(EValidatorRegistrar registrar) {
	
  		val registry = Platform.getExtensionRegistry();
  		if (registry !== null) {
	   		val extensions = registry.getConfigurationElementsFor(DOMAIN_EXTENSION_ID);
			val packages = getEPackages();
			if (packages.size()==0) {
				throw new IllegalStateException("No EPackages were registered for the validator "+getClass().getName()+" please override and implement getEPackages().");
			}
			for (EPackage ePackage : packages) {
				registrar.register(ePackage, this);
			}
			for (ext : extensions) {
				val p = ext.createExecutableExtension("class") as AbstractDeclarativeValidator;
				for (EPackage ePackage : packages) {
					registrar.register(ePackage, p);
				}
			};
		
		} else {
			super.register(registrar);
		}		
	}


	@Check
	def checkNoDuplicateElement(Symbol e) {
		if (e.eContainer.eContents.filter(Symbol).exists[it != e && it.name !== null && it.name == e.name])
			error("Duplicate term symbol '" + e.name + "'", ImlPackage::eINSTANCE.symbol_Name, DUPLICATE_ELEMENT)
	}

	@Check
	def checkExtension(NamedType t) {
		val extensions = t.relations.filter[it instanceof Extension].map[it as Extension]
		if (t.numeric) {
			if (extensions.size > 1) {
				error('''If a type is extending a primitive numeric type, then it cannot extend any other type''',
					ImlPackage::eINSTANCE.symbol_Name, INVALID_TYPE_DECLARATION);
			}
			if (t.template) {
				error('''If a type is extending a primitive numeric type, then it cannot be generic''',
					ImlPackage::eINSTANCE.symbol_Name, INVALID_TYPE_DECLARATION);
			}
		}
	}
	
	@Check
	def checkExtendsRelation(Extension extendRelation) {
		extendRelation.extensions.forEach[
			if (! (it.type instanceof SimpleTypeReference)) {
				error("Types can extend only simple types", 
					ImlPackage::eINSTANCE.extension_Extensions, INVALID_RELATION)
			}
		]
	}

	@Check
	def checkNoCycleInNamedTypeHierarchy(NamedType nt) {
		val extensions = getExtensions(nt) 
		if (extensions.empty)
			return
		val visited = <NamedType>newArrayList()
		val superTypeHierarchy = new ArrayList<List<NamedType>>()
		superTypeHierarchy.add(new ArrayList<NamedType>())
		superTypeHierarchy.get(0).add(nt)
		var index = 0
		while (superTypeHierarchy.get(index).size() > 0) {
			val toAdd = <NamedType>newArrayList()
			for (cur : superTypeHierarchy.get(index)) {
				for (supType : getExtensions(cur)) {
					for(tr : supType.extensions){
						if (!visited.contains(tr.type.asSimpleTR.type))
							toAdd.add(tr.type.asSimpleTR.type)
						else {
							error(
								"Cycle in hierarchy of constrained type '" + cur.name + "'",
								ImlPackage::eINSTANCE.namedType_Relations,
								CYCLIC_NAMEDTYPE_HIERARCHY
							)
						}
					}
				}
				visited.add(cur)
			}
			if (toAdd.size() > 0) {
				superTypeHierarchy.add(toAdd)
				index = index + 1
			} else
				return
		}
		return
	}
	
	def getExtensions(NamedType type) {
		type.relations.filter[it instanceof Extension].map[it as Extension]
	}

	@Check
	def checkQuantifiedFormula(FolFormula f) {
		if (f instanceof QuantifiedFormula) {
			var exprtr = f.left.termExpressionType
			if (!exprtr.isBool) {
				error('''The expression inside a quantified formula should be Boolean, got «ImlUtil.getTypeName(exprtr, qnp)»  instead''',
					ImlPackage::eINSTANCE.folFormula_Left, INVALID_TYPE_PARAMETER)
			}
		}
	}

	@Check
	def checkFolFormula(FolFormula f) {
		if (f.op !== null) {
			if (f.op.equals("=>") || f.op.equals("<=>") || f.op.equals("||") || f.op.equals("&&")) {
				var exprtr = f.left.termExpressionType
				if (!exprtr.isBool) {
					error('''The left hand side should be Boolean, got «ImlUtil.getTypeName(exprtr, qnp)»  instead''',
						ImlPackage::eINSTANCE.folFormula_Left, INVALID_TYPE_PARAMETER)
				}
				exprtr = f.right.termExpressionType
				if (!exprtr.isBool) {
					error('''The right hand side should be Boolean, got «ImlUtil.getTypeName(exprtr, qnp)»  instead''',
						ImlPackage::eINSTANCE.folFormula_Right, INVALID_TYPE_PARAMETER)
				}
			}
		} else if (f instanceof SignedAtomicFormula && (f as SignedAtomicFormula).neg) {
			var exprtr = f.left.termExpressionType
			if (!exprtr.isBool) {
				error('''The ! operator can be only  applied to a Boolean expression, got «ImlUtil.getTypeName(exprtr, qnp)»  instead''',
					ImlPackage::eINSTANCE.folFormula_Left, INVALID_TYPE_PARAMETER)
			}
		}
	}

	@Check
	def checkAtomicExpression(AtomicExpression e) {
		if (e.rel == RelationKind.EQ || e.rel == RelationKind.NEQ) {
			var rt = e.right.termExpressionType
			var lt = e.left.termExpressionType
			if (! rt.isCompatible(lt) || ! lt.isCompatible(rt)) {
				error('''Type «ImlUtil.getTypeName(lt, qnp)» and «ImlUtil.getTypeName(rt, qnp)» are not compatible''',
					ImlPackage::eINSTANCE.atomicExpression_Rel, INCOMPATIBLE_TYPES)
			}
		} else {
			var rt = e.right.termExpressionType
			var lt = e.left.termExpressionType
			if (! (rt.isNumeric && lt.isNumeric)) {
				error('''Both sides must be numeric but got left type of: «ImlUtil.getTypeName(lt, qnp)» 
				and right type of: «ImlUtil.getTypeName(rt, qnp)»''', ImlPackage::eINSTANCE.atomicExpression_Rel,
					INVALID_TYPE_PARAMETER)
			}
		}
	}

	@Check
	def checkTailedExpression(TailedExpression expr) {
		val leftType = normalizeType(termExpressionType(expr.left))
		checkTypeAgainstTail(leftType, expr.tail)
	}
	
	def boolean isFinite(NamedType type) {
		type.restrictions.filter[it instanceof CardinalityRestriction].size > 0
	}
	
	def checkTypeAgainstTail(ImlType type, ExpressionTail tail) {
		val typeAsString = getTypeName(type, qnp)
		if (type instanceof SimpleTypeReference) {
			// Tail might be applied to NamedType or a SymbolReference
			if ((tail.eContainer as TailedExpression).left instanceof SymbolReferenceTerm) {
				val symbol = ((tail.eContainer as TailedExpression).left as SymbolReferenceTerm).symbol
				// FIXME check for the correct finite access
				if (!(symbol instanceof NamedType && (symbol as NamedType).isFinite)) {
					error('''Method invocation and array access are not applicable on the simple type '«typeAsString»' ''',
						ImlPackage.eINSTANCE.tailedExpression_Tail,
						METHOD_INVOCATION_ON_NAMEDTYPE
					)
				}
			}
			
			return false				
		} else if (type instanceof ArrayType) {
			if (tail instanceof TupleConstructor) {
				error('''Method invocation is not applicable over Array type '«typeAsString»' ''',
					ImlPackage.eINSTANCE.tailedExpression_Tail,
					METHOD_INVOCATION_ON_ARRAY
				)
				return false
			}
		} else if (type instanceof TupleType) {
			if (tail instanceof TupleConstructor) {
				error('''Method invocation is not applicable over Tuple type '«typeAsString»' ''',
					ImlPackage.eINSTANCE.tailedExpression_Tail,
					METHOD_INVOCATION_ON_TUPLE
				)
				return false
			} else if (tail instanceof ArrayAccess) { 
				val index = tail.index.left
				if (index instanceof NumberLiteral) {
					if (index.value >= type.types.size || index.neg) {
						error('''Tuple access index must be within the declared tuple elements size of '«typeAsString»
						'. Expected <«type.types.size» but got «if (index.neg) '-'»«index.value» ''',
							ImlPackage.eINSTANCE.tailedExpression_Tail,
							INVALID_INDEX_ACCESS
						)
						return false
					}
				}
			}
		} else if (type instanceof RecordType) {
			error('''Method invocation and array access are not applicable on the record type '«typeAsString»' ''',
						ImlPackage.eINSTANCE.tailedExpression_Tail,
						METHOD_INVOCATION_ON_RECORD
					)
		} else if (type instanceof FunctionType) { 
			if (tail instanceof ArrayAccess) {
				error('''Array access is not applicatble over Higher Order Type of: '«typeAsString»' ''',
							ImlPackage.eINSTANCE.tailedExpression_Tail,
							ARRAY_ACCESS_ON_FUNCTIONTYPE
						)
				return false
			} else if (tail instanceof TupleConstructor) {
				return checkFunctionCallParameters(type.domain, tail as TupleConstructor)
			}
		}
		return true
	}
	
	def checkFunctionCallParameters(ImlType domain, TupleConstructor tupleTail) {
		var List<ImlType> domainList = null;
		if (domain instanceof TupleType) {
			domainList = domain.types
		} else if (domain instanceof RecordType) {
			domainList = domain.symbols.map[type]
		} else {
			domainList = newArrayList(domain)
		}
		
		if (tupleTail.elements.size == 1) { // Special case to handle alias
			if (isCompatible(domain, termExpressionType(tupleTail.elements.get(0)))) {
				return true;
			}
		}
				
		if (domainList.size != tupleTail.elements.size) {
			error('''Number of parameters provided don't match the declared parameters in: '«getTypeName(domain, qnp)»'. 
			Expected «domainList.size» but got «tupleTail.elements.size» ''',
					ImlPackage.eINSTANCE.tailedExpression_Tail,
					INVALID_PARAMETER_LIST
				)
			return false;
		}
		
		// TODO check type matching of parameter provided v.s declared
		for (i : 0 ..< domainList.size) {
			val paramType = termExpressionType(tupleTail.elements.get(i))
			if (!isCompatible(domainList.get(i), paramType)) {
				error('''Invalid argument type. Expecting: «ImlUtil.getTypeName(domainList.get(i), qnp)» but got 
							«ImlUtil.getTypeName(paramType, qnp)»''',
					ImlPackage.eINSTANCE.tailedExpression_Tail,
					INVALID_PARAMETER_LIST
				)
			}
		}
		
		return true
	}
		
	@Check
	def checkMultiplication(Multiplication m) {
		if (m.sign == '%' || m.sign == 'mod') {
			if (!m.left.termExpressionType.isInt) {
				error(
				'''Only integers types are allowed for % and mod operations: left expression has type of: « ImlUtil.getTypeName(m.left.termExpressionType, qnp)» '''
				, ImlPackage::eINSTANCE.folFormula_Left ,
					TYPE_MISMATCH_IN_TERM_EXPRESSION);
			} else if ((m.right !== null) && !m.right.termExpressionType.isInt) {
				error(
				'''Only integers types are allowed for % and mod operations: right expression has type of «ImlUtil.getTypeName(m.right.termExpressionType, qnp)»'''
					, ImlPackage::eINSTANCE.folFormula_Right,
					TYPE_MISMATCH_IN_TERM_EXPRESSION);
			}
		}
	}

	@Check
	def checkParametersList(SimpleTypeReference tr) {
		val type = tr.type
		if (type !== null) {
			// check template parameter list
			if (type.template && type.typeParameter.size != tr.typeBinding.size) {
				error(
					'''Invalid number of template type binding parameters. Expected: «type.typeParameter.size», but got: «tr.typeBinding.size» ''',
					ImlPackage::eINSTANCE.simpleTypeReference_TypeBinding,
					INVALID_PARAMETER_LIST
				)
			}
		}
	}
		
	@Check
	def checkCompatibleDeclarationAndDefinition(SymbolDeclaration symbol) {
		if (symbol.type !== null && symbol.definition !== null) {
			val defType = termExpressionType(symbol.definition)
			if (!isCompatible(symbol.type, defType)) {
				error('''Incompatible types, expected  «ImlUtil.getTypeName(symbol.type, qnp)» but actual was «ImlUtil.getTypeName(defType, qnp)»''',
					ImlPackage.eINSTANCE.symbolDeclaration_Definition,
					TYPE_MISMATCH_IN_TERM_EXPRESSION
				)
			}	
		}	
	}
	
	@Check
	def checkCorrectSymbolDeclaration(SymbolDeclaration symbol) {
		val container = symbol.eContainer
		switch (container) {
			NamedType: {
				if (container.symbols.contains(symbol)) { // Symbols must have a type if there is no primitive properties
					if (symbol.type === null && !(symbol instanceof Assertion)) {
						error('''Symobl declaration  "«symbol.name»" must have a type''',
						ImlPackage.eINSTANCE.symbolDeclaration_Type,
						INVALID_SYMBOL_DECLARATION
						)
					}
				} 
			}
			
			SequenceTerm: { // Must have a type
				if (symbol.type === null) {
					error('''Symobl declaration  "«symbol.name»" must have a type''',
						ImlPackage.eINSTANCE.symbolDeclaration_Type,
						INVALID_SYMBOL_DECLARATION
					)
				}
			}
			
		}
	}
	
	@Check
	def checkAliasDeclaration(Alias alias) {
		val aliasType = normalizeType(alias.type.type)
		
		if (!isEqual(aliasType, alias.type.type, false)) {
			val mainType = EcoreUtil2.getContainerOfType(alias, NamedType);
			error('''Type «mainType.name» alias shouldn't include any further aliases''',
				ImlPackage.eINSTANCE.alias_Type,
				INVALID_TYPE_DECLARATION
			)
		}
	}
	
	@Check
	def checkNamedTypeDeclaration(NamedType type) {
		// Should have only one alias
		if (type.relations !== null) {
			if (type.relations.filter[it instanceof Alias].size > 1) {
				error('''Type «type.name» can NOT have more that one alias''',
					ImlPackage.eINSTANCE.namedType_Relations,
					INVALID_TYPE_DECLARATION
				)
			}
		}
		if (type instanceof Datatype) {
			if (type.constructors.isEmpty) {
				error('''Datatype constructors are missing''',
						ImlPackage.eINSTANCE.namedType_Constructors,
						INVALID_TYPE_DECLARATION
					)
			}
		} else {
			if (!type.constructors.isEmpty) {
				error('''Constructors allowed only for datatypes''',
						ImlPackage.eINSTANCE.namedType_Constructors,
						INVALID_TYPE_DECLARATION
					)
			}
		}
	}
	
	@Check
	def checkMatchDatatype(MatchExpression match) {
		val matchType = termExpressionType(match.datatypeExpr)
		if (!isDatatype(matchType)) {
			error('''Match expression applies only on Datatypes''',
						ImlPackage.eINSTANCE.matchExpression_DatatypeExpr,
						MATCH_NOT_DATATYPE
					)
		} 
	}
	
	@Check
	def checkMatchStatementConstructor(MatchStatement matchstm) {
		val constructor = matchstm.constructor
		if (matchstm.paramSymbols.size !== constructor.parameters.size) {
			error('''Match statement constructor parameters list size doesn't match the original constructor. ''' + 
					'''Expected «constructor.parameters.size», but got «matchstm.paramSymbols.size».''',
						ImlPackage.eINSTANCE.matchStatement_ParamSymbols,
						INVALID_PARAMETER_LIST
					)
		}
	}
	
	@Check
	def checkDatatypeInit(TermMemberSelection tms) {
		 val recType = termExpressionType(tms.receiver)
		 if (recType.datatype) { // Constructor selection validation
		 	if (!(tms.member instanceof SymbolReferenceTerm &&
		 		(tms.member as SymbolReferenceTerm).symbol instanceof DatatypeConstructor)) return;
		 	val constructor = (tms.member as SymbolReferenceTerm).symbol as DatatypeConstructor
		 	if (!constructor.parameters.isEmpty) { // Check compatible param list
		 		if (!(tms.eContainer instanceof TailedExpression && 
		 			(tms.eContainer as TailedExpression).tail instanceof TupleConstructor
		 		)) { // Missing param list
		 			error('''Datatype constuctor instantiation is missing parameters list.''' + 
					'''Expected «constructor.parameters.size» parameters.''',
						ImlPackage.eINSTANCE.termMemberSelection_Member,
						INVALID_PARAMETER_LIST
					)
					return	
		 		}
		 	 	val paramTuple = (tms.eContainer as TailedExpression).tail as TupleConstructor
		 	 	if (constructor.parameters.size !== paramTuple.elements.size) {
		 	 		error('''Datatype constuctor instantiation parameters list size doesn't match the declared one.''' + 
					'''Expected «constructor.parameters.size», but got «paramTuple.elements.size».''',
						ImlPackage.eINSTANCE.termMemberSelection_Member,
						INVALID_PARAMETER_LIST
					)
					return
		 	 	}
		 	 	// Check maching types
		 	 	for (i : 0 ..< constructor.parameters.size) {
		 	 		val env = new TypingEnvironment().addContext(recType as SimpleTypeReference)
		 	 		val declaredType = env.bind(constructor.parameters.get(i))
		 	 		val definedType = termExpressionType(paramTuple.elements.get(i))
		 	 		if (!isEqual(declaredType, definedType, true)) {
		 	 			error('''Datatype constuctor instantiation parameter doesn't match the declared one.''' + 
						'''Expected «getTypeName(declaredType, qnp)», but got «getTypeName(definedType, qnp)».''',
						ImlPackage.eINSTANCE.termMemberSelection_Member,
						INVALID_PARAMETER_LIST
					)
					return
		 	 		}
		 	 	}
		 	} else { // Empty constructor doesn't need parameters
		 		if (tms.eContainer instanceof TailedExpression) {
		 			error('''Datatype constuctor instantiation contains extraneous tail.''',  
						ImlPackage.eINSTANCE.termMemberSelection_Member,
						INVALID_PARAMETER_LIST
					)
		 		}
		 	}
		 }
	}
	
	def isDatatype(ImlType type) {
		type instanceof SimpleTypeReference && (type as SimpleTypeReference).type instanceof Datatype
	}

}
	