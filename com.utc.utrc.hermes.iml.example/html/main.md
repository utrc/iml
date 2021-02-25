# How to extend IML language and framework
The vision for IML is to be a framework where developers can contribute to and build their custom code on top of it. To support that vision, we have provided extensive extendability options using eclipse extension points. The summary of extension provided by IML are as following:
1. *Extending IML Libraries*: this allows the user to extend IML language by providing custom library to support specific domain.
2. *Extending IML Validators*: this allows the use to write custom validators for any IML constructs or custom IML libraries as defined in the previous point.
3. *Extending IML Generators*: where the user can write custom generators for IML or the custom libraries defined earlier.
4. *Extending IML Documentations*: where the use can provide documentations for any of the custom extensions mentioned before.

We also provided an example project `com.utc.utrc.hermes.iml.example` and associated test project `com.utc.utrc.hermes.iml.example.test` to give sample codes for how to use these extension points. In fact, this documentation is part of this example project for extending the IML documentations.