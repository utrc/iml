package com.utc.utrc.hermes.iml.gen.nusmv.generator

import com.utc.utrc.hermes.iml.gen.nusmv.model.NuSmvModel
import com.utc.utrc.hermes.iml.gen.nusmv.model.NuSmvModule
import com.utc.utrc.hermes.iml.gen.nusmv.model.NuSmvSymbol
import com.utc.utrc.hermes.iml.gen.nusmv.model.NuSmvTypeInstance
import com.utc.utrc.hermes.iml.iml.Addition
import com.utc.utrc.hermes.iml.iml.AtomicExpression
import com.utc.utrc.hermes.iml.iml.CaseTermExpression
import com.utc.utrc.hermes.iml.iml.NamedType
import com.utc.utrc.hermes.iml.iml.FolFormula
import com.utc.utrc.hermes.iml.iml.ImlType
import com.utc.utrc.hermes.iml.iml.IteTermExpression
import com.utc.utrc.hermes.iml.iml.Model
import com.utc.utrc.hermes.iml.iml.Multiplication
import com.utc.utrc.hermes.iml.iml.NumberLiteral
import com.utc.utrc.hermes.iml.iml.ParenthesizedTerm
import com.utc.utrc.hermes.iml.iml.SequenceTerm
import com.utc.utrc.hermes.iml.iml.SignedAtomicFormula
import com.utc.utrc.hermes.iml.iml.SimpleTypeReference
import com.utc.utrc.hermes.iml.iml.SymbolReferenceTerm
import com.utc.utrc.hermes.iml.iml.TermMemberSelection
import com.utc.utrc.hermes.iml.iml.TruthValue
import java.util.List
import java.util.ArrayList
import com.utc.utrc.hermes.iml.iml.RelationKind
import com.utc.utrc.hermes.iml.iml.TermExpression
import com.utc.utrc.hermes.iml.typing.ImlTypeProvider
import com.utc.utrc.hermes.iml.iml.Assertion
import com.google.inject.Inject

class NuSmvGeneratorServices {
	
	@Inject
	private ImlTypeProvider typeProvider;

	def String getNameFor(SimpleTypeReference tr) {
		return qualifiedName(tr.getType()) +
			'''«FOR b : tr.typeBinding BEFORE '<' SEPARATOR ',' AFTER '>'» «b.nameFor» «ENDFOR»'''
	}

	def String getNameFor(ImlType imlType) {
		if (imlType instanceof SimpleTypeReference) {
			return (imlType as SimpleTypeReference).nameFor
		}
		return "__NOT__SUPPORTED"
	}

	def String qualifiedName(NamedType t) {
		var typename = t.getName();
		return ( ( t.eContainer() as Model ).getName() + "." + typename);
	}

	def String getNameFor(FolFormula f) {
		if (f instanceof TermMemberSelection) {
			return getNameFor(f as TermMemberSelection);
		}
		if (f instanceof SymbolReferenceTerm) {
			return getNameFor(f as SymbolReferenceTerm);
		}
		return "NO_NAME_FOR_FOLFORMULA";

	}

	def String getNameFor(TermMemberSelection ts) {
		var String rec;
		var String mem;
		if (ts.getReceiver() instanceof SymbolReferenceTerm) {
			rec = getNameFor(ts.getReceiver() as SymbolReferenceTerm);
		} else {
			rec = getNameFor(ts.getReceiver() as TermMemberSelection);
		}
		if (ts.getMember() instanceof SymbolReferenceTerm) {
			mem = getNameFor(ts.getMember() as SymbolReferenceTerm);
		} else {
			mem = getNameFor(ts.getMember() as TermMemberSelection);
		}
		return rec + "." + mem;
	}

	def String getNameFor(SymbolReferenceTerm s) {
		return s.getSymbol().getName();
	}

	def String serialize(NuSmvModel m) {
		'''«FOR mod : m.modules.values AFTER '\n'»«serialize(mod)»«ENDFOR»'''
	}

	def String serialize(NuSmvModule m) {
		if(m.name.equals("iml.lang.Bool") || m.name.equals("iml.lang.Int")) return "";
		if(m.isEnum()) return "";
		'''
			MODULE «toNuSmvName(m)» «FOR p : m.parameters BEFORE '(' SEPARATOR ',' AFTER ')'» «p.name» «ENDFOR»
			«FOR v : m.variables.values AFTER '\n'»«serialize(v)»«ENDFOR» 
			«FOR v : m.inits.values AFTER '\n'»«serialize(v)»«ENDFOR»
			«FOR v : m.trans.values AFTER '\n'»«serialize(v)»«ENDFOR»
			«FOR v : m.definitions.values AFTER '\n'»«serialize(v)»«ENDFOR»
			«FOR v : m.invar.values AFTER '\n'»«serialize(v)»«ENDFOR»
		'''
	}

	def String serialize(NuSmvSymbol s) {
		switch (s.elementType) {
			case VAR: '''
				VAR «s.name» : «serialize(s.type)» «FOR p : s.type.params BEFORE '(' SEPARATOR ',' AFTER ')'»«p.name»«ENDFOR» ;
			'''
			case DEFINE: '''
				DEFINE «s.name» := «s.definition» ;
			'''
			case INIT: '''
				DEFINE «s.name» := «s.definition» ;
				INIT «s.name» ;
			'''
			case INVAR: '''
				INVAR «s.definition»  ;
			'''
			case TRANSITION: '''
				DEFINE «s.name» := «s.definition» ;
				TRANS «s.name» ;
			'''
		}
	}

	def List<String> suffix(NuSmvSymbol s) {
		var retval = new ArrayList<String>();
		for (field : s.type.type.variables.keySet) {
			if (s.type.type.variables.get(field).type.type.name.equals("iml.lang.Bool") ||
				s.type.type.variables.get(field).type.type.name.equals("iml.lang.Int")) {
				retval.add(field);
			} else {
				var tmplist = suffix(s.type.type.variables.get(field))
				for (ssuffix : tmplist) {
					retval.add(field + ssuffix);
				}
			}
		}
		return retval;
	}

	def List<String> suffix(NuSmvTypeInstance s) {
		var retval = new ArrayList<String>();
		for (field : s.type.variables.keySet) {
			if (s.type.variables.get(field).type.type.name.equals("iml.lang.Bool") ||
				s.type.variables.get(field).type.type.name.equals("iml.lang.Int")) {
				retval.add(field);
			} else {
				var tmplist = suffix(s.type.variables.get(field))
				for (ssuffix : tmplist) {
					retval.add(field + ssuffix);
				}
			}
		}
		return retval;
	}

	def String serialize(NuSmvTypeInstance i) {
		if (! i.type.enum) {
			return toNuSmvName(i.type);
		}
		'''«FOR l : i.type.literals BEFORE '{' SEPARATOR ',' AFTER '}'»«toNuSmvName(i.type,l)»«ENDFOR»'''
	}

	def String serialize(FolFormula e, SimpleTypeReference ctx) {
		var String retval = "";
		if (e.getOp() !== null &&
			(e.getOp().equals("=>") || e.getOp().equals("<=>") || e.getOp().equals("&&") || e.getOp().equals("||"))) {
			retval = '''«serialize(e.left,ctx)»  «convertOp(e.op)»  «serialize(e.right,ctx)» ''';
		} else if (e instanceof AtomicExpression) {

			if (e.rel === RelationKind.EQ) {
				var suff = getSuffix(e.left,ctx);
				if (suff.empty) {
					retval = '''«serialize(e.left,ctx)»«e.rel.toString»  «serialize(e.right,ctx)»'''
				} else {
					retval = '''«FOR suffix : suff SEPARATOR " & "» «serialize(e.left,ctx)»«suffix» «e.rel.toString»  «serialize(e.right,ctx)»«suffix» «ENDFOR»'''
				}
			} else {
				retval = ''' «serialize(e.left,ctx)» «e.rel.toString»  «serialize(e.right,ctx)» ''';
			}
		} else if (e instanceof Addition) {
			retval = ''' «serialize(e.left,ctx)» «e.sign» «serialize(e.right,ctx)»'''
		} else if (e instanceof Multiplication) {
			retval = ''' «serialize(e.left,ctx)» «e.sign» «serialize(e.right,ctx)»'''
		} else if (e instanceof TermMemberSelection) {
			// TODO this is a quick hack
			if (e.receiver instanceof SymbolReferenceTerm &&
				(e.receiver as SymbolReferenceTerm).symbol instanceof NamedType) {
				var typename = qualifiedName((e.receiver as SymbolReferenceTerm).symbol as NamedType);
				var literalname = serialize(e.member,ctx);
				retval = '''"«typename».«literalname»"'''
			} else {
				var rec = serialize(e.receiver,ctx);
				var mem = serialize(e.member,ctx);
				if (mem.equals("current")) {
					retval = rec;
				} else if (mem.equals("next")) {
					retval = '''next(«rec»)''';
				} else {
					retval = '''«serialize(e.receiver,ctx)».«serialize(e.member,ctx)»'''
				}
			}
		} else if (e instanceof SymbolReferenceTerm) {
			retval = e.symbol.name;
		} else if (e instanceof ParenthesizedTerm) {
			retval = '''( «serialize(e.sub,ctx)» )'''
		} else if (e instanceof IteTermExpression) {

			if (e.right === null) {
				retval = '''( «serialize(e.condition,ctx)» -> «serialize(e.left,ctx)» )'''
			} else {
				retval = '''( «serialize(e.condition,ctx)» ? «serialize(e.left,ctx)» : «serialize(e.right,ctx)»'''
			}
		} else if (e instanceof CaseTermExpression) {

			retval = '''
				case 
					«FOR index : 0..e.cases.size-1 SEPARATOR ";\n" AFTER ";\n"»«serialize(e.cases.get(index),ctx)» : «serialize(e.expressions.get(index),ctx)»«ENDFOR»
				esac
			'''
		} else if (e instanceof SequenceTerm) {
			retval = '''( «serialize(e.^return,ctx)» )'''
		} else if (e instanceof SignedAtomicFormula) {
			if (e.neg) {
				retval = retval + "!";
			}
			retval = retval + serialize(e.left,ctx);
		} else if (e instanceof NumberLiteral) {
			if (e.isNeg) {
				retval += "-";
			}
			retval = e.value.toString;
		} else if (e instanceof TruthValue) {
			if(e.TRUE) retval = "TRUE" else retval = "FALSE";
		}
		return retval;
	}

	def String convertOp(String op) {
		switch (op) {
			case "&&": "&"
			case "||": "|"
			case "=>": "->"
			case "<=>": "<->"
		}
	}

	def String toNuSmvName(NuSmvModule m) {
		if (m == NuSmvModel.Bool) {
			return "boolean"
		}
		if (m == NuSmvModel.Int) {
			return "0..256";
		}
		return '''"«m.name»"'''
	}

	def String toNuSmvName(NuSmvModule m, String literal) {
		'''"«m.name».«literal»"'''
	}

	def List<String> getSuffix(FolFormula e,SimpleTypeReference ctx) {
		if (e instanceof TermExpression){
			return getSuffix(e as TermExpression,ctx) ;
		} else {
			var retval = new ArrayList<String>();
			retval.add("");
			return retval;
		}
	}

	def List<String> getSuffix(TermExpression e, SimpleTypeReference ctx) {
		var retval = new ArrayList<String>();
		var t = typeProvider.termExpressionType(e,ctx);
		if (qualifiedName((t as SimpleTypeReference).type).equals("iml.fsm.PrimedVar")){
				retval.add("") ;
				return retval;
		} 
		retval.addAll(getSuffix("",t, ctx))
		return retval;
	}

	def List<String> getSuffix(String sofar, ImlType t, SimpleTypeReference ctx) {
		var retval = new ArrayList<String>();
		if (t instanceof SimpleTypeReference) {
			
			for (s : t.type.symbols) {
				if (! (s instanceof Assertion)) {
					var boundtype = typeProvider.bind(s.type,t) ;
					if ( qualifiedName( (boundtype as SimpleTypeReference).type).equals("iml.lang.Bool") || 
						qualifiedName((boundtype as SimpleTypeReference).type).equals("iml.lang.Int") )
							
					{
						retval.add(sofar + "." + s.name) ;
					} else {
						retval.addAll(getSuffix(sofar + "." + s.name,boundtype,ctx)) ;
					}
					
				}
			}

		}
		return retval;
	}

}
