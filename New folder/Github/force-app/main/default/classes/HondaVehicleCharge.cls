public class HondaVehicleCharge {

    @AuraEnabled
    public static void chargeRecordCreation(Id recordId){
        Contact contact = [select FirstName,LastName from Contact where Id =: recordId];

        Charge__c charge = new Charge__c();
        charge.Contact_Id__c = recordId;
        charge.Start_Time__c = System.now();
        insert charge;
    }
    
    @AuraEnabled
    public static void updateEndTimeOnRelatedContact(Id recordId){
        Charge__c charge = [select id,Start_Time__c,End_Time__c,Contact_Id__c from Charge__c where Contact_Id__c =: recordId order by lastModifiedDate desc limit 1];
        charge.End_Time__c = System.now();
        update charge;
    }
    
    public static void sendEmailToContactwithChargingDetails(List<Contact> contactList){
        List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
        EmailTemplate template = [select id,subject,body,DeveloperName,HtmlValue from EmailTemplate where DeveloperName = 'Charging_Details'];
        for(Contact contact : contactList){
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            mail.setSubject(template.Subject);
            String body = template.HtmlValue;
            if(contact.FirstName != null){
                body = body.replace('[contactName]',String.valueOf(contact.FirstName));
            }
            if(contact.Card_Value__c != null){
                body = body.replace('[cardValue]',String.valueOf(contact.Card_Value__c));
            }
            mail.setHtmlBody(body);
            String []Address = new String[] { contact.Email };
            mail.settoAddresses(Address);
                mails.add(mail);
        }
        Messaging.sendEmail(mails);
    }
}