/**
 * xpwn.c - Part of Ac1dSn0w
 * Copyright (C) 2011-2012 Manuel Gebele (forensix)
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 **/

#include "xpwn.h"
#include <stdio.h>
#include <string.h>
#include "libxpwn.h"
#include "nor_files.h"

/*
 * https://github.com/forensix/xpwn/blob/master/ipsw-patch/xpwntool.c
 */

#define BUFFERSIZE (1024*1024)

int xpwn(int argc, char* argv[]) {
	char* inData;
	size_t inDataSize;
	init_libxpwn(&argc, argv);
	
	if(argc < 3) {
		printf("usage: %s <infile> <outfile> [-x24k|-xn8824k] [-t <template> [-c <certificate>]] [-k <key>] [-iv <key>] [-decrypt]\n", argv[0]);
		return 0;
	}
	
	AbstractFile* template = NULL;
	AbstractFile* certificate = NULL;
	unsigned int* key = NULL;
	unsigned int* iv = NULL;
	int hasKey = FALSE;
	int hasIV = FALSE;
	int x24k = FALSE;
	int xn8824k = FALSE;
	int doDecrypt = FALSE;
	
	int argNo = 3;
	while(argNo < argc) {
		if(strcmp(argv[argNo], "-t") == 0 && (argNo + 1) < argc) {
			template = createAbstractFileFromFile(fopen(argv[argNo + 1], "rb"));
			if(!template) {
				fprintf(stderr, "error: cannot open template\n");
				return 1;
			}
		}
		
		if(strcmp(argv[argNo], "-decrypt") == 0) {
			doDecrypt = TRUE;
			template = createAbstractFileFromFile(fopen(argv[1], "rb"));
			if(!template) {
				fprintf(stderr, "error: cannot open template\n");
				return 1;
			}
		}
		
		if(strcmp(argv[argNo], "-c") == 0 && (argNo + 1) < argc) {
			certificate = createAbstractFileFromFile(fopen(argv[argNo + 1], "rb"));
			if(!certificate) {
				fprintf(stderr, "error: cannot open template\n");
				return 1;
			}
		}
		
		if(strcmp(argv[argNo], "-k") == 0 && (argNo + 1) < argc) {
			size_t bytes;
			hexToInts(argv[argNo + 1], &key, &bytes);
			hasKey = TRUE;
		}
		
		if(strcmp(argv[argNo], "-iv") == 0 && (argNo + 1) < argc) {
			size_t bytes;
			hexToInts(argv[argNo + 1], &iv, &bytes);
			hasIV = TRUE;
		}
		
		if(strcmp(argv[argNo], "-x24k") == 0) {
			x24k = TRUE;
		}
		
		if(strcmp(argv[argNo], "-xn8824k") == 0) {
			xn8824k = TRUE;
		}
		
		argNo++;
	}
	
	AbstractFile* inFile;
	if(doDecrypt) {
		if(hasKey) {
			inFile = openAbstractFile3(createAbstractFileFromFile(fopen(argv[1], "rb")), key, iv, 0);
		} else {
			inFile = openAbstractFile3(createAbstractFileFromFile(fopen(argv[1], "rb")), NULL, NULL, 0);
		}
	} else {
		if(hasKey) {
			inFile = openAbstractFile2(createAbstractFileFromFile(fopen(argv[1], "rb")), key, iv);
		} else {
			inFile = openAbstractFile(createAbstractFileFromFile(fopen(argv[1], "rb")));
		}
	}
	if(!inFile) {
		fprintf(stderr, "error: cannot open infile\n");
		return 2;
	}
	
	AbstractFile* outFile = createAbstractFileFromFile(fopen(argv[2], "wb"));
	if(!outFile) {
		fprintf(stderr, "error: cannot open outfile\n");
		return 3;
	}
	
	
	AbstractFile* newFile;
	
	if(template) {
		if(hasKey && !doDecrypt) {
			newFile = duplicateAbstractFile2(template, outFile, key, iv, certificate);
		} else {
			newFile = duplicateAbstractFile2(template, outFile, NULL, NULL, certificate);
		}
		if(!newFile) {
			fprintf(stderr, "error: cannot duplicate file from provided template\n");
			return 4;
		}
	} else {
		newFile = outFile;
	}
	
	if(hasKey && !doDecrypt) {
		if(newFile->type == AbstractFileTypeImg3) {
			AbstractFile2* abstractFile2 = (AbstractFile2*) newFile;
			abstractFile2->setKey(abstractFile2, key, iv);
		}
	}
	
	if(x24k) {
		if(newFile->type == AbstractFileTypeImg3) {
			exploit24kpwn(newFile);
		}
	}	
	
	if(xn8824k) {
		if(newFile->type == AbstractFileTypeImg3) {
			exploitN8824kpwn(newFile);
		}
	}
	
	
	inDataSize = (size_t) inFile->getLength(inFile);
	inData = (char*) malloc(inDataSize);
	inFile->read(inFile, inData, inDataSize);
	inFile->close(inFile);
	
	newFile->write(newFile, inData, inDataSize);
	newFile->close(newFile);
	
	free(inData);
	
	if(key)
		free(key);
	
	if(iv)
		free(iv);
	
	return 0;
}
