package com.utc.utrc.hermes.iml.encoding;

import java.util.Arrays;
import java.util.List;

public class SmtStandardLib {
	
	private static List<String> nativeTypes = Arrays.asList("Int", "Real", "Bool", "iml.lang.Int", "iml.lang.Real", "iml.lang.Bool");
	
	public static boolean isNative(String name) {
		return nativeTypes.contains(name);
	}

}
