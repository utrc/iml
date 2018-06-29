package com.utc.utrc.hermes.iml.generator.strategies;

import com.utc.utrc.hermes.iml.generator.infra.EncodedSymbol;
import com.utc.utrc.hermes.iml.generator.infra.SrlSymbol;
import com.utc.utrc.hermes.iml.generator.infra.SrlSymbolId;
import com.utc.utrc.hermes.iml.generator.infra.SymbolTable;

public class Encoder {

	public Encoder() {
		sttgs = new Strategies();
	}
	
	public void encode(SymbolTable st) throws EncodeStrategyException {
		
//		for (SrlSymbolId ssid : st.getSymbols().keySet()) {
//			EncodedSymbol es = st.getSymbols().get(ssid);
//			SrlSymbol ss = es.getSymbol();
//			if (es.getEncoding() != null)
//				throw new EncodeStrategyException("Solver level encode: expect not processed (null)");
//			es.setEncoding((sttgs.getStrategy(ss)).encode(ss));
//		}		
	}

	private Strategies sttgs = null;
}
