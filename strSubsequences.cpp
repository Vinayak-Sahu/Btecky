#include<iostream>
using namespace std;

void Subsequences(string str, string output, int i){
  if(i>=str.length())
  {
    cout<<output<<endl;
    return;
  }
  Subsequences(str,output,i+1);

  output.push_back(str[i]);
  Subsequences(str,output,i+1);
}
int main()
{

 string str = "abcg";
 string output = "";
int i=0;
Subsequences(str,output,i);

return 0;
}