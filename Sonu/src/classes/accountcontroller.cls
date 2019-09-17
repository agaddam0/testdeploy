public class accountcontroller {
    
    @AuraEnabled
public static List<Account> getacc() {
  
    List<Account> cases = [SELECT name,phone from Account Limit 1];
     return cases;
 }	

}