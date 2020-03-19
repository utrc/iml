package com.utc.utrc.hermes.iml.custom;

import java.math.BigDecimal;
import java.math.BigInteger;

import org.eclipse.xtext.common.services.DefaultTerminalConverters;
import org.eclipse.xtext.conversion.IValueConverter;
import org.eclipse.xtext.conversion.ValueConverter;
import org.eclipse.xtext.conversion.ValueConverterException;
import org.eclipse.xtext.conversion.impl.AbstractLexerBasedConverter;
import org.eclipse.xtext.conversion.impl.AbstractValueConverter;
import org.eclipse.xtext.nodemodel.INode;

import com.google.inject.Inject;

public class ImlValueConverters extends DefaultTerminalConverters {

	@Inject
	private BigIntegerValueConverter bigIntegerValueConverter;
	
	@Inject
	private BigDecimalValueConverter bigDecimalValueConverter;
	
	@ValueConverter(rule = "BIGINT")
	public IValueConverter<BigInteger> BIGINT() {
		return bigIntegerValueConverter;
	}
	
	@ValueConverter(rule = "FLOAT")
	public IValueConverter<BigDecimal> FLOAT() {
		return bigDecimalValueConverter;
	}
	
	private static class BigIntegerValueConverter extends AbstractValueConverter<BigInteger> {

		@Override
		public BigInteger toValue(String string, INode node)
				throws ValueConverterException {
			try {				
				return new BigInteger(string.replace(" ", ""));
			} catch (NumberFormatException e) {
				throw new ValueConverterException("BigInteger", node, e);
			}
		}

		@Override
		public String toString(BigInteger value) throws ValueConverterException {
			return value.toString();
		}
		
	}
	
	private static class BigDecimalValueConverter extends AbstractValueConverter<BigDecimal> {

		@Override
		public BigDecimal toValue(String string, INode node)
				throws ValueConverterException {
			try {				
				return new BigDecimal(string.replace(" ", ""));
			} catch (NumberFormatException e) {
				throw new ValueConverterException("BigInteger", node, e);
			}
		}

		@Override
		public String toString(BigDecimal value) throws ValueConverterException {
			return value.toString();
		}
		
	}
	
	
	
}
