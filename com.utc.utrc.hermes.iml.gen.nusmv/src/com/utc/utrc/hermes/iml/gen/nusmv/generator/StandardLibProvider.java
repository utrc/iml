package com.utc.utrc.hermes.iml.gen.nusmv.generator;

import java.util.Collection;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.eclipse.emf.ecore.EObject;
import org.eclipse.emf.ecore.resource.Resource;
import org.eclipse.emf.ecore.resource.ResourceSet;

import com.utc.utrc.hermes.iml.iml.NamedType;
import com.utc.utrc.hermes.iml.iml.Model;
import com.utc.utrc.hermes.iml.iml.Symbol;
import com.utc.utrc.hermes.iml.iml.SymbolDeclaration;

public class StandardLibProvider {
	
	
	private Map<String,Map<String,Symbol>> iml_symbols ;
	
	
	public StandardLibProvider(ResourceSet rs) {
		iml_symbols = new HashMap<>();
		populate(rs.getResources());
	}
	
	public void populate(List<Resource> libs) {
		for(Resource r : libs ) {
			if (r.getContents().get(0) instanceof Model) {
				if (isStandardLib((Model) r.getContents().get(0)))
					populate((Model) r.getContents().get(0)) ;
				}
		}
	}
	
	private boolean isStandardLib(Model m) {
		return m.getName().startsWith("iml.") ;
	}
	
	
	public void populate(Model m) {
		if (! iml_symbols.containsKey(m.getName())) {
			iml_symbols.put(m.getName(), new HashMap<>()) ;
		}
		for(Symbol s : m.getSymbols()) {
			
				iml_symbols.get(m.getName()).put(s.getName(), s);
			
		}
	}
	
	
	
	public NamedType getImlType(String qname) {
		String pkg = qname.substring(0, qname.lastIndexOf('.')) ;
		String name = qname.substring(qname.lastIndexOf('.')+1) ;
		if (iml_symbols.containsKey(pkg)) {
			if (iml_symbols.get(pkg).get(name) instanceof NamedType) {
				return (NamedType) iml_symbols.get(pkg).get(name) ;
			}
		}
		return null;
	}
	
	public SymbolDeclaration getImlSymbolDeclaration(String qname) {
		String pkg = qname.substring(0, qname.lastIndexOf('.')) ;
		String name = qname.substring(qname.lastIndexOf('.')+1) ;
		if (iml_symbols.containsKey(pkg)) {
			if (iml_symbols.get(pkg).get(name) instanceof SymbolDeclaration) {
				return (SymbolDeclaration) iml_symbols.get(pkg).get(name) ;
			}
		}
		return null;
	}
	
	
	public Collection<String> getImlStandardLibraries(){
		return iml_symbols.keySet() ;
	}
	
}
