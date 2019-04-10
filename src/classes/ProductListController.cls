/**
 * @File Name          : ProductListController.cls
 * @Description        : 
 * @Author             : ChangeMeIn@UserSettingsUnder.SFDoc
 * @Group              : 
 * @Last Modified By   : ChangeMeIn@UserSettingsUnder.SFDoc
 * @Last Modified On   : 07.04.2019, 14:14:58
 * @Modification Log   : 
 *==============================================================================
 * Ver         Date                     Author      		      Modification
 *==============================================================================
 * 1.0    07.04.2019, 13:10:54   ChangeMeIn@UserSettingsUnder.SFDoc     Initial Version
**/
public class ProductListController {
    public List<Product_Table__c> productList {get; set;}
    public String selectedId {get; set;}

    public ProductListController() {
    	productList = [SELECT Id, Image_Url__c, Name, Product_Description__c, Unit_Price__c
            FROM Product_Table__c];
    }

    public PageReference redirectToDetails() {
        PageReference pageDetails = Page.ProductDetails;
        pageDetails.getParameters().put('id', selectedId);
        pageDetails.setRedirect(true);
        return pageDetails;
    }

    public PageReference redirectToPayment() {
        PageReference pagePayment = Page.ProductPayment;
        pagePayment.getParameters().put('id', selectedId);
        pagePayment.getParameters().put('prevPageURL', ApexPages.currentPage().getUrl());
        pagePayment.setRedirect(true);
        return pagePayment;
    }
}