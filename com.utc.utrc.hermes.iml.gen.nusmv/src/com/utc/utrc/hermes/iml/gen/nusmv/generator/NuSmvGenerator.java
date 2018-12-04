package com.utc.utrc.hermes.iml.gen.nusmv.generator;

import com.utc.utrc.hermes.iml.gen.nusmv.model.NuSmvConstraint;
import com.utc.utrc.hermes.iml.gen.nusmv.model.NuSmvElementType;
import com.utc.utrc.hermes.iml.gen.nusmv.model.NuSmvModel;
import com.utc.utrc.hermes.iml.gen.nusmv.model.NuSmvModule;
import com.utc.utrc.hermes.iml.gen.nusmv.model.NuSmvSymbol;
import com.utc.utrc.hermes.iml.gen.nusmv.model.NuSmvTypeInstance;
import com.utc.utrc.hermes.iml.gen.nusmv.model.NuSmvVariable;
import com.utc.utrc.hermes.iml.iml.Assertion;
import com.utc.utrc.hermes.iml.iml.ConstrainedType;
import com.utc.utrc.hermes.iml.iml.Extension;
import com.utc.utrc.hermes.iml.iml.FolFormula;
import com.utc.utrc.hermes.iml.iml.HigherOrderType;
import com.utc.utrc.hermes.iml.iml.Model;
import com.utc.utrc.hermes.iml.iml.Relation;
import com.utc.utrc.hermes.iml.iml.SignedAtomicFormula;
import com.utc.utrc.hermes.iml.iml.SimpleTypeReference;
import com.utc.utrc.hermes.iml.iml.Symbol;
import com.utc.utrc.hermes.iml.iml.SymbolDeclaration;
import com.utc.utrc.hermes.iml.iml.SymbolReferenceTerm;
import com.utc.utrc.hermes.iml.iml.TermExpression;
import com.utc.utrc.hermes.iml.iml.TermMemberSelection;
import com.utc.utrc.hermes.iml.iml.TupleConstructor;
import com.utc.utrc.hermes.iml.iml.TypeWithProperties;
import com.utc.utrc.hermes.iml.typing.ImlTypeProvider;
import com.utc.utrc.hermes.iml.util.Phi;

import static com.utc.utrc.hermes.iml.gen.nusmv.generator.NuSmvGeneratorServices.*;
import static com.utc.utrc.hermes.iml.gen.nusmv.generator.NuSmvTranslationProvider.*;

public class NuSmvGenerator {

	private StandardLibProvider libs;

	private class NuSmvConnection {
		public String target_machine;
		public String target_input;
		public String source;
	}

	public NuSmvGenerator(StandardLibProvider libs) {
		this.libs = libs;
	}

	public NuSmvModule generateType(NuSmvModel m, HigherOrderType tr) {
		if (tr instanceof SimpleTypeReference) {
			return generateType(m, (SimpleTypeReference) tr);
		}
		return (new NuSmvModule(m, "HIGHER_HORDER_TYPE_NOT_SUPPORTED"));
	}

	public NuSmvModule generateType(NuSmvModel m, SimpleTypeReference tr) {
		String type_name = getNameFor(tr);
		if (m.hasType(type_name))
			return m.getType(type_name);
		if (isEnum(tr.getType())) {
			return generateEnumType(m, tr.getType());
		} else {
			
			for (HigherOrderType b : tr.getTypeBinding()) {
				generateType(m, b);
			}
			NuSmvModule target = new NuSmvModule(type_name);
			m.addModule(target);
			addSymbols(target, tr);
			return target;
		}
	}
	
	private void addSymbols(NuSmvModule target, SimpleTypeReference tr) {
			
		if (tr.getType().getRelations() != null) {
			for(Relation r : tr.getType().getRelations()) {
				if (r instanceof Extension) {
					for(TypeWithProperties p : ((Extension) r).getExtensions()) {
						//generate the type
						NuSmvModule added = generateType(target.getContainer(), ImlTypeProvider.bind(p.getType(), tr)) ;
						for(NuSmvSymbol s : added.getParameters()) {
							target.addSymbol(s);
						}
						for(NuSmvSymbol s : added.getVariables().values()) {
							target.addSymbol(s);
						}
						for(NuSmvSymbol s : added.getDefinitions().values()) {
							target.addSymbol(s);
						}
						for(NuSmvSymbol s : added.getInits().values()) {
							target.addSymbol(s);
						}
						for(NuSmvSymbol s : added.getTrans().values()) {
							target.addSymbol(s);
						}
						for(NuSmvSymbol s : added.getInvar().values()) {
							target.addSymbol(s);
						}
					}
				}
			}
		}

		
		for (Symbol s : tr.getType().getSymbols()) {
			if (s instanceof SymbolDeclaration && ! isConnector((SymbolDeclaration) s)) {
				SymbolDeclaration sd = (SymbolDeclaration) s;
				generateSymbolDeclaration(target, sd, tr);
			}
		}
		
		
		for (Symbol s : tr.getType().getSymbols()) {
			if (s instanceof SymbolDeclaration && isConnector((SymbolDeclaration) s)) {
				SymbolDeclaration sd = (SymbolDeclaration) s;
				generateSymbolDeclaration(target, sd, tr);
			}
		}
		
		
	}

	private NuSmvModule generateEnumType(NuSmvModel m, ConstrainedType type) {
		NuSmvModule target = new NuSmvModule(qualifiedName(type));
		m.addModule(target);
		target.setEnum(true);
		target.getLiterals().addAll(getLiterals(type));
		return target;
	}

	private NuSmvSymbol generateSymbolDeclaration(NuSmvModule m, SymbolDeclaration sd, SimpleTypeReference ctx) {
			
		HigherOrderType bound = null;
		String name = null;
		if (sd instanceof Assertion) {
			if (sd.getName() != null) {
				name = sd.getName();
			} else {
				name = m.getContainer().newSymbolName();
			}
			bound = ImlTypeProvider.ct2hot(libs.getImlType("iml.lang.Bool"));
		} else {
			name = sd.getName();
			bound = ImlTypeProvider.bind(sd.getType(), ctx);
		}

		NuSmvSymbol target = new NuSmvSymbol(name);

		// Generate the type
		// Decide on the element type
		if (isInput(sd)) {
			NuSmvModule nbound = generateType(m.getContainer(), bound);
			NuSmvTypeInstance ti = new NuSmvTypeInstance(nbound);
			target.setType(ti);
			target.setElementType(NuSmvElementType.PARAMETER);
			m.addSymbol(target);
		} else if (isOutput(sd)) {
			NuSmvModule nbound = generateType(m.getContainer(), bound);
			NuSmvTypeInstance ti = new NuSmvTypeInstance(nbound);
			target.setType(ti);
			if (sd.getDefinition() != null) {
				target.setDefinition(serialize(sd.getDefinition(),ctx));
				target.setElementType(NuSmvElementType.DEFINE);
			} else {
				target.setElementType(NuSmvElementType.VAR);
			}
			m.addSymbol(target);
		} else if (isInit(sd)) {
			NuSmvModule nbound = generateType(m.getContainer(), bound);
			NuSmvTypeInstance ti = new NuSmvTypeInstance(nbound);
			target.setType(ti);
			target.setElementType(NuSmvElementType.INIT);
			target.setDefinition(serialize(sd.getDefinition(),ctx));
			m.addSymbol(target);
		} else if (isTransition(sd)) {
			NuSmvModule nbound = generateType(m.getContainer(), bound);
			NuSmvTypeInstance ti = new NuSmvTypeInstance(nbound);
			target.setType(ti);
			target.setElementType(NuSmvElementType.TRANSITION);
			target.setDefinition(serialize(sd.getDefinition(),ctx));
			m.addSymbol(target);
		} else if (isConnector(sd)) {
			NuSmvConnection conn = getConnection(m, sd,ctx);
			// If this is a connection to an output of the current machine
			// simply add a define
			if (conn.target_machine == null) {
				//Need to take the output symbol
				NuSmvSymbol out = m.getVariables().get(conn.target_input) ;
				if (out != null) {
					NuSmvSymbol toadd = new NuSmvSymbol("") ;
					FolFormula def = 
							Phi.eq(
									(TermExpression) ((TupleConstructor) ((SymbolReferenceTerm)sd.getDefinition().getLeft()).getTails().get(0)).getElements().get(0).getLeft(), 
									(TermExpression) ((TupleConstructor) ((SymbolReferenceTerm)sd.getDefinition().getLeft()).getTails().get(0)).getElements().get(1).getLeft()
									) ;
					toadd.setName(m.getContainer().newSymbolName());
					toadd.setElementType(NuSmvElementType.INVAR);
					toadd.setDefinition(serialize(def,ctx));
					m.addSymbol(toadd);
				}
			} else {
				// otherwise
				NuSmvSymbol machine = m.getVariables().get(conn.target_machine);
				if (machine != null) {
					int index = machine.getType().getType().paramIndex(conn.target_input);
					if (index != -1) {
						NuSmvVariable param = new NuSmvVariable(conn.source);
						machine.getType().setParam(index, param);
						;
					}
				}
			}

			return null;
		} else if (isState(sd)) {
			NuSmvModule ti = generateType(m.getContainer(),
					ImlTypeProvider.bind(((SimpleTypeReference) sd.getType()).getTypeBinding().get(0), ctx));
			target.setType(new NuSmvTypeInstance(ti));
			target.setElementType(NuSmvElementType.VAR);
			m.addSymbol(target);
		} else if (sd instanceof Assertion) {
			NuSmvModule nbound = generateType(m.getContainer(), bound);
			NuSmvTypeInstance ti = new NuSmvTypeInstance(nbound);
			target.setType(ti);
			target.setElementType(NuSmvElementType.INVAR);
			target.setDefinition(serialize(sd.getDefinition(),ctx));
			m.addSymbol(target);
		} else {
			NuSmvModule nbound = generateType(m.getContainer(), bound);
			NuSmvTypeInstance ti = new NuSmvTypeInstance(nbound);
			target.setType(ti);
			target.setElementType(NuSmvElementType.VAR);
			m.addSymbol(target);
		}
		return target;
	}

	private NuSmvConnection getConnection(NuSmvModule m, SymbolDeclaration sd, SimpleTypeReference ctx) {
		// At this point we know that this is a connector
		// Get the definition which is expected to be a function
		NuSmvConnection retval = new NuSmvConnection();
		retval.source = "UNNAMED_SOURCE";
		FolFormula f = sd.getDefinition();
		if (f instanceof SignedAtomicFormula) {
			FolFormula f1 = f.getLeft();
			if (f1 instanceof SymbolReferenceTerm) {
				SymbolReferenceTerm connect = (SymbolReferenceTerm) f1;
				// get the source and destination
				if (connect.getTails().size() >= 1) {
					FolFormula sourcef = ((TupleConstructor) connect.getTails().get(0)).getElements().get(0).getLeft();
					FolFormula destf = ((TupleConstructor) connect.getTails().get(0)).getElements().get(1).getLeft();
					retval.source = serialize(sourcef,ctx);
					String dest_tmp = serialize(destf,ctx);
					int lastindex = dest_tmp.lastIndexOf('.');
					if (lastindex == -1) {
						retval.target_input = dest_tmp;
						retval.target_machine = null;

					} else {
						retval.target_machine = dest_tmp.substring(0, lastindex);
						retval.target_input = dest_tmp.substring(lastindex + 1);
					}
				}
			}
		}

		return retval;
	}
	

	public boolean isInput(SymbolDeclaration s) {
		return NuSmvTranslationProvider.isA(s, libs.getImlType("iml.connectivity.Input"));
	}

	public boolean isOutput(SymbolDeclaration s) {
		return NuSmvTranslationProvider.isA(s, libs.getImlType("iml.connectivity.Output"));
	}

	public boolean isComponent(SymbolDeclaration s) {
		return NuSmvTranslationProvider.isA(s, libs.getImlType("iml.connectivity.Component"));
	}

	public boolean isInit(SymbolDeclaration s) {
		return NuSmvTranslationProvider.isA(s, libs.getImlType("iml.fsm.Init"));
	}

	public boolean isTransition(SymbolDeclaration s) {
		return NuSmvTranslationProvider.isA(s, libs.getImlType("iml.fsm.Transition"));
	}

	public boolean isInvariant(SymbolDeclaration s) {
		return (s instanceof Assertion);
	}

	private boolean isState(SymbolDeclaration sd) {
		return NuSmvTranslationProvider.hasType(sd, libs.getImlType("iml.fsm.PrimedVar"));
	}

	public boolean isConnector(SymbolDeclaration s) {
		return NuSmvTranslationProvider.hasType(s, libs.getImlType("iml.connectivity.Connector"));
	}

	public boolean isSimpleTypeReference(HigherOrderType hot) {
		return (hot instanceof SimpleTypeReference);
	}

}
