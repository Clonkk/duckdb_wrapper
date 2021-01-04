# Execute the example

The examples include the wrapper using Nimterop. It is done at compile time in ``duckdb_wrapper.nim``.

Run it using : 

``nim c -r duckDbExamples.nim``

It is probably also possible to generate the same thing using ``c2nim``.

# Redirecting the output of duckdb_wrapper

The output is clean with verbosity at 0 and hints:off (see ``config.nims``)
``nim c duckdb_wrapper.nim > generatedOutput_duckdbwrapper.nim``

Now ``generatedOutput_duckdbwrapper.nim`` contains your wrapper. Publish it in a nimble package if you want.


