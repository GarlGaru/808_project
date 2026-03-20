package com.spring.eze.payment.dto;

public class kakaopayorderRequest {
    private String itemName;
    private String quantity;
    private String totalPrice;
    
    private String paymentType; // "TICKET" or "SUBSCRIBE"

    public String getPaymentType() {
		return paymentType;
	}
	public void setPaymentType(String paymentType) {
		this.paymentType = paymentType;
	}
	public String getItemName() { return itemName; }
    public void setItemName(String itemName) { this.itemName = itemName; }

    public String getQuantity() { return quantity; }
    public void setQuantity(String quantity) { this.quantity = quantity; }

    public String getTotalPrice() { return totalPrice; }
    public void setTotalPrice(String totalPrice) { this.totalPrice = totalPrice; }
}
