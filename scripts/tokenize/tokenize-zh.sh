TOK_DIR=`dirname $0`

java -jar $TOK_DIR/external/CNConvert.jar | java -jar $TOK_DIR/external/MTwokenizer/MTwokenizer.jar tok $TOK_DIR/external/MTwokenizer/regex 
