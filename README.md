SMMTT
=====

Social Media Machine Translation Toolkit - Everything you need to start building Machine Translation Systems on Social Media

structure:

data/parallel/ - parallel dataset directory: to add more data add files ending with ".en-cn" in the format "<English Sentence> ||| <Chinese Sentence>" ( see existing data/parallel/microtopia.en-cn for an example)

scripts/runExperiment.sh - script that builds an mt system using existing data and evaluates on the microblog testset. Run without arguments for description.

scripts/tokenize/ - path with different tokenizers for different languages
