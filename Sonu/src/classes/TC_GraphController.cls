public without sharing class  TC_GraphController {
    
     @auraEnabled
   public static Map<String, Decimal> getChartMap( String accountId){
        
         Map<String,String> mapFAToType = new Map<String,String>();

    Map<String,List<String>> mapFAToFieldName = new Map<String,List<String>>();
	 Map<String, Decimal> mp = new Map<String, Decimal>();  
    

    for( TC_Financial_Account_Details__mdt fad : [ SELECT DeveloperName, TC_Field_Containing_Balance__c, TC_IsNegativeInstrument__c FROM TC_Financial_Account_Details__mdt ]) {

        if( fad.TC_IsNegativeInstrument__c ) {
            mapFAToType.put(fad.DeveloperName, 'Negative');
        }

        else {
           mapFAToType.put(fad.DeveloperName, 'Positive'); 
        }
        
        if( !mapFAToFieldName.containsKey(fad.DeveloperName)) {
            mapFAToFieldName.put(fad.DeveloperName, new List<String>());
        }
        
        mapFAToFieldName.get(fad.DeveloperName).addAll(fad.TC_Field_Containing_Balance__c.split(','));
        

    }
    system.debug('-----------------------------------'+mapFAToFieldName);
		system.debug('-----------------------------------'+mapFAToFieldName.values());
    String query = 'SELECT Id,RecordType.DeveloperName, Name, RecordTypeId,FinServ__Balance__c, ';
    
    system.debug('query ----->'+query);

    set<string> values=new set<string>();
    List<list<string>> values1=new List<list<string>>(mapFAToFieldName.values());
    
    
    for(List<string> val:values1){
        for(integer i=0;i<val.size();i++){
            if(val[i]=='FinServ__Balance__c'){
                val.remove(i);
            }else{
        for(string s:val){
        values.add(s);
            }
                }
            }
    }
    list<string> FieldValues=new list<string>();
    FieldValues.addAll(values);
    
    
        system.debug('-------------list ----------------------'+FieldValues);

    for( String fieldNames :FieldValues ) {
        
            query += fieldNames + ', ';
        

    }




    query = query.substring(0,query.length()-2);
    
    system.debug('query after sub string----->'+query);

    query += ' FROM Finserv__FinancialAccount__c WHERE Finserv__PrimaryOwner__c = \'' + accountId + '\'';

    system.debug('-----------------------------query---------------'+query);

    

    System.debug( Database.query(query) + '--------------------'+mapFAToFieldName);

    for( Finserv__FinancialAccount__c fa :  Database.query(query)) {

        if( mapFAToType.containskey(fa.RecordType.DeveloperName) ) {

            if( mapFAToType.get(fa.RecordType.DeveloperName) == 'Positive') {
                
                 mp.put(fa.Name, fa.FinServ__Balance__c);

            }
            

            if( mapFAToType.get(fa.RecordType.DeveloperName) == 'Negative') {
               
              mp.put(fa.Name, fa.FinServ__Balance__c*(-1));
            }
        }
        
    }
    
    return mp;

    }
}