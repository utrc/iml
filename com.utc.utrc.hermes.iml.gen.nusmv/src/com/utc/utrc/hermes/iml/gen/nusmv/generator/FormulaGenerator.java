package com.utc.utrc.hermes.iml.gen.nusmv.generator;

import java.util.ArrayList;
import java.util.List;

import com.utc.utrc.hermes.iml.iml.Addition;
import com.utc.utrc.hermes.iml.iml.AtomicExpression;
import com.utc.utrc.hermes.iml.iml.FolFormula;
import com.utc.utrc.hermes.iml.iml.IteTermExpression;
import com.utc.utrc.hermes.iml.iml.Multiplication;
import com.utc.utrc.hermes.iml.iml.SequenceTerm;
import com.utc.utrc.hermes.iml.iml.SignedAtomicFormula;
import com.utc.utrc.hermes.iml.iml.SimpleTypeReference;
import com.utc.utrc.hermes.iml.iml.SymbolReferenceTerm;
import com.utc.utrc.hermes.iml.iml.TermExpression;
import com.utc.utrc.hermes.iml.iml.TermMemberSelection;
import com.utc.utrc.hermes.iml.iml.TupleConstructor;
import com.utc.utrc.hermes.iml.util.AbstractModelAcceptor;
import com.utc.utrc.hermes.iml.util.AbstractModelVisitor;

public class FormulaGenerator {
	static private class FormalGeneratorVisitor extends AbstractModelVisitor {
		private List<TermExpression> terms ;
		public FormalGeneratorVisitor() {
			terms = new ArrayList<TermExpression>();
		}
		
		@Override
		public void visit(FolFormula e) {
			
		}

		@Override
		public void visit(AtomicExpression e) {
		
		}

		@Override
		public void visit(Addition e) {
		
		}


		@Override
		public void visit(Multiplication e) {
			
		}


		@Override
		public void visit(TupleConstructor e) {
		
		}


		@Override
		public void visit(SignedAtomicFormula e) {
			
		}





		@Override
		public void visit(IteTermExpression e) {
		
		}





		@Override
		public void visit(TermMemberSelection e) {
			
		}
		@Override
		public void visit(SymbolReferenceTerm e) {
			
		}
		


		@Override
		public void visit(SequenceTerm e) {
			
		}
		
		
		
	}
	
	static private class FormulaGeneratorAcceptor extends AbstractModelAcceptor {
		public FormulaGeneratorAcceptor() {
			// TODO Auto-generated constructor stub
		}
	}
}
