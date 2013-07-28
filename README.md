# A compositional vector-space model of meaning

1. Vector space semantic models provide a nice solution to the symbol grounding
   problem, and have various useful computational properties.

3. Current vector-space semantic models are exclusively discriminative. We want
   to give a _generative_ model of meaning while maintaining efficient
   algorithms for analyzing word sequences into vectors.

2. We reject stronger forms of the distributional hypothesis which assert that
   cooccurrence data contain all information necessary to specify the semantics
   of a word or sentence. 

3. It ought to be possible to _induce_ a complete vector space semantics from
   non-distributional training data.

The code provided here does precisely this. For a description of the model and
some preliminary results refer to:

- Jacob Andreas and Zoubin Ghahramani. "A Generative Model of Vector Space
  Semantics". To appear in CVSC 2013.

This work is ongoing, and code in the repository will be unstable.
