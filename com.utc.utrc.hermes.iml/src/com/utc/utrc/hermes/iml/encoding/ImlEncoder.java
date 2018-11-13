package com.utc.utrc.hermes.iml.encoding;

import com.utc.utrc.hermes.iml.iml.ConstrainedType;
import com.utc.utrc.hermes.iml.iml.FolFormula;
import com.utc.utrc.hermes.iml.iml.HigherOrderType;
import com.utc.utrc.hermes.iml.iml.Model;
import com.utc.utrc.hermes.iml.iml.Symbol;
import com.utc.utrc.hermes.iml.iml.SymbolDeclaration;
/**
 * This is an interface to abstract the encoding of any IML objects
 *
 * @author Ayman Elkfrawy (elkfraaf@utrc.utc.com)
 * @author Gerald Wang (wangg@utrc.utc.com) 
 */
public interface ImlEncoder {
	public void encode(ConstrainedType type);
	
	public void encode(HigherOrderType hot);
	
	public void encode(Symbol symbol);
	
	public void encode(SymbolDeclaration symbol);
	
	public void encode(Model model);
	
}
