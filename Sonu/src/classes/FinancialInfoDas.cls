public class FinancialInfoDas {
    @auraEnabled
    public static list<Wrapperclass> getFAs(string Id){
        map<string,string> MapFAtype = new map<string,string>();
        map<string,list<string>> MapFAfieldnames = new map<string,list<string>>();
        
        for(TC_Financial_Account_Details__mdt fad : [select id,DeveloperName,TC_Field_Containing_Balance__c,TC_IsNegativeInstrument__c from TC_Financial_Account_Details__mdt]){
            if(fad.TC_IsNegativeInstrument__c){
                MapFAtype.put(fad.DeveloperName, 'Negative');
            }
            else{
                MapFAtype.put(fad.DeveloperName, 'Positive');
            }
            if(!MapFAfieldnames.containsKey(fad.DeveloperName)){
                MapFAfieldnames.put(fad.DeveloperName, new list<string>());
            }
            MapFAfieldnames.get(fad.DeveloperName).addAll(fad.TC_Field_Containing_Balance__c.split(','));
            
        }
        string query = 'SELECT Id,RecordType.DeveloperName, Name, RecordTypeId, ';
        for(list<string> fnames : MapFAfieldnames.values()){
            for(string fieldnames : fnames){
                query += fieldnames + ', ';
            }
        }
        query = query.substring(0,query.length()-2);
        query+=' from Finserv__FinancialAccount__c WHERE Finserv__PrimaryOwner__c=\'' + id + '\'';
        
        list<Wrapperclass> lwc = new list<Wrapperclass>();
        
        for(Finserv__FinancialAccount__c fa : database.query(query)){
            if(MapFAtype.containsKey(fa.RecordType.DeveloperName)){
                if(MapFAtype.get(fa.RecordType.DeveloperName) == 'Positive'){
                    Finserv__FinancialAccount__c falocal = new Finserv__FinancialAccount__c();
                    falocal.Name = fa.name;
                    for(string field : MapFAfieldnames.get(fa.RecordType.DeveloperName)){
                        falocal.put(field,(object)fa.get(field));
                    }
                    Wrapperclass wc = new Wrapperclass(true,false,falocal);
                    lwc.add(wc);
                }
                
                if(MapFAtype.get(fa.RecordType.DeveloperName) == 'Negative'){
                    Finserv__FinancialAccount__c falocal = new Finserv__FinancialAccount__c();
                    falocal.Name = fa.name;
                    for(string field : MapFAfieldnames.get(fa.RecordType.DeveloperName)){
                        falocal.put(field,(object)fa.get(field));
                    }
                    Wrapperclass wc = new Wrapperclass(false,true,falocal);
                    lwc.add(wc);
                }
            }
        }
        return lwc;
    }
    
    
    
    public class Wrapperclass{
        @auraEnabled public boolean ispositive;
        @auraEnabled public boolean isNegative;
        @auraEnabled public Finserv__FinancialAccount__c FArequired;
        public Wrapperclass(boolean ispositive, boolean isNegative, Finserv__FinancialAccount__c FArequired){
            this.ispositive = ispositive;
            this.isNegative = isNegative;
            this.FArequired = FArequired;
        }
    }
}