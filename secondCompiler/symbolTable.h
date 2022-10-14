//Symbol table header
#include <string.h>

// This is a very simplistic implementation of a symbol table
// You will use this as reference and build a much more robust one

/*TODO for SymTab: 
	1.Remove item value and find new way to get value from the AST
	2. Determine what other symbol table functionalities we will need*/
	
struct Entry
{
	int itemID;
	char itemName[50];  //the name of the identifier
	char itemKind[8];  //is it a function or a variable?
	char itemType[8];  // Is it int, char, etc.?
	char itemValue[5]; 
	int arrayLength;
	char scope[50];     // global, or the name of the function
};

struct Entry symTabItems[100];
int symTabIndex = 0;
int SYMTAB_SIZE = 20;


void symTabAccess(void){
	printf("::::> Symbol table accessed.\n");
}


void addItem(char itemName[50], char itemKind[8], char itemType[8], int arrayLength, char scope[50]){
	

		// what about scope? should you add scope to this function?
		symTabItems[symTabIndex].itemID = symTabIndex;
		strcpy(symTabItems[symTabIndex].itemName, itemName);
		strcpy(symTabItems[symTabIndex].itemKind, itemKind);
		strcpy(symTabItems[symTabIndex].itemType, itemType);
		strcpy(symTabItems[symTabIndex].itemValue, "NULL");
		symTabItems[symTabIndex].arrayLength = arrayLength;
		strcpy(symTabItems[symTabIndex].scope, scope);
		symTabIndex++;
	
}

void showSymTable(){
	printf("\nitemID    itemName    itemKind    itemType     ArrayLength    itemSCope	 itemValue\n");
	printf("-----------------------------------------------------------------------------------\n");
	for (int i=0; i<symTabIndex; i++){
		printf("%5d %10s  %10s  %10s %10d %15s %10s \n",symTabItems[i].itemID, symTabItems[i].itemName, symTabItems[i].itemKind, symTabItems[i].itemType, symTabItems[i].arrayLength, symTabItems[i].scope, symTabItems[i].itemValue);
	}
	

	printf("-----------------------------------------------------------------------------------\n");
}

// Adds value to an ID in the symbol table
int setItemValue(char itemName[50], char itemValue[50], char scope[50]) {
	
	for (int i = 0; i < SYMTAB_SIZE; i++) {
		int str1 = strcmp(symTabItems[i].itemName, itemName); 
		int str2 = strcmp(symTabItems[i].scope,scope);
		
		if (str1 == 0 && str2 == 0) {
			strcpy(symTabItems[i].itemValue, itemValue);
			printf("\nValue: %s added to %s\n", itemValue, symTabItems[i].itemName);
			showSymTable();
			return 1; //value added 
		}
	}

	printf("Item %s was not found", itemName);	
	return 0;
}

// Returns the value of a given ID
int getValue(char itemName[50], char scope[50]) {

	int returnValue;

	for(int i=0; i<100; i++) {
		int str1 = strcmp(symTabItems[i].itemName, itemName);
		int str2 = strcmp(symTabItems[i].scope,scope);

		if( str1 == 0 && str2 == 0){
			returnValue = atoi(symTabItems[i].itemValue);
			// printf("Item Value:%d\n", returnValue);
			return returnValue;
		}
	}

	return 0; //item not found;
}

// Returns the ID of a given itemName
int getItemID(char itemName[50], char scope[50]) {

	for(int i=0; i<100; i++) {
		int str1 = strcmp(symTabItems[i].itemName, itemName);
		int str2 = strcmp(symTabItems[i].scope, scope);
		if( str1 == 0 && str2 == 0){
			return symTabItems[i].itemID;
		}
	}

	return -1; //item not found
}

int found(char itemName[50], char scope[50]) {
	// Lookup an identifier in the symbol table
	// what about scope?
	// return TRUE or FALSE
	// Later on, you may want to return additional information
	for(int i=0; i<100; i++) {
		int str1 = strcmp(symTabItems[i].itemName, itemName);
		int str2 = strcmp(symTabItems[i].scope,scope);
		if( str1 == 0 && str2 == 0){
			return 1; // found the ID in the table
		}
	}
	return 0;
}


//Returns the node type of the given ID
const char* getNodeType(char itemName[50], char scope[50]) {

	for (int i = 0; i < SYMTAB_SIZE; i++) {
		int str1 = strcmp(symTabItems[i].itemName, itemName); 
		int str2 = strcmp(symTabItems[i].scope, scope); 
		
		//If the ID is found and in scope, return the item type
		if (str1 == 0 && str2 == 0) {
			//printf("%s\n", symTabItems[i].itemType);
			return symTabItems[i].itemType;
		}
	}
	
	return NULL;
}

int compareTypes(char firstItemName[50], char secondItemName[50], char scope[50]) {
	const char* firstidType = getNodeType(firstItemName, scope); 
	const char* secondidType = getNodeType(secondItemName, scope); 

	printf("----SEMANTIC CHECK----\n");
	printf("%s = %s\n", firstidType, secondidType);

	int typesAreEqual = strcmp(firstidType, secondidType);
	
	if(typesAreEqual == 0) {
		return 1;
	}
	return 0;
}


