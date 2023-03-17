import { LightningElement,api,wire,track } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import {NavigationMixin} from 'lightning/navigation';
import { CloseActionScreenEvent } from 'lightning/actions';
import { CurrentPageReference } from 'lightning/navigation';
import getItemMasterItem from '@salesforce/apex/InvoiceProfileLookup.getItemMasterItem';
import insertInvoice from '@salesforce/apex/InvoiceProfileLookup.insertInvoice';
import { getObjectInfo } from 'lightning/uiObjectInfoApi';
import InvoiceObj from '@salesforce/schema/Invoice__c';
export default class InvoiceCreationLWC extends NavigationMixin(LightningElement) {
    @api recordId;
    parentId;
    masterId;
    ctId;
    @track saveBool=false;
    @track profileName;
    @track itemMaster;

    @track lineCount;
    @track totalAmnt;
    @track totalTax;
    @track totalDis;
    @track totalNetAmt;
    invoiceId;
    base64Context;
    addressableContext;  
    @track showLine=false;
    invc = {}; 

    @wire(CurrentPageReference)
    pageRef; 

    connectedCallback() {   
        this.ConId();  

    } 

    ConId(){
        this.base64Context = this.pageRef.state.inContextOfRef;
        if (this.base64Context.startsWith("1\.")) {
            this.base64Context = this.base64Context.substring(2);
        } 
        this.addressableContext = JSON.parse(window.atob(this.base64Context));
        this.parentId=this.addressableContext.attributes.recordId;
        this.invc.Match_Maker__Contact__c=this.parentId;
    } 
    lookupRecord(event){
        console.log('Selected Record Value on Parent Component is ' +  JSON.stringify(event.detail.selectedRecord));
        this.profileName=event.detail.selectedRecord.Id;
        console.log('profile is....'+this.profileName);
    }  

    // handleSelection(event){
    //     console.log("the selected record id is"+JSON.stringify(event.detail.selectedId));
    //     this.profileName=event.detail.selectedId.Id;
    // }
    // myLookupHandle(event){
    //     console.log(event.detail.profileId);
    //     this.profileName = event.detail.profileId;
    // }
   
    invoiceChange(event){
        let fieldName = event.target.fieldName; 
        this.invc[fieldName] = event.target.value;

    }
    @wire(getObjectInfo, { objectApiName: InvoiceObj })
    objectInfo({ error, data }) {
    if (data) {
        const fieldInfo = data;
        console.log('defaultValue-------',data.fields.Match_Maker__Date__c.value);
        console.log('label',data.fields.Match_Maker__Date__c.label);
    } else if (error) {
        console.log('error d-------'+error);
        }
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

removeRow(event) {
    if (this.itemList.length >= 2) {
        this.itemList = this.itemList.filter(function (element) {
            return parseInt(element.id) !== parseInt(event.target.accessKey);
        });
    }
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

/*handleSubmit(event) {
    let fields = event.detail.fields;
    console.log( 'Fields are...' +  JSON.stringify( fields ) );
    event.preventDefault();
        // fields.Match_Maker__Address__Street__s   = this.addressStreet;
        // fields.Match_Maker__Address__City__s   = this.addressCity;
        // fields.Match_Maker__Address__StateCode__s   = this.addressState;
        // fields.Match_Maker__Address__CountryCode__s   = this.addressCountry;
        // fields.Match_Maker__Address__PostalCode__s  = this.addressPostalcode;
         fields.Match_Maker__Profile__c = this.profileName;
    
    this.template.querySelector('lightning-record-edit-form[data-id="invoiceForm"]').submit(fields);
} */

invoiceAndLineSave(event){
    this.saveBool=true;
   let invoice;
   if(this.itemList && this.itemList.length>0){
    console.log('itemList before-->' +JSON.stringify(this.itemList));   console.log('invc before-->' +JSON.stringify(this.invc));
    insertInvoice({lineItems: this.itemList , invoc : this.invc , prof:this.profileName })  
    .then(data => {   
        
        invoice = data; console.log('itemList after-->' +JSON.stringify(this.itemList));  console.log('invc after-->' +JSON.stringify(this.invc)); 
        console.log('saved-----' +JSON.stringify(invoice));
        const even = new ShowToastEvent({
            title: 'Success!',
            message: 'Invoice Record has been created successfully!',
            variant: 'success'
        });        
        this.dispatchEvent(even);
        this.saveBool=false;
        this[NavigationMixin.Navigate]({ 
            type: 'standard__recordPage',
            attributes: {
                recordId: this.parentId,
                objectApiName: 'Contact',
                actionName: 'view'
            }
        });

       
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
    this[NavigationMixin.Navigate]({ 
        type: 'standard__recordPage',
        attributes: {
            recordId: this.parentId,
            objectApiName: 'Contact',
            actionName: 'view'
        }
    });
    
    this.dispatchEvent(new CloseActionScreenEvent());
    
    }
}