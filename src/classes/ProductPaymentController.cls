public class ProductPaymentController {
	public ContactInfo contactInfo {get; set;}
	public AlertBox alertBox {get; set;}
	public Product_Table__c product {get; set;}
	private String prevPageURL;
	private Contact currentContact;

	public ProductPaymentController() {
		Map<String, String> paramPage = ApexPages.currentPage().getParameters();
		prevPageURL = paramPage.get('prevPageURL');
		String id = paramPage.get('id');
		product = [SELECT Image_Url__c, Name, Product_Description__c, Unit_Price__c, Units_Avail__c 
			FROM Product_Table__c
			WHERE Id = :id];
		contactInfo = new ContactInfo();
		alertBox = new AlertBox();
	}

	public PageReference redirectToPrevPage() {
		PageReference prevPage = (prevPageURL == null) ? Page.ProductList : new PageReference(prevPageURL);
		prevPage.setRedirect(true);
		return prevPage;
	}

	public void payment() {
		try {
            Map<String, String> paramPage = ApexPages.currentPage().getParameters();
			contactInfo.email = paramPage.get('email');
			contactInfo.checkEmail();
			if (contactInfo.emailError) {
				return;
			}
			List<Contact> contact = [SELECT Id, Email, FirstName, LastName FROM Contact WHERE Email = :contactInfo.email LIMIT 1];

			if (contact.size() == 0) {
				contactInfo.firstName = paramPage.get('firstName');
				contactInfo.checkFirstName();
				contactInfo.lastName = paramPage.get('lastName');
				contactInfo.checkLastName();
				if (contactInfo.lastNameError || contactInfo.firstNameError) {
					return;
				}
				currentContact = new Contact(
					Email = contactInfo.email,
					FirstName = contactInfo.firstName,
					LastName = contactInfo.lastName
				);
				UPSERT currentContact;
			} else {
				currentContact = contact.get(0);
				contactInfo.firstName = currentContact.FirstName;
				contactInfo.lastName = currentContact.LastName;
			}
			contactInfo.setValidName();

			Integer unitCount = Integer.valueOf(paramPage.get('unitCount'));
			Order_Table__c order = new Order_Table__c(
				Product__c = product.Id,
				Units__c = unitCount,
				Order_Amount__c = (product.Unit_Price__c * Decimal.valueOf(unitCount)).divide(1, 2),
				Contact__c = currentContact.Id
			);

			if (product.Units_Avail__c - unitCount < 0) {
				alertBox.showErrorAlertBox('Failed to complete the order. Available - ' + product.Units_Avail__c + '.');
				return;
			}
			product.Units_Avail__c -= unitCount;
			INSERT order;
			UPDATE product;
			alertBox.showSuccessAlertBox('Order for the amount of ' + order.Order_Amount__c + ' $ successfully completed!');
		} catch(Exception ex) { }
	}

	class ContactInfo {
		public String email {get; set;}
		public Boolean emailError {get; set;}
		public String firstName {get; set;}
		public Boolean firstNameError {get; set;}
		public String lastName {get; set;}
		public Boolean lastNameError {get; set;}

		public ContactInfo() {
			email = '';
			firstName = '';
			lastName = '';
			emailError = false;
			firstNameError = false;
			lastNameError = false;
		}

		public void checkEmail() {
			if (email.length() == 0) {
				emailError = true;
			} else {
				emailError = false;
			}
		}

		public void checkFirstName() {
			if (firstName.length() == 0) {
				firstNameError = true;
			} else {
				firstNameError = false;
			}
		}

		public void checkLastName() {
			if (lastName.length() == 0) {
				lastNameError = true;
			} else {
				lastNameError = false;
			}
		}

		public void setValidName() {
			firstNameError = false;
			lastNameError = false;
		}
	}

	class AlertBox {
		public String message {get; set;}
		public Boolean status {get; set;}
		public Boolean isSuccess {get; set;}

		public AlertBox() {
			status = false;
			message = '';
			isSuccess = false;
		}

		public void close() {
			status = false;
			message = '';
			isSuccess = false;
		}

		public void showSuccessAlertBox(String msg) {
			message = msg;
			isSuccess = true;
			status = true;
		} 

		public void showErrorAlertBox(String msg) {
			message = msg;
			isSuccess = false;
			status = true;
		} 
	}
}