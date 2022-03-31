import 'package:get/get.dart';

class FreqSetController extends GetxController{
  List<int> freqs = [500,525,650].obs;

  setInitFreq(int index){
    // TODO get from data
  }
  bool validateFreq(){
    if(freqs[0]<freqs[1] && freqs[1]<freqs[2])
      {
        return true;
      }
    else {
      return false;
    }
  }
  setFreq(int value, int index, int hashBoard){
    freqs[index]=value;
  }
  submit(){
    if (validateFreq())
      {
       // callback.value = 'success';
      }
    else{
      //callback.value = 'need 3 freqs in ascending order';
    }
  }
}