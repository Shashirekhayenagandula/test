import { LightningElement, api,wire,track} from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { CloseActionScreenEvent } from 'lightning/actions';
import {NavigationMixin} from 'lightning/navigation';
import { CurrentPageReference } from 'lightning/navigation';

export default class NewShortlistedEditForm extends NavigationMixin(LightningElement) {
    showpopup=true;
    @track data;
    @api recordId;
    parentId;
    base64Context;
    addressableContext;
    
    @wire(CurrentPageReference)
    pageRef; 
    
    connectedCallback() {
        console.log('In connectedCallback');
        this.getProfileId();
        console.log('his.recordId==='+this.recordId);
        console.log('his.paret ID==='+this.parentId);

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

    handleSubmit(event) {
        console.log('onsubmit event recordEditForm'+ event.detail.fields);
    }
    handleSave(event){
        const even = new ShowToastEvent({
            title: 'Success!',
            message: 'Shortlisted Profile was saved successfully!',
            variant: 'success'
        });
        if(this.parentId!=this.recordId)
        {
        this.showpopup=false;
        this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: {
                recordId: this.parentId,
                objectApiName: 'Match_Maker__Match_Preference__c',
                actionName: 'view'
            }
        });
       
    }
       else if(this.parentId==this.recordId){
        this.showpopup=false;
        this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: {
                recordId: this.recordId,
                objectApiName: 'Match_Maker__Shortlisted_Contact__c',
                actionName: 'view'
            }
        });
    }

        this.dispatchEvent(even);
        
            this.dispatchEvent(new CloseActionScreenEvent());
           // eval("$A.get('e.force:refreshView').fire();");

        }
    
    closeQuickAction(event) {
        if(this.parentId!=this.recordId)
        {
        this.showpopup=false;
        this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: {
                recordId: this.parentId,
                objectApiName: 'Match_Maker__Match_Preference__c',
                actionName: 'view'
            }
        });
       
    }
    else if(this.parentId==this.recordId){
        this.showpopup=false;
        this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: {
                recordId: this.recordId,
                objectApiName: 'Match_Maker__Shortlisted_Contact__c',
                actionName: 'view'
            }
        });
    }
    const inputFields = this.template.querySelectorAll(

        'lightning-input-field'

    );

    if (inputFields) {
        inputFields.forEach(field => {
            field.reset();
        });

        this.dispatchEvent(new CloseActionScreenEvent());
       
    }
   // eval("$A.get('e.force:refreshView').fire();");
}

disconnectCallback() {
    unregisterAllListeners(this);
}

}