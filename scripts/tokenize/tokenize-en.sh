TOK_DIR=`dirname $0`

perl $TOK_DIR/external/moses-tokenizer.perl -b -l en | perl $TOK_DIR/external/lowercase.perl
