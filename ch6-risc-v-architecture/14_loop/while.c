int main() {
    //determine the power x such that 2^x = 128

    int pow = 1;
    int x = 0;
    int target = 128;

    while (pow != target){   
       pow = pow * 2;
       x = x + 1;
    }
    
    return 0;
}   