import { LightningElement, api, track,wire } from "lwc";

import getRelatedFilesByRecordId from "@salesforce/apex/ProfileImageClass.getRelatedFilesByRecordId";
import {NavigationMixin} from 'lightning/navigation';
import { CurrentPageReference } from 'lightning/navigation';
export default class CustomCarosuelWapper extends LightningElement {
    @api recordId;
  @track files;
  @wire(CurrentPageReference) pageRef;
  // @api pictureSrc ="https://s3-us-west-1.amazonaws.com/sfdc-demo/image-placeholder.png";
   @track message;
  @track fileId;
  @track flag=false;
  pictureSrc;

  campaigns; 
areDetailsVisible = true;
@track filesList =[];
  
@wire(getRelatedFilesByRecordId, {recordId: '$recordId'})
    wiredResult({data, error}){ 

        if(data){ 
          let filesList = data;
          for( let i=0; i< data.length; i++)
          {
            let tempRecord = Object.assign({src : '', Id : ''}, filesList[i]); 
           
            this.filesList.push(tempRecord);
          }
 

          for(let i=0; i<data.length; i++){
              let pictureSrc = "/sfc/servlet.shepherd/version/download/" + data[i].Id;
             this.filesList[i].src=pictureSrc;
             this.filesList[i].Id=data[i].Id;

            console.log('pictureSrc' +this.pictureSrc);
            console.log('Images are======' +this.filesList);
            console.log('data are======' +JSON.stringify(data));
           // console.log('src'+data[i].src);
          }
         

        }
        if(error){ 
            console.log(error);
        }
    }
}