<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<c:set var="ctx" value="${pageContext.request.contextPath}" />
<c:set var="adminUrl" value="${ctx}/admin" />
<c:set var="adminRes" value="${ctx}/resources/common/admin" />
<style>
        /* 종 아이콘 스타일 */
        .yellow-bell {
            color: #f1c40f;
            font-size: 1.5rem;
            cursor: pointer;
            display: inline-block;
            transform-origin: top center;
            animation: bell-shake 2s infinite ease-in-out;
        }

        /* 빨간색 숫자 배지 스타일 */
        .bell-badge {
            position: absolute;
            top: -5px;
            right: -5px;
            background-color: #e74a3b;
            color: white;
            font-size: 0.7rem;
            padding: 2px 6px;
            border-radius: 50%;
            font-weight: bold;
            border: 2px solid white;
            display: inline-block;
        }

        /* 종과 숫자를 감싸는 바구니 */
        .notification-container {
            position: relative;
            display: inline-block;
            margin-right: 15px;
        }

        @keyframes bell-shake {
            0%, 100% { transform: rotate(0deg); }
            10% { transform: rotate(15deg); }
            20% { transform: rotate(-10deg); }
            30% { transform: rotate(5deg); }
            40% { transform: rotate(-5deg); }
            50% { transform: rotate(0deg); }
        }
        /* 알림 컨테이너 상대 위치 설정 */
.notification-container {
    position: relative;
}

/* 종 아이콘 배지 스타일 [cite: 37] */
.bell-badge {
    position: absolute;
    top: -5px;
    right: -5px;
    background-color: #e74a3b;
    color: white;
    border-radius: 50%;
    padding: 2px 5px;
    font-size: 10px;
    font-weight: 700;
    line-height: 1;
}

/* 부트스트랩 드롭다운 애니메이션 효과  */
.animated--grow-in {
    animation-name: growIn;
    animation-duration: 200ms;
    animation-timing-function: transform cubic-bezier(.175, .885, .32, 1.275);
}

@keyframes growIn {
    0% { transform: scale(.9); opacity: 0; }
    100% { transform: scale(1); opacity: 1; }
}

/* 드롭다운 아이템 호버 효과 */
.dropdown-item:hover {
    background-color: #f8f9fc !important;
}
    </style>

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport"
	content="width=device-width, initial-scale=1, shrink-to-fit=no">
<title>Admin - Dashboard</title>

<link href="${adminRes}/vendor/fontawesome-free/css/all.min.css"
	rel="stylesheet">
<link
	href="https://fonts.googleapis.com/css?family=Nunito:200,300,400,600,700,800,900"
	rel="stylesheet">
<link href="${adminRes}/css/sb-admin-2.min.css" rel="stylesheet">
</head>

<body id="page-top">

	<div id="wrapper">

		<!-- Sidebar -->
		<ul
			class="navbar-nav bg-gradient-primary sidebar sidebar-dark accordion"
			id="accordionSidebar">

			<a
				class="sidebar-brand d-flex align-items-center justify-content-center"
				href="${adminUrl}">
				<div class="sidebar-brand-icon">
					<i class="fas fa-user-shield"></i>
				</div>
				<div class="sidebar-brand-text mx-3">808 ADMIN</div>
			</a>

			<hr class="sidebar-divider my-0">

			<li class="nav-item active"><a class="nav-link"
				href="${adminUrl}"> <i class="fas fa-fw fa-tachometer-alt"></i>
					<span>Dashboard</span>
			</a></li>

			<li class="nav-item"><a class="nav-link" href="${adminUrl}/user">
					<i class="fas fa-fw fa-users"></i> <span>User Admin</span>
			</a></li>

			<li class="nav-item"><a class="nav-link" href="${adminUrl}/pay">
					<i class="fas fa-fw fa-credit-card"></i> <span>Pay Admin</span>
			</a></li>

			<li class="nav-item"><a class="nav-link"
				href="${adminUrl}/board"> <i class="fas fa-fw fa-clipboard-list"></i>
					<span>Board Admin</span>
			</a></li>

			<li class="nav-item"><a class="nav-link"
				href="${adminUrl}/music"> <i class="fas fa-fw fa-music"></i> <span>Music
						Admin</span>
			</a></li>
			
			<li class="nav-item">
			    <a class="nav-link" href="${adminUrl}/ticketpay">
			        <i class="fas fa-fw fa-ticket-alt"></i>
			        <span>Ticket Pay Admin</span>
			    </a>
			</li>

			<hr class="sidebar-divider d-none d-md-block">

		</ul>
		<!-- End Sidebar -->

		<div id="content-wrapper" class="d-flex flex-column">
			<div id="content">

				<!-- Topbar -->
				<nav
					class="navbar navbar-expand navbar-light bg-white topbar mb-4 static-top shadow">
					<span class="navbar-brand">808 Admin Dashboard</span>

					<div class="ml-auto d-flex align-items-center">

						<div class="notification-container dropdown no-arrow">
							<a href="#" class="yellow-bell dropdown-toggle"
								id="alertsDropdown" role="button" data-toggle="dropdown"
								aria-haspopup="true" aria-expanded="false" title="신규 알림"> <i
								class="fas fa-bell"></i> <span id="bell-count"
								class="bell-badge">0</span>
							</a>

							<div
								class="dropdown-list dropdown-menu dropdown-menu-right shadow animated--grow-in"
								aria-labelledby="alertsDropdown"
								style="width: 300px; padding: 0; border-radius: 10px; overflow: hidden;">
								<h6 class="dropdown-header"
									style="background-color: #ffcc00; border: none; color: #331a00; font-weight: 800; padding: 10px 15px;">
									Alerts Center</h6>

								<div id="notification-items"
									style="max-height: 300px; overflow-y: auto; background: #fff;">
									<a class="dropdown-item d-flex align-items-center" href="${path}/eze/board/list"
										style="padding: 10px 15px; border-bottom: 1px solid #eee;">
										<div class="mr-3">
											<div class="icon-circle bg-primary"
												style="width: 35px; height: 35px; border-radius: 50%; display: flex; 
												align-items: center; justify-content: center; color: #fff;">
												<i class="fas fa-file-alt"></i>
											</div>
										</div>
										
										<div>
											<div class="small text-gray-500" id="current-date">
											     <fmt:formateDate value="${row.regdate}"/>
											</div>
											<span class="font-weight-bold">리스트 바로가기</span>
											<div class="small text-gray-600">${row.title}</div>
										</div>
										
									</a>
									<div class="dropdown-item text-center small text-gray-500"
										id="empty-msg" style="padding: 20px;">새로운 알림이 없습니다</div>
								</div>

								<a class="dropdown-item text-center small text-gray-500"
									href="javascript:void(0);" id="view-all-btn"
									onclick="showTodayTitles();"
									style="background: #f8f9fc; padding: 10px; font-weight: bold; color: #ffcc00;">
									모든 알람 보기 </a>
							</div>
						</div>
					</div>
				</nav>
				<!-- Page Content -->
				<div class="container-fluid">

					<!-- 상단 카드 -->
					<div class="row">

						<!-- 최근 5일 가입자 총합 -->
						<div class="col-xl-3 col-md-6 mb-4">
							<div class="card border-left-primary shadow h-100 py-2">
								<div class="card-body">
									<div id="signupTotal"
										class="h5 mb-0 font-weight-bold text-gray-800">0</div>
									<div
										class="text-xs font-weight-bold text-primary text-uppercase">
										최근 5일 가입자 합계</div>
								</div>
							</div>
						</div>

						<!-- 최근 5일 결제 승인 총합 -->
						<div class="col-xl-3 col-md-6 mb-4">
							<div class="card border-left-success shadow h-100 py-2">
								<div class="card-body">
									<div id="payTotal"
										class="h5 mb-0 font-weight-bold text-gray-800">0</div>
									<div
										class="text-xs font-weight-bold text-success text-uppercase">
										최근 5일 결제 승인 합계</div>
								</div>
							</div>
						</div>

						<!-- READY 건수 -->
						<div class="col-xl-3 col-md-6 mb-4">
							<div class="card border-left-warning shadow h-100 py-2">
								<div class="card-body">
									<div id="readyCount"
										class="h5 mb-0 font-weight-bold text-gray-800">0</div>
									<div
										class="text-xs font-weight-bold text-warning text-uppercase">
										결제 READY</div>
								</div>
							</div>
						</div>

						<!-- APPROVED 건수 -->
						<div class="col-xl-3 col-md-6 mb-4">
							<div class="card border-left-info shadow h-100 py-2">
								<div class="card-body">
									<div id="approvedCount"
										class="h5 mb-0 font-weight-bold text-gray-800">0</div>
									<div class="text-xs font-weight-bold text-info text-uppercase">
										결제 APPROVED</div>
								</div>
							</div>
						</div>

					</div>

					<!-- 차트 영역 -->
					<div class="row">

						<!-- 가입자 라인차트 -->
						<div class="col-xl-8 col-lg-7">
							<div class="card shadow mb-4">
								<div class="card-header py-3">
									<h6 class="m-0 font-weight-bold text-primary">최근 5일 가입자</h6>
								</div>
								<div class="card-body">
									<div style="height: 320px;">
										<canvas id="myAreaChart"></canvas>
									</div>
								</div>
							</div>
						</div>

						<!-- 결제 상태 도넛 -->
						<div class="col-xl-4 col-lg-5">
							<div class="card shadow mb-4">
								<div class="card-header py-3">
									<h6 class="m-0 font-weight-bold text-primary">결제 상태 분포</h6>
								</div>
								<div class="card-body">
									<div style="height: 320px;">
										<canvas id="myPieChart"></canvas>
									</div>
								</div>
							</div>
						</div>

					</div>

					<!-- 바차트 -->
					<div class="row">
						<div class="col-xl-12 col-lg-12">
							<div class="card shadow mb-4">
								<div class="card-header py-3">
									<h6 class="m-0 font-weight-bold text-primary">최근 5일 결제 승인</h6>
								</div>
								<div class="card-body">
									<div style="height: 320px;">
										<canvas id="myBarChart"></canvas>
									</div>
								</div>
							</div>
						</div>
					</div>

				</div>
			</div>

			<!-- Footer -->
			<footer class="sticky-footer bg-white">
				<div class="container my-auto text-center">
					<span>808 &copy; Admin 2026</span>
				</div>
			</footer>

		</div>
	</div>

	<a class="scroll-to-top rounded" href="#page-top"> <i
		class="fas fa-angle-up"></i>
	</a>

	<script src="${adminRes}/vendor/jquery/jquery.min.js"></script>
	<script src="${adminRes}/vendor/bootstrap/js/bootstrap.bundle.min.js"></script>
	<script src="${adminRes}/vendor/jquery-easing/jquery.easing.min.js"></script>
	<script src="${adminRes}/js/sb-admin-2.min.js"></script>
	<script src="${adminRes}/vendor/chart.js/Chart.min.js"></script>

	<script>
		$(function() {

			var areaChart = null;
			var barChart = null;
			var pieChart = null;

			function sumArray(arr) {
				var total = 0;
				for (var i = 0; i < arr.length; i++) {
					total += Number(arr[i] || 0);
				}
				return total;
			}

			function buildLineChart(labels, data) {
				var ctx = document.getElementById('myAreaChart').getContext(
						'2d');
				if (areaChart)
					areaChart.destroy();

				areaChart = new Chart(ctx, {
					type : 'line',
					data : {
						labels : labels,
						datasets : [ {
							label : '가입자',
							data : data,
							backgroundColor : "rgba(78, 115, 223, 0.2)",
							borderColor : "rgba(78, 115, 223, 1)",
							pointBackgroundColor : "rgba(78, 115, 223, 1)",
							pointBorderColor : "#fff",
							pointRadius : 4,
							fill : true
						} ]
					},
					options : {
						maintainAspectRatio : false,
						scales : {
							yAxes : [ {
								ticks : {
									beginAtZero : true,
									precision : 0
								}
							} ]
						}
					}
				});
			}

			function buildBarChart(labels, data) {
				var ctx = document.getElementById('myBarChart')
						.getContext('2d');
				if (barChart)
					barChart.destroy();

				barChart = new Chart(ctx, {
					type : 'bar',
					data : {
						labels : labels,
						datasets : [ {
							label : '결제 승인',
							data : data,
							backgroundColor : "rgba(28, 200, 138, 0.7)",
							borderColor : "rgba(28, 200, 138, 1)",
							borderWidth : 1
						} ]
					},
					options : {
						maintainAspectRatio : false,
						scales : {
							yAxes : [ {
								ticks : {
									beginAtZero : true,
									precision : 0
								}
							} ]
						}
					}
				});
			}

			function buildPieChart(labels, data) {
				var ctx = document.getElementById('myPieChart')
						.getContext('2d');
				if (pieChart)
					pieChart.destroy();

				var colorMap = {
					READY : "#f6c23e",
					APPROVED : "#1cc88a",
					FAIL : "#e74a3b",
					CANCEL : "#858796"
				};

				var colors = labels.map(function(label) {
					return colorMap[label] || "#4e73df";
				});

				pieChart = new Chart(ctx, {
					type : 'doughnut',
					data : {
						labels : labels,
						datasets : [ {
							data : data,
							backgroundColor : colors,
							borderWidth : 1
						} ]
					},
					options : {
						maintainAspectRatio : false,
						legend : {
							position : 'bottom'
						}
					}
				});
			}

			$.getJSON('<c:url value="/admin/api/stats/signupLast5"/>',
					function(res) {
						var labels = res.map(function(x) {
							return x.label;
						});
						var data = res.map(function(x) {
							return x.cnt;
						});

						$('#signupTotal').text(sumArray(data));
						buildLineChart(labels, data);
					});

			$.getJSON('<c:url value="/admin/api/stats/payLast5"/>', function(
					res) {
				var labels = res.map(function(x) {
					return x.label;
				});
				var data = res.map(function(x) {
					return x.cnt;
				});

				$('#payTotal').text(sumArray(data));
				buildBarChart(labels, data);
			});

			$.getJSON('<c:url value="/admin/api/stats/payStatus"/>', function(
					res) {
				var labels = res.map(function(x) {
					return x.label;
				});
				var data = res.map(function(x) {
					return x.cnt;
				});

				buildPieChart(labels, data);

				var statusMap = {};
				for (var i = 0; i < res.length; i++) {
					statusMap[res[i].label] = res[i].cnt;
				}

				$('#readyCount').text(statusMap.READY || 0);
				$('#approvedCount').text(statusMap.APPROVED || 0);
			});

		});
		/*노란색 종 */
		$(document).ready(function() {
		    let lastCount = -1;

		    // 오늘 날짜 세팅
		    const today = new Date();
		    const formattedDate = today.getFullYear() + '-' + 
		                          String(today.getMonth() + 1).padStart(2, '0') + '-' + 
		                          String(today.getDate()).padStart(2, '0');
		    $('#current-date').text(formattedDate);

		    function checkNewPost() {
		        const targetUrl = '${ctx}/board/admin/api/stats/boardTodayCnt';

		        $.getJSON(targetUrl, function(currentCount) {
		            // 1. 카운트가 0보다 큰 경우 (게시글이 있을 때)
		            if (currentCount > 0) {
		                $('#bell-count').text(currentCount).show(); // 배지 표시
		                $('#new-post-item').show();                 // 알림 항목 표시
		                $('#empty-msg').hide();                     // "알림 없음" 숨김
		                
		                // 처음 발견했거나 숫자가 늘어났을 때만 종 흔들기 애니메이션 가동
		                if (lastCount !== -1 && currentCount > lastCount) {
		                    $('.yellow-bell').css('animation', 'bell-shake 0.5s infinite');
		                    setTimeout(function() {
		                        $('.yellow-bell').css('animation', 'bell-shake 2s infinite ease-in-out');
		                    }, 3000);
		                }
		            } 
		            // 2. 카운트가 0인 경우
		            else {
		                $('#bell-count').hide();        // 배지 숨김
		                $('#new-post-item').hide();     // 알림 항목 숨김
		                $('#empty-msg').show();         // "알림 없음" 표시
		                $('.yellow-bell').css('animation', 'none'); // 흔들림 정지
		            }
		            
		            lastCount = currentCount;
		        }).fail(function() {
		            console.log("알림 데이터를 가져오지 못했습니다.");
		        });
		    }

		    setInterval(checkNewPost, 5000); 
		    checkNewPost();
		});

		function showTodayTitles() {
		   
		    const targetUrl = '${ctx}/board/admin/api/stats/boardTodayList'; 

		    $.getJSON(targetUrl, function(data) {
		        const container = $('#notification-items');
		        container.empty(); 
		        if (data && data.length > 0) {
		        	data.forEach(function(post) {
		        		const item = `
		        		    <a class="dropdown-item d-flex align-items-center" 
		        		       href="${ctx}/board/board_detail?bno=\${post.bno}" 
		        		       style="padding: 12px 15px; border-bottom: 1px solid #eee;">
		        		        <div class="mr-2">
		        		            <span class="badge badge-warning" style="background-color: #ffcc00; color: #331a00;">NEW</span>
		        		        </div>
		        		        <div class="font-weight-bold text-truncate" style="max-width: 200px; color: #333;">
		        		            \${post.title}
		        		        </div>
		        		    </a>`;
		        	    container.append(item);
		        	});
		            $('#view-all-btn').text('목록 닫기').attr('onclick', 'location.reload()');
		        } else {
		            container.append('<div class="dropdown-item text-center small text-gray-500" style="padding: 20px;">오늘 등록된 글이 없습니다.</div>');
		        }
		    }).fail(function() {
		        alert("데이터를 가져오는 데 실패했습니다. 경로를 확인하세요: " + targetUrl);
		    });
		}
	</script>

</body>
</html>