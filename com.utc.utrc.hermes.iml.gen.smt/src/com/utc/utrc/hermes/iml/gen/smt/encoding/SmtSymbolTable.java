package com.utc.utrc.hermes.iml.gen.smt.encoding;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.eclipse.emf.ecore.EObject;

import com.google.inject.Inject;
import com.utc.utrc.hermes.iml.iml.ConstrainedType;
import com.utc.utrc.hermes.iml.iml.SymbolDeclaration;
import com.utc.utrc.hermes.iml.iml.TupleType;
/**
 * This class responsible for storing SMT model and provide access to the symbols or elements inside it
 *
 * @author Ayman Elkfrawy (elkfraaf@utrc.utc.com)
 * @author Gerald Wang (wangg@utrc.utc.com)
 *
 * @param <SortT>
 * @param <FunDeclT>
 */
public class SmtSymbolTable<SortT, FunDeclT, FormulaT> {

	@Inject EncodedIdFactory encodedIdFactory;
	
	private Map<EncodedId, SortT> sorts;
	private Map<EncodedId, Map<EncodedId, FunDeclT>> funDecls;
	private Map<EncodedId, Map<EncodedId, FormulaT>> assertions;
	
	public SmtSymbolTable() {
		sorts = new HashMap<>();
		funDecls = new HashMap<>();
		assertions = new HashMap<>();
	}
	
	public void addSort(EObject type, SortT sort) {
		EncodedId id = encodedIdFactory.createEncodedId(type);
		if (sorts.containsKey(id)) return;
		sorts.put(id, sort);
	}
	
	public boolean contains(EObject type) {
		EncodedId encoded = encodedIdFactory.createEncodedId(type);
		return sorts.containsKey(encoded);
	}

	public String getUniqueId(EObject type) {
		return encodedIdFactory.createEncodedId(type).stringId();
	}
	
	public SortT getSort(EObject type) {
		EncodedId id = encodedIdFactory.createEncodedId(type);
		return sorts.get(id);
	}

	public List<SortT> getSorts() {
		return new ArrayList<SortT>(sorts.values());
	}
	
	public void addFunDecl(EObject container, EObject symbol, FunDeclT funDecl) {
		EncodedId containerId = encodedIdFactory.createEncodedId(container);
		EncodedId symbolId = encodedIdFactory.createEncodedId(symbol);
		Map<EncodedId, FunDeclT> containerFunDecls = funDecls.get(containerId);
		if (containerFunDecls == null) {
			containerFunDecls = new HashMap<>();
			funDecls.put(containerId, containerFunDecls);
		}
		if (containerFunDecls.containsKey(symbolId)) return;
		
		containerFunDecls.put(symbolId, funDecl);
	}

	public List<EncodedId> getEncodedIds() {
		return new ArrayList<>(sorts.keySet());
		
	}

	public SortT getPrimitiveSort(String typeName) {
		for (Map.Entry<EncodedId, SortT> sort : sorts.entrySet()) {
			EObject imlObject = sort.getKey().getImlObject();
			if (imlObject instanceof ConstrainedType && ((ConstrainedType) imlObject).getName().equals(typeName)) {
				return sort.getValue();
			}
		}
		return null;
	}

	public List<FunDeclT> getFunDecls() {
		List<FunDeclT> result = new ArrayList<>();
		for (Map<EncodedId, FunDeclT> func : funDecls.values()) {
			if (func != null) {
				result.addAll(func.values());
			}
		}
		return result;
	}

	public FunDeclT getFunDecl(EObject container, EObject imlObject) {
		EncodedId containerId = encodedIdFactory.createEncodedId(container);
		EncodedId imlId = encodedIdFactory.createEncodedId(imlObject);
		Map<EncodedId, FunDeclT> decls = funDecls.get(containerId);
		if (decls != null) {
			return decls.get(imlId);
		}
		return null;
	}
	
	public FunDeclT getFunDecl(EObject imlObject) {
		EncodedId imlId = encodedIdFactory.createEncodedId(imlObject);
		for (Map<EncodedId, FunDeclT> funs : funDecls.values()) {
			if (funs.containsKey(imlId)) {
				return funs.get(imlId);
			}
		}
		return null;
	}

	public void addFormula(EObject container, SymbolDeclaration symbol, FormulaT assertion) {
		EncodedId containerId = encodedIdFactory.createEncodedId(container);
		EncodedId symbolId = encodedIdFactory.createEncodedId(symbol);
		Map<EncodedId, FormulaT> containerAssertions = assertions.get(containerId);
		if (containerAssertions == null) {
			containerAssertions = new HashMap<>();
			assertions.put(containerId, containerAssertions);
		}
		if (containerAssertions.containsKey(symbolId)) return;
		
		containerAssertions.put(symbolId, assertion);
	}
	
	public List<FormulaT> getAllFormulas() {
		List<FormulaT> result = new ArrayList<>();
		for (Map<EncodedId, FormulaT> asserts : assertions.values()) {
			if (asserts != null) {
				result.addAll(asserts.values());
			}
		}
		return result;
	}
	
	public Map<EncodedId, Map<EncodedId, FormulaT>> getAssertions() {
		return assertions;
	}

	public void setAssertions(Map<EncodedId, Map<EncodedId, FormulaT>> assertions) {
		this.assertions = assertions;
	}

}