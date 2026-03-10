<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ include file="/WEB-INF/views/common/setting.jsp"%>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <title>Premium Orange Board - 글쓰기</title>

    <link rel="stylesheet" href="${path}/resources/common/css/style.css">
    <link rel="stylesheet" href="${path}/resources/common/board.css">

    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <style>
        /* 1. 배경 및 전체 레이아웃: 딥 오렌지 그라데이션 */
        body {
            background: radial-gradient(circle at top, #ff6b13 0%, #2b1407 100%) !important;
            padding-top: 130px !important;
            margin: 0;
            min-height: 100vh;
            font-family: 'Pretendard', sans-serif;
            color: #ffffff !important;
        }

        /* 2. 컨테이너 박스 (유리 효과) */
        .table_div {
            margin: 0 auto !important;
            max-width: 900px;
            background: rgba(255, 255, 255, 0.08);
            backdrop-filter: blur(15px);
            padding: 40px;
            border-radius: 20px;
            border: 1px solid rgba(255, 255, 255, 0.2);
            box-shadow: 0 20px 50px rgba(0, 0, 0, 0.5);
        }

        h2 { 
            color: #ffffff !important; 
            margin-bottom: 40px; 
            text-align: center; 
            font-weight: 800;
            letter-spacing: 2px;
            text-shadow: 2px 2px 4px rgba(0,0,0,0.3);
        }

        /* 3. 테이블 디자인 */
        .write-table {
            width: 100%;
            border-collapse: collapse;
            margin-bottom: 20px;
        }
        .write-table th {
            width: 150px;
            padding: 18px;
            color: #ffcc00 !important; /* 옐로우 포인트 */
            text-align: left;
            font-weight: 700;
            border-bottom: 1px solid rgba(255, 255, 255, 0.1);
            text-transform: uppercase;
            font-size: 14px;
        }
        .write-table td {
            padding: 15px;
            border-bottom: 1px solid rgba(255, 255, 255, 0.1);
            color: #ffffff !important;
        }

        /* 4. 입력창 스타일 */
        input[type="text"], textarea {
            width: 100%;
            background: rgba(0, 0, 0, 0.3) !important;
            border: 1px solid rgba(255, 255, 255, 0.2) !important;
            border-radius: 12px;
            padding: 15px !important;
            color: #FFFFFF !important;
            font-size: 15px;
            box-sizing: border-box;
            transition: all 0.3s ease;
            outline: none;
        }

        input[type="text"]:focus, textarea:focus {
            border-color: #ffcc00 !important;
            background: rgba(0, 0, 0, 0.5) !important;
            box-shadow: 0 0 15px rgba(255, 204, 0, 0.2);
        }

        /* 5. 버튼 스타일 */
        .button-area {
            text-align: center;
            margin-top: 40px;
            display: flex;
            justify-content: center;
            gap: 15px;
        }

        .pill-button {
            padding: 15px 45px;
            border-radius: 50px;
            font-weight: 800;
            cursor: pointer;
            border: none;
            color: #ffffff !important;
            font-size: 16px;
            transition: all 0.3s cubic-bezier(0.175, 0.885, 0.32, 1.275);
            display: inline-block !important;
        }

        #btnSave { 
            background: linear-gradient(135deg, #ffcc00 0%, #ff6b13 100%) !important; 
            color: #2b1407 !important;
            box-shadow: 0 5px 20px rgba(255, 107, 19, 0.4) !important;
        }
        
        #btnReset { 
            background: rgba(255, 255, 255, 0.1) !important; 
            border: 1px solid rgba(255, 255, 255, 0.2) !important;
            color: #ffffff !important;
        }
        
        .pill-button:hover {
            transform: translateY(-3px) scale(1.03);
            filter: brightness(1.1);
        }

        ::placeholder {
            color: rgba(255, 255, 255, 0.3) !important;
        }
    </style>

    <script>
        $(function() {
            $('#btnSave').click(function() {
                const title = $('#title').val().trim();
                const content = $('#content').val().trim();

                if (title == "") {
                    alert("제목을 입력해주세요.");
                    $('#title').focus();
                    return false;
                }
                if (content == "") {
                    alert("내용을 입력해주세요.");
                    $('#content').focus();
                    return false;
                }

                document.insertForm.action = "${pageContext.request.contextPath}/board/insertBoard";
                document.insertForm.submit();
            });
        });
    </script>
</head>

<body>
    <%@ include file="/WEB-INF/views/common/header.jsp"%>

    <div class="wrap">
        <div class="table_div">
            <h2>게시글 작성</h2>

            <form name="insertForm" method="post">
                <table class="write-table"> 
                    <tr>
                        <th>작성자</th>
                        <td style="font-weight: 600; color: #ffcc00 !important;">
                            ${sessionScope.loginUser.nickname}
                            <input type="hidden" name="userId" value="${sessionScope.loginUser.userId}">
                        </td>
                    </tr>
                    <tr>
                        <th>글제목</th>
                        <td>
                            <input type="text" name="title" id="title" placeholder="주목받을 수 있는 제목을 입력하세요" required>
                        </td>
                    </tr>
                    <tr>
                        <th>글내용</th>
                        <td>
                            <textarea name="content" id="content" rows="12" placeholder="자유롭게 의견을 나눠보세요">${dto.content}</textarea>
                        </td>
                    </tr>
                </table>

                <div class="button-area">
                    <input type="hidden" name="hidden_bno" value="${dto.bno}">
                    <input type="hidden" name="nickname" value="${dto.nickname}">

                    <button type="button" class="pill-button" id="btnSave">작성완료</button>
                    <button type="reset" class="pill-button" id="btnReset">다시쓰기</button>
                </div>
            </form>
        </div>
    </div>

    <%@ include file="/WEB-INF/views/common/footer.jsp"%>
</body>
</html>