#include<stdio.h>

int main(){
    char user_input[64];

    printf("Enter sentence: ");
    fgets(user_input, 64, stdin);
    printf("\nYour sentence is: %s", user_input);
    return 0;
}