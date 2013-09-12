SMMTT
=====

Social Media Machine Translation Toolkit - Everything you need to start building Machine Translation Systems on Social Media

This toolkit was proposed as a project in MTMarathon 2013.

Proposed and Maintained by:Wang Ling (http://www.cs.cmu.edu/~lingwang/)

Contributors: Carolin Haas, Chris Dyer, Adam Lopez

Usage: scripts/runExperiment.sh source(ex: en) target(ex: zh) rootdir(where this package is) mosesdir(moses instalation) mosesexternaldir(where giza is, probably mosesdecoder/tools) model(where the model and results will be generated)

Structure:

data/parallel/ - parallel dataset directory: to add more data add files ending with ".en-cn" in the format "<English Sentence> ||| <Chinese Sentence>" ( see existing data/parallel/microtopia.en-cn for an example)

scripts/runExperiment.sh - script that builds an mt system using existing data and evaluates on the microblog testset. Run without arguments for description.

scripts/tokenize/ - path with different tokenizers for different languages

The parallel data is obtained from http://www.cs.cmu.edu/~lingwang/microtopia/. So, if you use this toolkit please cite:

@inproceedings{wangling:acl2013,
 author = {Ling, Wang and Xiang, Guang and Dyer, Chris and Black, Alan and Trancoso, Isabel},
 title = {Microblogs as Parallel Corpora},
 booktitle = {Proceedings of the 51st Annual Meeting on Association for Computational Linguistics},
 series = {ACL '13},
 year = {2013},
 location = {Sofia, Bulgaria},
 numpages = {8},
 publisher = {Association for Computational Linguistics}
} 


