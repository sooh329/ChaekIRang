<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.io.*" %>
<%@ page import="java.util.List" %>
<%@ page import="discussion.DiscussInfo" %>
<%@ page import="com.google.gson.Gson" %>
<%@ page import="userinfo.UserDAO" %>
<%@ page import="java.util.Base64" %>
<!DOCTYPE html>
<html>
<head>
 	<meta charset="UTF-8" />
 	<link rel="stylesheet" href="../css/discussChatPage.css" />
 	<link rel="stylesheet" href="../css/default.css"/>
    <title>책이랑-토론</title>
</head>
<body>
  <div class="div-wrapper">
    <div class="div">
	  <%@include file="../modules/header.jsp" %>
	  <%
String nickName = "";
if (idSession != null) {
    UserDAO userDAO = new UserDAO();
    nickName = userDAO.getNickNameById(idSession);
}
%>
	  
	  <%
    String profile;
	String discId = request.getParameter("disc_id");
    
    if (idSession != null) {
        UserDAO userDAO = new UserDAO();
        byte[] profileImgData = userDAO.loadProfileImg(idSession);
        
        if (profileImgData != null) {
            // Base64 인코딩을 사용하여 이미지 데이터를 문자열로 변환
            profile = "data:image/jpeg;base64," + Base64.getEncoder().encodeToString(profileImgData);
        } else {
            profile = "../img/profile/profilepic.jpg"; // 기본 프로필 이미지
        }
    } else {
        profile = "../img/profile/profilepic.jpg"; // 세션이 없는 경우 기본 프로필 이미지 사용
    }
    
%>
	  <div class="discusschat-page">
	  
	  	  <!-- 책 및 토론 정보 -->
	  	  <div class="info">
		      <div class="book-info">
		      	  <img class="book-cover" src="" alt="bookcover"/>
		      	  <div class="book-detail">
		      		  <p class="book-title">네메시스</p>
		      		  <p class="book-author">필립 로스(Philip Roth)</p>
		      	  </div>
		      </div>
		      <div class="line"></div>
		      <div class="discuss-info">
		      	  <p class="discuss-title">운명과 인간의 선택: 네메시스의 메타포</p>
		      	  <pre class="discuss-detail">
"네메시스"는 인간의 운명과 선택에 대한 깊은 질문을 던지는 소설입니다. 

이번 독서 토론에서는 이야기 속에서 네메시스가 어떻게 등장하며, 인물들이 직면하는 고난과 그들이 내리는 선택이 어떻게 연관되는지 탐구합니다. 

'네메시스'가 운명으로서 나타나는 순간들과 그에 대한 인물들의 
대응이 우리 현실과 어떻게 닮았는지, 그리고 이들이 던지는 철학적 질문이 우리에게 어떤 의미를 가지는지 함께 논의해봅니다.

'네메시스'가 운명으로서 나타나는 순간들과 그에 대한 인물들의 
대응이 우리 현실과 어떻게 닮았는지, 그리고 이들이 던지는 철학적 질문이 우리에게 어떤 의미를 가지는지 함께 논의해봅니다.

'네메시스'가 운명으로서 나타나는 순간들과 그에 대한 인물들의 
대응이 우리 현실과 어떻게 닮았는지, 그리고 이들이 던지는 철학적 질문이 우리에게 어떤 의미를 가지는지 함께 논의해봅니다.
				  </pre>
			  </div>
	      </div>
	      
	      <!-- 채팅블록 -->
	      <div class="chat-room">
	      	<div id="chatWindow">
	      	<!-- 여기에 채팅 -->
	      	</div>
	      	
	      	<form id="chatForm">
		        <textarea id="message" placeholder="메시지를 입력하세요"></textarea>
		        <div class="chat-buttons">
		        	<button id="scrollToTop" type="button">맨 위로</button>
		        	<button class="chat-submitbtn" type="submit">전송</button>
		        </div>
		    </form>
		    
	      </div>
      </div>
      
	  <%@ include file="../modules/footer.jsp" %>
	</div>
  </div>
  
  <script>
  	document.getElementById("scrollToTop").addEventListener("click", () => {
	    const chatWindow = document.getElementById("chatWindow");
	    chatWindow.scrollTop = 0; // 채팅창 맨 위로 감 채팅 처음부터 읽기용
	});

  	const nickName = "<%= nickName %>";
    const discId = "<%= discId %>";  
    const idKey = "<%= idSession %>";  
	const profileImg = "<%=profile%>";
    console.log("토론아이디체크: ", discId);  // 디버깅용
    // WebSocket 연결 설정
    const ws = new WebSocket('ws://localhost:8082/Chaek/chat/' + discId);

ws.onopen = function() {
    console.log('WebSocket 연결이 성공적으로 열렸습니다.');
};

ws.onerror = function(error) {
    console.log('WebSocket 오류: ', error);
};

ws.onclose = function() {
    console.log('WebSocket 연결이 종료되었습니다.');
};
	
    // 메시지 수신 시 처리
ws.onMessage = function(event) {
    console.log("수신된 데이터: ", event.data); // 디버깅용
    const data = JSON.parse(event.data);
    console.log("파싱된 데이터: ", data); // 디버깅용

    const profileImg = data.profileImg;
    const sender = data.sender;
    const message = data.message;
    console.log("img :"+profileImg+"sender :"+sender+"\n"+"message :"+message+"\n");

    const chatMessage = document.createElement("div");
    chatMessage.className = "chat-message";
    const chatUserInfo = document.createElement("div");
    chatUserInfo.className = "chat-userInfo";

    const img = document.createElement("img");
    img.src = "<%=profile%>";
    img.alt = "profileImg";
    img.className = "profile-img";
    sendUser.className = "chat-user";
    sendUser.textContent = sender;  // sendUser를 sender로 대체, 필요 없는 경우 삭제 가능

    const now = new Date();
    const year = now.getFullYear();
    const month = (now.getMonth() + 1).toString().padStart(2, '0');
    const date = now.getDate().toString().padStart(2, '0');
    const hours = now.getHours().toString().padStart(2, '0');
    const minutes = now.getMinutes().toString().padStart(2, '0');
    const seconds = now.getSeconds().toString().padStart(2, '0');

    const sendTime = document.createElement("p");
    sendTime.className = "chat-time";
    sendTime.textContent = year + ":" + month + ":" + date + " " + hours + ":" + minutes + ":" + seconds;

    const text = document.createElement("pre");
    text.className = "chat-text";
    text.innerHTML = message.replace(/\n/g, "<br>");
    text.textContent = message;

    chatUserInfo.appendChild(img);
    chatUserInfo.appendChild(sendUser);  // sendUser를 채팅 정보로 남기고 싶다면 추가, 필요 없으면 삭제
    chatUserInfo.appendChild(sendTime);
    chatMessage.appendChild(chatUserInfo);
    chatMessage.appendChild(text);
    document.getElementById("chatWindow").appendChild(chatMessage);

    chatWindow.scrollTop = chatWindow.scrollHeight;
};


    document.getElementById("message").addEventListener("keydown", (event) => {
        const messageInput = event.target;
        
        // Shift + Enter로 줄바꿈
        if (event.key === "Enter" && event.shiftKey) {
            return;
        }

        // Enter로 메시지 전송
        if (event.key === "Enter" && !event.shiftKey) {
            event.preventDefault();
            document.getElementById("chatForm").dispatchEvent(new Event("submit")); // Form submit 이벤트 호출
        }

    });

    document.getElementById("chatForm").onsubmit = (e) => {
        e.preventDefault();
        const messageInput = document.getElementById("message");
        const idKey = "<%= idSession %>"; 
        const profileImg = "<%= profile %>";

        ws.send(JSON.stringify({
            id: idKey,
            message: messageInput.value,
            profileImg: profileImg,
            nickName: nickName
        }));
        messageInput.value = ""; // 입력창 초기화
    };

   </script>
</body>
</html>