import { LightningElement,api,wire,track} from 'lwc';
import {NavigationMixin} from 'lightning/navigation';
import { CloseActionScreenEvent } from 'lightning/actions';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { CurrentPageReference } from 'lightning/navigation';
import getMatchReferences from "@salesforce/apex/MatchPreferenceNewOverideClass.getMatchReferences";
export default class NewMatchPreferences extends NavigationMixin(LightningElement){

@api recordId;
parentId;
base64Context;
addressableContext;
minimumAge;
maximumAge;
minimumHeight;
maximumHeight;
status;
@track saveBool=false;
@track ageError='';
@track errorBool=false;
@track heightError='';
@track showMsg=false;
@track showMsg2 = true;
@wire(CurrentPageReference)
pageRef 

connectedCallback() {
console.log('In connectedCallback');
this.getMatchReferences();
}

hideModalBox() {  
    this.showMsg = false;
    this.saveBool=false;
    this[NavigationMixin.Navigate]({
        type: 'standard__recordPage',
        attributes: {
            recordId: this.parentId,
            objectApiName: 'Match_Maker__Profile__c',
            actionName: 'view'
        },
    });
    
    eval("$A.get('e.force:refreshView').fire();"); 
   
    
}

getMatchReferences(){
this.base64Context = this.pageRef.state.inContextOfRef;
if (this.base64Context.startsWith("1\.")) {
    this.base64Context = this.base64Context.substring(2);
}
this.addressableContext = JSON.parse(window.atob(this.base64Context));
console.log('recordId profile=='+this.addressableContext.attributes.recordId);
this.parentId=this.addressableContext.attributes.recordId;


getMatchReferences({
    profileId: this.parentId

})
//console.log('Called Apex Method');
    .then((result) => {
    console.log('result=='+JSON.stringify(result));
    if (result>=1) {
        this.showMsg=true;
        this.showMsg2=false;
       console.log('In If Condition');
        
    }
   /* else{
        this[NavigationMixin.Navigate]({
            type: 'standard__objectPage',
            attributes: {
                objectApiName: 'Match_Maker__Match_Preference__c',
                actionName: 'new'
            },
            state: {
                count:'1',                               
                nooverride:'1',
                navigationLocation:'lightning/o/Match_Maker__Profile__c/list?filterName=Recent',
                backgroundContext: '/lightning/r/Match_Maker__Profile__c/'+this.parentId+'/view',
                defaultFieldValues: defaultValues
            }
        });
     

    }*/
    })
    .catch((error) => {
    console.log("error in get profile: ", error);
    });

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
    this.saveBool=true;
    event.preventDefault();
        console.log('submitting fieldss no errors');
        this.template.querySelector("lightning-record-edit-form").submit();

    }

handelSuccess(event){
    this.saveBool=true;
const even = new ShowToastEvent({
    title: 'Success!',
    message: 'Match Preference Record has been created successfully!',
    variant: 'success'
});
this.dispatchEvent(even); 
this.saveBool=false;
    this[NavigationMixin.Navigate]({
        type: 'standard__recordPage',
        attributes: {
            recordId: this.parentId,
            objectApiName: 'Match_Maker__Profile__c',
            actionName: 'view'
        },
    });
    this.dispatchEvent(new CloseActionScreenEvent());
    eval("$A.get('e.force:refreshView').fire();");
}

handelCancel(event){
    this.saveBool=false;
this[NavigationMixin.Navigate]({
    type: 'standard__recordPage',
    attributes: {
        recordId: this.parentId,
        objectApiName: 'Match_Maker__Profile__c',
        actionName: 'view'
    },
});

this.dispatchEvent(new CloseActionScreenEvent());

}

}