public class TC_FinancialInfo {
    
@auraEnabled

public static List<FAWrapper> getFAs ( String accountId ) {

    Map<String,String> mapFAToType = new Map<String,String>();

    Map<String,List<String>> mapFAToFieldName = new Map<String,List<String>>();

    

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

    String query = 'SELECT Id,RecordType.DeveloperName, Name, RecordTypeId, ';

    system.debug('--------mapFAToFieldName----------'+mapFAToFieldName.values());

    for( List<String> fieldNames : mapFAToFieldName.values() ) {
        for( String fName : fieldNames ) {
            query+= fName + ', ';
        }
    }




    query = query.substring(0,query.length()-2);

    query += ' FROM Finserv__FinancialAccount__c WHERE Finserv__PrimaryOwner__c = \'' + accountId + '\'';

    system.debug('-----------------------------query---------------'+query);

    List< FAWrapper > listFAWrapper = new List<FAWrapper>();

    System.debug( Database.query(query) + '--------------------'+mapFAToFieldName);

    for( Finserv__FinancialAccount__c fa :  Database.query(query)) {

        

        if( mapFAToType.containskey(fa.RecordType.DeveloperName) ) {

            if( mapFAToType.get(fa.RecordType.DeveloperName) == 'Positive') {
                
                Finserv__FinancialAccount__c faLocal = new Finserv__FinancialAccount__c();
                faLocal.Name = fa.Name;
             
                for( String field : mapFAToFieldName.get(fa.RecordType.DeveloperName)) {
                   faLocal.put(field,(Decimal)fa.get(field));
                }
                system.debug('--------------------------------------------'+faLocal);
                FAWrapper faw = new FAWrapper( true, false, faLocal );
                listFAWrapper.add(faw);

            }
            system.debug('--------------------------------------------'+listFAWrapper);

            if( mapFAToType.get(fa.RecordType.DeveloperName) == 'Negative') {
                
                Map<String, Decimal> localMap = new Map<String, Decimal>();
                
                //(Decimal)fa.get(mapFAToFieldName.get(Finserv__FinancialAccount__c.SObjectType.getDescribe().getRecordTypeInfosById().get(fa.RecordTypeId).getDeveloperName()))
                
               Finserv__FinancialAccount__c faLocal = new Finserv__FinancialAccount__c();
                faLocal.Name = fa.Name;
                for( String field : mapFAToFieldName.get(fa.RecordType.DeveloperName)) {
                   faLocal.put(field,(Decimal)fa.get(field));
                   
                }
                system.debug('--------------------------------------------'+faLocal);
                FAWrapper faw = new FAWrapper( false, true, faLocal );
                listFAWrapper.add(faw);
            }
        }
    }
    
    return listFAWrapper;

}


public class FAWrapper{
    @auraEnabled public Boolean isPositive;

    @auraEnabled public Boolean isNegative;

    @auraEnabled public Finserv__FinancialAccount__c requiredFA;
    public FAWrapper( Boolean isPositive, Boolean isNegative, Finserv__FinancialAccount__c requiredFA) {

        this.isPositive = isPositive;

        this.isNegative = isNegative;

        this.requiredFA = requiredFA;

    }





}

}