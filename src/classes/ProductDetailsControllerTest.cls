@isTest
private class ProductDetailsControllerTest {
	
	@isTest static void testingRedirectToAnotherPage() {
		Product_Table__c product = new Product_Table__c(
			Image_Url__c = 'https://content2.onliner.by/catalog/device/header/66b4a98e3593b6bb23f39d320b9289e8.jpeg',
			Name = 'Test product',
			Product_Description__c = 'Test description',
			Unit_Price__c = 245.00,
			Units_Avail__c = 250
		);
		INSERT product;

		PageReference productDetailsPage = Page.ProductDetails;
		productDetailsPage.getParameters().put('id', product.id);
		Test.setCurrentPage(productDetailsPage);
		ProductDetailsController productDetailsController = new ProductDetailsController();
		System.assertNotEquals(Page.ProductList, productDetailsController.redirectToShop(), 'The resulting page is not ProductList');
		System.assertNotEquals(Page.ProductPayment, productDetailsController.redirectToPayment(), 'The resulting page is not ProductPayment');
	}
}