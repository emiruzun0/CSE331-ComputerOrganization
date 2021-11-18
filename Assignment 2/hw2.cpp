#include <iostream>
#define MAX_SIZE 100

using namespace std;

int CheckSumPossibility(int num, int arr[], int size)
{
	if (num == 0){				//First base case
		return 1;
	}
	if (size == 0)				//Second base case
		return 0;

	if(arr[size-1] > num) return CheckSumPossibility(num,arr,size-1);		//To reduce compiler's work, send just one recursive call
	
	return  CheckSumPossibility(num-arr[size-1],arr,size-1) || CheckSumPossibility(num,arr,size-1);		//recursive calls

}


int main()
{
	int arraySize;
	int arr[MAX_SIZE];
	int num;
	int returnVal;
	cout << "Enter the array size : " ;
	cin >> arraySize;
	cout << "Enter the target number : ";
	cin >> num;
	for(int i = 0; i < arraySize; ++i)		//Take inputs for array
	{
		cout << i+1 << ".number : " ; 
		cin >> arr[i];
	}
	returnVal = CheckSumPossibility(num, arr, arraySize);
	if(returnVal == 1)
	{
		cout << "Possible!" << endl;
	}
	else
	{
		cout << "Not possible!" << endl;
	}
	return 0;
}
