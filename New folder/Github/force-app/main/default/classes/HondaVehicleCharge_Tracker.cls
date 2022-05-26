@isTest
public class HondaVehicleCharge_Tracker {
    static testMethod void validateChargeRecordCreation() {
        List<Contact> contactList = new List<Contact>();
        
        Contact contact = new Contact();
        contact.FirstName = 'test123';
        contact.LastName = 'testName';
        contact.Email = 'test123@gmail.com';
        insert contact;
        contactList.add(contact);
        
        HondaVehicleCharge.chargeRecordCreation(contact.Id);
        HondaVehicleCharge.sendEmailToContactwithChargingDetails(contactList);
        HondaVehicleCharge.updateEndTimeOnRelatedContact(contact.Id);
    }
}