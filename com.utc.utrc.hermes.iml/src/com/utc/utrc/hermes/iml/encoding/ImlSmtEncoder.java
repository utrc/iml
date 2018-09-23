package com.utc.utrc.hermes.iml.encoding;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

import org.eclipse.emf.ecore.EObject;
import org.eclipse.xtext.naming.IQualifiedNameProvider;

import com.google.inject.Inject;
import com.utc.utrc.hermes.iml.iml.Alias;
import com.utc.utrc.hermes.iml.iml.ArrayType;
import com.utc.utrc.hermes.iml.iml.ConstrainedType;
import com.utc.utrc.hermes.iml.iml.Extension;
import com.utc.utrc.hermes.iml.iml.HigherOrderType;
import com.utc.utrc.hermes.iml.iml.Model;
import com.utc.utrc.hermes.iml.iml.RelationInstance;
import com.utc.utrc.hermes.iml.iml.SimpleTypeReference;
import com.utc.utrc.hermes.iml.iml.Symbol;
import com.utc.utrc.hermes.iml.iml.SymbolDeclaration;
import com.utc.utrc.hermes.iml.iml.TupleType;
import com.utc.utrc.hermes.iml.typing.ImlTypeProvider;
import com.utc.utrc.hermes.iml.typing.TypingServices;
import com.utc.utrc.hermes.iml.util.ImlUtils;

/**
 * SMT implementation for {@link ImlEncoder}. The encoder is build for SMT v2.5
 * The encoder abstract the underlaying SMT model by using {@link SmtModelProvider}
 * 
 * @author elkfraaf
 *
 * @param <SortT> the model class for SMT sort declaration
 * @param <FuncDeclT> the model class for SMT function declaration
 */
public class ImlSmtEncoder<SortT, FuncDeclT> implements ImlEncoder {

	@Inject SmtSymbolTable<SortT, FuncDeclT> symbolTable;
	@Inject SmtModelProvider<SortT, FuncDeclT> smtModelProvider;
	@Inject IQualifiedNameProvider qnp ;
	
	public static final String ARRAY_SELECT_FUNC_NAME = ".__array_select";
	public static final String ALIAS_FUNC_NAME = ".__alias_value";
	public static final String EXTENSION_BASE_FUNC_NAME = ".__base_";

	@Override
	public void encode(Model model) {
		for (Symbol symbol : model.getSymbols()) {
			encode(symbol);
		}
	}

	@Override
	public void encode(Symbol symbol) {
		if (symbol instanceof ConstrainedType) {
			encode((ConstrainedType) symbol);
		} else {
			encode((SymbolDeclaration) symbol);
		}
	}
	
	@Override
	public void encode(SymbolDeclaration symbolDecl) {
		HigherOrderType symbolType = symbolDecl.getType();
		encode(symbolType);
		// Create function declaration to access this symbol
		SortT symbolSort = symbolTable.getSort(symbolType);
		String symbolId = getUniqueName(symbolDecl);
		FuncDeclT funDecl = smtModelProvider.createConst(symbolId, symbolSort);
		symbolTable.addFunDecl(symbolDecl.eContainer(), symbolDecl, funDecl);
	}

	@Override
	public void encode(ConstrainedType type) {
		encodeType(type);
	}
	
	@Override
	public void encode(HigherOrderType hot) {
		encodeType(hot);
	}
	
	private void encodeType(EObject type) {
		// Stage 1: define sorts
		if (type instanceof ConstrainedType) {
			defineTypes((ConstrainedType) type);
		} else if (type instanceof HigherOrderType) {
			defineTypes((HigherOrderType) type);
		} else {
			throw new IllegalArgumentException("Type should be either ConstrainedType or HigherOrderType only");
		}
		
		// Stage 2: declare functions
		declareFuncs();
	}
	
	private void defineTypes(ConstrainedType type) {
		defineTypes(type, null);
	}
	
	/**
	 * Define all sorts related to the given {@link ConstrainedType}, this only cares about creating the required sorts
	 * Given a context means that there are bindings for this template type
	 * @param type
	 * @param context
	 */
	private void defineTypes(ConstrainedType type, SimpleTypeReference context) {
		if (context == null) {
			if (symbolTable.contains(type)) return;
			
			// Encode relations no matter if it is a template or not
			for (RelationInstance relation : type.getRelations()) {
				defineTypes(relation.getTarget());
			}

			if (type.isTemplate()) return; // We don't encode template types without bindings
			
			addTypeSort(type);
		} else { 
			// We encode each binding only once
			if (symbolTable.contains(context)) return;
		}
		
		// Encode types of all symbol declarations inside this type
		for (SymbolDeclaration symbol : type.getSymbols()) {
			defineTypes(getActualType(symbol, context));
		}
	}
	
	private void defineTypes(HigherOrderType type) {
		if (symbolTable.contains(type)) return;
		
		if (type.getRange() != null) { // Actual Higher Order Type
			defineTypes(type.getDomain());
			defineTypes(type.getRange());
			// TODO add new Function?
			addTypeSort(type);
		} else if (type instanceof ArrayType) {
			ArrayType arrType = (ArrayType) type;
			// Create new type for each dimension beside the main type
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
			SimpleTypeReference simpleRef = (SimpleTypeReference) type;
			defineTypes(simpleRef.getType());
			if (!simpleRef.getTypeBinding().isEmpty()) { // Type is a Template
				for (HigherOrderType binding : simpleRef.getTypeBinding()) {
					defineTypes(binding);
				}
				// Encode the new type content, this is necessary in case that type contains symbols with 
				// new HigherOrderTypes that need to b created
				defineTypes(simpleRef.getType(), simpleRef);
				
				addTypeSort(simpleRef);
			}
		} else {
			throw new IllegalArgumentException("Unsupported type: " + type.getClass().getName());
		}
	}

	private SortT addTypeSort(EObject type) {
		String sortName = getUniqueName(type);
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

	/**
	 * 
	 * @param symbol the symbol which might be using template e.g T~>P
	 * @param context null or the type reference with the actual binding e.g Pair<Int,Real>
	 * @return the same symbol type if context is null or the binding of the type with the context
	 */
	private HigherOrderType getActualType(SymbolDeclaration symbol, SimpleTypeReference context) {
		if (context == null) {
			return symbol.getType();
		} else {
			return ImlTypeProvider.getType(symbol, context);
		}
	}

	/**
	 * This method creates all necessary function declarations for all sorts already defined
	 */
	private void declareFuncs() {
		// Go over all sorts that already defined
		List<EncodedId> types = symbolTable.getEncodedIds();
		for (EncodedId container : types) {
			EObject type = container.getImlObject();
			if (type instanceof ConstrainedType) {
				declareFuncs((ConstrainedType) type);
			} else if (type instanceof ArrayType) {
				declareFuncs((ArrayType) type);
			} else if (type instanceof SimpleTypeReference) {
				declareFuncs((SimpleTypeReference) type);
			}
		}
		
	}

	/***
	 * Having {@link SimpleTypeReference} as a type means it includes bindings which means we need to take in consideration the bindings
	 * @param type
	 */
	private void declareFuncs(SimpleTypeReference type) {
		if (!type.getTypeBinding().isEmpty()) {
			declareFuncs(type.getType(), type);
		}
	}

	/**
	 * Declare all required functions for the given {@link ConstrainedType}
	 * @param container
	 */
	private void declareFuncs(ConstrainedType container) {
		declareFuncs(container, null);
	}
	
	/**
	 * Create all required functions for the given type. If context is provided then it will be used for any required template binding inside the type
	 * @param container with templates e.g {@code type Pair<T,P>} or without templates e.g {@codeo type System}
	 * @param context null or actual binding e.g {@code var1 : Pair<Int, Real>}
	 */
	private void declareFuncs(ConstrainedType container, SimpleTypeReference context) {
		// encode relations TODO consider context
		for (RelationInstance relation : container.getRelations()) {
			if (relation instanceof Alias) {
				String funName = getUniqueName(container) + ALIAS_FUNC_NAME;
				FuncDeclT aliasFunc = smtModelProvider.createFuncDecl(funName, Arrays.asList(symbolTable.getSort(container)), symbolTable.getSort(((Alias)relation).getTarget()));
				symbolTable.addFunDecl(container, relation, aliasFunc);
			} else if (relation instanceof Extension) {
				// TODO should we consider using FQN for base? in case extending multiple types with the same name in different packages
				String funName = getUniqueName(container) + EXTENSION_BASE_FUNC_NAME + getUniqueName(((SimpleTypeReference) ((Extension) relation).getTarget()).getType());
				
				FuncDeclT extensionFunc = smtModelProvider.createFuncDecl(funName, Arrays.asList(symbolTable.getSort(container)), symbolTable.getSort(((Extension)relation).getTarget()));
				symbolTable.addFunDecl(container, relation, extensionFunc);
			}
		}
		
		// encode type symbols
		for (SymbolDeclaration symbol : container.getSymbols()) {
			EObject actualContainer;
			String funName;
			if (context == null) {
				funName = getUniqueName(symbol);
				actualContainer = container;
			} else {
				// The container is the context itself
				funName = getUniqueName(context) + "." + symbol.getName(); 
				actualContainer = context;
			}
			HigherOrderType symbolType = getActualType(symbol, context); // e.g if it was T~>P then maybe Int~>Real
			SortT containerSort = symbolTable.getSort(actualContainer);
			SortT symbolTypeSort = symbolTable.getSort(symbolType);
			
			FuncDeclT symbolFunDecl = smtModelProvider.createFuncDecl(funName, Arrays.asList(containerSort), symbolTypeSort);
			symbolTable.addFunDecl(actualContainer, symbol, symbolFunDecl);
		}
	}

	/**
	 * Create an array access function declaration
	 * @param type 
	 */
	private void declareFuncs(ArrayType type) {
		String funName = getUniqueName(type) + ARRAY_SELECT_FUNC_NAME;
		// TODO what if Int wasn't ever encoded? Need to make sure we encode all primitive sorts
		FuncDeclT arraySelectFunc = smtModelProvider.createFuncDecl(
				funName, Arrays.asList(symbolTable.getSort(type), symbolTable.getPrimitiveSort("Int")), 
				symbolTable.getSort(TypingServices.accessArray(type, 1)));
		symbolTable.addFunDecl(type, type, arraySelectFunc);
	}

	private List<SortT> getTupleSorts(TupleType type) {
		List<SortT> sorts = new ArrayList<>();
		for (SymbolDeclaration  symbol : type.getSymbols()) {
			sorts.add(symbolTable.getSort(symbol.getType()));
		}
		return sorts;
	}
	
	private FuncDeclT getSymbolDeclFun(SymbolDeclaration symbolDecl) {
		FuncDeclT funDecl = symbolTable.getFunDecl(symbolDecl.eContainer(), symbolDecl);
		if (funDecl == null) {
			if (symbolDecl.eContainer() instanceof Model) {
				encode(symbolDecl);
				funDecl = getFuncDeclaration(symbolDecl);
			} else {
				throw new IllegalArgumentException("Couldn't find encoding for the symbol declaration: " + symbolDecl.getName() + " of type: " + ImlUtils.getTypeNameManually(symbolDecl.getType(), qnp));
			}
		}
		return funDecl;
	}

	private String getUniqueName(EObject type) {
		return symbolTable.getUniqueId(type);
	}


	public List<SortT> getAllSorts() {
		return symbolTable.getSorts();
	}

	public List<FuncDeclT> getAllFuncDeclarations() {
		return symbolTable.getFunDecls();
	}

	public SortT getSort(EObject type) {
		return symbolTable.getSort(type);
	}

	public FuncDeclT getFuncDeclaration(EObject container, EObject imlObject) {
		return symbolTable.getFunDecl(container, imlObject);
	}
	
	public FuncDeclT getFuncDeclaration(EObject imlObject) {
		return symbolTable.getFunDecl(imlObject);
	}
	
	@Override
	public String toString() {
		StringBuilder sb = new StringBuilder();

		for (SortT sort : symbolTable.getSorts()) {
			sb.append(sort + "\n");
		}
		
		for (FuncDeclT funDecl : symbolTable.getFunDecls()) {
			sb.append(funDecl + "\n");
		}
		
		return sb.toString();
	}
}
 