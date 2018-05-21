package com.utc.utrc.hermes.iml.generator.strategies

import com.utc.utrc.hermes.iml.generator.infra.SExpr
import com.utc.utrc.hermes.iml.generator.infra.SExprTokens
import com.utc.utrc.hermes.iml.generator.infra.SrlHigherOrderTypeSymbol
import com.utc.utrc.hermes.iml.generator.infra.SrlNamedTypeSymbol
import com.utc.utrc.hermes.iml.generator.infra.SrlObjectSymbol
import static com.utc.utrc.hermes.iml.generator.infra.SExprTokens.*

//TODO Should implement an interface which we don't have yet
class RecordEncoder {

	def public SExpr encode(SrlNamedTypeSymbol ts) {

		if (ts.symbols.size > 0) {
			// Each named type is annotated	
			var retval = createSequence(EXCLAMATION_POINT, DECLARE_DATATYPE)
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

	def public SExpr encode(SrlHigherOrderTypeSymbol ts) {
	}

}
