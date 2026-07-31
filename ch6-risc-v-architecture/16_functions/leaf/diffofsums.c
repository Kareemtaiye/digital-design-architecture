int main() {
    int y;
    //...
    y = diffofsums(2, 3, 4, 5);

    //...
    return 0;
}

int diffofsums(int a, int b, int c, int d) {
    int result = (a + b) - (c + d);
    return result;
}