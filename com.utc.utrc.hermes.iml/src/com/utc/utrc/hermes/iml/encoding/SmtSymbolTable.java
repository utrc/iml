package com.utc.utrc.hermes.iml.encoding;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.eclipse.emf.ecore.EObject;

import com.google.inject.Inject;
import com.utc.utrc.hermes.iml.iml.ConstrainedType;
import com.utc.utrc.hermes.iml.iml.SymbolDeclaration;
import com.utc.utrc.hermes.iml.iml.TupleType;

public class SmtSymbolTable<SortT, FunDeclT> {

	@Inject EncodedIdFactory encodedIdFactory;
	
	private Map<EncodedId, SortT> sorts;
	private Map<EncodedId, Map<EncodedId, FunDeclT>> funDecls;
	
	public SmtSymbolTable() {
		sorts = new HashMap<>();
		funDecls = new HashMap<>();
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
		if (type instanceof TupleType && ((TupleType) type).getSymbols().size() == 1) {
			return getSort(((TupleType) type).getSymbols().get(0).getType());
		}
		EncodedId id = encodedIdFactory.createEncodedId(type);
		return sorts.get(id);
	}

	public List<SortT> getSorts() {
		return new ArrayList<SortT>(sorts.values());
	}
	
	public void addFunDecl(EObject container, EObject symbol, FunDeclT funDecl) {
		EncodedId containerId = encodedIdFactory.createEncodedId(container);
		EncodedId symbolId = encodedIdFactory.createEncodedId(symbol);
		Map<EncodedId, FunDeclT> containerFunDecl = funDecls.get(containerId);
		if (containerFunDecl == null) {
			containerFunDecl = new HashMap<>();
			funDecls.put(containerId, containerFunDecl);
		}
		if (containerFunDecl.containsKey(symbolId)) return;
		
		containerFunDecl.put(symbolId, funDecl);
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
}
