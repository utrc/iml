/*
 * generated by Xtext 2.9.1
 */
package com.utc.utrc.hermes.iml.validation

import com.utc.utrc.hermes.iml.iml.AtomicExpression
import com.utc.utrc.hermes.iml.iml.ConstrainedType
import com.utc.utrc.hermes.iml.iml.FolFormula
import com.utc.utrc.hermes.iml.iml.Model
import com.utc.utrc.hermes.iml.iml.Multiplication
import com.utc.utrc.hermes.iml.iml.Symbol
import com.utc.utrc.hermes.iml.iml.TermMemberSelection
import java.util.ArrayList
import java.util.List
import org.eclipse.xtext.validation.Check

import static extension com.utc.utrc.hermes.iml.typing.ImlTypeProvider.*
import static extension com.utc.utrc.hermes.iml.typing.TypingServices.*
import static extension org.eclipse.xtext.EcoreUtil2.*
import com.utc.utrc.hermes.iml.iml.Addition
import com.google.inject.Inject
import org.eclipse.xtext.validation.EValidatorRegistrar
import org.eclipse.core.runtime.Platform
import org.eclipse.xtext.validation.AbstractDeclarativeValidator
import org.eclipse.emf.ecore.EPackage
import com.utc.utrc.hermes.iml.iml.ImlPackage
import com.utc.utrc.hermes.iml.iml.HigherOrderType
import com.utc.utrc.hermes.iml.iml.SimpleTypeReference
import com.utc.utrc.hermes.iml.iml.SymbolReferenceTerm

/**
 * This class contains custom validation rules. 
 * 
 * See https://www.eclipse.org/Xtext/documentation/303_runtime_concepts.html#validation
 */
class ImlValidator extends AbstractImlValidator {

	private static final String DOMAIN_EXTENSION_ID = 
      "com.utc.utrc.hermes.iml.validation.domaindefinition";

	public static val INVALID_PARAMETER_LIST = 'com.utc.utrc.hermes.iml.validation.InvalidParameterList'
	public static val METHOD_INVOCATION_ON_VARIABLE = 'com.utc.utrc.hermes.iml.validation.MethodInvocationOnVariable'
	public static val METHOD_INVOCATION_ON_CONSTAINT = 'com.utc.utrc.hermes.iml.validation.MethodInvocationOnConstant'
	public static val MISSING_METHOD_INVOCATION = 'com.utc.utrc.hermes.iml.validation.MissingMethodInvocation'
	public static val TYPE_MISMATCH_IN_TERM_EXPRESSION = 'com.utc.utrc.hermes.iml.validation.TypeMismatchInTermExpression'
	public static val TYPE_MISMATCH_IN_TERM_RELATION = 'com.utc.utrc.hermes.iml.validation.TypeMismatchInTermRelation'
	public static val INVALID_STEREOTYPE_HIERARCHY = 'com.utc.utrc.hermes.iml.validation.InvalidStereotypeHierarchy'
	public static val CYCLIC_CONSTRAINEDTYPE_HIERARCHY = 'com.utc.utrc.hermes.iml.validation.CyclicConstrainedTypeHierarchy'
	public static val DUPLICATE_ELEMENT = 'com.utc.utrc.hermes.iml.validation.DuplicateElement'
	public static val INVALID_STEREOTYPE = 'com.utc.utrc.hermes.iml.validation.InvalidStereotype';
	public static val ELEMENTS_IN_STATIC_TYPES = 'com.utc.utrc.hermes.iml.validation.ElementsInStaticTypes';
	public static val INVALID_TYPE_PARAMETER = 'com.utc.utrc.hermes.iml.validation.InvalidTypeParameter';
	public static val INVALID_TYPE_DECLARATION = 'com.utc.utrc.hermes.iml.validation.InvalidTypeDeclaration';
	public static val INVALID_ELEMENT = 'com.utc.utrc.hermes.iml.validation.InvalidElement';
	public static val INVALID_RELATION = 'com.utc.utrc.hermes.iml.validation.InvalidRelation';

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
		if (e.eContainer.eContents.filter(Symbol).exists[it != e && it.name == e.name])
			error("Duplicate term symbol '" + e.name + "'", ImlPackage::eINSTANCE.symbol_Name, DUPLICATE_ELEMENT)

	}

	// Check correct Template declaration
	@Check
	def checkTemplateType(ConstrainedType t) {
		if (t.template) {
			for (tp : t.typeParameter) {
				if (tp.finite || tp.meta || tp.template || !tp.symbols.isEmpty || tp.doc !== null || !tp.relations.isEmpty) {
					error('''Type parameters must be simple types''',
						ImlPackage::eINSTANCE.constrainedType_TypeParameter, t.typeParameter.indexOf(
							tp
						), INVALID_TYPE_PARAMETER)
					
				}
			}
		}
	}

	@Check
	def checkExtension(ConstrainedType t) {
		val extensions = t.relations.filter[it instanceof com.utc.utrc.hermes.iml.iml.Extension].map[it as com.utc.utrc.hermes.iml.iml.Extension]
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
	def checkExtendsRelation(com.utc.utrc.hermes.iml.iml.Extension extendRelation) {
		if (! (extendRelation.target instanceof SimpleTypeReference)) {
			error("Types can extend only simple types", 
				ImlPackage::eINSTANCE.extension_Target, INVALID_RELATION)
		}
	}

	// If allowing user to introduce stereotype, make sure to update stereoTypeMap
	// then map should never be null
	@Check
	def checkLegitimateStereoType(ConstrainedType t) {
//		val s = t.properties
//		if (t.static) {
//			for (Element e : t.elements) {
//				switch (e) {
//					NamedFormula: {
//					}
//					ConstrainedType: {
//						error('''Type declarations are not allowed in static types''',
//							ImlPackage::eINSTANCE.constrainedType_Elements, t.elements.indexOf(
//								e
//							), ELEMENTS_IN_STATIC_TYPES)
//					}
//					//TypeProperty: {
//					//	error('''Stereotype declarations are not allowed in static types''',
//					//		ImlPackage::eINSTANCE.constrainedType_Elements, t.elements.indexOf(
//					//			e
//					//		), ELEMENTS_IN_STATIC_TYPES)
//					//}
//					VariableDeclaration: {
//						error('''Variable declarations are not allowed in static types''',
//							ImlPackage::eINSTANCE.constrainedType_Elements, t.elements.indexOf(
//								e
//							), ELEMENTS_IN_STATIC_TYPES)
//					}
//					default: {
//					}
//				}
//			}
//		}
	}



	@Check
	def checkNoCycleInConstrainedTypeHierarchy(ConstrainedType ct) {
		val extensions = getExtensions(ct) 
		if (extensions.empty)
			return
		val visited = <ConstrainedType>newArrayList()
		val superTypeHierarchy = new ArrayList<List<ConstrainedType>>()
		superTypeHierarchy.add(new ArrayList<ConstrainedType>())
		superTypeHierarchy.get(0).add(ct)
		var index = 0
		while (superTypeHierarchy.get(index).size() > 0) {
			val toAdd = <ConstrainedType>newArrayList()
			for (cur : superTypeHierarchy.get(index)) {
				for (supType : getExtensions(cur)) {
					if (!visited.contains(supType.target.asSimpleTR.ref))
						toAdd.add(supType.target.asSimpleTR.ref)
					else {
						error(
							"Cycle in hierarchy of constrained type '" + cur.name + "'",
							ImlPackage::eINSTANCE.constrainedType_Relations,
							CYCLIC_CONSTRAINEDTYPE_HIERARCHY
						)
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
	
	def getExtensions(ConstrainedType type) {
		type.relations.filter[it instanceof com.utc.utrc.hermes.iml.iml.Extension].map[it as com.utc.utrc.hermes.iml.iml.Extension]
	}

	@Check
	def checkFormula(FolFormula f) {
//		var context = createBasicType(f.getContainerOfType(ConstrainedType))
//		var exprtr = f.termExpressionType(context)
//		if (exprtr !== Bool) {
//			error('''The formula should be Booelan,  got «exprtr.printType»''',f, INVALID_TYPE_PARAMETER)
//		}
	}

	@Check
	def checkQuantifiedFormula(FolFormula f) {
//		if (f instanceof QuantifiedFormula) {
//			var context = ct2tr(f.getContainerOfType(ConstrainedType))
//			var exprtr = f.left.termExpressionType(context)
//			if (exprtr !== boolTypeRef) {
//				error('''The expression inside a named formula should be Booelan, got «exprtr.printTypeReference»  instead''',
//					ImlPackage::eINSTANCE.folFormula_Left, INVALID_TYPE_PARAMETER)
//			}
//		}
	}

	@Check
	def checkFolFormula(FolFormula f) {
//		if (f.symbol !== null) {
//			var context = ct2tr(f.getContainerOfType(ConstrainedType))
//			if (f.symbol.equals("=>") || f.symbol.equals("<=>") || f.symbol.equals("||") || f.symbol.equals("&&")) {
//				var exprtr = f.left.termExpressionType(context)
//				if (exprtr != boolTypeRef) {
//					error('''The left hand side should be Boolean, got «exprtr.printTypeReference»  instead''',
//						ImlPackage::eINSTANCE.folFormula_Left, INVALID_TYPE_PARAMETER)
//				}
//				exprtr = f.right.termExpressionType(context)
//				if (exprtr != boolTypeRef) {
//					error('''The right hand side should be Boolean, got «exprtr.printTypeReference»  instead''',
//						ImlPackage::eINSTANCE.folFormula_Right, INVALID_TYPE_PARAMETER)
//				}
//			}
//		} else if (f.neg) {
//			var context = ct2tr(f.getContainerOfType(ConstrainedType))
//			var exprtr = f.left.termExpressionType(context)
//			if (exprtr != boolTypeRef) {
//				error('''The ! operator can be only  applied to a Boolean expression, got «exprtr.printTypeReference»  instead''',
//					ImlPackage::eINSTANCE.folFormula_Left, INVALID_TYPE_PARAMETER)
//			}
//		}
	}

	@Check
	def checkAtomicExpression(AtomicExpression e) {

//		var context = ct2tr(e.getContainerOfType(ConstrainedType))
//		switch (e.rel) {
//			case EQ: {
//				var rt = e.right.termExpressionType(context)
//				var lt = e.left.termExpressionType(context)
//				if (! rt.isCompatible(lt, true) || ! lt.isCompatible(rt, true)) {
//					error('''Type «lt.printTypeReference» and «rt.printTypeReference» are not compatible''',
//						ImlPackage::eINSTANCE.atomicExpression_Rel, INVALID_TYPE_PARAMETER)
//				}
//			}
//			default: {
//				var rt = e.right.termExpressionType(context)
//				var lt = e.left.termExpressionType(context)
//				if (! (rt.isNumeric && lt.isNumeric)) {
//					error('''Both sides must be numeric''', ImlPackage::eINSTANCE.atomicExpression_Rel,
//						INVALID_TYPE_PARAMETER)
//				}
//			}
//		}

	}

	@Check
	def checkParameterList(SymbolReferenceTerm at) {
		
		
//		val symbol = f.ref
//		if (symbol !== null) {
//			if (symbol instanceof VariableDeclaration && f.methodinvocation) {
//				error('''Method invocation on a variable term''', ImlPackage::eINSTANCE.symbolRef_Methodinvocation,
//					METHOD_INVOCATION_ON_VARIABLE)
//			}
//			if (symbol instanceof ConstantDeclaration && f.methodinvocation) {
//				error('''Method invocation on a constant term''', ImlPackage::eINSTANCE.symbolRef_Methodinvocation,
//					METHOD_INVOCATION_ON_CONSTAINT)
//			}
//			if (symbol instanceof FunctionDefinition) {
//				val fdecl = (symbol as FunctionDefinition)
//				if (fdecl.parameters.size > 0 && ! f.methodinvocation) {
//					error('''Missing method invocation''', ImlPackage::eINSTANCE.symbolRef_Methodinvocation,
//						MISSING_METHOD_INVOCATION)
//				} else {
//					// check parameter list
//					if (fdecl.parameters.size != f.parameters.size) {
//						error(
//							'''Invalid number of arguments : expecting ''' + fdecl.parameters.size + " but only got " +
//								f.parameters.size, ImlPackage::eINSTANCE.symbolRef_Methodinvocation,
//							INVALID_PARAMETER_LIST)
//						} else {
//							for (i : 0 ..< fdecl.parameters.size) {
//								var typeref = fdecl.parameters.get(i).type
//								var context = ct2tr(f.getContainerOfType(ConstrainedType))
//								val argType = f.parameters.get(i).termExpressionType(context)
//								val expected = bindTypeRefWith(typeref, context)
//
//								if (! argType.isCompatible(expected, true))
//									error(
//										'''Invalid argument type: expecting ''' + expected.printTypeReference +
//											''', got ''' + argType.printTypeReference,
//										ImlPackage::eINSTANCE.symbolRef_Parameters, i, INVALID_PARAMETER_LIST)
//
//							}
//						}
//
//					}
//				}
//			}
		}

		// validate function's parameters against its declaration's
		@Check
		def checkParameterList(TermMemberSelection f) {
//			val member = f.member
//			if (member !== null) {
//				if (member instanceof VariableDeclaration && f.methodinvocation) {
//					error('''Method invocation on a variable term''',
//						ImlPackage::eINSTANCE.termMemberSelection_Methodinvocation, METHOD_INVOCATION_ON_VARIABLE)
//				}
//				if (member instanceof ConstantDeclaration && f.methodinvocation) {
//					error('''Method invocation on a constant term''',
//						ImlPackage::eINSTANCE.termMemberSelection_Methodinvocation, METHOD_INVOCATION_ON_CONSTAINT)
//				}
//				if (member instanceof FunctionDefinition) {
//					val fdecl = (member as FunctionDefinition)
//					if (fdecl.parameters.size > 0 && ! f.methodinvocation) {
//						error('''Missing method invocation''',
//							ImlPackage::eINSTANCE.termMemberSelection_Methodinvocation, MISSING_METHOD_INVOCATION)
//					} else {
//						// check parameter list
//						if (fdecl.parameters.size != f.parameters.size) {
//							error(
//								'''Invalid number of arguments : expecting ''' + fdecl.parameters.size +
//									" but only got " + f.parameters.size,
//								ImlPackage::eINSTANCE.symbolRef_Methodinvocation, INVALID_PARAMETER_LIST)
//						} else {
//							var context = ct2tr(f.getContainerOfType(ConstrainedType))
//							for (i : 0 ..< fdecl.parameters.size) {
//								var expected = bindTypeRefWith(fdecl.parameters.get(i).type,
//									f.receiver.termExpressionType(context))
//								var argType = f.parameters.get(i).termExpressionType(context);
//								if (! argType.isCompatible(expected, true))
//									error(
//										'''Invalid argument type: expecting ''' + expected.printTypeReference +
//											''', got ''' + argType.printTypeReference,
//										ImlPackage::eINSTANCE.termMemberSelection_Parameters, i, INVALID_PARAMETER_LIST)
//							}
//						}
//					}
//				}
//			}
		}

		@Check
		def checkMultiplication(Multiplication m) {
		//	var context = ct2tr(m.getContainerOfType(ConstrainedType))
//			if (m.sign == '%' || m.sign == 'mod') {
//				if (m.left.termExpressionType(context).type.name != 'Int') {
//					error(
//					'''Only integers types are allowed for % and mod operations: left expression has type m.left.
//						termExpressionType(context).type.name''', ImlPackage::eINSTANCE.folFormula_Left,
//						TYPE_MISMATCH_IN_TERM_EXPRESSION);
//				} else if ((m.right != null) && m.right.termExpressionType(context).type.name != 'Int') {
//					error(
//					'''Only integers types are allowed for % and mod operations: right expression has type m.right.
//						termExpressionType(context).type.name''', ImlPackage::eINSTANCE.folFormula_Right,
//						TYPE_MISMATCH_IN_TERM_EXPRESSION);
//				}
//			}
		}

		@Check
		def checkMultiplication(Addition m) {
			//var context = ct2tr(m.getContainerOfType(ConstrainedType))
			
		}

		@Check
		def checkParametersList(HigherOrderType tr) {
//			val type = tr.type
//			if (type !== null) {
//				// check template parameter list
//				val ct = (type as ConstrainedType)
//				if (ct.template && ct.typeParameter.size != tr.typeBinding.size) {
//					error(
//						'''Invalid number of template type binding parameters''',
//						ImlPackage::eINSTANCE.typeReference_TypeBinding,
//						INVALID_PARAMETER_LIST
//					)
//				}
//			}
		}

	}
	