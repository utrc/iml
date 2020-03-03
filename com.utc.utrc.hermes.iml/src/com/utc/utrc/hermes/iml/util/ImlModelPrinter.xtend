package com.utc.utrc.hermes.iml.util

import com.utc.utrc.hermes.iml.iml.util.ImlSwitch

import com.utc.utrc.hermes.iml.iml.Addition;
import com.utc.utrc.hermes.iml.iml.Alias;
import com.utc.utrc.hermes.iml.iml.AndExpression;
import com.utc.utrc.hermes.iml.iml.Annotation;
import com.utc.utrc.hermes.iml.iml.ArrayAccess;
import com.utc.utrc.hermes.iml.iml.ArrayType;
import com.utc.utrc.hermes.iml.iml.Assertion;
import com.utc.utrc.hermes.iml.iml.AtomicExpression;
import com.utc.utrc.hermes.iml.iml.CardinalityRestriction;
import com.utc.utrc.hermes.iml.iml.CaseTermExpression;
import com.utc.utrc.hermes.iml.iml.CharLiteral;
import com.utc.utrc.hermes.iml.iml.Datatype;
import com.utc.utrc.hermes.iml.iml.DatatypeConstructor;
import com.utc.utrc.hermes.iml.iml.Doc;
import com.utc.utrc.hermes.iml.iml.EnumRestriction;
import com.utc.utrc.hermes.iml.iml.ExpressionTail;
import com.utc.utrc.hermes.iml.iml.FloatNumberLiteral;
import com.utc.utrc.hermes.iml.iml.FolFormula;
import com.utc.utrc.hermes.iml.iml.FunctionType;
import com.utc.utrc.hermes.iml.iml.ImlType;
import com.utc.utrc.hermes.iml.iml.Import;
import com.utc.utrc.hermes.iml.iml.Inclusion;
import com.utc.utrc.hermes.iml.iml.InstanceConstructor;
import com.utc.utrc.hermes.iml.iml.IteTermExpression;
import com.utc.utrc.hermes.iml.iml.LambdaExpression;
import com.utc.utrc.hermes.iml.iml.MatchExpression;
import com.utc.utrc.hermes.iml.iml.MatchStatement;
import com.utc.utrc.hermes.iml.iml.Model;
import com.utc.utrc.hermes.iml.iml.Multiplication;
import com.utc.utrc.hermes.iml.iml.NamedType;
import com.utc.utrc.hermes.iml.iml.NumberLiteral;
import com.utc.utrc.hermes.iml.iml.OptionalTermExpr;
import com.utc.utrc.hermes.iml.iml.OrExpression;
import com.utc.utrc.hermes.iml.iml.ParenthesizedTerm;
import com.utc.utrc.hermes.iml.iml.Property;
import com.utc.utrc.hermes.iml.iml.PropertyList;
import com.utc.utrc.hermes.iml.iml.QuantifiedFormula;
import com.utc.utrc.hermes.iml.iml.RecordConstructor;
import com.utc.utrc.hermes.iml.iml.RecordConstructorElement;
import com.utc.utrc.hermes.iml.iml.RecordType;
import com.utc.utrc.hermes.iml.iml.Refinement;
import com.utc.utrc.hermes.iml.iml.Relation;
import com.utc.utrc.hermes.iml.iml.SelfTerm;
import com.utc.utrc.hermes.iml.iml.SelfType;
import com.utc.utrc.hermes.iml.iml.SequenceTerm;
import com.utc.utrc.hermes.iml.iml.SignedAtomicFormula;
import com.utc.utrc.hermes.iml.iml.SimpleTypeReference;
import com.utc.utrc.hermes.iml.iml.StringLiteral;
import com.utc.utrc.hermes.iml.iml.Symbol;
import com.utc.utrc.hermes.iml.iml.SymbolDeclaration;
import com.utc.utrc.hermes.iml.iml.SymbolReferenceTerm;
import com.utc.utrc.hermes.iml.iml.TailedExpression;
import com.utc.utrc.hermes.iml.iml.TermExpression;
import com.utc.utrc.hermes.iml.iml.TermMemberSelection;
import com.utc.utrc.hermes.iml.iml.Trait;
import com.utc.utrc.hermes.iml.iml.TraitExhibition;
import com.utc.utrc.hermes.iml.iml.TruthValue;
import com.utc.utrc.hermes.iml.iml.TupleConstructor;
import com.utc.utrc.hermes.iml.iml.TupleType;
import com.utc.utrc.hermes.iml.iml.TypeRestriction;
import com.utc.utrc.hermes.iml.iml.TypeWithProperties;
import org.eclipse.emf.common.util.EList
import java.util.List
import org.eclipse.emf.ecore.EObject

class ImlModelPrinter extends ImlSwitch<String> {
	
	def static String print(EObject object) {
		new ImlModelPrinter().doSwitch(object)
	}
	
	override String caseModel(Model object) {
		'''
		package «object.name»;
		
		«FOR importt : object.imports»
		«importt.doSwitch»
		«ENDFOR»
		
		«FOR symbol : object.symbols»
		«symbol.doSwitch»
		«ENDFOR»
		'''
	}

	
	override String caseImport(Import object) {
		"import " + object.importedNamespace + ";"
	}

	
	override String caseSymbol(Symbol object) {
		return super.caseSymbol(object);
	}

	
	override String caseDoc(Doc object) {
		'''«FOR prop : object.properties BEFORE '@' SEPARATOR ' '»«prop.name» "«object.descriptions.get(object.properties.indexOf(prop))»"«ENDFOR»'''
	}

	
	override String caseProperty(Property object) {
		object.ref.doSwitch + " " + object.definition.doSwitch
	}

	
	override String casePropertyList(PropertyList object) {
		'''«FOR property : object.properties BEFORE '[' SEPARATOR ', ' AFTER ']'»«property.doSwitch»«ENDFOR»'''
	}

	
	override String caseTypeWithProperties(TypeWithProperties object) {
		doSwitch(object.properties) + doSwitch(object.type) 
	}

	
	override String caseRelation(Relation object) {
		return super.caseRelation(object);
	}

	
	override String caseNamedType(NamedType object) {
		if (ImlUtil.isActualNamedType(object)) {
			return "type " + namedTypeContent(object);
		} else {
			return super.caseNamedType(object)
		}
		
	}
	
	def namedTypeContent(NamedType type) {
		val sb = new StringBuilder
		if (type.propertylist !== null)
			sb.append(doSwitch(type.propertylist) + " ");
		sb.append(type.name)
		if (type.template) 
			sb.append(" " + typeTemplatesString(type.typeParameter))
		if (type.constructors !== null && type.constructors.size > 0)
			sb.append(" " + typeConstructorsString(type.constructors))
		if (type.relations !== null && type.relations.size > 0)
			sb.append(''' «FOR rel : type.relations SEPARATOR ' '»«doSwitch(rel)»«ENDFOR»''')
		if (type.restriction !== null)
			sb.append(" " + doSwitch(type.restriction))
		sb.append(
		'''{
	«FOR symbol : type.symbols SEPARATOR '\n'»«doSwitch(symbol)»;«ENDFOR»
}''')
		sb.toString
	}
	
	def typeConstructorsString(EList<Symbol> list) {
		'''«FOR param : list BEFORE '(' SEPARATOR ', ' AFTER ')'»«doSwitch(param)»«ENDFOR»'''
	}
	
	def scopeParamsString(EList<SymbolDeclaration> list) {
		'''«FOR param : list BEFORE '(' SEPARATOR ', ' AFTER ')'»«doSwitch(param)»«ENDFOR»'''
	}
	
	def typeTemplatesString(EList<NamedType> list) {
		'''«FOR param : list BEFORE '<' SEPARATOR ', ' AFTER '>'»«param.name»«ENDFOR»'''
	}

	
	override String caseTypeRestriction(TypeRestriction object) {
		return super.caseTypeRestriction(object);
	}

	
	override String caseSymbolDeclaration(SymbolDeclaration object) {
		'''«doSwitch(object.propertylist)» «object.name»«typeTemplatesString(object.typeParameter)»''' +
		'''«IF object.type !== null»:«doSwitch(object.type)»«ENDIF»''' +
		'''«IF object.definition !== null»:=«doSwitch(object.definition)»«ENDIF»'''
	}

	
	override String caseImlType(ImlType object) {
		return super.caseImlType(object);
	}

	
	override String caseOptionalTermExpr(OptionalTermExpr object) {
		'''«IF object.term !== null»«doSwitch(object.term)»«ENDIF»'''
	}

	
	override String caseFolFormula(FolFormula object) {
		if (object.op !== null) {
			return doSwitch(object.left) + object.op + doSwitch(object.right)
		} else {
			return super.caseFolFormula(object);
		}
	}

	
	override String caseTermExpression(TermExpression object) {
		return super.caseTermExpression(object);
	}

	
	override String caseExpressionTail(ExpressionTail object) {
		return super.caseExpressionTail(object);
	}

	
	override String caseRecordConstructorElement(RecordConstructorElement object) {
		object.name + " := " + doSwitch(object.definition)
	}

	
	override String caseMatchExpression(MatchExpression object) {
		'''match («doSwitch(object.datatypeExpr)») { «FOR stmt:object.matchStatements SEPARATOR ' '»«doSwitch(stmt)»«ENDFOR» }'''
	}

	
	override String caseMatchStatement(MatchStatement object) {
		'''
		«object.constructor.name»«FOR param:object.paramSymbols BEFORE '(' SEPARATOR ', ' AFTER ')'»«doSwitch(param)»«ENDFOR»
		''' + ":" + doSwitch(object.^return)
	}

	
	override String caseInclusion(Inclusion object) {
		"includes " + listOfParams(object.inclusions)
	}
	
	def listOfParams(EList<TypeWithProperties> list) {
		'''«FOR param:list BEFORE '(' SEPARATOR ', ' AFTER ')'»«doSwitch(param)»«ENDFOR»'''
	}

	
	override String caseRefinement(Refinement object) {
		"refines " + listOfParams(object.refinements)
	}

	
	override String caseAlias(Alias object) {
		"is " + doSwitch(object.type)
	}

	
	override String caseTraitExhibition(TraitExhibition object) {
		"exhibits " + listOfParams(object.exhibitions)
	}

	
	override String caseAnnotation(Annotation object) {
		"annotation " + namedTypeContent(object);
	}

	
	override String caseTrait(Trait object) {
		"trait " + namedTypeContent(object);
	}

	
	override String caseDatatype(Datatype object) {
		"datatype " + namedTypeContent(object);
	}

	
	override String caseDatatypeConstructor(DatatypeConstructor object) {
		doSwitch(object.propertylist) + object.name + 
		'''«FOR param:object.parameters BEFORE '(' SEPARATOR ', ' AFTER ')'»«doSwitch(param)»«ENDFOR»'''
	}

	
	override String caseCardinalityRestriction(CardinalityRestriction object) {
		"finite " + object.cardinality
	}

	
	override String caseEnumRestriction(EnumRestriction object) {
		"enum " + '''«FOR param:object.literals BEFORE '{' SEPARATOR ', ' AFTER '}'»«doSwitch(param)»«ENDFOR»'''
	}

	
	override String caseAssertion(Assertion object) {
		'''assert «doSwitch(object.propertylist)»«IF object.comment !== null»"«object.comment»" «ENDIF»«IF object.name !== null»«object.name» «ENDIF»«doSwitch(object.definition)»'''
	}

	
	override String caseFunctionType(FunctionType object) {
		doSwitch(object.domain) + "->" + doSwitch(object.range)
	}

	
	override String caseArrayType(ArrayType object) {
		doSwitch(object.type) + '''«FOR param:object.dimensions»[«doSwitch(param)»]«ENDFOR»'''
	}

	
	override String caseRecordType(RecordType object) {
		'''«FOR param:object.symbols BEFORE '{' SEPARATOR ', ' AFTER '}'»«doSwitch(param)»«ENDFOR»'''
	}

	
	override String caseTupleType(TupleType object) {
		'''«FOR param:object.types BEFORE '(' SEPARATOR ', ' AFTER ')'»«doSwitch(param)»«ENDFOR»'''
	}

	
	override String caseSelfType(SelfType object) {
		"Self"
	}

	
	override String caseSimpleTypeReference(SimpleTypeReference object) {
		object.type.name + '''«FOR param:object.typeBinding BEFORE '<' SEPARATOR ', ' AFTER '>'»«doSwitch(param)»«ENDFOR»'''
	}

	
	override String caseQuantifiedFormula(QuantifiedFormula object) {
		object.op+typeTemplatesString(object.typeParameter)+scopeParamsString(object.scope)+doSwitch(object.left)
	}

	
	override String caseOrExpression(OrExpression object) {
		doSwitch(object.left) + "||" + doSwitch(object.right)
	}

	
	override String caseAndExpression(AndExpression object) {
		doSwitch(object.left) + "&&" + doSwitch(object.right)
	}

	
	override String caseSignedAtomicFormula(SignedAtomicFormula object) {
		'''«IF object.neg»!«ENDIF»«doSwitch(object.left)»'''
	}

	
	override String caseAtomicExpression(AtomicExpression object) {
		doSwitch(object.left) + object.rel.literal + doSwitch(object.right)
	}

	
	override String caseTruthValue(TruthValue object) {
		if (object.TRUE) return 'true' else return 'false'
	}

	
	override String caseAddition(Addition object) {
		doSwitch(object.left) + object.sign + doSwitch(object.right)
	}

	
	override String caseMultiplication(Multiplication object) {
		doSwitch(object.left) + object.sign + doSwitch(object.right)
	}

	
	override String caseTermMemberSelection(TermMemberSelection object) {
		doSwitch(object.receiver) + '.' + doSwitch(object.member)
	}

	
	override String caseTailedExpression(TailedExpression object) {
		doSwitch(object.left) + doSwitch(object.tail)
	}

	
	override String caseArrayAccess(ArrayAccess object) {
		'[' + object.index.doSwitch + ']'
	}

	
	override String caseNumberLiteral(NumberLiteral object) {
		'''«IF object.neg»-«ENDIF»«object.value»'''
	}

	
	override String caseFloatNumberLiteral(FloatNumberLiteral object) {
		'''«IF object.neg»-«ENDIF»«object.value»'''
	}

	
	override String caseStringLiteral(StringLiteral object) {
		'''"«object.value»"'''
	}

	
	override String caseCharLiteral(CharLiteral object) {
		"'" + object.value + "'"
	}

	
	override String caseSelfTerm(SelfTerm object) {
		'self'
	}

	
	override String caseLambdaExpression(LambdaExpression object) {
		 '''fun «scopeParamsString(object.parameters)»«IF object.returnType !== null»:«object.returnType.doSwitch»«ENDIF»«object.definition.doSwitch»'''
	}

	
	override String caseInstanceConstructor(InstanceConstructor object) {
		'''some («object.ref.doSwitch»)«object.definition.doSwitch»'''
	}

	
	override String caseTupleConstructor(TupleConstructor object) {
		'''«FOR fol: object.elements BEFORE '(' SEPARATOR ', ' AFTER ')'»«fol.doSwitch»«ENDFOR»'''
	}

	
	override String caseParenthesizedTerm(ParenthesizedTerm object) {
		"(" + object.sub.doSwitch + ")"
	}

	
	override String caseRecordConstructor(RecordConstructor object) {
		'''«FOR rec: object.elements BEFORE '{' SEPARATOR ', ' AFTER '}'»«rec.doSwitch»«ENDFOR»'''
	}

	
	override String caseSymbolReferenceTerm(SymbolReferenceTerm object) {
		object.symbol.name + '''«FOR param: object.typeBinding BEFORE '<' SEPARATOR ', ' AFTER '>'»«param.doSwitch»«ENDFOR»'''
	}

	
	override String caseIteTermExpression(IteTermExpression object) {
		'''if («object.condition.doSwitch») «object.left.doSwitch»«IF object.right!==null»else «object.right.doSwitch»«ENDIF»'''
	}

	
	override String caseCaseTermExpression(CaseTermExpression object) {
		'''case {«FOR cas:object.cases» «cas.doSwitch»:«object.expressions.get(object.cases.indexOf(cas)).doSwitch»;«ENDFOR»}'''
	}

	
	override String caseSequenceTerm(SequenceTerm object) {
		'''{ 	«FOR va:object.defs»var «va.doSwitch»;«ENDFOR»
	«object.^return.doSwitch»;
}'''
	}
	
	override doSwitch(EObject eObject) {
		if (eObject === null) return ""
		else return super.doSwitch(eObject)
	}
	
	def String forMap(List<EObject> list, String before, String sep, String after) {
		'''«FOR param:list BEFORE before SEPARATOR sep AFTER after»«doSwitch(param)»«ENDFOR»'''
	}
	
}