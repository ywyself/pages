# 附录一：session、attribute和cookie的用法

> 说明：
>
>  ```java
> // ServletRequest servletRequest, ServletResponse servletResponse
>  HttpServletRequest request   = (HttpServletRequest)servletRequest;
> HttpServletResponse response = (HttpServletResponse)servletResponse;
>  ```
## `session`用法的说明

### 获取`session`中的数据
```java
Object object = request.getSession().getAttribute("user");
```

### 设置`session`中的数据
> 参数`true`表示：在session不存在的时候，创建一个session。
```java
request.getSession(true).setAttribute("user", new Object());
```
*`session`有一个`setMaxInactiveInterval`方法，使用了设置session的过期时间的，负数表述不过期*

### 移除`session`中的数据
```java
request.getSession().removeAttribute("user");
```

## `arrtibute`用法的说明
> `arrtibute`是用来向页面模板注入值的

### 获取`arrtibute`
```java
Object object = servletRequest.getAttribute("userName");
```

### 注入`arrtibute`
```java
servletRequest.setAttribute("userName", "userName");
```

### 移除`arrtibute`
```java
servletRequest.removeAttribute("userName");
```

## cookie用法的详细说明

### 获取cookie数据

- 获取所有的cookie数据
```java
Cookie[] cookies = request.getCookies();
```
- 基于cookie名获取cookie的值
```java
/**
 * Get cookie object by cookie name.
 */
public Cookie getCookieObject(HttpServletRequest request, String name) {
  Cookie[] cookies = request.getCookies();
  if (cookies != null)
    for (Cookie cookie : cookies)
      if (cookie.getName().equals(name))
        return cookie;
  return null;
}
```

### 设置cookie数据
> 过期时间为 **`-1`** 表示用不过期

```java
Cookie cookie = new Cookie("testCookie", "testCookie");
cookie.setMaxAge(-1);
response.addCookie(cookie);
```

### 移除cookie数据
> 设置过期时间为**0**

```java
Cookie cookie = new Cookie("testCookie", null);
cookie.setMaxAge(0);
response.addCookie(cookie);
```