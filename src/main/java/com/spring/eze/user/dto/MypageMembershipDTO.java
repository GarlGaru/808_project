package com.spring.eze.user.dto;

public class MypageMembershipDTO {
	
	    // 멤버쉽 정보
	    private String orderId;	   // 주문 번호
	    private String itemName;   // 상품명 (예: 808 PRO 멤버십)
	    private String expireDate; // 화면 표시용 만료일 (2026년 04월 30일)
	    private int daysLeft;      // D-Day (남은 일수)
	    private String status;	   // 결제 상태 (APPROVED 등)
	    
		public MypageMembershipDTO() {
			super();
		}

		public MypageMembershipDTO(String orderId, String itemName, String expireDate, int daysLeft, String status) {
			super();
			this.orderId = orderId;
			this.itemName = itemName;
			this.expireDate = expireDate;
			this.daysLeft = daysLeft;
			this.status = status;
		}

		public String getOrderId() {
			return orderId;
		}

		public void setOrderId(String orderId) {
			this.orderId = orderId;
		}

		public String getItemName() {
			return itemName;
		}

		public void setItemName(String itemName) {
			this.itemName = itemName;
		}

		public String getExpireDate() {
			return expireDate;
		}

		public void setExpireDate(String expireDate) {
			this.expireDate = expireDate;
		}

		public int getDaysLeft() {
			return daysLeft;
		}

		public void setDaysLeft(int daysLeft) {
			this.daysLeft = daysLeft;
		}

		public String getStatus() {
			return status;
		}

		public void setStatus(String status) {
			this.status = status;
		}

		@Override
		public String toString() {
			return "MypageMembershipDTO [orderId=" + orderId + ", itemName=" + itemName + ", expireDate=" + expireDate
					+ ", daysLeft=" + daysLeft + ", status=" + status + "]";
		}
	    
		

}
