/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package Utils;

import java.util.List;
import java.util.Set;

import javax.servlet.http.HttpServletRequest;

import Config.SecurityConfig;

public class SecurityUtils {

    // Kiểm tra 'request' này có bắt buộc phải đăng nhập hay không.
    public static boolean isSecurityPage(HttpServletRequest request) {
        String urlPattern = UrlPatternUtils.getUrlPattern(request);
        Set<String> roles = SecurityConfig.getAllAppRoles();
        for (String role : roles) {
            List<String> urlPatterns = SecurityConfig.getUrlPatternsForRole(role);
            if (urlPatterns != null && urlPatterns.contains(urlPattern)) {
                return true;
            }
        }
        return false;
    }

    // Kiểm tra 'request' này có vai trò phù hợp hay không?
    public static boolean hasPermission(HttpServletRequest request, int role_id) {
        String urlPattern = UrlPatternUtils.getUrlPattern(request);
        String role = Integer.toString(role_id);
        List<String> urlPatternsList = SecurityConfig.getUrlPatternsForRole(role);
        if (urlPatternsList != null && urlPatternsList.contains(urlPattern)) {
            return true;
        } else {
            return false;
        }
    }
}
