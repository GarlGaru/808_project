<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<link rel="stylesheet" href="${path}/resources/music/css/mainstory.css">



 <!-- 메인 컨텐츠 영역 -->
    <div class="container mt-4 mb-5">
   
  	
        <!-- (옵션) 장르 필터 버튼 - 필요하면 주석 해제 -->
        <!--
        <div class="mb-3">
            <button class="btn btn-sm btn-outline-light mr-2" onclick="loadCategory(1)">POP</button>
            <button class="btn btn-sm btn-outline-light mr-2" onclick="loadCategory(2)">HIPHOP</button>
            <button class="btn btn-sm btn-outline-light mr-2" onclick="loadCategory(3)">BALAD</button>
        </div>
        -->
           
		       <!-- 장르랭킹 리스트 Ajax 교체 영역 -->
        <div id="songArea">
            <c:if test="${empty songList}">
                <div class="alert alert-secondary">
                    등록된 곡이 없습니다. 곡 데이터를 먼저 추가해 주세요.
                </div>
            </c:if>

            <c:if test="${not empty songList}">
                <div class="weekly-rank-container">

                    <!-- 🔥 타이틀 + 좌우 화살표 -->
                    <div class="d-flex align-items-center mb-3">
                        <span style="font-size:1.4rem; margin-right:8px;">🔥</span>
                        <span class="section-title text-white"
                              style="font-size:1.2rem; font-weight:700;">장르 랭킹</span>

                        <div class="weekly-arrows">
                            <button type="button"
                                    class="weekly-arrow-btn weekly-arrow-left">&lt;</button>
                            <button type="button"
                                    class="weekly-arrow-btn weekly-arrow-right">&gt;</button>
                        </div>
                    </div>

                    <!-- 🔥 가로 스크롤 래퍼 -->
                    <div class="weekly-rank-wrapper" id="weeklyRankWrapper">
                        <div class="weekly-rank-track" id="weeklyRankTrack">
                            <c:forEach var="song" items="${songList}">
                                <div class="card bg-dark text-white music-card"
                                     onclick="location.href='${path}/music/detail?songId=${song.songId}'">

                                    <div class="card-img-top-wrapper position-relative">
                                        <c:choose>
                                            <c:when test="${not empty song.coverImageUrl}">
                                                <img class="card-img-top"
                                                     src="${path}${song.coverImageUrl}"
                                                     alt="${song.title}">
                                            </c:when>
                                            <c:otherwise>
                                                <img class="card-img-top"
                                                     src="${path}/resources/music/img/default_album.jpg"
                                                     alt="default">
                                            </c:otherwise>
                                        </c:choose>
                                        <!-- 필요하면 여기 play 아이콘 오버레이 넣기 -->
                                        <!-- <div class="play-overlay">▶</div> -->
                                    </div>

                                    <div class="card-body px-1 py-2">
                                        <h6 class="card-title mb-1 text-truncate">
                                            ${song.title}
                                        </h6>
                                        <p class="card-text mb-1 text-truncate"
                                           style="font-size:0.85rem; color:#bbb;">
                                            ${song.artistName}
                                        </p>
                                        <div class="music-meta">
                                            ▶ ${song.playCount} · ♥ ${song.likeCount}
                                        </div>
                                    </div>
                                </div>
                            </c:forEach>
                        </div>
                    </div>
                </div>
            </c:if>
        </div> 
        <!-- #장르랭킹 리스트 Area 끝 -->
        <br>
        <!-- 추천랭킹 Ajax 교체 영역 -->
        <div id="songArea">
            <c:if test="${empty songList}">
                <div class="alert alert-secondary">
                    등록된 곡이 없습니다. 곡 데이터를 먼저 추가해 주세요.
                </div>
            </c:if>

            <c:if test="${not empty songList}">
                <div class="weekly-rank-container">

                    <!-- 🔥 타이틀 + 좌우 화살표 -->
                    <div class="d-flex align-items-center mb-3">
                        <span style="font-size:1.4rem; margin-right:8px;">🔥</span>
                        <span class="section-title text-white"
                              style="font-size:1.2rem; font-weight:700;">추천 랭킹</span>

                        <div class="weekly-arrows">
                            <button type="button"
                                    class="weekly-arrow-btn weekly-arrow-left">&lt;</button>
                            <button type="button"
                                    class="weekly-arrow-btn weekly-arrow-right">&gt;</button>
                        </div>
                    </div>

                    <!-- 🔥 가로 스크롤 래퍼 -->
                    <div class="weekly-rank-wrapper" id="weeklyRankWrapper">
                        <div class="weekly-rank-track" id="weeklyRankTrack">
                            <c:forEach var="song" items="${songList}">
                                <div class="card bg-dark text-white music-card"
                                     onclick="location.href='${path}/music/detail?songId=${song.songId}'">

                                    <div class="card-img-top-wrapper position-relative">
                                        <c:choose>
                                            <c:when test="${not empty song.coverImageUrl}">
                                                <img class="card-img-top"
                                                     src="${path}${song.coverImageUrl}"
                                                     alt="${song.title}">
                                            </c:when>
                                            <c:otherwise>
                                                <img class="card-img-top"
                                                     src="${path}/resources/music/img/default_album.jpg"
                                                     alt="default">
                                            </c:otherwise>
                                        </c:choose>
                                        <!-- 필요하면 여기 play 아이콘 오버레이 넣기 -->
                                        <!-- <div class="play-overlay">▶</div> -->
                                    </div>

                                    <div class="card-body px-1 py-2">
                                        <h6 class="card-title mb-1 text-truncate">
                                            ${song.title}
                                        </h6>
                                        <p class="card-text mb-1 text-truncate"
                                           style="font-size:0.85rem; color:#bbb;">
                                            ${song.artistName}
                                        </p>
                                        <div class="music-meta">
                                            ▶ ${song.playCount} · ♥ ${song.likeCount}
                                        </div>
                                    </div>
                                </div>
                            </c:forEach>
                        </div>
                    </div>
                </div>
            </c:if>
        </div> 
        <!-- #추천랭킹 끝 -->
        <%@ include file="/WEB-INF/views/common/footer.jsp" %>
    </div> <!-- .container 끝 -->
    
