import { LightningElement,api} from "lwc";
import sendMail from "@salesforce/apex/SendSiteformLink.sendMail";
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
export default class SendEmailSiteForm extends LightningElement {
    @api recordId;
    //console.log('====before recordId'+this.recordId);
    
    handleSave() {
        
        console.log('==== after recordId'+this.recordId);
        sendMail({
            
            recordId:this.recordId  

        })
        .then(() => {
                
            const event = new ShowToastEvent({
                title: 'SUCCESS',
                message: 'Profile Link Sent Successfully ',
                variant: 'success'
            });
            this.dispatchEvent(event);
            this.dispatchEvent(new CloseActionScreenEvent());
        })
        .catch((error) => {
            this.disabled = false;
            console.error("Error in sendEmailController:", error);
        });

    }
    closeQuickAction(event) {
       
        
        this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: {
                recordId: this.parentId,
                objectApiName: 'Match_Maker__Profile__c',
                actionName: 'view'
            }
        });
       
    }

}