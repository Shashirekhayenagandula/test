import { LightningElement ,api,track} from 'lwc';
import sendMail from "@salesforce/apex/InvoicePdfClass.sendInvoiceMail";
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { CloseActionScreenEvent } from 'lightning/actions';

export default class SendInvoicePdf extends LightningElement {
    @api recordId;
    //console.log('====before recordId'+this.recordId);
    @track isShowModal = true;
    @track sendBoolean=false
    handleSave(event) {
        let fields = event.detail.fields;
        console.log( 'Fields are ' +  JSON.stringify( fields ) );
        this.sendBoolean=true;

        console.log('==== after recordId'+this.recordId);
        sendMail({
              
            recordId:this.recordId
            
        })
        .then(() => {
            this.showpopup=false; 
            const event = new ShowToastEvent({
                title: 'SUCCESS',
                message: 'Invoice Pdf Sent Successfully ',
                variant: 'success'
            });
            this.isShowModal = false;
            this.dispatchEvent(event);
            this.dispatchEvent(new CloseActionScreenEvent());
        })
        .catch((error) => {
            this.sendBoolean=false;
            this.disabled = false;
            sendBoolean=
            console.error("Error in sendEmailController:", error);
        });

    }
    closeQuickAction(event) {
        this.sendBoolean=false;
        this.showpopup=false;
        this.dispatchEvent(new CloseActionScreenEvent());
      
       
    }


}