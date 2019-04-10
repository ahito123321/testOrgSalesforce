@isTest
private class ProductPaymentControllerTest {
	
	@isTest static void testingRedirectToPrevPageWithLink() {
		Product_Table__c product = new Product_Table__c(
			Image_Url__c = 'https://content2.onliner.by/catalog/device/header/66b4a98e3593b6bb23f39d320b9289e8.jpeg',
			Name = 'Test product',
			Product_Description__c = 'Test description',
			Unit_Price__c = 245.00,
			Units_Avail__c = 250
		);
		INSERT product;

		PageReference productPaymentPage = Page.ProductPayment;
		productPaymentPage.getParameters().put('id', product.id);
		productPaymentPage.getParameters().put('prevPageURL', productPaymentPage.getUrl());
		Test.setCurrentPage(productPaymentPage);
		ProductPaymentController productPaymentController = new ProductPaymentController();
		System.assertNotEquals(Page.ProductDetails, productPaymentController.redirectToPrevPage(), 'The resulting page is not ProductDetails');
	}

	@isTest static void testingRedirectToPrevPageWithoutLink() {
		Product_Table__c product = new Product_Table__c(
			Image_Url__c = 'https://content2.onliner.by/catalog/device/header/66b4a98e3593b6bb23f39d320b9289e8.jpeg',
			Name = 'Test product',
			Product_Description__c = 'Test description',
			Unit_Price__c = 245.00,
			Units_Avail__c = 250
		);
		INSERT product;

		PageReference productPaymentPage = Page.ProductPayment;
		productPaymentPage.getParameters().put('id', product.id);
		Test.setCurrentPage(productPaymentPage);
		ProductPaymentController productPaymentController = new ProductPaymentController();
		System.assertNotEquals(Page.ProductList, productPaymentController.redirectToPrevPage(), 'The resulting page is not ProductList');
	}

	@isTest static void testingPaymentWithContactInfo() {
		Product_Table__c product = new Product_Table__c(
			Image_Url__c = 'https://content2.onliner.by/catalog/device/header/66b4a98e3593b6bb23f39d320b9289e8.jpeg',
			Name = 'Test product',
			Product_Description__c = 'Test description',
			Unit_Price__c = 245.00,
			Units_Avail__c = 250
		);
		INSERT product;

		PageReference productPaymentPage = Page.ProductPayment;
		productPaymentPage.getParameters().put('id', product.id);
		productPaymentPage.getParameters().put('email', 'test.email@gmail.com');
		productPaymentPage.getParameters().put('lastName', 'LTest');
		productPaymentPage.getParameters().put('firstName', 'FTest');
		productPaymentPage.getParameters().put('unitCount', '2');
		Test.setCurrentPage(productPaymentPage);
		ProductPaymentController productPaymentController = new ProductPaymentController();
		Test.startTest();
		productPaymentController.payment();
		Test.stopTest();
	}

	@isTest static void testingPaymentWithContactEmail() {
		Product_Table__c product = new Product_Table__c(
			Image_Url__c = 'https://content2.onliner.by/catalog/device/header/66b4a98e3593b6bb23f39d320b9289e8.jpeg',
			Name = 'Test product',
			Product_Description__c = 'Test description',
			Unit_Price__c = 245.00,
			Units_Avail__c = 250
		);
		Contact contact = new Contact(
			Email = 'test.email@gmail.com',
			FirstName = 'FTest',
			LastName = 'LTest'
		);
		INSERT product;
		INSERT contact;

		PageReference productPaymentPage = Page.ProductPayment;
		productPaymentPage.getParameters().put('id', product.id);
		productPaymentPage.getParameters().put('email', contact.Email);
		productPaymentPage.getParameters().put('unitCount', '2');
		Test.setCurrentPage(productPaymentPage);
		ProductPaymentController productPaymentController = new ProductPaymentController();
		Test.startTest();
		productPaymentController.payment();
		Test.stopTest();
	}
}