// ---- Contains Calculations for Parser ---- //

int numArray[50];
int currentIndex = 0;

//TODO Find way to get value from AST and not the symbolTable

void printArray() {
    printf("numArray{");
    for (int i = 0; i < 8; i++)  {
        printf("%d, ", numArray[i]);
    }
    printf("}\n\n");
    
}

void addNumToArray(int n) {

    numArray[currentIndex] = n;
    printf("\nAdding %d to Array\n", n);
    currentIndex++;
    printArray();

}

int returnSum() {
    int sum = 0;

    for (int i = 0; i < 50; i++) {
        sum += numArray[i];
        numArray[i] = 0; //reset array
    }    

    // printf("Sum = %d", sum);
    return sum;
}


void reverseArray(int arr[], int start, int end)
{
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

void clearNumArray() {
    
    for (int i = 0; i <= currentIndex; i++)  {
        numArray[i] == 0;
    }

    currentIndex = 0;
}
 