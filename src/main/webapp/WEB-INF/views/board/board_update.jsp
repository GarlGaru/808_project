<%@ page language="java" contentType="text/html; charset=UTF-8"

pageEncoding="UTF-8"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<%@ include file="/WEB-INF/views/common/setting.jsp" %>



<!DOCTYPE html>

<html lang="ko">

<head>

<meta charset="UTF-8">

<meta name="description" content="Bootstrap 4 Spotify-style buttons sample">

    <meta http-equiv="X-UA-Compatible" content="IE=edge">

    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">





<title>게시글 상세 및 수정</title>



 <link rel="stylesheet" href="${path}/resources/common/css/style.css">

 <link rel="stylesheet" href="${path}/resources/common/style.css">

 <link rel="stylesheet" href="${path}/resources/common/board.css">





<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

<style>

    /* 1. 배경 및 전체 레이아웃 */

    body {

        /* 어두운 배경에서 하얀색 글씨가 돋보이도록 설정 */

        background: linear-gradient(135deg, #121212 0%, #1e1e1e 100%) !important;

        padding-top: 130px !important;

        margin: 0;

        color: #ffffff !important; /* 전체 기본 글자색 하얀색 */

    }



    /* 2. 컨테이너 박스 (유리 효과) */

    .table_div {

        margin: 0 auto !important;

        max-width: 900px;

        background: rgba(255, 255, 255, 0.03);

        backdrop-filter: blur(15px);

        padding: 40px;

        border-radius: 20px;

        border: 1px solid rgba(255, 255, 255, 0.1);

        box-shadow: 0 20px 50px rgba(0, 0, 0, 0.6);

    }



    h2 { color: #ffffff !important; margin-bottom: 30px; text-align: center; }



    /* 3. 테이블 내 텍스트 하얀색 강제 */

    .update-table {

        width: 100%;

        border-collapse: collapse;

        margin-bottom: 20px;

    }

    .update-table th {

        width: 120px;

        padding: 15px;

        color: #03c75a !important; /* 제목(항목)은 포인트 컬러 */

        text-align: left;

        border-bottom: 1px solid rgba(255, 255, 255, 0.1);

    }

    .update-table td {

        padding: 15px;

        border-bottom: 1px solid rgba(255, 255, 255, 0.1);

        color: #ffffff !important; /* 데이터 텍스트 무조건 하얀색 */

    }



    /* 4. 입력창 스타일 (★여기서 하얀색 글씨 강제★) */

    input[type="text"], 

    input[type="password"],

    textarea {

        width: 100%;

        background: rgba(255, 255, 255, 0.07) !important;

        border: 1px solid rgba(255, 255, 255, 0.2) !important;

        border-radius: 8px;

        padding: 12px !important;

        color: #FFFFFF !important; /* 입력하는 글자색을 하얀색으로 강제 */

        font-size: 15px;

        box-sizing: border-box;

    }

    

    /* 입력창 클릭 시(포커스) 스타일 */

    input[type="text"]:focus, 

    textarea:focus {

        outline: none;

        border-color: #03c75a !important;

        background: rgba(255, 255, 255, 0.1) !important;

        color: #FFFFFF !important;

    }



    /* 5. 버튼 그룹 스타일 */

    .btn-group {

        text-align: center;

        margin-top: 30px;

        display: flex;

        justify-content: center;

        gap: 10px;

    }



    .inputButton {

        padding: 12px 25px;

        border-radius: 8px;

        font-weight: bold;

        cursor: pointer;

        border: none;

        color: #FFFFFF !important; /* 버튼 글자도 하얀색 */

        transition: 0.3s;

    }



    .btn-update { background-color: #03c75a !important; }

    .btn-delete { background-color: #ff4757 !important; }

    .btn-cancel { background-color: #555 !important; }

</style>

<script>

$(function() {

    // 1. 목록 버튼

    $('#btnList').click(function() {

        location.href = "${pageContext.request.contextPath}/board/list";

    });



    // 2. 수정 완료 (submit 발생 시)

    $('#updateForm').submit(function() {

        if (confirm("수정하시겠습니까?")) {

            return true;

        }

        return false;

    });



    // 3. 삭제 버튼 클릭 시 (새로 추가!)

 // 3. 삭제 버튼 클릭 시 스크립트 수정

    $('#btnDelete').click(function() {

        if (confirm("정말 삭제하시겠습니까? 삭제 후에는 복구할 수 없습니다.")) {

            var bno = $("input[name='bno']").val();

            

            // name='user_Id'가 아니라 'user_id'를 읽어오도록 수정

            var userId = $("input[name='user_id']").val(); 

            

            // 컨트롤러로 데이터 전송

            location.href = "${pageContext.request.contextPath}/board/board_delete?bno=" + bno + "&user_id=" + userId;

        }

    });

});

</script>

</head>

<body>

<div class="wrap">

<%@ include file="/WEB-INF/views/common/header.jsp"%>

<br><br><br><br>

<hr>



<div id="container">

<div align="center">

<h2>상세보기 및 수정</h2>

</div>



<div id="right" style="width: 800px; margin: 0 auto;">

<form id="updateForm"

action="${pageContext.request.contextPath}/board/board_update"

method="post">

<input type="hidden" name="bno" value="${dto.bno}"> <input

type="hidden" name="user_id" value="${dto.userId}">



<table border="1" style="width: 100%; border-collapse: collapse;">

<tr>

<th>글번호</th>

<td>${dto.bno}</td>

<th>조회수</th>

<td>${dto.viewcnt}</td>

</tr>

<tr>

<th>작성자</th>

<td>${sessionScope.loginUser.nickname}</td>

<th>등록일</th>

<td><fmt:formatDate value="${dto.regdate}"

pattern="yyyy-MM-dd HH:mm" /></td>

</tr>

<tr>

<th>글제목</th>

<td colspan="3"><input type="text" name="title"

value="${dto.title}" style="width: 90%"></td>

</tr>

<tr>

<th>글내용</th>

<td colspan="3"><textarea name="content" rows="10"

style="width: 90%">${dto.content}</textarea></td>

</tr>

</table>



<div style="text-align: center; margin-top: 20px;">

<button type="submit">수정완료</button>

<button type="button" id="btnDelete">삭제완료</button>

<button type="button" id="btnList">목록으로</button>

<button type="button" onclick="history.back()">취소</button>

</div>

</form>

</div>

</div>

</div>

<br><br><br><br>

<br><br><br><br>

<br><br><br><br>

<%@ include file="/WEB-INF/views/common/footer.jsp" %>

    <script src="${path}/resources/common/bootstrap-4.6.2-dist/js/bootstrap.bundle.min.js"></script>

    <script src="${path}/resources/common/js/plugins/plugins.js"></script>

    <script src="${path}/resources/common/js/active.js"></script>

    <script src="${path}/resources/common/js/main.js"></script>


</body>

</html>