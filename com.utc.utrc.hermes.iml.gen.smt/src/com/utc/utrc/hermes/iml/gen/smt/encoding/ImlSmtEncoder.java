package com.utc.utrc.hermes.iml.gen.smt.encoding;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collection;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import org.eclipse.emf.common.util.EList;
import org.eclipse.emf.ecore.EObject;
import org.eclipse.xtext.EcoreUtil2;
import org.eclipse.xtext.naming.IQualifiedNameProvider;

import com.google.inject.Inject;
import com.utc.utrc.hermes.iml.custom.ImlCustomFactory;
import com.utc.utrc.hermes.iml.iml.Addition;
import com.utc.utrc.hermes.iml.iml.Alias;
import com.utc.utrc.hermes.iml.iml.ArrayAccess;
import com.utc.utrc.hermes.iml.iml.ArrayType;
import com.utc.utrc.hermes.iml.iml.Assertion;
import com.utc.utrc.hermes.iml.iml.AtomicExpression;
import com.utc.utrc.hermes.iml.iml.NamedType;
import com.utc.utrc.hermes.iml.iml.EnumRestriction;
import com.utc.utrc.hermes.iml.iml.ExpressionTail;
import com.utc.utrc.hermes.iml.iml.Extension;
import com.utc.utrc.hermes.iml.iml.FloatNumberLiteral;
import com.utc.utrc.hermes.iml.iml.FolFormula;
import com.utc.utrc.hermes.iml.iml.FunctionType;
import com.utc.utrc.hermes.iml.iml.ImlType;
import com.utc.utrc.hermes.iml.iml.InstanceConstructor;
import com.utc.utrc.hermes.iml.iml.IteTermExpression;
import com.utc.utrc.hermes.iml.iml.LambdaExpression;
import com.utc.utrc.hermes.iml.iml.Model;
import com.utc.utrc.hermes.iml.iml.Multiplication;
import com.utc.utrc.hermes.iml.iml.NumberLiteral;
import com.utc.utrc.hermes.iml.iml.ParenthesizedTerm;
import com.utc.utrc.hermes.iml.iml.QuantifiedFormula;
import com.utc.utrc.hermes.iml.iml.Relation;
import com.utc.utrc.hermes.iml.iml.SelfTerm;
import com.utc.utrc.hermes.iml.iml.SequenceTerm;
import com.utc.utrc.hermes.iml.iml.SignedAtomicFormula;
import com.utc.utrc.hermes.iml.iml.SimpleTypeReference;
import com.utc.utrc.hermes.iml.iml.Symbol;
import com.utc.utrc.hermes.iml.iml.SymbolDeclaration;
import com.utc.utrc.hermes.iml.iml.SymbolReferenceTerm;
import com.utc.utrc.hermes.iml.iml.TailedExpression;
import com.utc.utrc.hermes.iml.iml.TermExpression;
import com.utc.utrc.hermes.iml.iml.TermMemberSelection;
import com.utc.utrc.hermes.iml.iml.TraitExhibition;
import com.utc.utrc.hermes.iml.iml.TruthValue;
import com.utc.utrc.hermes.iml.iml.TupleConstructor;
import com.utc.utrc.hermes.iml.iml.TupleType;
import com.utc.utrc.hermes.iml.iml.TypeWithProperties;
import com.utc.utrc.hermes.iml.typing.ImlTypeProvider;
import com.utc.utrc.hermes.iml.typing.TypingServices;
import com.utc.utrc.hermes.iml.util.ImlUtil;

import static com.utc.utrc.hermes.iml.util.ImlUtil.*;
/**
 * SMT implementation for {@link ImlEncoder}. The encoder is build for SMT v2.5.
 * This encoder abstracts the underlying SMT model by using {@link SmtModelProvider}
  *
  * @author Ayman Elkfrawy (elkfraaf@utrc.utc.com)
  * @author Gerald Wang (wangg@utrc.utc.com)
 *
 * @param <SortT> the model class for SMT sort declaration
 * @param <FuncDeclT> the model class for SMT function declaration
 */
// 
public class ImlSmtEncoder<SortT extends AbstractSort, FuncDeclT, FormulaT> implements ImlEncoder {

	/*
	 * TODO refactor template to extend basic types like SortT extends AbstractSort ...
	 * TODO add to_real when using Int as Real
	 * TODO encode sqrt to pow .5
	 */
	@Inject SmtSymbolTable<SortT, FuncDeclT, FormulaT> symbolTable;
	@Inject SmtModelProvider<SortT, FuncDeclT, FormulaT> smtModelProvider;
	@Inject IQualifiedNameProvider qnp ;
	
	Map<NamedType, ImlType> aliases = new HashMap<>();
	
	public static final String ARRAY_SELECT_FUNC_NAME = ".__array_select";
	public static final String ALIAS_FUNC_NAME = ".__alias_value";
	public static final String EXTENSION_BASE_FUNC_NAME = ".__base_";
	public static final String INST_NAME = "__inst__";

	@Override
	public void encode(Model model) {
		for (Symbol symbol : model.getSymbols()) {
			encode(symbol);
		}
	}

	@Override
	public void encode(Symbol symbol) {
		if (symbol instanceof NamedType) {
			encode((NamedType) symbol);
		} else {
			encode((SymbolDeclaration) symbol);
		}
	}
	
	@Override
	public void encode(SymbolDeclaration symbolDecl) {
		// TODO Refactor this to work with global or type symbols and combine it with declareFunc(NamedType), this is only for global symbols now
		
		ImlType symbolType = symbolDecl.getType();

		// Create function declaration to access this symbol
		List<SortT> inputSort = new ArrayList<>();
		SortT outputSort = null;
		if (symbolType instanceof FunctionType) {
			encode(((FunctionType) symbolType).getDomain());
			encode(((FunctionType) symbolType).getRange());
			inputSort.add(symbolTable.getSort(((FunctionType) symbolType).getDomain()));
			outputSort = symbolTable.getSort(((FunctionType) symbolType).getRange());
		} else {
			encode(symbolType);
			outputSort = symbolTable.getSort(symbolType);
		}
		
		String symbolId = getUniqueName(symbolDecl);
		FuncDeclT funDecl = smtModelProvider.createFuncDecl(symbolId, inputSort, outputSort);
		symbolTable.addFunDecl(symbolDecl.eContainer(), symbolDecl, funDecl);
		
		// TODO Temp fix for Global symbol declaration definition
		if (ImlUtil.isGlobalSymbol(symbolDecl) && symbolDecl.getDefinition() != null) {
			FormulaT definitionEncoding = null;
			try { // TODO don't handle it here
				definitionEncoding = encodeFormula(symbolDecl.getDefinition(), null, null, new ArrayList<>());
			} catch (SMTEncodingException e) {
				e.printStackTrace();
			}
			List<FormulaT> forallScope = new ArrayList<>();
						
//			ImlType symbolType = getActualType(symbol, context); // e.g if it was T~>P then maybe Int~>Real
			if (!(symbolDecl instanceof Assertion))  {
				List<FormulaT> functionParams = getFunctionParameterList(symbolDecl, true);
				FormulaT symbolAccess = smtModelProvider.createFormula(funDecl,  functionParams);
				
				definitionEncoding = smtModelProvider.createFormula(OperatorType.EQ, Arrays.asList(symbolAccess, definitionEncoding));	
				forallScope.addAll(getFunctionParameterList(symbolDecl, false));
			} 
			FormulaT forall = smtModelProvider.createFormula(OperatorType.FOR_ALL, 
					Arrays.asList(smtModelProvider.createFormula(forallScope), definitionEncoding));
			FormulaT assertion = smtModelProvider.createFormula(OperatorType.ASSERT, Arrays.asList(forall));
			symbolTable.addFormula(symbolDecl.eContainer(), symbolDecl, assertion);
		}
	}

	@Override
	public void encode(NamedType type) {
		encodeType(type);
	}
	
	@Override
	public void encode(ImlType hot) {
		encodeType(hot);
	}
	
	private void encodeType(EObject type) {
		if (symbolTable.contains(type)) return;
		
		// Stage 1: define sorts
		if (type instanceof NamedType) {
			defineTypes((NamedType) type);
		} else if (type instanceof ImlType) {
			defineTypes((ImlType) type);
		} else {
			throw new IllegalArgumentException("Type should be either NamedType or ImlType only");
		}
		
		// Stage 2: declare functions
		declareFuncs();
		
		// Stage 3: define formulas
		try { // TODO shouldn't be handled here
			defineAssertions();
		} catch (SMTEncodingException e) {
			e.printStackTrace();
		}
	}
	
	private void defineAssertions() throws SMTEncodingException {
		List<EncodedId> types = symbolTable.getEncodedIds();
		for (EncodedId container : types) {
			EObject type = container.getImlObject();
			if (type instanceof NamedType) {
				defineAssertions((NamedType) type, 
						ImlCustomFactory.INST.createSimpleTypeReference((NamedType) type));
			} else if (type instanceof SimpleTypeReference) {
				if (!((SimpleTypeReference) type).getTypeBinding().isEmpty()) {
					defineAssertions(((SimpleTypeReference) type).getType(), (SimpleTypeReference) type);
				}
			}
		}
	}

	// TODO maybe we only need context by converting NamedType into SimpleTypeReference!
	private void defineAssertions(NamedType container, SimpleTypeReference context) throws SMTEncodingException {
		for (SymbolDeclaration symbol : container.getSymbols()) {
			if (symbol.getDefinition() == null) continue; // We only add assertion if we have a definition
			
			EObject actualContainer;
			if (context == null) {
				actualContainer = container;
			} else {
				// The container is the context itself
				actualContainer = context;
			}
			
			SortT containerSort = symbolTable.getSort(actualContainer);
			FormulaT inst = smtModelProvider.createFormula(INST_NAME);
			FormulaT instDecl = smtModelProvider.createFormula(INST_NAME, containerSort);
			FormulaT definitionEncoding = encodeFormula(symbol.getDefinition(), context, inst, new ArrayList<>());
			List<FormulaT> forallScope = new ArrayList<>(Arrays.asList(instDecl));
						
//			ImlType symbolType = getActualType(symbol, context); // e.g if it was T~>P then maybe Int~>Real
			if (!(symbol instanceof Assertion))  {
				if (!isConnector(symbol)) {
					List<FormulaT> functionParams = getFunctionParameterList(symbol, true);
					functionParams.add(0, inst);
					FormulaT symbolAccess = smtModelProvider.createFormula(getSymbolDeclFun(symbol, context),  functionParams);
					
					definitionEncoding = smtModelProvider.createFormula(OperatorType.EQ, Arrays.asList(symbolAccess, definitionEncoding));	
					forallScope.addAll(getFunctionParameterList(symbol, false));
				}
			} 
			FormulaT forall = smtModelProvider.createFormula(OperatorType.FOR_ALL, 
					Arrays.asList(smtModelProvider.createFormula(forallScope), definitionEncoding));
			FormulaT assertion = smtModelProvider.createFormula(OperatorType.ASSERT, Arrays.asList(forall));
			symbolTable.addFormula(actualContainer, symbol, assertion);
			
		}
	}

	private boolean isConnector(SymbolDeclaration symbol) {
		ImlType type = symbol.getType();
		if (type instanceof SimpleTypeReference) {
			return ((SimpleTypeReference) type).getType().getName().equals("Connector"); // TODO do it the right way
		}
		return false;
	}

	private List<FormulaT> getFunctionParameterList(SymbolDeclaration symbol, boolean nameOnly) {
		FolFormula definition = symbol.getDefinition();
		if (definition instanceof SignedAtomicFormula) {
			definition = definition.getLeft();
		}
		List<FormulaT> result = new ArrayList<>();
		if (definition instanceof LambdaExpression) {
			ImlType signature = ((LambdaExpression) definition).getSignature();
			if (signature instanceof TupleType) { 
				for (SymbolDeclaration param : ((TupleType) signature).getSymbols()) {
					if (nameOnly) {
						result.add(smtModelProvider.createFormula(param.getName()));
					} else {
						result.add(smtModelProvider.createFormula(param.getName(), getSort(param.getType())));
					}
				}
			}
		}
		return result;
	}

	private void defineTypes(NamedType type) {
		defineTypes(type, null);
	}
	
	/**
	 * Define all sorts related to the given {@link NamedType}, this only cares about creating the required sorts
	 * Given a context means that there are bindings for this template type
	 * @param type
	 * @param context
	 */
	private void defineTypes(NamedType type, SimpleTypeReference context) {
		if (context == null) {
			if (symbolTable.contains(type)) return;
			
			// Encode relation types no matter if it is a template or not
			for (TypeWithProperties relationType : getRelationTypes(type)) {
				defineTypes(relationType.getType());
			}

			if (type.isTemplate()) return; // We don't encode template types without bindings
			
			addTypeSort(type);
		} else { 
			// We encode each binding only once
			if (symbolTable.contains(context)) return;
		}
		
		// Encode types of all symbol declarations inside this type
		for (SymbolDeclaration symbol : type.getSymbols()) {
			if (!(symbol instanceof Assertion)) {
				defineTypes(getActualType(symbol, context));
			}
		}
	}
	
	private void defineTypes(ImlType type) {
		if (symbolTable.contains(type)) return;
		// Check if acceptable type
		if (!ImlUtil.isFirstOrderFunction(type)) {
			throw new IllegalArgumentException("the type '" + getTypeName(type, qnp) + "' is not supported for SMT encoding.");
		}
		
		if (type instanceof FunctionType) { 
			defineTypes(((FunctionType) type).getDomain());
			defineTypes(((FunctionType) type).getRange());
		} else if (type instanceof ArrayType) {
			ArrayType arrType = (ArrayType) type;
			// Create new type for each dimension beside the main type
			for (int dim = 0; dim < arrType.getDimensions().size() ; dim++) {
				ImlType currentDim = TypingServices.accessArray(arrType, dim);
				addTypeSort(currentDim);
			}
			defineTypes(arrType.getType());
		} else if (type instanceof TupleType) {
			// TODO handle empty tuple!
			TupleType tupleType = (TupleType) type;
			for (SymbolDeclaration symbol : tupleType.getSymbols()) {
				defineTypes(symbol.getType());
			}
			addTypeSort(tupleType);
		} else if (type instanceof SimpleTypeReference) {
			SimpleTypeReference simpleRef = (SimpleTypeReference) type;
			defineTypes(simpleRef.getType());
			if (!simpleRef.getTypeBinding().isEmpty()) { // Type is a Template
				for (ImlType binding : simpleRef.getTypeBinding()) {
					defineTypes(binding);
				}
				// Encode the new type content, this is necessary in case that type contains symbols with 
				// new Higher Order Types that need to be created
				defineTypes(simpleRef.getType(), simpleRef);
				
				addTypeSort(simpleRef);
			}
		} else {
			throw new IllegalArgumentException("Unsupported type: " + type.getClass().getName());
		}
	}

	/**
	 * This method is responsible for creating and adding a new sort for the given IML type
	 * @param type it can be NamedType or ImlType
	 * @return the created sort
	 */
	private SortT addTypeSort(EObject type) {
		String sortName = getUniqueName(type);
		SortT sort = null;
		if (type instanceof TupleType){
			sort = smtModelProvider.createTupleSort(sortName, getTupleSorts((TupleType) type));
//		} else if (isEnum(type)) { // TODO Should check for other Restricitions
////			sort = smtModelProvider.createEnum(sortName, getEnumList((NamedType) type));
		} else {
			sort = smtModelProvider.createSort(sortName);
		}
		if (sort != null) {
			symbolTable.addSort(type, sort);
		}
		return sort;
	}

	private Object getEnumList(NamedType type) {
		List<String> result = new ArrayList<String>();
		for (SymbolDeclaration symbol: ((EnumRestriction) type.getRestrictions().get(0)).getLiterals()) {
			result.add(getUniqueName(symbol));
		}
		return result;
	}

	private boolean isEnum(EObject type) {
		
		// Check if enum
		if (type instanceof NamedType && ((NamedType)type).getRestrictions() != null 
				&& !((NamedType)type).getRestrictions().isEmpty()) {
			// TODO why resitrictions is a list! we only handle 1
			return ((NamedType)type).getRestrictions().get(0) instanceof EnumRestriction;
		}
		return false;
	}

	/**
	 * 
	 * @param symbol the symbol which might be using template e.g T~>P
	 * @param context null or the type reference with the actual binding e.g Pair<Int,Real>
	 * @return the same symbol type if context is null or the binding of the type with the context
	 */
	// TODO we need to pass SymbolReferenceTerm instead of SymbolDeclaration
	private ImlType getActualType(SymbolDeclaration symbol, SimpleTypeReference context) {
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
			if (type instanceof NamedType) {
				declareFuncs((NamedType) type);
			} else if (type instanceof ArrayType) {
				declareFuncs((ArrayType) type);
			} else if (type instanceof SimpleTypeReference) {
				declareFuncs((SimpleTypeReference) type);
			}
		}
		
	}

	/***
	 * Having {@link SimpleTypeReference} as a type in symbol table means it includes bindings 
	 * which means we need to take in consideration the bindings
	 * @param type
	 */
	private void declareFuncs(SimpleTypeReference type) {
		if (!type.getTypeBinding().isEmpty()) {
			declareFuncs(type.getType(), type);
		}
	}

	/**
	 * Declare all required functions for the given {@link NamedType}
	 * @param container
	 */
	private void declareFuncs(NamedType container) {
		declareFuncs(container, null);
	}
	
	/**
	 * Create all required functions for the given type. If context is provided then it will be used for any required template binding inside the type
	 * @param container with templates e.g {@code type Pair<T,P>} or without templates e.g {@codeo type System}
	 * @param context null or actual binding e.g {@code var1 : Pair<Int, Real>}
	 */
	private void declareFuncs(NamedType container, SimpleTypeReference context) {
		EObject actualContainer;
		if (context == null) {
			actualContainer = container;
		} else {
			// The container is the context itself
			actualContainer = context;
		}
		// encode relations TODO consider context
		List<AtomicRelation> relations = relationsToAtomicRelations(container.getRelations());
		for (AtomicRelation relation : relations) {
			if (relation.getRelation() instanceof Alias) {
				String funName = getUniqueName(actualContainer) + ALIAS_FUNC_NAME;
				ImlType aliasType = ((Alias) relation.getRelation()).getType().getType();
				FuncDeclT aliasFunc = smtModelProvider.createFuncDecl(funName, Arrays.asList(symbolTable.getSort(actualContainer)), symbolTable.getSort(aliasType));
				symbolTable.addFunDecl(actualContainer, relation, aliasFunc);
			} else if (relation.getRelation() instanceof Extension) {
				for (TypeWithProperties extendedType : ((Extension) relation.getRelation()).getExtensions()) {
					String funName = getUniqueName(actualContainer) + EXTENSION_BASE_FUNC_NAME + getUniqueName(extendedType.getType());
					FuncDeclT extensionFunc = smtModelProvider.createFuncDecl(funName, Arrays.asList(symbolTable.getSort(actualContainer)), symbolTable.getSort(extendedType.getType()));
					symbolTable.addFunDecl(actualContainer, relation, extensionFunc);
				}
			}
		}
		// encode type symbols
		for (SymbolDeclaration symbol : container.getSymbols()) {
			if (symbol instanceof Assertion) continue; // We don't need function declaration for assertions
			
			String funName;
			if (context == null) {
				funName = getUniqueName(symbol);
			} else {
				// The container is the context itself
				funName = getUniqueName(context) + "." + symbol.getName(); 
			}
			ImlType symbolType = getActualType(symbol, context); // e.g if it was T~>P then maybe Int~>Real
			SortT containerSort = symbolTable.getSort(actualContainer);
			
			SortT funOutoutSort = null;
			List<SortT> funInputSorts = new ArrayList<>(Arrays.asList(containerSort));
			
			if (symbolType instanceof FunctionType) { // Encode it as a function
				funInputSorts.add(symbolTable.getSort(((FunctionType) symbolType).getDomain())); // TODO what if domain is a tuple?
				funOutoutSort = symbolTable.getSort(((FunctionType) symbolType).getRange());
			} else { // Symbol is not a function
				funOutoutSort = symbolTable.getSort(symbolType);
			}
			
			FuncDeclT symbolFunDecl = smtModelProvider.createFuncDecl(funName, funInputSorts, funOutoutSort);
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
	
	public FormulaT encodeFormula(FolFormula formula, SimpleTypeReference context, FormulaT inst, List<SymbolDeclaration> scope) throws SMTEncodingException {
		if (scope == null) {
			scope = new ArrayList<>();
		}
		// TODO need to refactor createFormula functions, we shouldn't assume the internal structure of it
		FormulaT leftFormula = null;
		FormulaT rightFormula = null; 
		if (formula.getLeft() != null) {
			leftFormula = encodeFormula(formula.getLeft(), context, inst, scope);
		}
		if (formula.getRight() != null) {
			rightFormula = encodeFormula(formula.getRight(), context, inst, scope);
		}
		
		if (formula instanceof ParenthesizedTerm) {
			return encodeFormula(((ParenthesizedTerm) formula).getSub(), context, inst, scope);
		} else if (formula.getOp() != null && !formula.getOp().isEmpty()) {
			OperatorType op = OperatorType.parseOp(formula.getOp());
			
			if (op == OperatorType.IMPL) { 
				return smtModelProvider.createFormula(op, Arrays.asList(leftFormula, rightFormula));
			} else if (op == OperatorType.EQUIV) {
				FormulaT l2r = smtModelProvider.createFormula(op, Arrays.asList(leftFormula, rightFormula));
				FormulaT r2l = smtModelProvider.createFormula(op, Arrays.asList(rightFormula, leftFormula));
				return smtModelProvider.createFormula(OperatorType.AND, Arrays.asList(l2r, r2l));
			} else if (op == OperatorType.FOR_ALL || op == OperatorType.EXISTS) {
				QuantifiedFormula quantFormula = (QuantifiedFormula) formula;
				List<FormulaT> scopeFormulas = quantFormula.getScope().stream().map(symbol -> {
					String typeName = getUniqueName(symbol.getType());
					return smtModelProvider.createFormula(Arrays.asList(smtModelProvider.createFormula(symbol.getName()),
								smtModelProvider.createFormula(typeName)));
				}).collect(Collectors.toList());
				
				scope.addAll(quantFormula.getScope());
				leftFormula = encodeFormula(formula.getLeft(), context, inst, scope);
				
				return smtModelProvider.createFormula(op, Arrays.asList(smtModelProvider.createFormula(scopeFormulas), leftFormula));
			} else if (op == OperatorType.AND || op == OperatorType.OR) {
				return smtModelProvider.createFormula(op, Arrays.asList(leftFormula, rightFormula));
			}
		} else if (formula instanceof SignedAtomicFormula) {
			if (((SignedAtomicFormula) formula).isNeg()) {
				return smtModelProvider.createFormula(OperatorType.NOT, Arrays.asList(leftFormula));
			} else {
				return leftFormula;
			}
		} else if (formula instanceof AtomicExpression) {
			OperatorType op = OperatorType.parseOp(((AtomicExpression) formula).getRel().getLiteral());
			// TODO why AtmoicExpression has * instead of ?
			return smtModelProvider.createFormula(op, Arrays.asList(leftFormula, rightFormula));
		} else if (formula instanceof Addition) {
			return smtModelProvider.createFormula(OperatorType.parseOp(((Addition) formula).getSign()), Arrays.asList(leftFormula, rightFormula));
		} else if (formula instanceof Multiplication) {
			return smtModelProvider.createFormula(OperatorType.parseOp(((Multiplication) formula).getSign()), Arrays.asList(leftFormula, rightFormula));
		} else if (formula instanceof TermMemberSelection) {
			TermExpression receiver = ((TermMemberSelection) formula).getReceiver();
			TermExpression member = ((TermMemberSelection) formula).getMember();
			
			FormulaT receiverFormula = encodeFormula(receiver, context, inst, scope);
			ImlType receiverType = ImlTypeProvider.termExpressionType(receiver, context);
			if (receiverType instanceof SimpleTypeReference) {
				return encodeFormula(member, (SimpleTypeReference) receiverType, receiverFormula, scope);
			}
		} else if (formula instanceof NumberLiteral) {
			if (((NumberLiteral) formula).isNeg()) {
				FormulaT valueFormula = smtModelProvider.createFormula(((NumberLiteral) formula).getValue());
				return smtModelProvider.createFormula(OperatorType.NEGATIVE, Arrays.asList(valueFormula));
			} else {
				return smtModelProvider.createFormula(((NumberLiteral) formula).getValue());
			}
		} else if (formula instanceof FloatNumberLiteral) {
			if (((FloatNumberLiteral) formula).isNeg()) {
				FormulaT valueFormula = smtModelProvider.createFormula(((FloatNumberLiteral) formula).getValue());
				return smtModelProvider.createFormula(OperatorType.NEGATIVE, Arrays.asList(valueFormula));
			} else {
				return smtModelProvider.createFormula(((FloatNumberLiteral) formula).getValue());
			}
		} else if (formula instanceof TupleConstructor) {
			// TODO
			ImlType tupleType = ImlTypeProvider.termExpressionType(formula, context);
			if (tupleType instanceof TupleType) {
				SortT sort = getSort(tupleType);
				List<FormulaT> tupleFormulas = encodeTupleElements((TupleConstructor) formula, context, inst, scope);
				
				return smtModelProvider.createFormula(tupleFormulas);
			}
			
		}else if (formula instanceof TailedExpression) {
			TailedExpression tailedExpr = (TailedExpression) formula;
			
			FolFormula leftFol = tailedExpr.getLeft();
			
			FormulaT leftFormular = encodeFormula(leftFol, context, inst, scope);
			
			ExpressionTail tail = tailedExpr.getTail();
			if (tail == null) {	// can this really happen? cannot really catch the test case, should the validator rule it out????
				if (leftFol instanceof SymbolDeclaration && ((SymbolDeclaration) leftFol).getType() instanceof FunctionType) {
					throw new SMTEncodingException(((SymbolDeclaration) leftFol).getName() + " function can't be used as a variable");
				}				
			}
			FormulaT tailFormular = null;
			if (tail instanceof TupleConstructor) {
				tailFormular = encodeFormula((TupleConstructor) tailedExpr.getTail(), context, inst, scope);
				List<FormulaT> paramFormulas = new ArrayList<>();
				paramFormulas.add(leftFormular);
				paramFormulas.add(tailFormular);
				return smtModelProvider.createFormula((OperatorType) null, paramFormulas);
			}
		
		}else if (formula instanceof SymbolReferenceTerm) {
			SymbolReferenceTerm symbolRef = (SymbolReferenceTerm) formula;		
			FormulaT symbolRefFormula = getSymbolAccessFormula(symbolRef, context, inst, scope);
			return symbolRefFormula;
			
			/*****************
			 *  FIXME Need to be refactored and use TailedExpression
			 ***************** /
			
			/*
			SymbolReferenceTerm symbolRef = (SymbolReferenceTerm) formula;
			
			// Check if it is a connect 
			if (isConnect(symbolRef.getSymbol())) {
				FolFormula connectLeft = ((TupleConstructor) symbolRef.getTails().get(0)).getElements().get(0);
				FolFormula connectRight  = ((TupleConstructor) symbolRef.getTails().get(0)).getElements().get(1);
				FormulaT connectLeftFormula = encodeFormula(connectLeft, context, inst, scope);
				FormulaT connectRightFormula = encodeFormula(connectRight, context, inst, scope);
				
				return smtModelProvider.createFormula(OperatorType.EQ, Arrays.asList(connectLeftFormula, connectRightFormula));
			}
			
			// 1. Get FunctionDeclaration for the symbol
			FormulaT symbolRefFormula = getSymbolAccessFormula(symbolRef, context, inst, scope);
			// TODO check if symbol of a function is used as a parameter or uses an assertion
			
			Symbol symbol = symbolRef.getSymbol();
			// 2. Handle Tails from left to right
			if (symbolRef.getTails() != null &&  !symbolRef.getTails().isEmpty()) {
				if (symbol instanceof SymbolDeclaration) {
					ImlType type = ImlTypeProvider.getType((SymbolDeclaration) symbol, context);
					for (SymbolReferenceTail tail : symbolRef.getTails()) {
						// Get the symbol type
						if (tail instanceof ArrayAccess) {
							FuncDeclT arrayAccessFun = getFuncDeclaration(type);
							symbolRefFormula = smtModelProvider.createFormula(arrayAccessFun, Arrays.asList(symbolRefFormula));
						} else { // TupleConstructor
							List<FormulaT> tupleFormulas = encodeTupleElements((TupleConstructor) tail, context, inst, scope);
							// TODO Refactor?!
							List<FormulaT> paramFormulas = new ArrayList<>();
							paramFormulas.add(symbolRefFormula);
							paramFormulas.addAll(tupleFormulas);
							
							symbolRefFormula = smtModelProvider.createFormula((OperatorType) null, paramFormulas);
						}
						
						type = ImlTypeProvider.accessTail(type, tail); // TODO revisit the type provider
					}
				}
			} else {
				if (symbol instanceof SymbolDeclaration && ((SymbolDeclaration) symbol).getType() instanceof FunctionType) {
					throw new SMTEncodingException(symbol.getName() + " function can't be used as a variable");
				}
			}
			return symbolRefFormula;*/
		} else if (formula instanceof InstanceConstructor) {
			// TODO handle some instance constructor
//			if (formula instanceof ImplicitInstanceConstructor) {
//				ImplicitInstanceConstructor instanceConstructor = (ImplicitInstanceConstructor) formula;
//				SimpleTypeReference constructedType = (SimpleTypeReference) instanceConstructor.getRef();
//				SymbolDeclaration containerSymbol = EcoreUtil2.getContainerOfType(formula, SymbolDeclaration.class);
//				SortT inputSort = symbolTable.getSort(context);
//				SortT outputSort = symbolTable.getSort(constructedType);
//				
////				String funName = getUniqueName(containerSymbol) + "_" + getUniqueName(constructedType.getType());
//				String funName = getUniqueName(formula);
//				FuncDeclT instanceConstructorFun = smtModelProvider.createFuncDecl(funName, Arrays.asList(inputSort), outputSort);
//				symbolTable.addFunDecl(context, formula, instanceConstructorFun);
//				
//				// TODO to complete
////				encodeFormula(instanceConstructor.getDefinition(), constructedType, inst, scope)
//				
//			} else { 
//				
//			}
			
		} else if (formula instanceof IteTermExpression) {
			FolFormula condition = ((IteTermExpression) formula).getCondition();
			FormulaT conditionFormua = encodeFormula(condition, context, inst, scope);
			if (formula.getRight() != null) {
				return smtModelProvider.createFormula(OperatorType.ITE, Arrays.asList(conditionFormua, leftFormula, rightFormula));
			} else {
				if (isAssertion(formula)) {
					return smtModelProvider.createFormula(OperatorType.IMPL, Arrays.asList(conditionFormua, leftFormula));
				} else {
					throw new SMTEncodingException("If-then-else must include else clause if it is used in an assignment");
				}
			}
			
		} else if (formula instanceof SelfTerm) {
			// Not used for now
		} else if (formula instanceof TruthValue) {
			return smtModelProvider.createFormula(((TruthValue) formula).isTRUE());
		} else if (formula instanceof SequenceTerm) {
			scope.addAll(((SequenceTerm) formula).getDefs());
			FormulaT returnFormula = encodeFormula(((SequenceTerm) formula).getReturn(), context, inst, scope);
			
			if (!isNullOrEmpty(((SequenceTerm) formula).getDefs())) {
				for (int i=((SequenceTerm) formula).getDefs().size()-1 ; i >= 0 ; i--) {
					SymbolDeclaration currentSymbol = ((SequenceTerm) formula).getDefs().get(i);
					FormulaT binderFormula = smtModelProvider.createFormula(Arrays.asList(
							smtModelProvider.createFormula(Arrays.asList(
									smtModelProvider.createFormula(currentSymbol.getName()), encodeFormula(currentSymbol.getDefinition(), context, inst, scope)))));
					returnFormula = smtModelProvider.createFormula(OperatorType.LET, Arrays.asList(binderFormula, returnFormula));
			
				}
			}
			return returnFormula;
		} else if (formula instanceof LambdaExpression) {
			scope.addAll(((TupleType) ((LambdaExpression) formula).getSignature()).getSymbols());
			return encodeFormula(((LambdaExpression) formula).getDefinition(), context, inst, scope);
		} else {
			throw new SMTEncodingException("Unsupported formula: " + formula);
		}
		throw new SMTEncodingException("Couldn't encode the formula to SMT!");
	}
	
	private boolean isConnect(Symbol symbol) {
		return symbol instanceof SymbolDeclaration && ((SymbolDeclaration) symbol).getName().equals("connect"); //TODO FIXME do it right!
	}

	private boolean isAssertion(FolFormula formula) {
		return EcoreUtil2.getContainerOfType(formula, Assertion.class) != null;
	}

	private List<FormulaT> encodeTupleElements(TupleConstructor tail, SimpleTypeReference context, FormulaT inst, List<SymbolDeclaration> scope) throws SMTEncodingException {
		List<FormulaT> encodedFormulas = new ArrayList<>();
		for (FolFormula formula : tail.getElements()) {
			encodedFormulas.add(encodeFormula(formula, context, inst, scope));
		}
		return encodedFormulas;
	}

	private FormulaT getSymbolAccessFormula(SymbolReferenceTerm symbolRef, SimpleTypeReference context, FormulaT inst, List<SymbolDeclaration> scope) {
		// Check the scope first
		if ((scope != null && scope.contains(symbolRef.getSymbol())) /*||
			isGlobalSymbol(symbolRef.getSymbol())*/) {
			return smtModelProvider.createFormula(getUniqueName(symbolRef.getSymbol()));
		}
		
		if (symbolRef.getSymbol() instanceof NamedType) { // Check for NamedType symbol
			// We only support enum now
		}
		
		FuncDeclT symbolAccess = getSymbolDeclFun((SymbolDeclaration) symbolRef.getSymbol(), context);
		// Handle super types
		if (symbolAccess == null) {
			for (AtomicRelation relation : relationsToAtomicRelations(context.getType().getRelations())) {
				if (relation.getRelatedType() instanceof SimpleTypeReference) {
					SimpleTypeReference parent = (SimpleTypeReference) relation.getRelatedType();
					FuncDeclT relationFunction = getFuncDeclaration(context, relation); // Get the function declaration for current relation
					FormulaT parentSymbolAccess = getSymbolAccessFormula(symbolRef, parent, smtModelProvider.createFormula(relationFunction, Arrays.asList(inst)), scope);
					if (parentSymbolAccess != null) {
						return parentSymbolAccess;
					}
				}
			}
			return null; 
		} else {
			if (isGlobalSymbol(symbolRef.getSymbol())) {
				return smtModelProvider.createFormula(symbolAccess, null);
			} else {
				return smtModelProvider.createFormula(symbolAccess, Arrays.asList(inst));
			}
		}
	}

	private List<AtomicRelation> relationsToAtomicRelations(EList<Relation> relations) {
		List<AtomicRelation> atomicRelations = new ArrayList<>();
		for (Relation relation : relations) {
			if (relation instanceof Alias) {
				atomicRelations.add(new AtomicRelation(relation, ((Alias) relation).getType().getType()));
			} else {
				List<TypeWithProperties> types;
				if (relation instanceof Extension) {
					types = ((Extension) relation).getExtensions();
				} else {
					types = ((TraitExhibition) relation).getExhibitions();
				}
				for (TypeWithProperties type : types) {
					atomicRelations.add(new AtomicRelation(relation, type.getType()));
				}
			}
		}
		return atomicRelations;
	}

	/**
	 * This method tries to get function declaration that access the given symbol. It will also create that function
	 * in case the symbol was a global variable and wasn't encoded
	 * @param symbolDecl
	 * @return
	 */
	private FuncDeclT getSymbolDeclFun(SymbolDeclaration symbolDecl, SimpleTypeReference container) {
		FuncDeclT funDecl = symbolTable.getFunDecl(container, symbolDecl);
		if (funDecl == null) {
			if (isGlobalSymbol(symbolDecl)) {
				encode(symbolDecl);
				funDecl = getFuncDeclaration(symbolDecl);
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
		return symbolTable.getFunDecl(container,  imlObject);
	}
	
	public FuncDeclT getFuncDeclaration(EObject imlObject) {
		return symbolTable.getFunDecl(imlObject);
	}
	
	@Override
	public String toString() {
		StringBuilder sb = new StringBuilder();

		for (SortT sort : symbolTable.getSorts()) {
			if (!SmtStandardLib.isNative(sort.getName())) {
				sb.append(sort + "\n");
			}
		}
		
		for (FuncDeclT funDecl : symbolTable.getFunDecls()) {
			sb.append(funDecl + "\n");
		}
		
		for (FormulaT formula : symbolTable.getAllFormulas()) {
			sb.append(formula + "\n");
		}
		
		return sb.toString();
	}

	public FormulaT encodeFormula(FolFormula formula, SymbolDeclaration symbol) throws SMTEncodingException {
		return encodeFormula(formula, (SimpleTypeReference) symbol.getType(),  smtModelProvider.createFormula(symbol.getName()), new ArrayList<>());
	}
	
}
 