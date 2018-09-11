package com.utc.utrc.hermes.iml.encoding;

import java.util.ArrayList;
import java.util.List;

import org.eclipse.emf.ecore.EObject;

import com.google.inject.Inject;
import com.utc.utrc.hermes.iml.iml.ArrayType;
import com.utc.utrc.hermes.iml.iml.ConstrainedType;
import com.utc.utrc.hermes.iml.iml.HigherOrderType;
import com.utc.utrc.hermes.iml.iml.Model;
import com.utc.utrc.hermes.iml.iml.OptionalTermExpr;
import com.utc.utrc.hermes.iml.iml.RelationInstance;
import com.utc.utrc.hermes.iml.iml.SimpleTypeReference;
import com.utc.utrc.hermes.iml.iml.Symbol;
import com.utc.utrc.hermes.iml.iml.SymbolDeclaration;
import com.utc.utrc.hermes.iml.iml.TupleType;
import com.utc.utrc.hermes.iml.typing.TypingServices;

public class ImlSmtEncoder<SortT, DeclFunT> implements ImlEncoder {

	@Inject SmtSymbolTable<SortT, DeclFunT> symbolTable;
	@Inject SmtModelProvider<SortT> smtModelProvider;
	
	@Override
	public void encode(ConstrainedType type) {
		defineTypes(type);
	}

	private void defineTypes(ConstrainedType type) {
		if (type.isTemplate()) return;
		
		if (symbolTable.contains(type)) return;
		
		// types[T] <- newSort(T)
		addTypeSort(type);
		
		for (RelationInstance relation : type.getRelations()) {
			defineTypes(relation.getTarget());
		}
		
		for (SymbolDeclaration symbol : type.getSymbols()) {
			defineTypes(symbol.getType());
		}
	}

	private void defineTypes(HigherOrderType type) {
		if (symbolTable.contains(type)) return;
		
		if (type.getRange() != null) {
			defineTypes(type.getDomain());
			defineTypes(type.getRange());
			// TODO add new Function?
			addTypeSort(type);
		} else if (type instanceof ArrayType) {
			ArrayType arrType = (ArrayType) type;
			for (int dim = 0; dim < arrType.getDimensions().size() ; dim++) {
				HigherOrderType currentDim = TypingServices.accessArray(arrType, dim);
				addTypeSort(currentDim);
			}
			defineTypes(arrType.getType());
		} else if (type instanceof TupleType) {
			if (((TupleType) type).getSymbols().size() == 1) { // Tuple with one element TODO provide general solution
				defineTypes(((TupleType) type).getSymbols().get(0).getType());
			} else {
				TupleType tupleType = (TupleType) type;
				for (SymbolDeclaration symbol : tupleType.getSymbols()) {
					defineTypes(symbol.getType());
				}
				addTypeSort(tupleType);
			}
		} else if (type instanceof SimpleTypeReference) {
			addTypeSort(type);
			for (HigherOrderType binding : ((SimpleTypeReference) type).getTypeBinding()) {
				defineTypes(binding);
			}
		} else {
			throw new IllegalArgumentException("Unsupported type: " + type.getClass().getName());
		}
	}

	private SortT addTypeSort(EObject type) {
		String sortName = getUniqueSortName(type);
		SortT sort = null;
		if (type instanceof HigherOrderType && ((HigherOrderType) type).getRange() != null) {
			HigherOrderType hot = (HigherOrderType) type;
			sort = smtModelProvider.createHotSort(sortName, symbolTable.getSort(hot.getDomain()), symbolTable.getSort(hot.getRange()));
		} else if (type instanceof TupleType){
			sort = smtModelProvider.createTupleSort(sortName, getTupleSorts((TupleType) type));
		} else {
			sort = smtModelProvider.createSort(sortName);
		}
		if (sort != null) {
			symbolTable.addSort(type, sort);
		}
		return sort;
	}

	private List<SortT> getTupleSorts(TupleType type) {
		List<SortT> sorts = new ArrayList<>();
		for (SymbolDeclaration symbol : type.getSymbols()) {
			sorts.add(symbolTable.getSort(symbol.getType()));
		}
		return sorts;
	}

	private String getUniqueSortName(EObject type) {
		return symbolTable.getEncodedId(type);
	}

	@Override
	public void encode(HigherOrderType hot) {
		// TODO Auto-generated method stub

	}

	@Override
	public void encode(SymbolDeclaration symbol) {
		// TODO Auto-generated method stub

	}

	@Override
	public void encode(Model model) {
		for (Symbol symbol : model.getSymbols()) {
			encode(symbol);
		}
	}
	
	@Override
	public String toString() {
		StringBuilder sb = new StringBuilder();
		List<SortT> sorts = symbolTable.getSorts();
		
		for (SortT sort : sorts) {
			sb.append(sort + "\n");
		}
		
		return sb.toString();
	}

	@Override
	public void encode(Symbol symbol) {
		if (symbol instanceof ConstrainedType) {
			encode((ConstrainedType) symbol);
		} else {
			encode((SymbolDeclaration) symbol);
		}
	}

}
 