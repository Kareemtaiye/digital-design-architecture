int main() {
    int pow = 1;
    int x = 0;
    int target = 128;


    do {
        pow = pow * 2;
        x = x + 1;
    } while(pow != target);

    return 0;
}