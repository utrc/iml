package com.utc.utrc.hermes.iml.generator.infra;

import com.utc.utrc.hermes.iml.iml.Alias;
import com.utc.utrc.hermes.iml.iml.ConstrainedType;
import com.utc.utrc.hermes.iml.iml.Extension;
import com.utc.utrc.hermes.iml.iml.HigherOrderType;
import com.utc.utrc.hermes.iml.iml.MetaRelaion;
import com.utc.utrc.hermes.iml.iml.Model;
import com.utc.utrc.hermes.iml.iml.RelationInstance;
import com.utc.utrc.hermes.iml.iml.Symbol;
import com.utc.utrc.hermes.iml.iml.SymbolDeclaration;

public class Iml2Symbolic {

	
	public Iml2Symbolic() {

	}

	public SrlSymbol encode(Model m) throws SrlSymbolException {
		SrlModelSymbol retval = new SrlModelSymbol(m);
		for (Symbol s : m.getSymbols()) {
			if (s instanceof ConstrainedType) {
				SrlNamedTypeSymbol t = encode((ConstrainedType) s);
				retval.getTypes().add(t);
			} else if (s instanceof SymbolDeclaration) {
				SrlObjectSymbol t = encode((SymbolDeclaration) s);
				retval.getSymbols().add(t);
			}
		}
		return retval;
	}

	public SrlNamedTypeSymbol encode(ConstrainedType t) throws SrlSymbolException {
		SrlNamedTypeSymbol retval = new SrlNamedTypeSymbol(t);
		setModifiers(retval, t);
		addProperties(retval, t);
		addConstants(retval, t);
		addParameters(retval, t);
		addRelations(retval, t);
		addSymbols(retval, t);
		return retval;
	}

	public SrlObjectSymbol encode(SymbolDeclaration s) {
		SrlObjectSymbol retval = new SrlObjectSymbol(s);
		retval.setType(encode(s.getType()));
		addProperties(retval,s);
		//TODO Add Definition
		return retval;
	}

	public SrlObjectSymbol encode(RelationInstance r) {
		SrlObjectSymbol retval = new SrlObjectSymbol();
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
	
	public SrlHigherOrderTypeSymbol encode(HigherOrderType t) {
		//TODO
		return null;
	}

	public void setModifiers(SrlNamedTypeSymbol s, ConstrainedType t) {
		if (t.isMeta())
			s.addModifier(SrlTypeModifier.META);
		if (t.isFinite())
			s.addModifier(SrlTypeModifier.FINITE);
		if (t.getTypeParameter().size() > 0)
			s.addModifier(SrlTypeModifier.TEMPLATE);
	}

	public void addProperties(SrlNamedTypeSymbol s, ConstrainedType t) {
		for (SymbolDeclaration sd : t.getPropertylist().getProperties()) {
			s.getProperties().add(encode(sd));
		}
	}

	public void addConstants(SrlNamedTypeSymbol s, ConstrainedType t) {
		if (s.isFinite()) {
			// A finite type can have a list of constants or a cardinality constraint
			if (t.getLiterals().size() > 0) {
				for (SymbolDeclaration sd : t.getLiterals()) {
					s.getProperties().add(encode(sd));
				}
			} else {
				// This finite type has been defined with a cardinality constraint
				SrlHigherOrderTypeSymbol thisType = new SrlHigherOrderTypeSymbol();
				thisType.setDomain(s);
				thisType.setName(s.getName());
				for (int i = 0; i < t.getCardinality(); i++) {
					SrlObjectSymbol c = new SrlObjectSymbol();
					c.setType(thisType);
					c.setContainer(t);
					c.setName("@" + i);
				}
			}
		}
	}

	public void addParameters(SrlNamedTypeSymbol s, ConstrainedType t) throws SrlSymbolException {
		for (ConstrainedType p : t.getTypeParameter()) {
			SrlNamedTypeSymbol pt = new SrlNamedTypeSymbol(p);
			s.getParameters().add(pt);
		}
	}

	public void addRelations(SrlNamedTypeSymbol s, ConstrainedType t) {
		for (RelationInstance r : t.getRelations()) {
			s.getRelations().add(encode(r));
		}
	}

	public void addSymbols(SrlNamedTypeSymbol s, ConstrainedType t) {
		for (SymbolDeclaration sd : t.getSymbols()) {
			s.getSymbols().add(encode(sd));
		}
	}
	
	public void addProperties(SrlObjectSymbol s, SymbolDeclaration sd) {
		for (SymbolDeclaration ssd : sd.getPropertylist().getProperties()) {
			s.getProperties().add(encode(ssd));
		}
	}
}
