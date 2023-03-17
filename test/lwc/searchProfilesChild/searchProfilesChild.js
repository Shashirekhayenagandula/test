import { LightningElement ,api,track,wire} from 'lwc';
import ProfileObject from '@salesforce/schema/Profile__c';
import MatchPreferenceObj from '@salesforce/schema/Match_Preference__c';
import { getObjectInfo } from 'lightning/uiObjectInfoApi';
import {NavigationMixin} from 'lightning/navigation';
export default class SearchProfilesChild extends NavigationMixin(LightningElement) {
    @api profile=[];
    @api recordId;
    @track selectedShortlistedProfile;
    @track updatedProfileIds=[];
    profileslabel={} ;
    mplabel={} ;
   
    connectedCallback() {
       console.log('child connected callback');
       console.log('child profile valiue=============>'+this.profile);
    }

    handleSectionToggle(event){
        console.log(event.detail.openSections);
    }

    @wire(getObjectInfo, { objectApiName: ProfileObject })
    objInfo({ data, error }) {
        if (data){
            this.profileslabel=data;
            console.log('this.label => ',this.profileslabel);
            console.log('Age Label => ', data.fields.Match_Maker__Age__c.label);
        } 
    }

    @wire(getObjectInfo, { objectApiName: MatchPreferenceObj })
    objInfo1({ data, error }) {
        if (data){
            this.mplabel=data;
            console.log('this.label => ',this.mplabel);
            console.log('Age Label => ', data.fields.Match_Maker__Min_Age__c.label);
        } 
    }

    

    navigateProfile(event){
        let recId = event.target.value;
        console.log('recId==='+recId);
        this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: {
                
                recordId: recId,
                objectApiName: 'Profile__c', // objectApiName is optional
                actionName: 'view'
            }
        });
    }

    handleCheckBox(event){
       
        this.selectedShortlistedProfile=event.target.dataset.id;
        let checkvalue=event.target.checked;
        console.log('checkvalue'+this.checkvalue);

            this.dispatchEvent(new CustomEvent("checkboxvalue",{
                detail:{
                    profileid:this.selectedShortlistedProfile,
                    checkvalue:checkvalue
                }
            }));
           
    }
}