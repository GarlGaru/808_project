package com.spring.eze.user.dto;

public class MypageMembershipDTO {
	
	    // 멤버쉽 정보
	    private String orderId;	   // 주문 번호
	    private String itemName;   // 상품명 (PRO, FREE는 멤버쉽, 나머지는 음악 or 공연)
	    private String expireDate; // 화면 표시용 만료일
	    private int daysLeft;      // D-Day (남은 일수)
	    private String status;	   // 결제 상태 (APPROVED, FAIl, READY, CANCEL)
	    
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
