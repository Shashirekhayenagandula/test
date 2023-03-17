import { LightningElement,api,wire,track} from 'lwc';
import {NavigationMixin} from 'lightning/navigation';
import { CloseActionScreenEvent } from 'lightning/actions';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { CurrentPageReference } from 'lightning/navigation';
import getProfileForMatchPreference from "@salesforce/apex/MatchPreferenceNewOverideClass.getProfileForMatchPreference";
export default class NewMatchPreferences extends NavigationMixin(LightningElement){
    @api recordId;
    parentId;
    parentId1;
    base64Context;
    addressableContext;
    minimumAge;
    maximumAge;
    minimumHeight;
    maximumHeight;
    status;
    @track ageError='';
@track errorBool=false;
@track heightError='';
   saveBool=false;
    @wire(CurrentPageReference)
    pageRef 

    connectedCallback() {
        console.log('In connectedCallback');
        this.getProfileId();

}

getProfileId(){
    this.base64Context = this.pageRef.state.inContextOfRef;
    if (this.base64Context.startsWith("1\.")) {
        this.base64Context = this.base64Context.substring(2);
    }
    this.addressableContext = JSON.parse(window.atob(this.base64Context));

    console.log('recordId=='+this.addressableContext.attributes.recordId);
    this.parentId=this.addressableContext.attributes.recordId;

   
} 

    @wire(getProfileForMatchPreference, { matchId: '$recordId'})
    deWired({ error, data }) {
        if (data) {
            this.parentId1 = data;
           
        } else if (error) {
            this.error = error;
        }
    }

validateFields() {
    console.log('validate fields entered');
    if(this.minimumAge>this.maximumAge){
        this.ageError='*Maximum Age Greater than Minimum Age';
        this.errorBool=true;
       /* const even = new ShowToastEvent({
            title: 'Invalid Data!',
            message: 'Min Age Should less than max Age!',
            variant: 'error'
        });
        this.dispatchEvent(even); */
    }
    
    if(this.minimumHeight>this.maximumHeight){
        this.heightError='*Maximum Height Greater than Minimum Helight';
        this.errorBool=true;
       /* const even = new ShowToastEvent({
            title: 'Invalid Data!',
            message: 'Min Height Should less than max Height!',
            variant: 'error'
        });
        this.dispatchEvent(even); */
    }
}

minAge(event){
        this.minimumAge = event.target.value;
        console.log('minage;;;;;'+this.minimumAge);
}
maxAge(event){
    this.maximumAge = event.target.value;
}
minHeight(event){
    this.minimumHeight=event.target.value;
}
maxHeight(event){
    this.maximumHeight=event.target.value;
}
marital(event){
    this.status=event.target.value;
}

handleSubmit(event) {
    event.preventDefault();
    
        console.log('submitting fieldss no errors');
        this.template.querySelector("lightning-record-edit-form").submit();
    
 
}

handelSuccess(event){
    const even = new ShowToastEvent({
        title: 'Success!',
        message: 'Match Preference was saved successfully!',
        variant: 'success'
    });
    if(this.parentId!=this.recordId)
        {
        this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: {
                recordId: this.parentId,
                objectApiName: 'Match_Maker__Profile__c',
                actionName: 'view'
            }
        });
       
    }
       else if(this.parentId==this.recordId){
        this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: {
                recordId: this.recordId,
                objectApiName: 'Match_Maker__Match_Preference__c',
                actionName: 'view'
            }
        });
    }

        this.dispatchEvent(even);
        
            this.dispatchEvent(new CloseActionScreenEvent()); 
}

    handelCancel(event){
        if(this.parentId!=this.recordId)
        {
        this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: {
                recordId: this.parentId,
                objectApiName: 'Match_Maker__Profile__c',
                actionName: 'view'
            }
        });
       
    }
    else if(this.parentId==this.recordId){
        this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: {
                recordId: this.recordId,
                objectApiName: 'Match_Maker__Match_Preference__c',
                actionName: 'view'
            }
        });
    }
    const inputFields = this.template.querySelectorAll('lightning-input-field' );

    if (inputFields) {
        inputFields.forEach(field => {
            field.reset();
        });

        this.dispatchEvent(new CloseActionScreenEvent());
       
    }

    
  }

}