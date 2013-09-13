if [ "$#" -ne 6 ] || ! [ -d $3 ]; then
  echo "Usage: $0 source(ex: en) target(ex: zh) rootdir(where this package is) mosesdir(moses instalation) mosesexternaldir(where giza is, probably mosesdecoder/tools) model(where the model and results will be generated)">&2
  exit 1
fi

s=$1
t=$2
ROOT=$(cd $3; pwd)
CORPORA_ALL=$ROOT/data/
MOSES_DIR=$(cd $4; pwd)
MOSES_EXTERNAL_DIR=$(cd $5; pwd)
model=$(cd $(dirname $6); pwd)/$6

corpora=$model/corpora/

mkdir -p $corpora
cat $CORPORA_ALL/parallel/*.$s-$t > $corpora/parallel.$s-$t
cat $CORPORA_ALL/parallel/*.$t-$s | awk -F ' \\|\\|\\| ' '{print $2 " ||| " $1}' >> $corpora/parallel.$s-$t

cat $CORPORA_ALL/parallel_dev/*.$s-$t > $corpora/dev.$s-$t
cat $CORPORA_ALL/parallel_test/*.$s-$t > $corpora/test.$s-$t

cat $CORPORA_ALL/monolingual/*.$t > $corpora/monolingual.$t
cat $corpora/parallel.$s-$t | awk -F' \\|\\|\\| ' '{print $2}' >> $corpora/monolingual.$t
sh scripts/tokenize/tokenize-$t.sh < $corpora/monolingual.$t > $corpora/monolingual.tok.$t

cat $corpora/parallel.$s-$t | awk -F' \\|\\|\\| ' '{print $1}' > $corpora/parallel.$s
cat $corpora/parallel.$s-$t | awk -F' \\|\\|\\| ' '{print $2}' > $corpora/parallel.$t
cat $corpora/dev.$s-$t | awk -F' \\|\\|\\| ' '{print $1}' > $corpora/dev.$s
cat $corpora/dev.$s-$t | awk -F' \\|\\|\\| ' '{print $2}' > $corpora/dev.$t
cat $corpora/test.$s-$t | awk -F' \\|\\|\\| ' '{print $1}' > $corpora/test.$s
cat $corpora/test.$s-$t | awk -F' \\|\\|\\| ' '{print $2}' > $corpora/test.$t

sh $ROOT/scripts/tokenize/tokenize-$s.sh < $corpora/parallel.$s > $corpora/parallel.tok.$s
sh $ROOT/scripts/tokenize/tokenize-$t.sh < $corpora/parallel.$t > $corpora/parallel.tok.$t
sh $ROOT/scripts/tokenize/tokenize-$s.sh < $corpora/dev.$s > $corpora/dev.tok.$s
sh $ROOT/scripts/tokenize/tokenize-$t.sh < $corpora/dev.$t > $corpora/dev.tok.$t
sh $ROOT/scripts/tokenize/tokenize-$s.sh < $corpora/test.$s > $corpora/test.tok.$s
sh $ROOT/scripts/tokenize/tokenize-$t.sh < $corpora/test.$t > $corpora/test.tok.$t

#language modeling
lm=$model/lm
lmfile=$model/lm.binary
echo "building language model in $lm"
mkdir -p $lm
$MOSES_DIR/bin/lmplz -o 5 -T $ROOT/tmp -S 40% <$corpora/monolingual.tok.$t >$lm/lm.arpa 
$MOSES_DIR/bin/build_binary $lm/lm.arpa $lmfile

#translation modeling
tm=$model/tm

echo "building translation model in $tm"
$MOSES_DIR/scripts/training/clean-corpus-n.perl $corpora/parallel.tok $s $t $corpora/parallel.tok.train.filtered 1 80
	
$MOSES_DIR/scripts/training/train-model.perl -root-dir $tm -corpus $corpora/parallel.tok.train.filtered -f $s -e $t -alignment grow-diag-final-and -reordering msd-bidirectional-fe -lm 0:5:$lmfile:8 -external-bin-dir $MOSES_EXTERNAL_DIR

#tuning
$MOSES_DIR/scripts/training/mert-moses.pl $corpora/dev.tok.$s $corpora/dev.tok.$t $MOSES_DIR/bin/moses $tm/model/moses.ini --mertdir $MOSES_DIR/bin/ --working-dir $tm/model/tuning

#evaluation
evalDir=$model/eval
mkdir $evalDir
cat $corpora/test.tok.$s | $MOSES_DIR/bin/moses -f $tm/model/tuning/moses.ini > $evalDir/translated.txt
$MOSES_DIR/scripts/generic/multi-bleu.perl -lc $corpora/test.tok.$t <  $evalDir/translated.txt > $evalDir/bleu.txt

