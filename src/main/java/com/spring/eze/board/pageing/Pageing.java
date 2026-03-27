package com.spring.eze.board.pageing;

public class Pageing {
    
    private int pageSize = 10;    
    private int count = 0;        
    private int number = 0;       
    private String pageNum;       
    
    private int startRow;         
    private int endRow;           
    
    private int currentPage;      
    private int pageCount;        // 전체 페이지 수
    private int totalPage;        // JSP에서 사용하는 전체 페이지 수
    private int startPage;
    private int pageRed = 10;     // 한 블록당 보여줄 페이지 개수
    private int endPage;
    
    private int prev;             
    private int next;    
    private int totalCount;       

    public Pageing() {}
    
    public Pageing(String pageNum) {
        if(pageNum == null || pageNum.isEmpty()) {
            pageNum = "1";
        }
        this.pageNum = pageNum;

        this.currentPage = Integer.parseInt(pageNum);	
        this.currentPage = Integer.parseInt(pageNum);

    }

    public void setTotalCount(int totalCount) {  
        this.totalCount = totalCount; 
        this.count = totalCount;      
        
        // 데이터 시작과 끝 행 계산
        this.startRow = (currentPage - 1) * pageSize + 1;
        this.endRow = currentPage * pageSize;
        this.number = totalCount - (currentPage - 1) * pageSize;
        
        // 개수가 세팅될 때마다 페이징 계산기 실행
        pageCalculator();
    }

    public void pageCalculator() {
        if(count > 0) {
            // 1. 전체 페이지 수 계산
            this.pageCount = count / pageSize + (count % pageSize == 0 ? 0 : 1);
            this.totalPage = this.pageCount; 
            
            // 2. 시작 페이지 계산 (1, 11, 21...)
            this.startPage = ((currentPage - 1) / pageRed) * pageRed + 1;
            
            // 3. 끝 페이지 계산 (일단 블록 끝으로 설정)
            this.endPage = startPage + pageRed - 1;
            
            // 4. [핵심] 실제 페이지 수보다 끝 페이지가 크면 실제 페이지 수로 맞춤
            if(this.endPage > this.pageCount) {
                this.endPage = this.pageCount;
            }
            
            // 5. 이전/다음 버튼 값 세팅 (0이면 버튼 안나옴)
            this.prev = (startPage > 1) ? startPage - 1 : 0;
            this.next = (endPage < pageCount) ? endPage + 1 : 0;
            
        } else {
            // 검색 결과가 0개일 때 모든 값을 1 또는 0으로 초기화
            this.pageCount = 1;
            this.totalPage = 1;
            this.startPage = 1;
            this.endPage = 1;
            this.prev = 0;
            this.next = 0;
        }
    }

	public int getPageSize() {
		return pageSize;
	}

	public void setPageSize(int pageSize) {
		this.pageSize = pageSize;
	}

	public int getCount() {
		return count;
	}

	public void setCount(int count) {
		this.count = count;
	}

	public int getNumber() {
		return number;
	}

	public void setNumber(int number) {
		this.number = number;
	}

	public String getPageNum() {
		return pageNum;
	}

	public void setPageNum(String pageNum) {
		this.pageNum = pageNum;
	}

	public int getStartRow() {
		return startRow;
	}

	public void setStartRow(int startRow) {
		this.startRow = startRow;
	}

	public int getEndRow() {
		return endRow;
	}

	public void setEndRow(int endRow) {
		this.endRow = endRow;
	}

	public int getCurrentPage() {
		return currentPage;
	}

	public void setCurrentPage(int currentPage) {
		this.currentPage = currentPage;
	}

	public int getPageCount() {
		return pageCount;
	}

	public void setPageCount(int pageCount) {
		this.pageCount = pageCount;
	}

	public int getTotalPage() {
		return totalPage;
	}

	public void setTotalPage(int totalPage) {
		this.totalPage = totalPage;
	}

	public int getStartPage() {
		return startPage;
	}

	public void setStartPage(int startPage) {
		this.startPage = startPage;
	}

	public int getPageRed() {
		return pageRed;
	}

	public void setPageRed(int pageRed) {
		this.pageRed = pageRed;
	}

	public int getEndPage() {
		return endPage;
	}

	public void setEndPage(int endPage) {
		this.endPage = endPage;
	}

	public int getPrev() {
		return prev;
	}

	public void setPrev(int prev) {
		this.prev = prev;
	}

	public int getNext() {
		return next;
	}

	public void setNext(int next) {
		this.next = next;
	}

	public int getTotalCount() {
		return totalCount;
	}

    // --- Getter & Setter ---

}