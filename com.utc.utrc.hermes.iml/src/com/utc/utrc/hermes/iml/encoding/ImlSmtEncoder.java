package com.utc.utrc.hermes.iml.encoding;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import org.eclipse.emf.ecore.EObject;
import org.eclipse.xtext.EcoreUtil2;
import org.eclipse.xtext.naming.IQualifiedNameProvider;

import com.google.inject.Inject;
import com.utc.utrc.hermes.iml.iml.Addition;
import com.utc.utrc.hermes.iml.iml.Alias;
import com.utc.utrc.hermes.iml.iml.ArrayAccess;
import com.utc.utrc.hermes.iml.iml.ArrayType;
import com.utc.utrc.hermes.iml.iml.Assertion;
import com.utc.utrc.hermes.iml.iml.AtomicExpression;
import com.utc.utrc.hermes.iml.iml.ConstrainedType;
import com.utc.utrc.hermes.iml.iml.Extension;
import com.utc.utrc.hermes.iml.iml.FloatNumberLiteral;
import com.utc.utrc.hermes.iml.iml.FolFormula;
import com.utc.utrc.hermes.iml.iml.HigherOrderType;
import com.utc.utrc.hermes.iml.iml.IteTermExpression;
import com.utc.utrc.hermes.iml.iml.LambdaExpression;
import com.utc.utrc.hermes.iml.iml.Model;
import com.utc.utrc.hermes.iml.iml.Multiplication;
import com.utc.utrc.hermes.iml.iml.NumberLiteral;
import com.utc.utrc.hermes.iml.iml.Program;
import com.utc.utrc.hermes.iml.iml.RelationInstance;
import com.utc.utrc.hermes.iml.iml.SignedAtomicFormula;
import com.utc.utrc.hermes.iml.iml.SimpleTypeReference;
import com.utc.utrc.hermes.iml.iml.Symbol;
import com.utc.utrc.hermes.iml.iml.SymbolDeclaration;
import com.utc.utrc.hermes.iml.iml.SymbolReferenceTail;
import com.utc.utrc.hermes.iml.iml.SymbolReferenceTerm;
import com.utc.utrc.hermes.iml.iml.TermExpression;
import com.utc.utrc.hermes.iml.iml.TermMemberSelection;
import com.utc.utrc.hermes.iml.iml.This;
import com.utc.utrc.hermes.iml.iml.TruthValue;
import com.utc.utrc.hermes.iml.iml.TupleConstructor;
import com.utc.utrc.hermes.iml.iml.TupleType;
import com.utc.utrc.hermes.iml.iml.TypeConstructor;
import com.utc.utrc.hermes.iml.typing.ImlTypeProvider;
import com.utc.utrc.hermes.iml.typing.TypingServices;
import com.utc.utrc.hermes.iml.util.ImlUtils;

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
// TODO refactor template to extend basic types like SortT extends AbstractSort ...
public class ImlSmtEncoder<SortT, FuncDeclT, FormulaT> implements ImlEncoder {

	@Inject SmtSymbolTable<SortT, FuncDeclT, FormulaT> symbolTable;
	@Inject SmtModelProvider<SortT, FuncDeclT, FormulaT> smtModelProvider;
	@Inject IQualifiedNameProvider qnp ;
	
	Map<ConstrainedType, HigherOrderType> aliases = new HashMap<>();
	
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
		
		// TODO **** handle assertion symbol declarations ******
		
		// Stage 2: declare functions
		declareFuncs();
		
		// Stage 3: define formulas
		defineFormulas();
	}
	
	private void defineFormulas() {
		
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
	 * @param type it can be ConstrainedType or HigherOrderType
	 * @return the created sort
	 */
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
	
	public FormulaT encodeFormula(FolFormula formula, SimpleTypeReference context, FormulaT inst, List<SymbolDeclaration> scope) throws SMTEncodingException {
		// TODO need to refactor createFormula functions, we shouldn't assume the internal structure of it
		FormulaT leftFormula = null;
		FormulaT rightFormula = null; 
		if (formula.getLeft() != null) {
			leftFormula = encodeFormula(formula.getLeft(), context, inst, scope);
		}
		if (formula.getRight() != null) {
			rightFormula = encodeFormula(formula.getRight(), context, inst, scope);
		}
		
		if (formula.getOp() != null && !formula.getOp().isEmpty()) {
			OperatorType op = OperatorType.parseOp(formula.getOp());
			
			if (op == OperatorType.IMPL) { 
				return smtModelProvider.createFormula(op, Arrays.asList(leftFormula, rightFormula));
			} else if (op == OperatorType.EQUIV) {
				FormulaT l2r = smtModelProvider.createFormula(op, Arrays.asList(leftFormula, rightFormula));
				FormulaT r2l = smtModelProvider.createFormula(op, Arrays.asList(rightFormula, leftFormula));
				return smtModelProvider.createFormula(OperatorType.AND, Arrays.asList(l2r, r2l));
			} else if (op == OperatorType.FOR_ALL || op == OperatorType.EXISTS) { 
				List<FormulaT> scopeFormulas = formula.getScope().stream().map(symbol -> {
					String typeName = getUniqueName(symbol.getType());
					return smtModelProvider.createFormula(Arrays.asList(smtModelProvider.createFormula(symbol.getName()),
								smtModelProvider.createFormula(typeName)));
				}).collect(Collectors.toList());
				
				if (scope == null) {
					scope = new ArrayList<>();
				}
				scope.addAll(formula.getScope());
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
			HigherOrderType receiverType = ImlTypeProvider.termExpressionType(receiver, context);
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
		} else if (formula instanceof SymbolReferenceTerm) {
			SymbolReferenceTerm symbolRef = (SymbolReferenceTerm) formula;
			// 1. Get FunctionDeclaration for the symbol
			FormulaT symbolRefFormula = getSymbolAccessFormula(symbolRef, context, inst, scope);
			
			// 2. Handle Tails from left to right
			if (symbolRef.getTails() != null &&  !symbolRef.getTails().isEmpty()) {
				Symbol symbol = symbolRef.getSymbol();
				if (symbol instanceof SymbolDeclaration) {
					HigherOrderType type = ImlTypeProvider.getType((SymbolDeclaration) symbol, context);
					for (SymbolReferenceTail tail : symbolRef.getTails()) {
						// Get the symbol type
						if (tail instanceof ArrayAccess) {
							FuncDeclT arrayAccessFun = getFuncDeclaration(type);
							symbolRefFormula = smtModelProvider.createFormula(arrayAccessFun, Arrays.asList(symbolRefFormula));
						} else { // TupleConstructor
							List<FormulaT> tupleFormulas = encodeTupleElements((TupleConstructor) tail, context);
							// TODO function call here 
						}
						
						type = ImlTypeProvider.accessTail(type, tail); // TODO revisit the type provider
					}
				}
			}
			return symbolRefFormula;
		} else if (formula instanceof TypeConstructor) {
			// TODO Assert the type constructor content
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
			
		} else if (formula instanceof This) {
			// Not used for now
		} else if (formula instanceof TruthValue) {
			return smtModelProvider.createFormula(((TruthValue) formula).isTRUE());
		} else if (formula instanceof Program) {
			// TODO use let binder
		} else if (formula instanceof LambdaExpression) {
			// TODO
			// lambda encoding alone = encode(definition)
			
			// At higher level if Symbol type is HOT, then we need to create forall(p in parameters) {symbol.select(p) = encode(definition with parameter mapping)}
		}
		
		throw new SMTEncodingException("Unsupported formula: " + formula);
	}
	
	private boolean isAssertion(FolFormula formula) {
		SymbolDeclaration symbolDeclaration = EcoreUtil2.getContainerOfType(formula, SymbolDeclaration.class);
		return (symbolDeclaration.getPrimitiveProperty() != null && symbolDeclaration.getPrimitiveProperty() instanceof Assertion);
	}

	private List<FormulaT> encodeTupleElements(TupleConstructor tail, SimpleTypeReference context) {
//		return tail.getElements().stream().map(it -> encodeFormula(it, context)).collect(Collectors.toList());
		return null;
	}

	private FormulaT getSymbolAccessFormula(SymbolReferenceTerm symbolRef, SimpleTypeReference context, FormulaT inst, List<SymbolDeclaration> scope) {
		// Check the scope first
		if (scope != null && scope.contains(symbolRef.getSymbol())) {
			return smtModelProvider.createFormula(symbolRef.getSymbol().getName());
		}
		
		// Handle super types
		FuncDeclT symbolAccess = getSymbolDeclFun((SymbolDeclaration) symbolRef.getSymbol(), context);
		if (symbolAccess == null) {
			for (RelationInstance relation : context.getType().getRelations()) {
				SimpleTypeReference parent = null;
				if (relation instanceof Extension) {
					if (relation.getTarget() instanceof SimpleTypeReference) {
						parent = (SimpleTypeReference) relation.getTarget();
					}
				} else if (relation instanceof Alias) {
					if (relation.getTarget() instanceof SimpleTypeReference) {
						parent = (SimpleTypeReference) relation.getTarget();
					}
				}
				if (parent != null) {
					FuncDeclT relationFunction = getFuncDeclaration(context, relation); // Get the function declaration for current relation
					FormulaT parentSymbolAccess = getSymbolAccessFormula(symbolRef, parent, smtModelProvider.createFormula(relationFunction, Arrays.asList(inst)), scope);
					if (parentSymbolAccess != null) {
						return parentSymbolAccess;
					}
				}
			}
			return null; 
		} else {
			return smtModelProvider.createFormula(symbolAccess, Arrays.asList(inst));
		}
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
			if (symbolDecl.eContainer() instanceof Model) {
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
			sb.append(sort + "\n");
		}
		
		for (FuncDeclT funDecl : symbolTable.getFunDecls()) {
			sb.append(funDecl + "\n");
		}
		
		return sb.toString();
	}
	
}
 