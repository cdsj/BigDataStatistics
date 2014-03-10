//MPI
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

//c++ includes
#include <thrust/device_vector.h>
#include <thrust/tabulate.h>
#include <thrust/random.h>
#include <thrust/transform.h>
#include <thrust/transform_scan.h>
#include <thrust/sort.h>
#include <thrust/reduce.h>
#include <thrust/binary_search.h>
#include <thrust/iterator/constant_iterator.h>
#include <cmath>
#include <map>
#include <string>
#include <iostream>
#include <vector>

//#include <mpi.h>

using namespace std;

class KeyValue {
public:
   const char *key;
   unsigned value;
};

/* Returns true if string is all alphabetical*/
bool IsAlpha(char *toCheck) {
   int count;
   int len = strlen(toCheck);
   bool flag = true;

   for (count = 0; count < len && flag; count++) {
      if (flag = isalpha(toCheck[count])) {
         toCheck[count] = tolower(toCheck[count]);
      }
   }
   return flag;
}

map<string, int> countWords(FILE *fp, int fileSize) {
   map<string, int> words;
   char *fileData = (char *)malloc(fileSize);
   string temp;
   if (!fileData) {
      perror("Malloc");
      exit(1);
   }
   
   fread(fileData, sizeof(char),fileSize, fp);
   char *pch = strtok(fileData, " ,{}\"/=_()-<>`\'!.?:;\n ");
   while (pch) {
      if (IsAlpha(pch)) {
         words[string(pch)]++;
      }
      pch = strtok(NULL, " ,{}\"/=_()-<>`\'!.?:;\n");
   }
   
   return words;
}


int main(int argc, char **argv) {
   map<string, int> words;

   if (argc < 3) {
      fprintf(stderr, "Usage: %s <infile> <outfile.hist>\n", *argv);
      exit(1);
   }
   
   FILE *fp = fopen(argv[1],"r");
   fseek(fp, 0, SEEK_END);
   int fileSize = ftell(fp);
   rewind(fp);

   words = countWords(fp, fileSize); 
   FILE *outfile = fopen(argv[2], "w");
   if (!outfile) {
      perror("fopen");
      exit(1);
   }
   thrust::device_vector<const char *> d_keys;
   thrust::device_vector<int> d_values;
  
   for (map<string, int>::iterator it = words.begin(); it!=words.end(); 
    it++){
      d_keys.push_back(it->first.c_str());
      d_values.push_back(it->second);
   }
   
   thrust::host_vector<const char *> keys;
   thrust::host_vector<int> values;
   
   thrust::sort_by_key(d_values.begin(), d_values.end(), d_keys.begin(), 
    thrust::greater<int>());

   keys = d_keys;
   values = d_values;
   thrust::host_vector<int>::iterator vit = values.begin();
   for (thrust::host_vector<const char *>::iterator it = keys.begin();
    it != keys.end(); it++, vit++) {
      fprintf(outfile, "%s, %d\n", *it, *vit);
   }

   fclose(outfile);
   fclose(fp);
}