<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<style>

.subscribe-modal{
    display:none;
    position:fixed;
    inset:0;
    background:rgba(0,0,0,0.75);
    z-index:10000;
    justify-content:center;
    align-items:center;
}

.subscribe-modal-container {
    display: flex;
    gap: 30px;
    align-items: stretch; /* 핵심: 카드 높이 통일 */
}

/* 카드 기본 */
.subscribe-card {
    width: 330px;
    background: #121212;
    color: #fff;
    padding: 30px;
    border-radius: 14px;
    box-shadow: 0 15px 40px rgba(0,0,0,0.4);
    transition: all .2s ease;
    display: flex; /* 내부 요소 정렬 */
    flex-direction: column;
}

.subscribe-card:hover{
    transform:scale(1.05);
}

/* 텍스트 */

.subscribe-plan{
    font-size:16px;
    margin-bottom:5px;
    color:#DF8845;
}

.subscribe-title{
    font-size:30px;
    font-weight:700;
    margin-bottom:10px;
}

/* 개인 색 */

.subscribe-title.pink{
    color:#fff;
}

/* 베이직 색 */

.subscribe-title.green{
    color:#fff;
}

.subscribe-price{
    margin-bottom:18px;
    font-size:15px;
}

/* 특징 목록이 남은 공간을 다 채우게 해서 버튼 위치를 맞춤 */
.subscribe-feature {
    margin: 20px 0;
    padding-left: 18px;
    flex-grow: 1; /* 핵심: 버튼을 아래로 밀어냄 */
    list-style: none; /* 점 없애기 원하면 추가 */
}

.subscribe-feature li::before {
    content: '•';
    color: #DF8845;
    display: inline-block; 
    width: 1em;
    margin-left: -1em;
}

.subscribe-feature li{
    margin-bottom:8px;
}

/* 버튼 */

.subscribe-btn{
    width:100%;
    border:none;
    padding:14px;
    border-radius:40px;
    font-size:15px;
    font-weight:600;
    cursor:pointer;
}

.subscribe-btn.pink{
    background: linear-gradient(90deg, #b56f38 0%, #bf5301 100%);
    color:#fff;
}

.subscribe-btn.green{
    background: linear-gradient(160deg, #2a3a7e, rgba(60, 160, 200, 0.10) 100%);
    color:#fff;
}

.subscribe-btn:hover{
    opacity:0.9;
}

</style>


<div id="subscribeModal" class="subscribe-modal">

    <div class="subscribe-modal-container">

        <!-- 개인 -->
        <div class="subscribe-card">

            <h3 class="subscribe-plan">Standard</h3>
            <h2 class="subscribe-title pink">FREE</h2>

            <p class="subscribe-price">
            무료
            </p>

            <ul class="subscribe-feature">
                <li>광고 노출</li>
                <li>스트리밍 불가</li>
                <li>아티스트 정보 제공</li>
                <li>기본 굿즈 구매</li>
            </ul>

            <form action="${pageContext.request.contextPath}/kakaopay/ready" method="post">

                <input type="hidden" name="paymentType" value="SUBSCRIBE">
                <input type="hidden" name="itemName" value="PERSONAL">
                <input type="hidden" name="quantity" value="1">
                <input type="hidden" name="totalPrice" value="0">

                <button type="button" class="subscribe-btn pink" onclick="closeSubscribeModal()">
				    현재 플랜 유지
				</button>

            </form>

        </div>


        <!-- 베이직 -->
        <div class="subscribe-card">

            <h3 class="subscribe-plan">Premium</h3>
            <h2 class="subscribe-title green">PRO</h2>

            <p class="subscribe-price">
                매월 ₩7,900
            </p>

            <ul class="subscribe-feature">
                <li>무제한 스트리밍</li>
                <li>AI 음악 추천</li>
                <li>808 플레이리스트</li>
                <li>고음질 스트리밍</li>
                <li>독점 콘텐츠</li>
            </ul>

            <form action="${pageContext.request.contextPath}/kakaopay/ready" method="post">

                <input type="hidden" name="paymentType" value="SUBSCRIBE">
                <input type="hidden" name="itemName" value="pro">
                <input type="hidden" name="quantity" value="1">
                <input type="hidden" name="totalPrice" value="7900">

                <button type="submit" class="subscribe-btn green">
                    PRO로 업그레이드
                </button>

            </form>

        </div>

    </div>

</div>