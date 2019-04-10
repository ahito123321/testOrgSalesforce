/**
 * @File Name          : ProductDetailsController.cls
 * @Description        : 
 * @Author             : ChangeMeIn@UserSettingsUnder.SFDoc
 * @Group              : 
 * @Last Modified By   : ChangeMeIn@UserSettingsUnder.SFDoc
 * @Last Modified On   : 07.04.2019, 14:15:49
 * @Modification Log   : 
 *==============================================================================
 * Ver         Date                     Author      		      Modification
 *==============================================================================
 * 1.0    07.04.2019, 13:58:25   ChangeMeIn@UserSettingsUnder.SFDoc     Initial Version
**/
public class ProductDetailsController {
	public Product_Table__c product {get; set;}
	public ProductDetailsController() {
		String id = ApexPages.currentPage().getParameters().get('id');
		product = [SELECT Id, Image_Url__c, Name, Product_Description__c, Unit_Price__c, Units_Avail__c 
			FROM Product_Table__c
			WHERE Id = :id];
	}

	public PageReference redirectToShop() {
		PageReference shop = Page.ProductList;
		shop.setRedirect(true);
		return shop;
	}

	public PageReference redirectToPayment() {
		PageReference pagePayment = Page.ProductPayment;
        pagePayment.getParameters().put('id', product.Id);
        pagePayment.getParameters().put('prevPageURL', ApexPages.currentPage().getUrl());
        pagePayment.setRedirect(true);
        return pagePayment;
	}
}