// ---- Contains Calculations for Parser ---- //

int numArray[50];
char operatorArray[50];
int numCount = 0;
int opIndex = 0;

//TODO Find way to get value from AST and not the symbolTable

void printArray() {
    
    // Num Array
    printf("numArray{");
    for (int i = 0; i < 8; i++)  {
        printf("%d, ", numArray[i]);
    }
    printf("}\n\n");

    //Operator array
    // printf("opArray{");
    // for (int i = 0; i < 8; i++)  {
    //     printf("%s, ", operatorArray[i]);
    // }
    // printf("}\n\n");
    // printf("Test\n");

    
}

void reverseArray(int arr[], int start, int end) {
    
    int temp;
    while (start < end)
    {
        temp = arr[start];  
        arr[start] = arr[end];
        arr[end] = temp;
        start++;
        end--;
    }  
}  

void addNumToArray(int n, char c[5]) {
    
    // check for multiplication or division
    // printf("The binary operator is: %c\n", c);

    //Add operator to array
    // if (strcmp(c, "+") == 0) {
    //     printf("ADDITION STMT FOUND\n");
    // }
    operatorArray[opIndex] = c;
    //printf("opArray[%d] = %s", opIndex, operatorArray[opIndex]);
    opIndex++;       

    numArray[numCount] = n;
    printf("\nAdding %d to NumArray\n", n);
    numCount++;
    printArray();
    printf("Test\n");
}

int returnSum() {

    //Base case
    if (numCount == 1) {
        return numArray[0];
    }
    //reverseArray(); // put the array in correct order
    int sum = 0;

    int i = 0;
    while (i < numCount) {       
        //check for each operator and conduct corresponding arithmetic
        int currNum = numArray[i]; //var for current number
        char opCurr = operatorArray[i];

        // Multiplication
        if (strcmp(opCurr, "*") == 0) {

            printf("Operation = %d", numArray[i]);
            numArray[i] = currNum * numArray[i+1];
            shiftNums(i + 1);
        }
        // Division
        if (strcmp(opCurr, "*") == 0) {

            printf("Operation = %d", numArray[i]);
            numArray[i] = currNum / numArray[i+1];
            shiftNums(i + 1);
        }
        // Addition
        if (strcmp(opCurr, "*") == 0) {

            printf("Operation = %d", numArray[i]);
            numArray[i] = currNum + numArray[i+1];
            shiftNums(i + 1);
        }
        // Subtraction
        if (strcmp(opCurr, "*") == 0) {
            printf("Operation = %d", numArray[i]);        
            numArray[i] = currNum - numArray[i+1];
            shiftNums(i + 1);
        }   
        // for (int j = 0; j < opIndex; j++) {
            
        // }
        
        // sum += numArray[i];
        // numArray[i] = 0; //reset array
        printArray();

        // Increment i and decrease then numCount by 1
        i++;
        numCount--;
    }    

    // printf("Sum = %d", sum);
    return sum;
}

void shiftNums(int pos) {

   for (int i = pos; i < numCount - 1; i++)  {  
        numArray[i] = numArray[i+1]; // assign arr[i+1] to arr[i]  
    }  
    printArray();
}  

void clearNumArray() {
    
    for (int i = 0; i <= numCount; i++)  {
        numArray[i] == 0;
    }

    numCount = 0;
}
