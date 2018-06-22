package com.utc.utrc.hermes.iml.custom;

import com.utc.utrc.hermes.iml.iml.FolFormula;
import com.utc.utrc.hermes.iml.iml.SymbolDeclaration;
import com.utc.utrc.hermes.iml.iml.SymbolReferenceTerm;
import com.utc.utrc.hermes.iml.iml.TermExpression;
import com.utc.utrc.hermes.iml.iml.TermMemberSelection;
import com.utc.utrc.hermes.iml.iml.impl.ImlFactoryImpl;

public class ImlCustomFactory extends ImlFactoryImpl {
	public static ImlCustomFactory INST = new ImlCustomFactory();

	public TermMemberSelection createTermMemberSelection(SymbolDeclaration receiver, SymbolDeclaration member) {
		TermMemberSelection termMemberSelection = createTermMemberSelection();
		termMemberSelection.setReceiver(createSymbolReferenceTerm(receiver));
		termMemberSelection.setMember(createSymbolReferenceTerm(member));
		return termMemberSelection;
	}

	public TermExpression createSymbolReferenceTerm(SymbolDeclaration symbol) {
		SymbolReferenceTerm symbolRef = createSymbolReferenceTerm();
		symbolRef.setSymbol(symbol);
		return symbolRef;
	}

	public TermMemberSelection createTermMemberSelection(TermMemberSelection reciever, SymbolDeclaration member) {
		TermMemberSelection termMemberSelection = createTermMemberSelection();
		termMemberSelection.setReceiver(reciever);
		termMemberSelection.setMember(createSymbolReferenceTerm(member));
		return termMemberSelection;
	}

}
