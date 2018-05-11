package com.utc.utrc.hermes.iml.generator.infra;

import com.google.inject.Inject;
import com.utc.utrc.hermes.iml.iml.Alias;
import com.utc.utrc.hermes.iml.iml.ArrayType;
import com.utc.utrc.hermes.iml.iml.ConstrainedType;
import com.utc.utrc.hermes.iml.iml.Extension;
import com.utc.utrc.hermes.iml.iml.HigherOrderType;
import com.utc.utrc.hermes.iml.iml.MetaRelaion;
import com.utc.utrc.hermes.iml.iml.Model;
import com.utc.utrc.hermes.iml.iml.RelationInstance;
import com.utc.utrc.hermes.iml.iml.SimpleTypeReference;
import com.utc.utrc.hermes.iml.iml.Symbol;
import com.utc.utrc.hermes.iml.iml.SymbolDeclaration;
import com.utc.utrc.hermes.iml.iml.TermExpression;
import com.utc.utrc.hermes.iml.iml.TupleType;

public class Iml2Symbolic {
	
	@Inject SrlFactory factory;
	
	private SymbolTable table ;
	
	public Iml2Symbolic() {
		table = new SymbolTable();
	}

	public SrlSymbol encode(Model m) throws SrlSymbolException {
		SrlModelSymbol retval = factory.createModelSymbol(m);
		for (Symbol s : m.getSymbols()) {
			if (s instanceof ConstrainedType) {
				SrlTypeSymbol t = encode((ConstrainedType) s);
				retval.getTypes().add(t);
			} else if (s instanceof SymbolDeclaration) {
				SrlObjectSymbol t = encode((SymbolDeclaration) s);
				retval.getSymbols().add(t);
			}
		}
		return retval;
	}

	public SrlTypeSymbol encode(ConstrainedType t) throws SrlSymbolException {
		SrlNamedTypeSymbol retval = factory.createNamedTypeSymbol(t);
		if (table.isDefined(retval)) {
			return (SrlNamedTypeSymbol) table.getSymbols().get(retval).getSymbol() ;
		}
		setModifiers(retval, t);
		addProperties(retval, t);
		addConstants(retval, t);
		addParameters(retval, t);
		addRelations(retval, t);
		addSymbols(retval, t);
		table.add(retval, new EncodedSymbol(retval, null));
		return retval;
	}

	public SrlObjectSymbol encode(SymbolDeclaration s) throws SrlSymbolException {
		SrlObjectSymbol retval = factory.createObjectSymbol(s);
		retval.setType(encode(s.getType()));
		addProperties(retval,s);
		//TODO Add Definition
		return retval;
	}

	public SrlObjectSymbol encode(RelationInstance r) throws SrlSymbolException {
		SrlObjectSymbol retval = factory.createObjectSymbol();
		retval.setId(r);
		if (r instanceof Extension) {
			Extension re = (Extension) r;
			retval.setType(encode(re.getTarget()));
		} else if (r instanceof Alias) {
			Alias ra = (Alias) r;
			retval.setType(encode(ra.getTarget()));
		} else {
			MetaRelaion rm = (MetaRelaion) r;
			retval.setType(encode(rm.getTarget()));
			for (SymbolDeclaration sd : rm.getPropertylist().getProperties()) {
				retval.getProperties().add(encode(sd));
			}
		}
		return retval;
	}
	
	public SrlTypeSymbol encode(HigherOrderType t) throws SrlSymbolException {
		//If already encoded, return it
		SrlSymbolId id = factory.createSymbolId(t);
		if (table.isDefined(id)) {
			return (SrlTypeSymbol) table.getSymbols().get(id).getSymbol();
		}
		//This is a new symbol		
		SrlTypeSymbol s = null ;
		if (t instanceof SimpleTypeReference) {
			SrlHigherOrderTypeSymbol h = factory.createHigherOrderTypeSymbol(t);
			SimpleTypeReference str = (SimpleTypeReference) t ;
			h.setDomain( encode(str.getRef()) );
			for(HigherOrderType param : str.getTypeBinding()) {
				h.getBindings().add(encode(param)) ;
			}
			s = h;
		} else if (t instanceof ArrayType) {
			ArrayType at = (ArrayType) t ;
			SrlHigherOrderTypeSymbol h = factory.createHigherOrderTypeSymbol(at) ; 
			h.setDomain(encode(at.getType())); 
			for(TermExpression e : at.getDimension()) {
				//TODO Compile terms
				h.getDimensions().add(factory.createTerm(e)) ;
			}
			s = h ;
		} else if (t instanceof TupleType) {
			TupleType tt = (TupleType) t ;
			SrlHigherOrderTypeSymbol h = factory.createHigherOrderTypeSymbol(tt);
			for(SymbolDeclaration d : tt.getSymbols()) {
				h.getTupleElements().add(encode(d));
			}
			s = h;
		}
		table.add(s, new EncodedSymbol(s, null));
		return s;
	}

	public void setModifiers(SrlNamedTypeSymbol s, ConstrainedType t) {
		if (t.isMeta())
			s.addModifier(SrlTypeModifier.META);
		if (t.isFinite())
			s.addModifier(SrlTypeModifier.FINITE);
		if (t.getTypeParameter().size() > 0)
			s.addModifier(SrlTypeModifier.TEMPLATE);
	}

	public void addProperties(SrlNamedTypeSymbol s, ConstrainedType t) throws SrlSymbolException {
		if (t.getPropertylist() == null ) return;
		for (SymbolDeclaration sd : t.getPropertylist().getProperties()) {
			s.getProperties().add(encode(sd));
		}
	}

	public void addConstants(SrlNamedTypeSymbol s, ConstrainedType t) throws SrlSymbolException {
		if (s.isFinite()) {
			// A finite type can have a list of constants or a cardinality constraint
			if (t.getLiterals().size() > 0) {
				for (SymbolDeclaration sd : t.getLiterals()) {
					s.getProperties().add(encode(sd));
				}
			} else {
				// This finite type has been defined with a cardinality constraint
				SrlHigherOrderTypeSymbol thisType = factory.createHigherOrderTypeSymbol();
				thisType.setDomain(s);
				thisType.setName(s.getName());
				for (int i = 0; i < t.getCardinality(); i++) {
					SrlObjectSymbol c = factory.createObjectSymbol();
					c.setType(thisType);
					c.setContainer(t);
					c.setName("@" + i);
				}
			}
		}
	}

	public void addParameters(SrlNamedTypeSymbol s, ConstrainedType t) throws SrlSymbolException {
		for (ConstrainedType p : t.getTypeParameter()) {
			SrlNamedTypeSymbol pt = factory.createNamedTypeSymbol(p);
			s.getParameters().add(pt);
		}
	}

	public void addRelations(SrlNamedTypeSymbol s, ConstrainedType t) throws SrlSymbolException {
		for (RelationInstance r : t.getRelations()) {
			s.getRelations().add(encode(r));
		}
	}

	public void addSymbols(SrlNamedTypeSymbol s, ConstrainedType t) throws SrlSymbolException {
		for (SymbolDeclaration sd : t.getSymbols()) {
			s.getSymbols().add(encode(sd));
		}
	}
	
	public void addProperties(SrlObjectSymbol s, SymbolDeclaration sd) throws SrlSymbolException {
		if (sd.getPropertylist() == null) return;
		for (SymbolDeclaration ssd : sd.getPropertylist().getProperties()) {
			s.getProperties().add(encode(ssd));
		}
	}
	
	public SymbolTable getSymbolTable() {
		return table;
	}
	
}
