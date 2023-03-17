import { LightningElement,api,wire,track } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import {NavigationMixin} from 'lightning/navigation';
import { CloseActionScreenEvent } from 'lightning/actions';
import { CurrentPageReference } from 'lightning/navigation';
import getItemMasterItem from '@salesforce/apex/InvoiceProfileLookup.getItemMasterItem';
import upsertInvoice from '@salesforce/apex/InvoiceProfileLookup.upsertInvoice';
import fetchLineItem from '@salesforce/apex/InvoiceProfileLookup.fetchLineItem';
import getContactId from '@salesforce/apex/InvoiceProfileLookup.getContactId';
// import { getRecord } from 'lightning/uiRecordApi';
export default class InvoiceCreationLWC extends NavigationMixin(LightningElement) {
    @api recordId;
    @api lineItemId;
    parentId;
    parentId1;
    masterId;
    @track saveBool=false;
    @track profileName;
    @track itemMaster;
//     @track rateValue;
//     @track taxValue;
//     @track calTaxValues;
//     @track amt;
//     @track qnty;
//     @track disc;
//     @track lineTotal;
//     @track lineTotalDis;
//     @track lineItemTotal;
//     @track discAmnt;
//     @track taxs;
//     @track taxAmnt; 
@track lineCount;
@track totalAmnt;
@track totalTax;
@track totalDis;
@track totalNetAmt;
    invoiceId;
    base64Context;
    addressableContext;  
    @track showLine=false;
    wiredRecords;
    error;
    
     invc = {}; 
     @track tempList=[];
    
    @wire(CurrentPageReference)
    pageRef; 

    connectedCallback() {   
        this.ContactId();  
    } 

    ContactId(){
        this.base64Context = this.pageRef.state.inContextOfRef;
        if (this.base64Context.startsWith("1\.")) {
            this.base64Context = this.base64Context.substring(2);
        } 
        this.addressableContext = JSON.parse(window.atob(this.base64Context));
        this.parentId=this.addressableContext.attributes.recordId;
        this.invc.Match_Maker__Contact__c=this.parentId; 
    } 
    @wire(getContactId, { conId: '$recordId'})
    deWired({ error, data }) {
        if (data) {
            this.parentId1 = data;
            this.invc.Match_Maker__Contact__c=this.parentId1;
           
        } else if (error) {
            this.error = error;
        }
    }
    // lookupRecord(event){
    //     console.log('Selected Record Value on Parent Component is ' +  JSON.stringify(event.detail.selectedRecord));
    //     this.profileName=event.detail.selectedRecord.Id;
    //     console.log('profile is....'+this.profileName);
    // }  
     
    @wire(fetchLineItem, {recordId : '$recordId'})  
    wiredLineItem(result) {
        this.wiredRecords = result;          
        const { data, error } = result;
 
        if(data) {          
            this.itemList = JSON.parse(JSON.stringify(data));
            let i=0;   //for deleteing rec with passing id to the itemList
         //   let tempList=[];
            for(let rec of data){
                let record={};
                record.id=i;
                record.Id=rec.Id;
                record.Match_Maker__Invoice__c=rec.Match_Maker__Invoice__c;
                record.Match_Maker__Items__c=rec.Match_Maker__Items__c;
                record.Match_Maker__Amount__c=rec.Match_Maker__Amount__c;
                record.Match_Maker__Quantity__c=rec.Match_Maker__Quantity__c;
                record.Match_Maker__Line_Total__c=rec.Match_Maker__Line_Total__c;
                record.Match_Maker__Discount__c=rec.Match_Maker__Discount__c;
                record.Match_Maker__Discount_Amount__c=rec.Match_Maker__Discount_Amount__c;
                record.Match_Maker__Line_Total_After_Discount__c=rec.Match_Maker__Line_Total_After_Discount__c;
                record.Match_Maker__Taxs__c=rec.Match_Maker__Taxs__c;
                record.Match_Maker__Tax_Amount__c=rec.Match_Maker__Tax_Amount__c;
                record.Match_Maker__Line_Item_Total__c=rec.Match_Maker__Line_Item_Total__c;
                i=i+1;
                this.tempList.push(record);
            }
            this.itemList = this.tempList;
           // this.invc =  this.itemList;
            this.error = undefined;
            this.handleIsLoading(false);
        } else if(error) {
            this.error = error;
            this.itemList = undefined;
            this.handleIsLoading(false);
        }
    } 
    // @wire(getRecord, { recordId: '$recordId', fields: invc})
    // invoiceRec;
 
    invoiceChange(event){
        let fieldName = event.target.fieldName; 
        this.invc[fieldName] = event.target.value; 
        
    }

        handelOnchangeItem(event){            
               let rowIndex=event.target.name; 
               let fieldName = event.target.fieldName;
               this.itemList[rowIndex][fieldName]=event.target.value;
               console.log('row....',rowIndex);
               this.invc.Match_Maker__Line_Item_Count__c= rowIndex+1;
               this.masterId=event.target.value;
               var itemid=event.target.value;
                console.log('masterId===='+this.masterId);
                console.log('masterId'+event.target.value);
                //to reset itemlist
       if(itemid=='' || itemid ==null || itemid==undefined){
           this.itemList[rowIndex].Match_Maker__Amount__c='';
           this.itemList[rowIndex].Match_Maker__Quantity__c='';
           this.itemList[rowIndex].Match_Maker__Taxs__c='';
           this.itemList[rowIndex].Match_Maker__Line_Total__c='';
           this.itemList[rowIndex].Match_Maker__Discount__c='';  console.log('disValue no.itm----' +JSON.stringify(this.itemList[rowIndex].Match_Maker__Discount__c));
           this.itemList[rowIndex].Match_Maker__Discount_Amount__c='';
           this.itemList[rowIndex].Match_Maker__Line_Total_After_Discount__c='';
           this.itemList[rowIndex].Match_Maker__Tax_Amount__c='';
          this.itemList[rowIndex].Match_Maker__Line_Item_Total__c='';
          this.invc.Match_Maker__Line_Item_Count__c=this.invc.Match_Maker__Line_Item_Count__c-1;
       
         let totAmtSum = 0; let totTaxSum = 0; let totDisSum = 0; 
         for(let rec of this.itemList){
            totAmtSum = totAmtSum + rec.Match_Maker__Line_Total__c;
            totTaxSum = totTaxSum + rec.Match_Maker__Tax_Amount__c;
            totDisSum = totDisSum + rec.Match_Maker__Discount_Amount__c;
         }
         this.itemList.Match_Maker__Line_Total__c = totAmtSum;
         this.itemList.Match_Maker__Tax_Amount__c = totTaxSum;
         this.itemList.Match_Maker__Discount_Amount__c = totDisSum; 
         console.log('totalSum-->',totAmtSum ,totTaxSum ,totDisSum); 
         this.invc.Match_Maker__Total_Amount__c =  totAmtSum;
         this.invc.Match_Maker__Total_Tax_Amount__c = totTaxSum;
         this.invc.Match_Maker__Total_Discount_Amount__c = totDisSum;
         this.invc.Match_Maker__Net_Invoice_Amount__c = totAmtSum-totDisSum+totTaxSum;
         }

                getItemMasterItem({ itemId:this.masterId})
                .then(result => {
                    window.console.log(JSON.stringify(result));   
                    this.itemMaster=result;
                    this.Match_Maker__Amount__c=result.Match_Maker__Rate__c;
                    this.Match_Maker__Taxs__c=result.Match_Maker__Tax__c;
                    this.itemList[rowIndex].Match_Maker__Amount__c=this.Match_Maker__Amount__c;
                    this.itemList[rowIndex].Match_Maker__Taxs__c=this.Match_Maker__Taxs__c;

                    this.itemList[rowIndex].Match_Maker__Quantity__c=1;
                    this.itemList[rowIndex].Match_Maker__Discount__c=0;
                    console.log('ratevalue'+result.Match_Maker__Rate__c);
                    console.log('taxvalue'+result.Match_Maker__Tax__c);
                    console.log('disValue if.itm----' +JSON.stringify(this.itemList[rowIndex].Match_Maker__Discount__c));
                     this.itemList[rowIndex].Match_Maker__Line_Total__c=this.itemList[rowIndex].Match_Maker__Amount__c*1;
                     this.itemList[rowIndex].Match_Maker__Discount_Amount__c=(this.itemList[rowIndex].Match_Maker__Discount__c/100)*this.itemList[rowIndex].Match_Maker__Line_Total__c;
                     this.itemList[rowIndex].Match_Maker__Line_Total_After_Discount__c=this.itemList[rowIndex].Match_Maker__Line_Total__c-this.itemList[rowIndex].Match_Maker__Discount_Amount__c;
                     this.itemList[rowIndex].Match_Maker__Tax_Amount__c=this.itemList[rowIndex].Match_Maker__Line_Total_After_Discount__c*(this.itemList[rowIndex].Match_Maker__Taxs__c/100);
                     this.itemList[rowIndex].Match_Maker__Line_Item_Total__c=this.itemList[rowIndex].Match_Maker__Line_Total_After_Discount__c+this.itemList[rowIndex].Match_Maker__Tax_Amount__c;
                    console.log('lineTotal in item===' +JSON.stringify(this.itemList[rowIndex].Match_Maker__Line_Total__c));   
                  //calc for total
                    let totAmtSum = 0; let totTaxSum = 0; let totDisSum = 0; 
                    for(let rec of this.itemList){
                       totAmtSum = totAmtSum + rec.Match_Maker__Line_Total__c;
                       totTaxSum = totTaxSum + rec.Match_Maker__Tax_Amount__c;
                       totDisSum = totDisSum + rec.Match_Maker__Discount_Amount__c;
                    }
                    this.itemList.Match_Maker__Line_Total__c = totAmtSum;
                    this.itemList.Match_Maker__Tax_Amount__c = totTaxSum;
                    this.itemList.Match_Maker__Discount_Amount__c = totDisSum; 
                    console.log('totalSum-->',totAmtSum ,totTaxSum ,totDisSum); 
                    this.invc.Match_Maker__Total_Amount__c =  totAmtSum;
                    this.invc.Match_Maker__Total_Tax_Amount__c = totTaxSum;
                    this.invc.Match_Maker__Total_Discount_Amount__c = totDisSum;
                    this.invc.Match_Maker__Net_Invoice_Amount__c = totAmtSum-totDisSum+totTaxSum;     
                 //calc ends           
                

                }) 
                .catch(error => {
                    this.error = error;
                });
                             

        }  
                                           
        rateQtyChange(event)
        {
            let rowIndex=event.target.name;
            let fieldName = event.target.fieldName;
            this.itemList[rowIndex][fieldName]=event.target.value;  
            console.log('name&index' +JSON.stringify(this.itemList[rowIndex][fieldName]));

            this.itemList[rowIndex].Match_Maker__Line_Total__c =  this.itemList[rowIndex].Match_Maker__Amount__c * this.itemList[rowIndex].Match_Maker__Quantity__c;
            console.log('rateValue' +JSON.stringify(this.itemList[rowIndex].Match_Maker__Amount__c));
            console.log('qntyValue' +JSON.stringify(this.itemList[rowIndex].Match_Maker__Quantity__c));
            console.log('lineTotal' +JSON.stringify(this.itemList[rowIndex].Match_Maker__Line_Total__c));
            console.log('disct------' +JSON.stringify(this.itemList[rowIndex].Match_Maker__Discount__c));
            console.log('disct amt------' +JSON.stringify(this.itemList[rowIndex].Match_Maker__Discount_Amount__c));
            
            this.itemList[rowIndex].Match_Maker__Discount_Amount__c=  (this.itemList[rowIndex].Match_Maker__Discount__c/100)*this.itemList[rowIndex].Match_Maker__Line_Total__c;
            this.itemList[rowIndex].Match_Maker__Line_Total_After_Discount__c=this.itemList[rowIndex].Match_Maker__Line_Total__c-this.itemList[rowIndex].Match_Maker__Discount_Amount__c;
            this.itemList[rowIndex].Match_Maker__Tax_Amount__c=this.itemList[rowIndex].Match_Maker__Line_Total_After_Discount__c*(this.itemList[rowIndex].Match_Maker__Taxs__c/100);
            this.itemList[rowIndex].Match_Maker__Line_Item_Total__c=this.itemList[rowIndex].Match_Maker__Line_Total_After_Discount__c+this.itemList[rowIndex].Match_Maker__Tax_Amount__c;
                //calc for total
                 let totAmtSum = 0; let totTaxSum = 0; let totDisSum = 0; 
                 for(let rec of this.itemList){
                    totAmtSum = totAmtSum + rec.Match_Maker__Line_Total__c;
                    totTaxSum = totTaxSum + rec.Match_Maker__Tax_Amount__c;
                    totDisSum = totDisSum + rec.Match_Maker__Discount_Amount__c;
                 }
                 this.itemList.Match_Maker__Line_Total__c = totAmtSum;
                 this.itemList.Match_Maker__Tax_Amount__c = totTaxSum;
                 this.itemList.Match_Maker__Discount_Amount__c = totDisSum; 
                 console.log('totalSum-->',totAmtSum ,totTaxSum ,totDisSum); 
                 this.invc.Match_Maker__Total_Amount__c =  totAmtSum;
                 this.invc.Match_Maker__Total_Tax_Amount__c = totTaxSum;
                 this.invc.Match_Maker__Total_Discount_Amount__c = totDisSum;
                 this.invc.Match_Maker__Net_Invoice_Amount__c = totAmtSum-totDisSum+totTaxSum;     
                 
    }  
    disChange(event){
        let rowIndex=event.target.name;
        let fieldName = event.target.fieldName;
        this.itemList[rowIndex][fieldName]=event.target.value;  
        console.log('name&index' +JSON.stringify(this.itemList[rowIndex][fieldName]));

      //  this.itemList[rowIndex].Match_Maker__Line_Total__c =  this.itemList[rowIndex].Match_Maker__Amount__c * this.itemList[rowIndex].Match_Maker__Quantity__c;
        console.log('disValue onchange----' +JSON.stringify(this.itemList[rowIndex].Match_Maker__Discount__c));
        console.log('lineTotal' +JSON.stringify(this.itemList[rowIndex].Match_Maker__Line_Total__c));
        console.log('Tax_Amount------' +JSON.stringify(this.itemList[rowIndex].Match_Maker__Taxs__c));

        this.itemList[rowIndex].Match_Maker__Discount_Amount__c=(this.itemList[rowIndex].Match_Maker__Discount__c/100)*this.itemList[rowIndex].Match_Maker__Line_Total__c;
        this.itemList[rowIndex].Match_Maker__Line_Total_After_Discount__c=this.itemList[rowIndex].Match_Maker__Line_Total__c-this.itemList[rowIndex].Match_Maker__Discount_Amount__c;
        this.itemList[rowIndex].Match_Maker__Tax_Amount__c=this.itemList[rowIndex].Match_Maker__Line_Total_After_Discount__c*(this.itemList[rowIndex].Match_Maker__Taxs__c/100);
        this.itemList[rowIndex].Match_Maker__Line_Item_Total__c=this.itemList[rowIndex].Match_Maker__Line_Total_After_Discount__c+this.itemList[rowIndex].Match_Maker__Tax_Amount__c;
            //calc for total
             let totAmtSum = 0; let totTaxSum = 0; let totDisSum = 0; 
             for(let rec of this.itemList){
                totAmtSum = totAmtSum + rec.Match_Maker__Line_Total__c;
                totTaxSum = totTaxSum + rec.Match_Maker__Tax_Amount__c;
                totDisSum = totDisSum + rec.Match_Maker__Discount_Amount__c;
             }
             this.itemList.Match_Maker__Line_Total__c = totAmtSum;
             this.itemList.Match_Maker__Tax_Amount__c = totTaxSum;
             this.itemList.Match_Maker__Discount_Amount__c = totDisSum; 
             console.log('totalSum-->',totAmtSum ,totTaxSum ,totDisSum); 
             this.invc.Match_Maker__Total_Amount__c =  totAmtSum;
             this.invc.Match_Maker__Total_Tax_Amount__c = totTaxSum;
             this.invc.Match_Maker__Total_Discount_Amount__c = totDisSum;
             this.invc.Match_Maker__Net_Invoice_Amount__c = totAmtSum-totDisSum+totTaxSum;     
          
    }
    taxChange(event){
        let rowIndex=event.target.name;
        let fieldName = event.target.fieldName;
        this.itemList[rowIndex][fieldName]=event.target.value;  
        console.log('name&index' +JSON.stringify(this.itemList[rowIndex][fieldName]));

      //  this.itemList[rowIndex].Match_Maker__Line_Total__c =  this.itemList[rowIndex].Match_Maker__Amount__c * this.itemList[rowIndex].Match_Maker__Quantity__c;
        console.log('rateValue' +JSON.stringify(this.itemList[rowIndex].Match_Maker__Amount__c));
        console.log('qntyValue' +JSON.stringify(this.itemList[rowIndex].Match_Maker__Quantity__c));
        console.log('lineTotal' +JSON.stringify(this.itemList[rowIndex].Match_Maker__Line_Total__c));
        console.log('Tax_Amount------' +JSON.stringify(this.itemList[rowIndex].Match_Maker__Taxs__c));

       // this.itemList[rowIndex].Match_Maker__Discount_Amount__c=(this.itemList[rowIndex].Match_Maker__Discount__c/100)*this.itemList[rowIndex].Match_Maker__Line_Total__c;
       // this.itemList[rowIndex].Match_Maker__Line_Total_After_Discount__c=this.itemList[rowIndex].Match_Maker__Line_Total__c-this.itemList[rowIndex].Match_Maker__Discount_Amount__c;
        this.itemList[rowIndex].Match_Maker__Tax_Amount__c=this.itemList[rowIndex].Match_Maker__Line_Total_After_Discount__c*(this.itemList[rowIndex].Match_Maker__Taxs__c/100);
        this.itemList[rowIndex].Match_Maker__Line_Item_Total__c=this.itemList[rowIndex].Match_Maker__Line_Total_After_Discount__c+this.itemList[rowIndex].Match_Maker__Tax_Amount__c;
            //calc for total
             let totAmtSum = 0; let totTaxSum = 0; let totDisSum = 0; 
             for(let rec of this.itemList){
                totAmtSum = totAmtSum + rec.Match_Maker__Line_Total__c;
                totTaxSum = totTaxSum + rec.Match_Maker__Tax_Amount__c;
                totDisSum = totDisSum + rec.Match_Maker__Discount_Amount__c;
             }
             this.itemList.Match_Maker__Line_Total__c = totAmtSum;
             this.itemList.Match_Maker__Tax_Amount__c = totTaxSum;
             this.itemList.Match_Maker__Discount_Amount__c = totDisSum; 
             console.log('totalSum-->',totAmtSum ,totTaxSum ,totDisSum); 
             this.invc.Match_Maker__Total_Amount__c =  totAmtSum;
             this.invc.Match_Maker__Total_Tax_Amount__c = totTaxSum;
             this.invc.Match_Maker__Total_Discount_Amount__c = totDisSum;
             this.invc.Match_Maker__Net_Invoice_Amount__c = totAmtSum-totDisSum+totTaxSum;     
        }

           
keyIndex = 0;
@track itemList = [
    {
        id: 0
    }
];

addRow() {
    ++this.keyIndex;
    var newItem = [{ id: this.keyIndex }];
    this.itemList = this.itemList.concat(newItem);
}
@track tempdelList = [];
removeRow(event) {
   
    this.tempdelList.push(this.itemList[event.target.dataset.id]);

    if (this.itemList.length >= 2) {
        this.itemList = this.itemList.filter(function (element) {
            console.log('elementId',element.id);  
            console.log('dataid',event.target.dataset.id);
            console.log('accessKey',event.target.accessKey);
            return parseInt(element.id) !== parseInt(event.target.accessKey);
        });
    }
    console.log('deleteList-->' +JSON.stringify(this.tempdelList));
    
     let rowIndex=event.target.name;
     this.invc.Match_Maker__Line_Item_Count__c=this.invc.Match_Maker__Line_Item_Count__c-1;
    let totAmtSum = 0; let totTaxSum = 0; let totDisSum = 0; 
    for(let rec of this.itemList){
       totAmtSum = totAmtSum + rec.Match_Maker__Line_Total__c;
       totTaxSum = totTaxSum + rec.Match_Maker__Tax_Amount__c;
       totDisSum = totDisSum + rec.Match_Maker__Discount_Amount__c;
    }
    this.itemList.Match_Maker__Line_Total__c = totAmtSum;
    this.itemList.Match_Maker__Tax_Amount__c = totTaxSum;
    this.itemList.Match_Maker__Discount_Amount__c = totDisSum; 
    console.log('totalSum-->',totAmtSum ,totTaxSum ,totDisSum); 
    this.invc.Match_Maker__Total_Amount__c =  totAmtSum;
    this.invc.Match_Maker__Total_Tax_Amount__c = totTaxSum;
    this.invc.Match_Maker__Total_Discount_Amount__c = totDisSum;
    this.invc.Match_Maker__Net_Invoice_Amount__c = totAmtSum-totDisSum+totTaxSum;     
 
}
handelOnload(event){
    var record = event.detail.records;
    var fields = record[this.recordId].fields; 
    // let fieldName = event.target.fieldName; 
    // this.invc[fieldName] = record[this.recordId].fields; 
   // const accName = fields.Match_Maker__Email__c.value;   
    this.invc.Match_Maker__Email__c=   fields.Match_Maker__Email__c.value;
    this.invc.Match_Maker__Phone__c=   fields.Match_Maker__Phone__c.value;
    this.invc.Match_Maker__Payment_Status__c=   fields.Match_Maker__Payment_Status__c.value;
    this.invc.Match_Maker__Date__c=   fields.Match_Maker__Date__c.value;
    this.invc.Match_Maker__Time__c=   fields.Match_Maker__Time__c.value;
    this.invc.Match_Maker__Payment_Method__c=   fields.Match_Maker__Payment_Method__c.value;
    this.invc.Match_Maker__Line_Item_Count__c=   fields.Match_Maker__Line_Item_Count__c.value;
    this.invc.Match_Maker__Address__Street__s=   fields.Match_Maker__Address__Street__s.value;
    this.invc.Match_Maker__Address__City__s=   fields.Match_Maker__Address__City__s.value;
    this.invc.Match_Maker__Address__StateCode__s=   fields.Match_Maker__Address__StateCode__s.value;
    this.invc.Match_Maker__Address__PostalCode__s=   fields.Match_Maker__Address__PostalCode__s.value;
    this.invc.Match_Maker__Address__CountryCode__s=   fields.Match_Maker__Address__CountryCode__s.value;
    this.invc.Match_Maker__Total_Amount__c=   fields.Match_Maker__Total_Amount__c.value;
    this.invc.Match_Maker__Total_Tax_Amount__c=   fields.Match_Maker__Total_Tax_Amount__c.value;
    this.invc.Match_Maker__Total_Discount_Amount__c=   fields.Match_Maker__Total_Discount_Amount__c.value;
    this.invc.Match_Maker__Net_Invoice_Amount__c=   fields.Match_Maker__Net_Invoice_Amount__c.value;
   
}

invoiceAndLineSave(event){
   this.saveBool=true;

   let invoice; 
   if(this.itemList && this.itemList.length>0){         
    console.log('itemList before-->' +JSON.stringify(this.itemList));   console.log('invc before-->' +JSON.stringify(this.invc));  console.log('invc record-->' +JSON.stringify(this.recordId)); 
    upsertInvoice({lineItems: this.itemList , invoc : this.invc, recId :this.recordId ,removeLineItemIds : this.tempdelList})  
    .then(data => {   
        console.log('invoiceAndLineSave');
        invoice = data; console.log('itemList after-->' +JSON.stringify(this.itemList));  console.log('invc after-->' +JSON.stringify(this.invc)); 
        console.log('saved-----' +JSON.stringify(invoice));
        const even = new ShowToastEvent({
            title: 'Success!',
            message: 'Invoice Record has been updated successfully!',
            variant: 'success'
        });        
        this.dispatchEvent(even);
        this.saveBool=false;       
        if(this.parentId!=this.recordId)
        {
        this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: {
                recordId: this.parentId,
                objectApiName: 'Contact',
                actionName: 'view'
            }
        });
       
    }
       else if(this.parentId==this.recordId){
        this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: {
                recordId: this.recordId,
                objectApiName: 'Match_Maker__Invoice__c',
                actionName: 'view'
            }
        });
    }
       
    })
    .catch(error => {
         console.log(JSON.stringify(error));
         this.saveBool=false;
        const evt = new ShowToastEvent({
        title: 'error',
        message: error.body.pageErrors[0].message,
        variant: 'error',
         });
         this.dispatchEvent(evt);
         }); 
   }

}    

/*handelInvoiceSaveSuccess(event){
    this.invoiceId = event.detail.id;
    console.info("Invoice is saved, new id is: " + this.invoiceId);

    this.template.querySelectorAll('lightning-input-field[data-id="lineInvoiceId"]').forEach((field) => {
      field.value = this.invoiceId;
    });

    this.template.querySelectorAll('lightning-record-edit-form[data-id="lineItemForm"]').forEach((form) => { 
        form.submit(); 
    });
}
handleLineSaveSuccess(event){
    const even = new ShowToastEvent({
        title: 'Success!',
        message: 'Invoice Record has been created successfully!',
        variant: 'success'
    });        
    this.dispatchEvent(even);
    this[NavigationMixin.Navigate]({ 
        type: 'standard__recordPage',
        attributes: {
            recordId: this.parentId,
            objectApiName: 'Contact',
            actionName: 'view'
        }
    });
} */
handelCancel(event){
    this.saveBool=false;
    if(this.parentId!=this.recordId)
    {
    this[NavigationMixin.Navigate]({
        type: 'standard__recordPage',
        attributes: {
            recordId: this.parentId,
            objectApiName: 'Contact',
            actionName: 'view'
        }
    });
   
}
   else if(this.parentId==this.recordId){
    this[NavigationMixin.Navigate]({
        type: 'standard__recordPage',
        attributes: {
            recordId: this.recordId,
            objectApiName: 'Match_Maker__Invoice__c',
            actionName: 'view'
        }
    });
} 
// else{ 
//     this[NavigationMixin.Navigate]({
//         type: 'standard__objectPage',
//         attributes: {
//             objectApiName: 'Match_Maker__Invoice__c',
//             actionName: 'view'
//         }
//     });
// }
    
    this.dispatchEvent(new CloseActionScreenEvent());
    
    }
}