<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/common/setting.jsp" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="description" content="Bootstrap 4 Spotify-style buttons sample">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
  <script type="text/javascript">
    .player-btn {
	    width: 32px;
	    height: 32px;
	    border-radius: 50%;
	    border: none;
	    background: transparent;
	    color: #fff;
	    display: inline-flex;
	    align-items: center;
	    justify-content: center;
	    cursor: pointer;
	    font-size: 16px;
	}
    .sidebar{
    	  position: fixed;   /* 이미 fixed면 유지 */
    	  z-index: 9999;
    	}
	.sidebar .player-btn{
	  width: 100%;          /* 또는 auto */
	  height: auto;         /* 32px 제거 */
	  border-radius: 10px;  /* 원형 제거 */
	  padding: 10px 12px;
	  justify-content: flex-start; /* 왼쪽 정렬 */
	  white-space: nowrap;  /* 한 줄 고정 */
	}
	</script>
<title>RANKING</title>
<link rel="stylesheet" href="${path}/resources/common/css/style.css">
<link rel="stylesheet" href="${path}/resources/common/style.css">

</head>
<body>
    <%@ include file="/WEB-INF/views/common/common.jsp" %>
    <%@ include file="/WEB-INF/views/common/header.jsp" %>

    <br><br><br><br>
<div>

<div>
	<%@ include file="/WEB-INF/views/music/aside.jsp" %>

</div>
<div>


</div>


</div>

  
</body>
  <%@ include file="/WEB-INF/views/common/footer.jsp" %>

    <!-- 공통 JS -->
    <script src="${path}/resources/common/js/jquery/jquery-2.2.4.min.js"></script>
    <script src="${path}/resources/common/bootstrap-4.6.2-dist/js/bootstrap.bundle.min.js"></script>
    <script src="${path}/resources/common/js/plugins/plugins.js"></script>
    <script src="${path}/resources/common/js/active.js"></script>
    <script src="${path}/resources/common/js/main.js"></script>
</html>