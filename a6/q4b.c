int x[8] = {1,2,3,-1,-2,0,184,340057058};
int y[8];

int f(int p) {
	int i = 0;
	int compareVal = -2147483648;
	while (p != 0) {
		if((p & compareVal) != 0) {
			i++;
		}
	p = p*2;
	}
	return i;
}



int main() {

	for (int n = 7; n >=0; n--) {
		y[n] = f(x[n]);
	}

	for(int i = 0; i < 8; i++)
        printf("%i\n", x[i]);
    
    for(int i = 0; i < 8; i++)
        printf("%i\n", y[i]);

}