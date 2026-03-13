<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<style>

.subscribe-modal{
    display:none;
    position:fixed;
    inset:0;
    background:rgba(0,0,0,0.75);
    z-index:9999;
    justify-content:center;
    align-items:center;
}

.subscribe-modal-container{
    display:flex;
    gap:30px;
}

/* 카드 기본 */
.subscribe-card{
    width:330px;
    background:#121212;
    color:#fff;
    padding:30px;
    border-radius:14px;
    box-shadow:0 15px 40px rgba(0,0,0,0.4);
    transition:all .2s ease;
}

.subscribe-card:hover{
    transform:scale(1.05);
}

/* 텍스트 */

.subscribe-plan{
    font-size:16px;
    margin-bottom:5px;
    color:#ffcf40;
}

.subscribe-title{
    font-size:30px;
    font-weight:700;
    margin-bottom:10px;
}

/* 개인 색 */

.subscribe-title.pink{
    color:#ffc9c9;
}

/* 베이직 색 */

.subscribe-title.green{
    color:#b4f05a;
}

.subscribe-price{
    margin-bottom:18px;
    font-size:15px;
}

.subscribe-feature{
    margin:20px 0;
    padding-left:18px;
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
    background:#ffc9c9;
    color:#000;
}

.subscribe-btn.green{
    background:#b4f05a;
    color:#000;
}

.subscribe-btn:hover{
    opacity:0.9;
}

</style>


<div id="subscribeModal" class="subscribe-modal">

    <div class="subscribe-modal-container">

        <!-- 개인 -->
        <div class="subscribe-card">

            <h3 class="subscribe-plan">Premium</h3>
            <h2 class="subscribe-title pink">개인</h2>

            <p class="subscribe-price">
                ₩0
            </p>

            <ul class="subscribe-feature">
                <li>Premium 계정 1개</li>
                <li>스프리밍 불가</li>
                <li>무손실 음질</li>
                <li>언제든 해지 가능</li>
            </ul>

            <form action="${pageContext.request.contextPath}/kakaopay/ready" method="post">

                <input type="hidden" name="paymentType" value="SUBSCRIBE">
                <input type="hidden" name="itemName" value="PERSONAL">
                <input type="hidden" name="quantity" value="1">
                <input type="hidden" name="totalPrice" value="0">

                <button type="button" class="subscribe-btn pink" onclick="closeSubscribeModal()">
				    ₩0의 요금 이용해보기
				</button>

            </form>

        </div>


        <!-- 베이직 -->
        <div class="subscribe-card">

            <h3 class="subscribe-plan">Premium</h3>
            <h2 class="subscribe-title green">프로</h2>

            <p class="subscribe-price">
                매월 ₩7,900
            </p>

            <ul class="subscribe-feature">
                <li>Premium 계정 1개</li>
                <li>스트리밍 가능</li>
                <li>뛰어난 음질</li>
                <li>언제든 해지 가능</li>
            </ul>

            <form action="${pageContext.request.contextPath}/kakaopay/ready" method="post">

                <input type="hidden" name="paymentType" value="SUBSCRIBE">
                <input type="hidden" name="itemName" value="pro">
                <input type="hidden" name="quantity" value="1">
                <input type="hidden" name="totalPrice" value="7900">

                <button type="submit" class="subscribe-btn green">
                    Premium 베이직 시작하기
                </button>

            </form>

        </div>

    </div>

</div>