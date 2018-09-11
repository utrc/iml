package com.utc.utrc.hermes.iml.encoding;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.eclipse.emf.ecore.EObject;

import com.google.inject.Inject;
import com.utc.utrc.hermes.iml.iml.ConstrainedType;
import com.utc.utrc.hermes.iml.iml.HigherOrderType;

public class SmtSymbolTable<SortT, DeclFunT> {

	@Inject EncodedIdFactory encodedIdFactory;
	
	private Map<EncodedId, SortT> sorts;
	private Map<EncodedId, DeclFunT> funDecls;
	
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

	public String getEncodedId(EObject type) {
		return encodedIdFactory.createEncodedId(type).stringId();
	}
	
	public SortT getSort(EObject type) {
		EncodedId id = encodedIdFactory.createEncodedId(type);
		return sorts.get(id);
	}

	public List<SortT> getSorts() {
		return new ArrayList<SortT>(sorts.values());
	}
}
