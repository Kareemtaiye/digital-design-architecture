int f1(int a, int b) {
    int i, x;
    x = (a + b) * (a - b);
    for(i = 0; i < a; i++) {
        x = x + f2(b + i);
    }

    return x;
}


int f2(int p) {
    int r;
    r = p + 5;

    return r + p;
}