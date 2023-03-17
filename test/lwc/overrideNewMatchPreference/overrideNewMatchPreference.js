import { LightningElement,track,api,wire } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import { encodeDefaultFieldValues } from 'lightning/pageReferenceUtils';
import { CurrentPageReference } from 'lightning/navigation';
import getMatchReferences from "@salesforce/apex/MatchPreferenceNewOverideClass.getMatchReferences";

export default class OverrideNewMatchPreference extends NavigationMixin (LightningElement) {
@wire(CurrentPageReference)
pageRef
@api recordId;
parentId;
@track showMsg=false;
@track hasRendered = true;
base64Context;
addressableContext;

@wire(CurrentPageReference)
pageRef
connectedCallback() {
    //if(this.hasRendered){
        console.log('In connectedCallback');
this.getMatchReferences();
//this.hasRendered=false;
    //}

}
hideModalBox() {  
    this.showMsg = false;
    
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

getMatchReferences() {
   
  
    this.base64Context = this.pageRef.state.inContextOfRef;
    if (this.base64Context.startsWith("1\.")) {
        this.base64Context = this.base64Context.substring(2);
    }
    this.addressableContext = JSON.parse(window.atob(this.base64Context));
   
    console.log('recordId=='+this.addressableContext.attributes.recordId);
    this.parentId=this.addressableContext.attributes.recordId;

    const defaultValues = encodeDefaultFieldValues({
        Match_Maker__Profile__c: this.parentId
    });
    getMatchReferences({
        profileId: this.parentId
    
    })
    //console.log('Called Apex Method');
        .then((result) => {
        console.log('result=='+JSON.stringify(result));
        if (result>=1) {
            this.showMsg=true;
           console.log('In If Condition');
            
        }
        else{
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
         

        }
        })
        .catch((error) => {
        console.log("error in get profile: ", error);
        });
    }

}