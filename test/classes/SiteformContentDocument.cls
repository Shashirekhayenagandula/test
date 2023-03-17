public class SiteformContentDocument {
	public static void createPublicLinkForFile(List<ContentVersion> contentVersions){
        system.debug('in ContentTriggerHandler');
        ContentDocumentLink[] contentDocumentLinks = new List<ContentDocumentLink>();
        ContentDistribution[] distributionsToInsert = new List<ContentDistribution>();
        Set<Id> contentDocId = new Set<Id>();
        for(ContentVersion objContentVersion : contentVersions){
            contentDocId.add(objContentVersion.ContentDocumentId);
        }

        Map<Id,ContentDocument> contentDocMap = new Map<Id,ContentDocument>([Select id, ParentId From ContentDocument WHere ID in : contentDocId]);

        for(ContentVersion objContentVersion : contentVersions){
            if(contentDocMap.containsKey(objContentVersion.ContentDocumentId)){
                Id parentId = contentDocMap.get(objContentVersion.ContentDocumentId).ParentId;
                if(parentId != null){
                    contentDocumentLinks.add(createContentDocumentLink(objContentVersion.ContentDocumentId, parentId));
                    distributionsToInsert.add(createContentDistribution(objContentVersion.Id));
                }
            }
        }

        insert contentDocumentLinks;
        insert distributionsToInsert;
    }

    public static ContentDocumentLink createContentDocumentLink(Id contentDocumentId, Id parentId){
        ContentDocumentLink objDocLink = new ContentDocumentLink();
        objDocLink.ContentDocumentId = contentDocumentId;
        objDocLink.LinkedEntityId = parentId;
        objDocLink.ShareType = 'V'; // Inferred permission
        objDocLink.Visibility = 'AllUsers'; //All users
        return objDocLink;
    }

    public static ContentDistribution createContentDistribution(Id contentVersionId){
        ContentDistribution newDist = new ContentDistribution();
        newDist.ContentVersionId = contentVersionId;
        newDist.Name = 'External Link';
        newDist.PreferencesNotifyOnVisit = false;
        newDist.PreferencesAllowViewInBrowser = true;
        return newDist;
    }
}