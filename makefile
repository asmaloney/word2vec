CC = gcc

#Using -Ofast instead of -O3 might result in faster code, but is supported only by newer GCC versions
CFLAGS = -lm -pthread -O3 -march=native -Wall -funroll-loops -Wno-unused-result

SRC_DIR=./src
BIN_DIR=./bin
SCRIPTS_DIR=./scripts

all: word2vec word2phrase distance word-analogy compute-accuracy

word2vec : ${SRC_DIR}/word2vec.c
	$(CC) ${SRC_DIR}/word2vec.c -o ${BIN_DIR}/word2vec $(CFLAGS)

word2phrase : ${SRC_DIR}/word2phrase.c
	$(CC) ${SRC_DIR}/word2phrase.c -o ${BIN_DIR}/word2phrase $(CFLAGS)

distance : ${SRC_DIR}/distance.c
	$(CC) ${SRC_DIR}/distance.c -o ${BIN_DIR}/distance $(CFLAGS)

word-analogy : ${SRC_DIR}/word-analogy.c
	$(CC) ${SRC_DIR}/word-analogy.c -o ${BIN_DIR}/word-analogy $(CFLAGS)

compute-accuracy : ${SRC_DIR}/compute-accuracy.c
	$(CC) ${SRC_DIR}/compute-accuracy.c -o ${BIN_DIR}/compute-accuracy $(CFLAGS)
	chmod +x ${SCRIPTS_DIR}/*.sh

clean:
	rm -rf ${BIN_DIR}/word2vec ${BIN_DIR}/word2phrase ${BIN_DIR}/distance ${BIN_DIR}/word-analogy ${BIN_DIR}/compute-accuracy
