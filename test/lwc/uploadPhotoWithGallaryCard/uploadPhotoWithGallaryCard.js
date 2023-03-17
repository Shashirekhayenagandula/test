import { LightningElement, api,wire,track } from "lwc";
import { fireEvent } from 'c/pubsub';
import {NavigationMixin} from 'lightning/navigation';
import { CurrentPageReference } from 'lightning/navigation';
import delFiles from '@salesforce/apex/UploadPhotoWithGallary.delFiles';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
export default class UploadPhotoWithGallaryCard extends NavigationMixin(LightningElement) {
    
    @api file;
    @api recordId;
    @api thumbnail;
    @wire(CurrentPageReference) pageRef;
  error;
    imageClick(event){
      if(this.file){
      console.log('fileId==='+this.file.ContentDocumentId);
      this[NavigationMixin.Navigate]({ 
          type:'standard__namedPage',
          attributes:{ 
              pageName:'filePreview'
          },
          state:{ 
            
              selectedRecordId: this.file.ContentDocumentId
          }
      })
    }
  }

  delGalleryPhoto(event){
    let delfileId = event.target.value;
    console.log('delfileId=='+delfileId,'record id==',this.recordId);
      delFiles({
        recid : this.recordId,
        delfileId : delfileId
  })
      .then((result) => {
        console.log('thennnn lwc blkkkk');
          this.dispatchEvent(
              new ShowToastEvent({
                  title: 'Success',
                  message: 'Photo Deleted Succesfully',
                  variant: 'success'
              })
          );
         //this.dispatchEvent(new CloseActionScreenEvent());
          const selectEvent = new CustomEvent('mycustomevent', {
            detail: this.delfileId
            });
             this.dispatchEvent(selectEvent);
             console.log('Publish1');

             fireEvent(this.pageRef, 'messageFromSpace', this);
             console.log('Publish2');
            
         
      });
    
  }
  
}