package com.utc.utrc.hermes.iml.gen.nusmv.generator;

public class Configuration {

	public boolean bypass_delay;

	private Configuration(Builder b) {
		this.bypass_delay = b.bypass_delay;
	}

	public static class Builder {

		public boolean bypass_delay;
		// mandatory
//        public static Builder BypassDelay(boolean bd) {
//            Builder b = new Builder();
//            b.bypass_delay = bd ;
//            return b;
//        }

		public Builder() {
			bypass_delay = false;
		}
		
		public Builder BypassDelay(boolean bd) {
			this.bypass_delay = bd ;
			return this ;
		}
		
		public Configuration build() {
			return new Configuration(this);
		}

	}

	public boolean bypassDelay() {
		return bypass_delay;
	}

	
	

}
