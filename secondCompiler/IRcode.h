// ---- Functions to handle IR code emissions ---- //
FILE *IRcode;

void  initIRcodeFile(){
    IRcode = fopen("IRcode.ir", "w");    
    fclose(IRcode);
}

void emitBinaryOperation(char op[1], const char* id1, const char* id2){

    IRcode = fopen("IRcode.ir", "a");
    fprintf(IRcode, "T1 = %s %s %s", id1, op, id2);
    fclose(IRcode);
}

void emitAssignment(char * id1, char * id2){

    IRcode = fopen("IRcode.ir", "a");
  // Option 1
  // fprintf(IRcode, "%s = %s\n", id1, id2);

  // Option 2
  fprintf(IRcode, "T1 = %s\n", id1);
  fprintf(IRcode, "T2 = %s\n", id2);
  fprintf(IRcode, "T2 = T1\n");

  fclose(IRcode);
}

void emitConstantIntAssignment (int idNum, char id2[50]){

    IRcode = fopen("IRcode.ir", "a");
    // printf("Test%d\n", idNum);
    fprintf(IRcode, "T%d = %s\n", idNum, id2);

    fclose(IRcode);
}

void emitArrayDecl (char* id, int size, int idNum) {

    IRcode = fopen("IRcode.ir", "a");

    fprintf(IRcode, "%s[%d]\n", id, size);
    fprintf(IRcode, "T%d = %s\n", idNum, id);

    fclose(IRcode);
}

void emitWriteId(int id) {

    IRcode = fopen("IRcode.ir", "a");
    //fprintf (IRcode, "output %s\n", id); // This is the intent... :)

    // This is what needs to be printed, but must manage temporary variables
    // We hardcode T2 for now, but you must implement a mechanism to tell you which one...
    fprintf (IRcode, "write T%d\n", id);
    fclose(IRcode);
}