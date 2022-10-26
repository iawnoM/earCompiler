
// Set of functions to emit MIPS code
FILE * MIPScode;

void  initAssemblyFile(){
    // Creates a MIPS file with a generic header that needs to be in every file

    MIPScode = fopen("MIPScode.asm", "w");
    
    fprintf(MIPScode, ".text\n");
    fprintf(MIPScode, "main:\n");
    fprintf(MIPScode, "# -----------------------\n");

    fclose(MIPScode);

}

void emitMIPSAssignment(char * id1, char * id2){
    MIPScode = fopen("MIPScode.asm", "a");
  // This is the temporary approach, until register management is implemented

    fprintf(MIPScode, "li $t1,%s\n", id1);
    fprintf(MIPScode, "li $t2,%s\n", id2);
    fprintf(MIPScode, "li $t2,$t1\n");

    fclose(MIPScode);
}

void emitMIPSConstantIntAssignment (int id1, char id2[50]){
    MIPScode = fopen("MIPScode.asm", "a");
     // This is the temporary approach, until register management is implemented
     // The parameters of this function should inform about registers
     // For now, this is "improvised" to illustrate the idea of what needs to 
     // be emitted in MIPS

     // nextRegister = allocateRegister(id1);  // This is conceptual to inform what needs to be done later
    printf("Emmiting INT mips ------>\n");
    fprintf(MIPScode, "li $t%d,%s\n", id1, id2);

    fclose(MIPScode);
}

void emitMIPSWriteInt(int id){
    MIPScode = fopen("MIPScode.asm", "a");
    // This is what needs to be printed, but must manage registers
    // $a0 is the register through which everything is printed in MIPS
    
    //fprintf(MIPScode, "li $a0,%s\n", id);
    fprintf(MIPScode, "# Printing -----------\n");
    fprintf(MIPScode, "move $a0, $t%d\n", id);
    fprintf(MIPScode, "li $v0, 1\n");
    fprintf(MIPScode, "syscall\n");

    fclose(MIPScode);
}

void emitMIPSWriteId(char * id){
    MIPScode = fopen("MIPScode.asm", "a");
    // This is what needs to be printed, but must manage registers
    // $a0 is the register through which everything is printed in MIPS
    
    //fprintf(MIPScode, "li $a0,%s\n", id);
    fprintf(MIPScode, "# Printing -----------\n");
    fprintf(MIPScode, "move $a0,%s\n", "$t0");
    fprintf(MIPScode, "li $v0, 4\n");
    fprintf(MIPScode, "syscall\n");

    fclose(MIPScode);
}

void emitMIPSArrayDecl (char id[50], int size) {
    MIPScode = fopen("MIPScode.asm", "a");

    // int bits = size*4;
    fprintf(MIPScode, "%s  .BLOCK   %d", id, size);

    fclose(MIPScode);
}

void emitEndOfAssemblyCode(){
    MIPScode = fopen("MIPScode.asm", "a ");

    fprintf(MIPScode, "# -----------------\n");
    fprintf(MIPScode, "#  Done, terminate program.\n\n");
    // fprintf(MIPScode, "li $v0,1   # call code for terminate\n");
    // fprintf(MIPScode, "syscall      # system call (terminate)\n");
    fprintf(MIPScode, "li $v0,10   # call code for terminate\n");
    fprintf(MIPScode, "syscall      # system call (terminate)\n");
    fprintf(MIPScode, ".end main\n");

    fclose(MIPScode);    
}
    