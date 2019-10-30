int arr[10] = {0,0,0,0,0,0,0,0,0,0};

void b(int x, int y){
    
    arr[y] = arr[y] + x;
}

void a(int p, int q) {
	b(3,4);
	b(p,q);
}

int main(){
    a(1,2);  

   for(int i = 0; i < 10; i++)
        printf("%i\n", arr[i]);         
}