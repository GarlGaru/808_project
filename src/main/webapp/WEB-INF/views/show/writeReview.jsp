<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/common/setting.jsp" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>후기 작성하기</title>
    <link rel="stylesheet" href="${path}/resources/common/css/style.css">
    <link rel="stylesheet" href="${path}/resources/common/style.css">
    <style>
        body { background-color: #121212; color: #fff; font-family: 'Pretendard', sans-serif; }
        .write-container { width: 100%;     
					    max-width: 800px; 
					    margin: 60px auto; 
					    padding: 40px; 
					    background: #1e1e1e; 
					    border-radius: 15px; 
					    border: 1px solid #333; }
        .form-group label { color: #ED6701; font-weight: bold; margin-bottom: 10px; display: block; }
        .form-control { 
            background-color: #2a2a2a; 
            border: 1px solid #444; 
            color: #fff; 
            border-radius: 8px; 
            padding: 6px; 
        }
        .form-control:focus { 
            background-color: #333; 
            border-color: #ED6701; 
            color: #fff; 
            box-shadow: none; 
            font-size: 13px;
        }
        .btn-submit {
            background-image: linear-gradient(to right, #DF8845, #ED6701);
            border: none; 
            color: white; 
            font-weight: bold; 
            padding: 12px 30px;
            border-radius: 50px; 
            width: 100%; 
            margin-top: 20px; 
            transition: 0.3s;
        }
        .btn-submit:hover { transform: scale(1.02); opacity: 0.9; }
        .btn-cancel { background: #444; color: #ccc; border: none; 
        border-radius: 50px; padding: 12px 30px; width: 100%; margin-top: 10px; }
    </style>
    
</head>

<body class="dark-mode">
    <%@ include file="/WEB-INF/views/common/header.jsp" %>

    <div class="container">
        <div class="write-container">
            <h2 class="text-center mb-4" style="color: white; font-weight: bold;">공연 후기 작성</h2>
            
            <form action="${path}/show/insertReview" method="post" onsubmit="return confirmRegister()">
                
                <div class="form-group">
                    <label for="concertTitle">관람한 공연</label>
                    <select name="showId" id="showId" class="form-control" required>
					    <option value="">공연을 선택해주세요</option>
					    <c:forEach var="title" items="${concertList}">
					        <option value="${title}">${title}</option>
					    </c:forEach>
					</select>
                </div>

                <div class="form-group">
                    <label for="rating">별점</label>
                    <select name="rating" id="rating" class="form-control" required>
                        <option value="5">★★★★★ (5점)</option>
                        <option value="4">★★★★☆ (4점)</option>
                        <option value="3">★★★☆☆ (3점)</option>
                        <option value="2">★★☆☆☆ (2점)</option>
                        <option value="1">★☆☆☆☆ (1점)</option>
                    </select>
                </div> 

                <div class="form-group">
                    <label for="content">후기 내용</label>
                    <textarea name="content" id="content" rows="8" class="form-control" placeholder="공연은 어떠셨나요? 생생한 후기를 남겨주세요!" required></textarea>
                </div>

                <button type="submit" class="btn-submit">후기 등록하기</button>
                <button type="button" class="btn-cancel" onclick="history.back()">취소</button>
            </form>
        </div>
    </div>

    <script>
    function confirmRegister() {
        if (confirm("작성하신 후기를 등록하시겠습니까?")) {
            return true; // 확인 누르면 전송 시작!
        } else {
            return false; // 취소 누르면 아무 일도 안 일어남
        }
    }
    </script>

    <%@ include file="/WEB-INF/views/common/footer.jsp" %>
</body>
</html>