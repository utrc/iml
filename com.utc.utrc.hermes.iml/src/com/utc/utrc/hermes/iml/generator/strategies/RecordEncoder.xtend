package com.utc.utrc.hermes.iml.generator.strategies

import com.utc.utrc.hermes.iml.generator.infra.SExpr
import com.utc.utrc.hermes.iml.generator.infra.SExprTokens
import com.utc.utrc.hermes.iml.generator.infra.SrlHigherOrderTypeSymbol
import com.utc.utrc.hermes.iml.generator.infra.SrlNamedTypeSymbol
import com.utc.utrc.hermes.iml.generator.infra.SrlObjectSymbol
import static com.utc.utrc.hermes.iml.generator.infra.SExprTokens.*
import java.util.List
import java.util.ArrayList
import com.utc.utrc.hermes.iml.generator.infra.SrlTerm
import com.utc.utrc.hermes.iml.iml.SignedAtomicFormula
import com.utc.utrc.hermes.iml.iml.SymbolReferenceTerm
import com.utc.utrc.hermes.iml.iml.NumberLiteral
import com.utc.utrc.hermes.iml.iml.FloatNumberLiteral
import com.utc.utrc.hermes.iml.iml.AtomicExpression
import com.utc.utrc.hermes.iml.iml.RelationKind
import com.utc.utrc.hermes.iml.iml.Addition
import com.utc.utrc.hermes.iml.iml.Multiplication
import com.utc.utrc.hermes.iml.iml.TruthValue

//TODO Should implement an interface which we don't have yet
class RecordEncoder {

	def public List<SExpr> encode(SrlNamedTypeSymbol ts) {
		val retval = new ArrayList<SExpr>();

		retval.add(createDeclarationExpr(ts))
		
		for (symbol : ts.symbols) {
			if (symbol.definition !== null) {
				retval.add(createDefinationExpr(symbol, ts))
			}
		}
		
		return retval;
	}
	
	def createDeclarationExpr(SrlNamedTypeSymbol ts) {
		if (ts.symbols.size > 0) {
			// Each named type is annotated	
			var retval = createSequence(EXCLAMATION_POINT, DECLARE_DATATYPES)
			// Add the list of data types (in this case only one)
			var typelist = createSequence;
			addToSequence(retval, typelist);
			var thistype = createSequence(createToken(ts.stringId), createToken(ts.parameters.size));
			addToSequence(typelist, thistype);
			// Need to add symbols
			var constructorlist = createSequence;
			addToSequence(retval, constructorlist);
			var thisconstructorlist = createSequence;
			addToSequence(constructorlist, thisconstructorlist);
			addToSequence(thisconstructorlist, REC_CONS);
			for (SrlObjectSymbol s : ts.symbols) {
				addToSequence(thisconstructorlist, createSequence(createToken(s.name), createToken(s.type.stringId)))
			}
			if (ts.isMeta) {
				retval.sexprs.add(SExprTokens.META);
			}
			retval.sexprs.add(SExprTokens.TYPE);
			return retval;
		} else {
			var retval = createSequence(EXCLAMATION_POINT, DECLARE_SORT) ;
			addToSequence(retval,createToken(ts.stringId), createToken(ts.parameters.size))
			if (ts.isMeta) {
				retval.sexprs.add(SExprTokens.META);
			}
			retval.sexprs.add(SExprTokens.TYPE);
			return retval;
		}
	}
	
	def createDefinationExpr(SrlObjectSymbol symbol, SrlNamedTypeSymbol context) {
		if (symbol.definition !== null) {
			val retval = createSequence(ASSERT)
			val forAll = createSequence(EXCLAMATION_POINT, FOR_ALL)
			addToSequence(retval, forAll)
			// ForAll quantifier parameters
			val varName = "__" + context.name.toLowerCase + "__"
			addToSequence(forAll, createSequence(createSequence(createToken(varName), createToken(context.stringId))))
			// Add the definition
			addToSequence(forAll, createSequence(EQ, createSequence(createToken(symbol.name), createToken(varName)), encode(symbol.definition)))
			// Meta property for the definition
			addToSequence(forAll, DEFINES, createSequence(createToken(symbol.stringId)))
			
			return retval
		}
		
	}

	def public SExpr encode(SrlHigherOrderTypeSymbol ts) {
		
	}
	
	def public SExpr encode(SrlTerm ts) {
		if (ts.formula !== null) {
			return encodeFormula(ts.formula)			
		}
	}

	def dispatch SExpr encodeFormula(SymbolReferenceTerm symbolRef) {
		return createToken(symbolRef.symbol.name) // TODO Test
	}
	
	def dispatch SExpr encodeFormula(NumberLiteral num) {
		var retval = createToken(num.value)
		if (num.isNeg) {
			return createSequence(NEG, retval)
		} else {
			return retval
		}
	}
	
	def dispatch SExpr encodeFormula(FloatNumberLiteral num) {
		var retval = createToken(num.value)
		if (num.isNeg) {
			return createSequence(NEG, retval)
		} else {
			return retval
		}
	}
	
	
	def dispatch SExpr encodeFormula(AtomicExpression expr) {
		return createSequence(createRelationToken(expr.rel), encodeFormula(expr.left), encodeFormula(expr.right))
	}
	
	def dispatch SExpr encodeFormula(Addition expr) {
		createSequence(createArithmeticOperator(expr.sign), encodeFormula(expr.left), encodeFormula(expr.right))
	}
	
	def dispatch SExpr encodeFormula(Multiplication expr) {
		createSequence(createArithmeticOperator(expr.sign), encodeFormula(expr.left), encodeFormula(expr.right))
	}
	
	def dispatch SExpr encodeFormula(TruthValue value) {
		var boolValue = false;
		if (value.isTRUE) {
			boolValue = true;
		}
		return createToken(boolValue)
	}
	
	def createArithmeticOperator(String sign) {
		// TODO create our own relation?
		return createToken(sign)
	}
	
	def createRelationToken(RelationKind kind) {
		// TODO create our own relation kinds?
		return createToken(kind.literal)
	}
	
	def dispatch SExpr encodeFormula(SignedAtomicFormula formula) {
		var retval = encodeFormula(formula.left)
		if (formula.isNeg) {
			retval = createSequence(NOT, retval)
		}
		return retval
	}
	
	
}
