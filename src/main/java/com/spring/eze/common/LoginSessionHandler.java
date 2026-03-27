package com.spring.eze.common;

import com.spring.eze.user.dto.UserDTO;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Component;

import javax.servlet.http.HttpServletRequest;

@Component
public class LoginSessionHandler {
    private static final Logger log = LoggerFactory.getLogger(LoginSessionHandler.class);

    public static final int SESSION_ERROR = -1;


    /**
     * 로그인이 되어있는지 판정
     * @param request HttpServletRequest 그대로
     * @return 성공시 : userId, 실패시 : SESSION_ERROR
     * */
    public int getUserIdFromSession(HttpServletRequest request){
        UserDTO userDTO = null;
        try{
            userDTO = (UserDTO) request.getSession().getAttribute("loginUser");
        }catch (Exception e){
            log.error(e.toString());
            return SESSION_ERROR;
        }
        if (userDTO == null) {
            return SESSION_ERROR;
        }

        return userDTO.getUserId();
    }


    /**
     * 로그인이 되어있는지 판정
     * @param request HttpServletRequest 그대로
     * @return 성공시 : UserDTO, 실패시 : null
     * */
    public UserDTO getUserDTOFromSession(HttpServletRequest request){
        UserDTO userDTO = null;
        try{
            userDTO = (UserDTO) request.getSession().getAttribute("loginUser");
        }catch (Exception e){
            log.error(e.toString());
            return null;
        }
        return userDTO;     // 있으면 dto, 없으면 null 리턴
    }


}
