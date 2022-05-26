trigger updateContactCardDetails on Charge__c (after update) {
    Set<Id> contactId = new Set<Id>();
    List<Contact> contactListToUpdate = new List<Contact>();
    Contact contact = new Contact();

    for(Charge__c charge : Trigger.New){
        contactId.add(charge.Contact_Id__c);
        contact = [select id,FirstName,Card_Value__c,Last_Used__c,Total_Usage_Hours__c,Email from Contact where Id =: charge.Contact_Id__c];
        if(contact.Card_Value__c != null){
            contact.Card_Value__c = contact.Card_Value__c - charge.Cost__c;
        }
        contact.Last_Used__c = System.now();
        if(!contactId.isEmpty()){
         Decimal Sum;
         Sum=0;
         for(Charge__c sample_transaction : [SELECT id,Cost__c,Total_Time_Used__c FROM Charge__c WHERE Contact_Id__c = : contactId]){
             Sum+= sample_transaction.Total_Time_Used__c;
         }
         System.debug('Sum>>'+Sum);
         contact.Total_Usage_Hours__c = sum/3600;
     }
        contactListToUpdate.add(contact);
    }
    
    if(contactListToUpdate.size() > 0){
        update contactListToUpdate;
        HondaVehicleCharge.sendEmailToContactwithChargingDetails(contactListToUpdate);
    }
}