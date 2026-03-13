package com.spring.eze.payment.dto;

public class KakaoPayCancelResponse {

	private String tid;
    private String cid;
    private String status;
    private String partner_order_id;
    private String partner_user_id;
    
    private Amount amount;
    private Amount canceled_amount;
    private Amount cancel_available_amount;
    
    public static class Amount {
        private Integer total;
        private Integer tax_free;
        private Integer vat;
        private Integer point;
        private Integer discount;
		public Integer getTotal() {
			return total;
		}
		public void setTotal(Integer total) {
			this.total = total;
		}
		public Integer getTax_free() {
			return tax_free;
		}
		public void setTax_free(Integer tax_free) {
			this.tax_free = tax_free;
		}
		public Integer getVat() {
			return vat;
		}
		public void setVat(Integer vat) {
			this.vat = vat;
		}
		public Integer getPoint() {
			return point;
		}
		public void setPoint(Integer point) {
			this.point = point;
		}
		public Integer getDiscount() {
			return discount;
		}
		public void setDiscount(Integer discount) {
			this.discount = discount;
		}
        
    }

	public String getTid() {
		return tid;
	}

	public void setTid(String tid) {
		this.tid = tid;
	}

	public String getCid() {
		return cid;
	}

	public void setCid(String cid) {
		this.cid = cid;
	}

	public String getStatus() {
		return status;
	}

	public void setStatus(String status) {
		this.status = status;
	}

	public String getPartner_order_id() {
		return partner_order_id;
	}

	public void setPartner_order_id(String partner_order_id) {
		this.partner_order_id = partner_order_id;
	}

	public String getPartner_user_id() {
		return partner_user_id;
	}

	public void setPartner_user_id(String partner_user_id) {
		this.partner_user_id = partner_user_id;
	}

	public Amount getAmount() {
		return amount;
	}

	public void setAmount(Amount amount) {
		this.amount = amount;
	}

	public Amount getCanceled_amount() {
		return canceled_amount;
	}

	public void setCanceled_amount(Amount canceled_amount) {
		this.canceled_amount = canceled_amount;
	}

	public Amount getCancel_available_amount() {
		return cancel_available_amount;
	}

	public void setCancel_available_amount(Amount cancel_available_amount) {
		this.cancel_available_amount = cancel_available_amount;
	}
    
    
    
}
