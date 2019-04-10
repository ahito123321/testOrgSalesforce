@isTest
private class ProductListControllerTest {
	
	@isTest static void testingRedirectToAnotherPage() {
		ProductListController productListController = new ProductListController();
		System.assertNotEquals(Page.ProductDetails, productListController.redirectToDetails(), 'The resulting page is not ProductDetails');
		System.assertNotEquals(Page.ProductPayment, productListController.redirectToPayment(), 'The resulting page is not ProductPayment');
	}
}