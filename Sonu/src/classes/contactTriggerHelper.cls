/*
*@Description: helper class for contact to user update
*@References: W-000056 - Sync Contact Record with associated User Record
*@Author: Akhil Prabhakaran 
*@Date: 12/06/2018 
*/

public class contactTriggerHelper {
    public static void updateUser(List<Contact> conList,Map<Id,Contact> oldConMap){
      //Only contact records of type Employee are considered
      Id conRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Employee').getRecordTypeId();
        List<Id> conIdList = new List<Id>();
        //Looping through contacts to check for the fields changed
        for(Contact con: conList){
            if(con.RecordTypeId == conRecordTypeId && oldConMap != Null && (con.FirstName != oldConMap.get(con.Id).FirstName || con.LastName != oldConMap.get(con.Id).LastName || con.Email != oldConMap.get(con.Id).Email || con.Phone != oldConMap.get(con.Id).Phone || con.Active_Practice_Resource__c != oldConMap.get(con.id).Active_Practice_Resource__c || con.Department != oldConMap.get(con.id).Department || con.Tek_Title__c != oldConMap.get(con.id).Tek_Title__c || con.Contact_Photo__c != oldConMap.get(con.id).Contact_Photo__c || con.MailingCountry != oldConMap.get(con.id).MailingCountry || con.MailingStreet != oldConMap.get(con.id).MailingStreet || con.MailingCity != oldConMap.get(con.id).MailingCity || con.MailingState != oldConMap.get(con.id).MailingState)){
                conIdList.add(con.Id);
            }
        }
        //Passing all the filtered contacts to the future method, to update the values to the user
        updateRecord(conIdList);
        
    }
    
    //This future method accepts the list contacts and updates the contact details to the related user. This method is written as future to avoid the mixed DML error
    @future
    public static void updateRecord(List<Id> conList){ 
        List<Contact> conUsrList = new List<Contact>();
        List<User> usrList = new List<User>();
        conUsrList = [select id,FirstName,LastName,Email,MailingCity,Department,Tek_Title__c,MobilePhone,Phone,Active_Practice_Resource__c,FinServ__CountryOfResidence__c,Time_Zone__c, user__c,Contact_Photo__c,MailingCountry,MailingState,MailingStateCode,MailingPostalCode,MailingStreet from Contact where id in : conList];
        //loop through contacts and update the values on  the user
        for(Contact con : conUsrList){
            User usr = new User(id=con.user__c,FirstName = con.FirstName,LastName = con.LastName, Title = con.Tek_Title__c, Department = con.Department, Phone = con.Phone, isActive = con.Active_Practice_Resource__c, MobilePhone = con.MobilePhone, street = con.MailingStreet, city = con.MailingCity, country = con.MailingCountry, State = con.MailingState, StateCode = con.MailingStateCode, PostalCode = con.MailingPostalCode);
            usrList.add(usr);
        }
        //update user
        if(usrList.size()>0){
            update usrList;
        }
    }
}