import { LightningElement,api,track,wire } from 'lwc';
import { refreshApex } from '@salesforce/apex';
import getMatchedProfiles from '@salesforce/apex/Search_MM.getMatchedProfiles';
import shortListedProfiles from '@salesforce/apex/Search_MM.shortListedProfiles';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import {NavigationMixin} from 'lightning/navigation';

export default class SearchProfilesParent extends NavigationMixin(LightningElement) {
    @api recordId;
    @track matchedProfilesList=[];
    @track selectedShortlistedProfile=0;
    @track totalMatchedProfiles;
    @track updatedProfileIds=[];
    @track updatedProfileIdsnew=[];
    @track wiredResult;
    @track childchekvals;
    @track allchekvals=[];
    @track showBool=false;
    pageSizeOptions = [5,10]; //Page size options
    @track records = []; //All records available in the data table
    @track totalRecords = 0; //Total no.of records
    pageSize; //No.of records to be displayed per page
    totalPages; //Total no.of pages
    pageNumber = 1; //Page number    
    @track recordsToDisplay = []; //Records to be displayed on the page

    get bDisableFirst() {
        return this.pageNumber == 1;
    }
    get bDisableLast() {
        return this.pageNumber == this.totalPages;
    }

    @wire(getMatchedProfiles,{matchingId : '$recordId'})
    wiredMatchedProfile(result) {
       
        //console.log(' result==1=='+JSON.stringify(result));
        this.wiredResult = result;
       //console.log(' this.updatedProfileIds===='+this.updatedProfileIds);
        
        if (result.data) {
            //console.log('wiredResult==2=='+JSON.stringify(this.wiredResult));
            this.matchedProfilesList = result.data;
            
            this.totalMatchedProfiles=this.matchedProfilesList.length;
           
           console.log('totalMatchedProfiles ==',this.totalMatchedProfiles);
           console.log('matchedProfilesList==3=='+JSON.stringify(this.matchedProfilesList));
            this.error = undefined;

            //Paginaton
            this.records = result.data;
            //console.log('result'+JSON.stringify(  this.matchedProfilesListcheckvalue));
            
          // console.log(' this.records.profilewrapper==3=='+JSON.stringify( this.records.profilewrapper));
            this.totalRecords = this.totalMatchedProfiles; // update total records count                 
            this.pageSize = this.pageSizeOptions[0]; //set pageSize with default value as first option
            this.paginationHelper(); // call helper menthod to update pagination logic 
            console.log('total rec'+JSON.stringify(  this.totalRecords));
            console.log('total match'+JSON.stringify(  this.totalMatchedProfiles));
        } else if (result.error) {
            console.log('error====');
            const evt = new ShowToastEvent({
                title: 'Error',
                message: 'Please Contact System Admin.',
                variant: 'error',
            });
            this.dispatchEvent(evt);
            this.error = result.error;
            this.matchedProfilesList = undefined;
           
        }
        let res = result.data;
        console.log('res'+JSON.stringify(res));
        let wired=  this.wiredResult;
        console.log('wires'+JSON.stringify(wired));
        let matchedpro = this.matchedProfilesList;
        console.log('matpro'+JSON.stringify(matchedpro));
        if(res=='' && wired.data == '' && matchedpro.length==0){
            console.log('lastif all cond');
            this.norecords = 'No Matched Profiles Found...';
            this.showBool = true;
        }
        
    }

    handleCheck(event){
       
        let selectedProfileId=event.detail.profileid;
       
        console.log('selectedProfileId=== '+selectedProfileId);
        var checkvalue = event.detail.checkvalue;
        console.log('checkvalue=== '+checkvalue);
        if(checkvalue == true){
            console.log(' checkvalue if loop');
            
            //this.matchedProfilesListcheckvalue = checkvalue;
            this.updatedProfileIds.push(selectedProfileId);
            console.log('updatedProfileIds=== '+this.updatedProfileIds);

            this.selectedShortlistedProfile=this.selectedShortlistedProfile+1;
        }
        else{
            var index = this.updatedProfileIds.indexOf(selectedProfileId);
            console.log('index=== '+index);
                this.updatedProfileIds.splice(index, 1);

                console.log('updatedProfileIds elseee=== '+this.updatedProfileIds);
                 this.selectedShortlistedProfile=this.selectedShortlistedProfile-1;
            }

            }
           
    

    handleSave(event) {
        
        let profileIds = this.updatedProfileIds;
        console.log('profileIds==='+profileIds);
        if(profileIds.length!=0){
            shortListedProfiles({
            lstRecordId : this.updatedProfileIds,
            matchpreferenceId : this.recordId
        })
            .then(() => {
                this.selectedShortlistedProfile=0;
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Success',
                        message: 'Profile(s) Shortlisted Succesfully',
                        variant: 'success'
                    })
                );
              
                return refreshApex(this.wiredResult);
            })
            .catch((error) => {
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Error',
                        message: 'Error',
                        variant: 'error'
                    })
                );
            });
        }
        else{
            const evt = new ShowToastEvent({
                title: 'Error',
                message: 'Please select any profile.',
                variant: 'error',
            });
            this.dispatchEvent(evt);
        }
    }

    handleRecordsPerPage(event) {
        this.pageSize = event.target.value;
        this.paginationHelper();
    }
    previousPage() {
        this.pageNumber = this.pageNumber - 1;
        this.paginationHelper();
    }
    nextPage() {
        this.pageNumber = this.pageNumber + 1;
        this.paginationHelper();
    }
    firstPage() {
        this.pageNumber = 1;
        this.paginationHelper();
    }
    lastPage() {
        this.pageNumber = this.totalPages;
        this.paginationHelper();
    }
    // JS function to handel pagination logic 
    paginationHelper() {
        console.log('pagenation helper entered');
        this.recordsToDisplay = [];
        // calculate total pages
        this.totalPages = Math.ceil(this.totalRecords / this.pageSize);
        // set page number 
        if (this.pageNumber <= 1) {
            this.pageNumber = 1;
        } else if (this.pageNumber >= this.totalPages) {
            this.pageNumber = this.totalPages;
        }
        // set records to display on current page 
        for (let i = (this.pageNumber - 1) * this.pageSize; i < this.pageNumber * this.pageSize; i++) {
            var temp = 0;
            if (i === this.totalRecords) {
               
                break;
                
            }
            for(var j=0; j<this.updatedProfileIds.length;j++){

                if(this.records[i].profilewrapper.Id == this.updatedProfileIds[j])
                {
                    this.recordsToDisplay.push({label:this.records[i] , value:true});
                    temp = temp +1;
                    break;
                }

            }
            if(temp == 0){
                this.recordsToDisplay.push({label:this.records[i] , value:false});
              
            }
           // this.recordsToDisplay.push(this.records[i]);
        }
        this.recordsToDisplay.map(accordionItem => (
            console.log('recordsToDisplay parent 111111111111 js====>'+JSON.stringify(accordionItem))
        ));
        console.log('recordsToDisplay parent js====>'+this.recordsToDisplay);
    }
   

}