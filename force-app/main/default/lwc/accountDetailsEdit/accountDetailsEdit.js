import { LightningElement, api, wire } from 'lwc';
import { getRecord } from 'lightning/uiRecordApi';


const FIELDS = ['Account.Type', 'Account.AccountNumber'];
export default class AccountDetailsEdit extends LightningElement {
    @api recordId;

    accountInfo;
    @wire(getRecord, { recordId: '$recordId', fields: FIELDS })
    wiredRecord({ error, data }) {
        if (error) {
            console.log('error: ' + this.recordId);
        } else if (data) {
            this.accountInfo = data;
            //this.validateAccountNumber(this.accountInfo);
        }
    }

    handleSave() {
        console.log('Teste: ' + this.recordId);
    }

    showNotification(title, msg, variant) {
        const evt = new ShowToastEvent({
          title: title,
          message: msg,
          variant: variant
        })
        this.dispatchEvent(evt);
    }
}