import { LightningElement, api,wire,track} from 'lwc';
export default class SiteformInLWC extends LightningElement {
    @api recordId;
    handleSuccess(event) {
        this.recordId = event.detail.id;
    }
    
    connectedCallback() {
        console.log('In connectedCallback');
        //this.getProfileId();
        console.log('his.recordId==='+this.recordId);
       // console.log('his.paret ID==='+this.parentId);

    }

    handleSave(event){
        console.log('this.recordI'+this.recordI);
        const even = new ShowToastEvent({
            title: 'Success!',
            message: 'Profile was saved successfully!',
            variant: 'success'
        });
    }
}