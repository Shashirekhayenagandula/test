import { LightningElement, track,api,wire } from "lwc";
import sendEmailController from "@salesforce/apex/EmailClass.sendEmailController";
import profileDetails from "@salesforce/apex/EmailClass.profileDetails";
import { CloseActionScreenEvent } from 'lightning/actions';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
export default class EmailLwc extends LightningElement {
    toAddress = [];
    subject = "";
    //body = "Please find the attachment below.";
    @track profileDetails;
    @api recordId;
    noEmailError = false;
    invalidEmails = false;
    disabled = false; 
   
    handleRemove(event) {
        const index = event.target.dataset.index;
        this.files.splice(index, 1);
    }

    handleToAddressChange(event) {
        this.toAddress = event.detail.selectedValues;
    }

   /* handleCcAddressChange(event) {
        this.ccAddress = event.detail.selectedValues;
    }
    */
    handleSubjectChange(event) {
        
        this.subject = event.target.value;
    }
/*
    handleBodyChange(event) {
        this.body = event.target.value;
    }
*/
   validateEmails(emailAddressList) {
        let areEmailsValid;
        if(emailAddressList.length > 1) {
            areEmailsValid = emailAddressList.reduce((accumulator, next) => {
                const isValid = this.validateEmail(next);
                return accumulator && isValid;
            });
        }
        else if(emailAddressList.length > 0) {
            areEmailsValid = this.validateEmail(emailAddressList[0]);
        }
        console.log('areEmailsValid===',areEmailsValid);
        return areEmailsValid;
    }

    validateEmail(email) {
        console.log("===In validate  Email===");
        const res = /^([A-Za-z0-9_\-\.])+\@([A-Za-z0-9_\-\.])+\.([A-Za-z]{2,4})$/;
        console.log("res", res);
        return res.test(String(email).toLowerCase());
    }

    handleReset() {
        this.toAddress = [];
        //this.ccAddress = [];
        this.subject = "";
        this.body = "";
        //this.files = [];
        this.template.querySelectorAll("c-send-to").forEach((input) => input.reset());
    }

    handleSendEmail() {
        this.disabled = true;
        this.noEmailError = false;
        this.invalidEmails = false;
        if (![...this.toAddress].length > 0) {
            this.noEmailError = true;
            this.disabled = false;
            return;
        }
        
        if (!this.validateEmails([...this.toAddress])) {
            this.disabled = false;

            this.invalidEmails = true;
            return;
        }
      

        let emailDetails = {
            toAddress: this.toAddress,
            //ccAddress: this.ccAddress,
            subject: this.subject,
            //body: this.body,
            profileid : this.recordId
        };
        console.log('emailDetails=='+JSON.stringify(emailDetails));

        sendEmailController({ emailDetailStr: JSON.stringify(emailDetails) })
            .then(() => {
                
                const event = new ShowToastEvent({
                    title: 'SUCCESS',
                    message: 'Email Sent Successfully ',
                    variant: 'success'
                });
                this.dispatchEvent(event);
                this.dispatchEvent(new CloseActionScreenEvent());
                console.log("Email Sent");
                
            
            })
            .catch((error) => {
                this.disabled = false;
                console.error("Error in sendEmailController:", error);
            });
           
            
    }
    
    
    handleClose(){
        this.dispatchEvent(new CloseActionScreenEvent());
        
    }

    @wire(profileDetails,{profileId : '$recordId'})
    wiredProfileDetails(result) {
        if(result.data){
            this.profileDetails = result.data;
            console.log('profileDetails wired=== '+this.profileDetails);
            this.subject='Profile of '+this.profileDetails.Name+'.'
            console.log('subject wired=== '+this.subject);
        }
    }
    
}