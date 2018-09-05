package com.utc.utrc.hermes.iml.encoding;

import com.utc.utrc.hermes.iml.iml.ConstrainedType;
import com.utc.utrc.hermes.iml.iml.HigherOrderType;
import com.utc.utrc.hermes.iml.iml.Model;
import com.utc.utrc.hermes.iml.iml.Symbol;
import com.utc.utrc.hermes.iml.iml.SymbolDeclaration;

public interface ImlEncoder {
	public void encode(ConstrainedType type);
	
	public void encode(HigherOrderType hot);
	
	public void encode(Symbol symbol);
	
	public void encode(SymbolDeclaration symbol);
	
	public void encode(Model model);
}
