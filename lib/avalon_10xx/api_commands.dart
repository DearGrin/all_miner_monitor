class CommandConstructor{
  String setPools(String username, String password, String pooladdr, String worker, String workerpasswd){
    String _ = 'ascset|0,setpool,$username,$password,$pooladdr,$worker,$workerpasswd';
    return _;
  }
  String reboot(){
    String _ = 'ascset|0,reboot,0';
    return _;
  }
  String getStats(){
    return 'estats';
  }
  String getPools(){
    return 'pools';
  }
  String setPrivilege(int level){
    String _ = 'privilege|0,enable_privilege,$level';
    return _;
  }
  String setFreq(int freq1, int freq2, int freq3, int freq4, int hash_no){ // hash_no starts from 1
    String _ = 'privilege|0,setfreq,$freq1, $freq2, $freq3, $freq4, $hash_no';
    return _;
  }
  String setVoltage(int? volt){
    String _ = 'privilege|0,setvolt,$volt'; // step is 40, min is 1200
    return _;
  }
  String disableFan(){
    return 'privilege|0,disable_fan';
  }
  String enableFan(){
    return 'privilege|0,enable_fan';
  }
  String setTemp(int? temp){
    String _ = 'privilege|0,settemp,$temp';
    return _;
  }
  String savePrivilegeSettings(){
    return 'privilege|0,savesettings';
  }
  String setChipMaxTemp(int? temp){
    String _ = 'privilege|0,set_chip_max_temp,$temp';
    return _;
  }
}