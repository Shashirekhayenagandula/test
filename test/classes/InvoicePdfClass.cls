public with sharing class InvoicePdfClass {
    
    public List<Match_Maker__Invoice_Line_Item__c> invoiceLineitem {get;set;}
    public String recordId {get;set;}
    public String netTotal{get;set;}
    public void getInvoiceInformation(){
        recordId  = ApexPages.currentPage().getParameters().get('id');
        invoiceLineitem= [SELECT Id,Match_Maker__Item_Description__c,Match_Maker__Invoice__r.CreatedDate,Match_Maker__Invoice__r.Name,Match_Maker__Invoice__r.Match_Maker__Full_Name__c, Match_Maker__Invoice__r.Match_Maker__Time__c, Match_Maker__Invoice__r.Id, Match_Maker__Invoice__r.Match_Maker__Address__Street__s, Match_Maker__Invoice__r.Match_Maker__Address__City__s, Match_Maker__Invoice__r.Match_Maker__Address__StateCode__s, Match_Maker__Invoice__r.Match_Maker__Address__CountryCode__s, Match_Maker__Invoice__r.Match_Maker__Address__PostalCode__s, Match_Maker__Invoice__r.Match_Maker__Email__c, Match_Maker__Invoice__r.Match_Maker__Phone__c, Match_Maker__Items__c,Match_Maker__Amount__c,Match_Maker__Discount__c,Match_Maker__Discount_Amount__c,
                          Match_Maker__Line_Item_Total__c,Match_Maker__Line_Total__c,Match_Maker__Line_Total_After_Discount__c,Match_Maker__Quantity__c,Match_Maker__Taxs__c,Match_Maker__Tax_Amount__c,Match_Maker__Invoice__r.Match_Maker__Total_Amount__c, Match_Maker__Invoice__r.Match_Maker__Total_Tax_Amount__c, Match_Maker__Invoice__r.Match_Maker__Total_Discount_Amount__c, Match_Maker__Invoice__r.Match_Maker__Net_Invoice_Amount__c, Match_Maker__Items__r.Name FROM Match_Maker__Invoice_Line_Item__c WHERE Match_Maker__Invoice__r.Id  =:recordId  WITH SECURITY_ENFORCED Limit 500];
        System.debug('invoiceLineitem===='+invoiceLineitem);
        decimal Total=invoiceLineitem[0].Match_Maker__Invoice__r.Match_Maker__Net_Invoice_Amount__c;
        InvoicePdfClass nwcObj = new InvoicePdfClass();
        
        if(!test.isRunningTest()){
            netTotal = nwcObj.getNumberTOWordConvertion(Total);
        }
        
        
    }
    @auraEnabled(cacheable=true)
    public static void sendInvoiceMail(String recordId){
        Blob b;
        for(Match_Maker__Invoice__c inv:[SELECT Id,Match_Maker__Full_Name__c,Match_Maker__Email__c,Match_Maker__Contact__c from Match_Maker__Invoice__c WHERE Id =:recordId WITH SECURITY_ENFORCED  limit 1]){
            system.debug('inv===='+inv);
            PageReference pdf = Page.InvoicePdfPage;
            pdf.getParameters().put('id',inv.Id);
            pdf.setRedirect(true);
            if(!Test.isRunningTest()){
                b = pdf.getContent();
            }
            
            Messaging.EmailFileAttachment efa = new Messaging.EmailFileAttachment();
            efa.setFileName('Invoice of '+inv.Match_Maker__Full_Name__c+'.pdf');
            efa.setBody(b);
            
            Schema.EmailTemplate emailTemplate =[Select Id,Name,Subject,Description,HtmlValue,DeveloperName,Body from EmailTemplate where Name ='Send Invoice Pdf' WITH SECURITY_ENFORCED  limit 1 ];
            String htmlBody=emailTemplate.HtmlValue;
            system.debug('htmlBody===='+htmlBody);
            String plainBody=emailTemplate.Body;
            Messaging.SingleEmailMessage semail = new Messaging.SingleEmailMessage();
            Messaging.EmailFileAttachment attach = new Messaging.EmailFileAttachment();
            
            List<String> sendTo = new List<String>();
            sendTo.add(inv.Match_Maker__Email__c);
            semail.setToAddresses(sendTo);
            semail.setTemplateId(emailTemplate.Id);
            semail.setTreatTargetObjectAsRecipient(false);
            semail.setTargetObjectId(inv.Match_Maker__Contact__c);
            semail.setWhatId(inv.Id);
            semail.setSaveAsActivity(false);
            semail.setTreatBodiesAsTemplate(true);
            semail.setplainTextBody(plainBody);
            //semail.setHtmlBody(htmlBody);
            semail.setSubject('Matchy Invoice PDF');
            semail.setFileAttachments(new Messaging.EmailFileAttachment[] { efa }); 
            try
            {
                Messaging.sendEmail(new Messaging.SingleEmailMessage[] { semail });  
                System.debug('email sent Successfully');
            }
            catch(Exception e)
            {
                throw new AuraHandledException(e.getMessage());
            }
            
        }
    }
    public String getNumberTOWordConvertion(Decimal num) {

        Decimal junkVal = num;
        Decimal junkValPaisa = junkVal - Math.floor(junkVal);
        junkVal = Math.floor(junkVal);

        String obStr = junkVal.toPlainString();
        String[] numReversed = obStr.split('');
        String[] actnumber = reverse(numReversed);
        String firstHalf = convertInWords(numReversed, actnumber);

        Integer tmp = Math.round(junkValPaisa * 100);
        junkValPaisa = (Decimal)tmp / 100; System.debug('jj :' + junkValPaisa);
        String paisaStr = junkValPaisa.toPlainString();
        String secondHalf;
        if (paisaStr == '0') {
            secondHalf = '';
        } else if (paisaStr.length() != 4) {
            paisaStr = paisaStr + '0';
            paisaStr = paisaStr.substring(2);
            String [] numReversedPaisa = paisaStr.split('');
            String[] actnumberPaisa = reverse(numReversedPaisa);
            secondHalf = convertInWords(numReversedPaisa, actnumberPaisa);
        } else {
            paisaStr = paisaStr.substring(2);
            String [] numReversedPaisa = paisaStr.split('');
            String[] actnumberPaisa = reverse(numReversedPaisa);
            secondHalf = convertInWords(numReversedPaisa, actnumberPaisa);
        }

        String SumOFHalves = '';

        if (secondHalf.length() > 4) {
            firstHalf = firstHalf.replace('Only', 'Rupess And ');
            secondHalf = secondHalf.replace('Only', 'Paisa Only');
            SumOFHalves = firstHalf + secondHalf;
        } else {
            firstHalf = firstHalf.replace('Only', 'Rupess Only');
            SumOFHalves = firstHalf;
        }

        // IF amount has any value
        if (SumOFHalves.length() > 5) {
            return SumOFHalves;
        } else {
            return '';
        }
    }
    // Method reverse the number
    public List<String> reverse(List<String> strToRev) {
        List<String> revList = new List<String>();
        for (Integer i = strToRev.size() - 1; i >= 0; i--) {
            revList.add(strToRev.get(i));
        }
        revList.add('');
        return revList;
    }

    public String convertInWords(String[] numRev, String[] actnum) {
        List<String> iWords = new List<String> {'Zero', ' One', ' Two', ' Three', ' Four', ' Five', ' Six', ' Seven', ' Eight', ' Nine'};
        List<String> ePlace = new List<String> {' Ten', ' Eleven', ' Twelve', ' Thirteen', ' Fourteen', ' Fifteen', ' Sixteen', ' Seventeen', ' Eighteen', ' Nineteen'};
        List<String> tensPlace = new List<String> {'dummy', ' Ten', ' Twenty', ' Thirty', ' Forty', ' Fifty', ' Sixty', ' Seventy', ' Eighty', ' Ninety' };

        Integer iWordsLength = numRev.size();
        String totalWords = '';
        List<String> inWords = new List<String>();
        for (Integer k = 0; k < iWordsLength; k++) {
            inWords.add('');
        }
        String finalWord = '';
        Integer j = 0;

        // Main For loop
        for (Integer i = 0; i < iWordsLength; i++) {

            if (i == 0) {
                if (actnum[i] == '0' || actnum[i + 1] == '1') {
                    inWords[j] = '';
                } else {
                    inWords[j] = iWords[Integer.valueof(actnum[i])];
                }
                inWords[j] = inWords[j] + ' Only';
            } else if (i == 1) {

                if (actnum[i] == '0') {
                    inWords[j] = '';
                } else if (actnum[i] == '1') {
                    inWords[j] = ePlace[Integer.valueof(actnum[i - 1])];
                } else {
                    inWords[j] = tensPlace[Integer.valueof(actnum[i])];
                }
            } else if (i == 2) {
                if (actnum[i] == '0') {
                    inWords[j] = '';
                } else if (actnum[i - 1] != '0' && actnum[i - 2] != '0') {
                    inWords[j] = iWords[Integer.valueof(actnum[i])] + ' Hundred and';
                } else {
                    inWords[j] = iWords[Integer.valueof(actnum[i])] + ' Hundred';
                }
            } else if (i == 3) {
                if (actnum[i] == '0' || actnum[i + 1] == '1') {
                    inWords[j] = '';
                } else {
                    inWords[j] = iWords[Integer.valueof(actnum[i])];
                }
                if (actnum[i + 1] != '0' || Integer.valueof(actnum[i]) > 0) {
                    inWords[j] = inWords[j] + ' Thousand';
                }
            } else if (i == 4) {

                if (actnum[i] == '0') {
                    inWords[j] = '';
                } else if (actnum[i] == '1') {
                    inWords[j] = ePlace[Integer.valueof(actnum[i - 1])];
                } else {
                    inWords[j] = tensPlace[Integer.valueof(actnum[i])];
                }

            } else if (i == 5) {
                if (actnum[i] == '0' || actnum[i + 1] == '1') {
                    inWords[j] = '';
                } else {
                    inWords[j] = iWords[Integer.valueof(actnum[i])];
                }
                if (actnum[i + 1] != '0' || Integer.valueof(actnum[i]) > 0) {
                    inWords[j] = inWords[j] + ' Lakh';
                }
            } else if (i == 6) {

                if (actnum[i] == '0') {
                    inWords[j] = '';
                } else if (actnum[i] == '1') {
                    inWords[j] = ePlace[Integer.valueof(actnum[i - 1])];
                } else {
                    inWords[j] = tensPlace[Integer.valueof(actnum[i])];
                }

            } else if (i == 7) {
                if (actnum[i] == '0' || actnum[i + 1] == '1' ) {
                    inWords[j] = '';
                } else {
                    inWords[j] = iWords[Integer.valueof(actnum[i])];
                }
                inWords[j] = inWords[j] + ' Crore';
            } else if (i == 8) {

                if (actnum[i] == '0') {
                    inWords[j] = '';
                } else if (actnum[i] == '1') {
                    inWords[j] = ePlace[Integer.valueof(actnum[i - 1])];
                } else {
                    inWords[j] = tensPlace[Integer.valueof(actnum[i])];
                }

            }

            j++;
        }
        // End of For loop

        // Reverse the List
        inWords = reverse(inWords);

        for (Integer i = 0; i < inWords.size(); i++) {
            finalWord += inWords[i];
        }

        return finalWord;
    }


    
    
}