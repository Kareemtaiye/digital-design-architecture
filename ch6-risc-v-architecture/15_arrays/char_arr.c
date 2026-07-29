int main() {
    char chararray[10];
    int i;

    for(i = 0; i < 10; i+=1) {
        chararray[i] = chararray[i] - 32;   // Converts to lowercase
    }

    return 0;
}