#include <unistd.h>
int main(void)
{
    int i=(sizeof(int));
    
    write(1,&i,4);
    return 0;
}
