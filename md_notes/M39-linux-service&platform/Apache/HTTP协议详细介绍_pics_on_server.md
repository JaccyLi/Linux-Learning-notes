<center><font face="黑体" color="grey" size="5">HTTP协议详细介绍</font></center>

# 1. 一.概述

HTTP(HyperText Transfer Protocol)：超文本传输协议，是一种允许通讯双方的一端获取资源
(如 HTML 文档)的协议。它是互联网上任何数据交换的基础，属于 C/S(客户端/服务器)协议，
这意味着请求是由接收方(通常是 Web 浏览器)发起的。一般 web浏览器会请求多种资源(子文
档)，从获取的不同子文档(例如文本、布局描述、图像、视频、脚本等)重建完整的文档并由
客户端(web 浏览器)显示出来。设计HTTP最初的目的是为了提供一种远距离共享知识的方式，
借助多文档进行关联实现超文本，连成相互参阅的WWW(world wide web,万维网)
![](http://suosuoli.cn/wp-content/uploads/2019/12/Fetching_a_page.png)

<center><font face="黑体" color="grey" size="2">上图展示了客户端请求资源的过程</font></center>

客户端和服务器通过交换相互独立的消息来通讯(而不是数据流)。客户端(通常是 web 浏览器)发送的消
息叫**请求**(_requests_)，而服务器发送的消息作为客户端消息的回应被称为**响应**(_response_)

![](http://suosuoli.cn/wp-content/uploads/2019/12/HTTP_layers.png)
<center><font face="黑体" color="grey" size="2">上图展示了HTTP协议在整个web架构的位置</font></center>

HTTP 在 1989 年就已经被在[CERN](https://en.wikipedia.org/wiki/CE)的[Tim Berners-Lee](https://en.wikipedia.org/wiki/Tim_Berners-Lee)所设计出来，到目前已经经历了 HTTP/0.9，
HTTP/1.0，HTTP/1.1 等版本的更迭，目前互联网广泛使用的是 HTTP/1.1 版本。HTTP 为应用层协议，
其数据通过 TCP 协议传输，并且可以结合 TLS 使用 TLS/SSL 加密的 TCP 传输。由于其丰富的扩展性，
其不仅仅用来传输超文本文档，还用于传递图形，视频等多媒体文件，还可以上传文件到服务器。HTTP
亦可以做到只传输部分文档来更新网页的部分内容。

# 2. 二.基于 HTTP 协议的系统组成

HTTP是个用于客户端/服务器架构的协议，请求一般由用户代理(_user-agent_)发出。大多数情况下用户代理
是一个网页浏览器，但也可以是其它的客户端，如linux下的[link](https://www.tecmint.com/command-line-web-browser-download-file-in-linux/),[curl](https://curl.haxx.se/docs/manpage.html)等工具。客户端发送的每个请求都会被
服务器接收并处理，处理完成后给出响应。在实际的互联网环境中，客户端和服务器之间往往会存在多台
其它类型的服务器，他们都被称为**代理**(_proxy_)，各自承担不同的服务角色，如作为网关、图片服务器或者
视频服务器或者缓存服务器。如下图
![](http://suosuoli.cn/wp-content/uploads/2019/12/Client-server-chain.png)
<center><font face="黑体" color="grey" size="2">上图展示了使用HTTP协议的客户端-服务器链</font></center>

实际上，在浏览器和处理请求的服务器之间有更多的计算机、路由器、调制解调器等等。由于Web的分层
设计，这些中间的设备在网络和传输层中是透明的。HTTP位于应用层的顶部。虽然诊断网络问题很重要
，但是底层的传输机制与HTTP的协议描述基本不相关。

## 2.1. 客户端:user-agent

用户代理可以是代表互联网用户的任何工具。一般此角色主要指Web浏览器执行。其他的用户代理也可能
是工程师和Web开发人员用来调试其应用程序的工具程序。

浏览器始终是发起请求的实体。一般不是服务器(尽管在http的发展过程中，也添加了一些机制来模拟
服务器发起的消息，但这种应用场景极少)。

要显示一个Web页面，浏览器发送一个原始请求来获取描述页面的HTML文档。获取到html源码后，其会
解析这个文件，并发出与执行脚本的结果、要显示的布局信息(CSS)和页面中包含的子资源(通常是图像
和视频)相对应的附加请求。然后，Web浏览器组合这些资源，向用户显示一个完整的文档，即Web页面。
由浏览器执行的脚本可以在接下来的阶段获取额外的资源，浏览器相应地更新部分Web页面。

一个网页就是一个超文本文档。这意味着显示的文本的某些部分是可以被激活的链接(通常通过单击
鼠标)，以获取新的Web页面，允许用户重定向其用户代理并在Web中导航。浏览器在HTTP请求中转换
这些方向，并进一步解释HTTP响应以向用户提供明确的响应。

## 2.2. Web服务器

与浏览器相对，通讯通道的另一端是web服务器，其提供客户端请求的文档。实际上服务器也只是一台
结构和客户端电脑相同的电脑，只不过其经过特殊设计和使用专业的硬件更适合做服务器。服务器也
可能是一群计算机的集合，请求被某个反向代理服务器分配到其中某台服务器中并被处理，而客户端
并不要求是哪台计算机处理请求，只要返回其请求的资源即可。

服务器也可能是某个运行在容器中的服务应用实例。在虚拟化容器中，可以在某台服务器部署虚拟化
容器，在容器中运行多个服务实例。客户端对此并不知情。

## 2.3. 代理

实际互联网环境中，在web浏览器和服务器之间，还有很多台电脑作为HTTP消息的中继服务器。由于
web技术栈的分层结构，在消息的传递过程中，大多数的处于传输层、网络层或物理层的操作在HTTP
层是不可见的，而这些操作可能会影响HTTP工作的效率。这些操作在应用层的角度称其为**代理**
。这些代理服务器进行的操作可以是透明的，即代理原封不动的转发请求；这些操作也可以是非透明的，
此时代理服务器会在转发请求之前更改请求的某些信息。

代理服务器有多种功能：
: 缓存`caching`(缓存可以公开或者私有，如浏览器缓存)
: 过滤`filtering`(如病毒扫描或家长控制)
: 负载均衡`load balancing`(允许多个服务器处理不同的请求)
: 身份认证(控制对不同的资源访问)
: 记录登录信息(允许存储历史信息`cookie`)

# 3. 三.HTTP 基本概念

## 3.1. HTTP以简单为设计原则

HTTP是简单的和人类可读的，HTTP消息可以被人类读取和理解，这为开发人员提供了更加简单的测试，
并降低了新手的入门门槛。

## 3.2. HTTP是可扩展的

HTTP/1.0版协议中引入了HTTP头`HTTP headers`的概念，这使得该协议易于扩展和进行实验性开放。可以
通过新引入的http头来添加新功能。

## 3.3. HTTP是无状态的但不是无会话的

HTTP是无状态的：在同一连接上连续执行的两个请求之间没有关联。这对于试图连贯地与某些页面交互
的用户(例如，使用购物网站的购物车)来说，马上就会出现问题。虽然HTTP本身的核心是无状态的，
但HTTP cookie允许使用有状态的会话。使用头可扩展性，将HTTP cookie添加到工作流中，并允许在
每个HTTP请求上创建会话来共享相同的上下文或相同的状态。这样即使网页被刷新，购物车的信息也
不会丢失。

## 3.4. HTTP和连接

HTTP的连接是在传输层控制和处理的，因此基本上超出了HTTP的作用范围。尽管HTTP并不要求底层
传输协议是基于连接的，而只要求它是可靠的，或者不丢失消息(所以至少显示一个错误)。在互联网
上最常见的两种传输层协议中，TCP是基于连接的可靠的协议，而UDP不是。因此，HTTP依赖于基于
连接的TCP标准协议。

在客户端和服务器可以交换HTTP请求/响应对之前，它们必须建立一个TCP连接，这是一个需要多次
往返的过程。HTTP/1.0版本的默认行为是为每个HTTP请求/响应对打开单独的TCP连接。当多个请求
连续发送时，其会多次打开和关闭TCP连接，这比共享单个TCP连接的效率要低。

为了缓和这个缺陷，HTTP/1.1版本引入了管道*pipelining*(被证明很难实现)和持久连接
*persistent connections*:实现了使用连接的头控制底层的TCP连接。HTTP/2更进一步，在单个连接
上多路复用消息，保持连接活跃和高效。

为了开发更加高效的传输层协议来配合HTTP协议，某些实验性的工作已经在进行中。如googe正在
实验使用[QUIC](https://en.wikipedia.org/wiki/QUIC)协议和UDP协议绑定来形成一个更加可靠和高效的协议。

# 4. 四.HTTP 协议可以控制什么？


随着时间的推移，HTTP的可扩展特性允许Web具有更多的控制和功能。缓存或身份验证功能是在HTTP
历史早期就实现的功能。相比之下，放宽同源限制策略[Relaxing the same-origin policy](https://en.wikipedia.org/wiki/Same-origin_policy#Relaxing_the_same-origin_policy)的能力则是在2010
年左右才增加的。
> [同源限制策略](https://en.wikipedia.org/wiki/Same-origin_policy#Relaxing_the_same-origin_policy)

下面是HTTP协议可以控制的特性：
: - Caching
如何缓存文档可以由HTTP控制。服务器可以指明代理服务器和客户端缓存什么以及缓存
多长时间。客户端可以指明中间缓存代理需要忽略存储的文档。
: - 放宽同源限制策略*Relaxing the same-origin policy*
为了防止出现窥探和其他隐私侵犯，Web浏览器会在各个Web站点之间实施严格的隔离
机制。只有来自同一来源的页面才能访问Web页面的所有信息。尽管这种约束对服务器
来说是一种负担，但使用HTTP头信息可以放松服务器端的这种严格分离，允许文档成为
来自不同域的子文档的信息的拼凑。
: - 认证*Authentication*
某些web页面可能受到保护，因此只有特定的用户才能访问它们。HTTP可以提供基本的
身份验证功能，可以使用[WWW-Authenticate](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/WWW-Authenticate)和类似的头文件，也可以使用HTTP cookie
设置特定的会话来实现该功能。

: - 代理和隧道[*Proxy and tunneling*](https://developer.mozilla.org/en-US/docs/Web/HTTP/Proxy_servers_and_tunneling)
服务器或客户端通常位于公司内部网络，并向其他计算机隐藏它们的真实IP地址。HTTP
请求一般会选择通过代理来跨越公司内部网络和外部互联网的网络障碍。并不是所有的
代理都是HTTP代理，例如，SOCKS协议属于较低级别的协议，http代理无法处理。但是
如ftp等应用层协议就可以由这些代理来处理。
: - 会话*Sessions*
使用HTTP cookie允许客户端将请求与服务器的状态链接起来，可以将携带cookie的
请求头部信息发送该服务器，也可以从服务器得到之前的cookie信息。这样就创建了
会话，尽管HTTP是一个无状态协议。这不仅对购物网站的购物车场景有用，而且对
任何允许用户配置和动态交互的站点都有用。

# 5. 五.HTTP 通讯过程

当某个客户端和服务器通讯时，不管通讯目标是最终提供服务的服务器还是中间的代理服务器，通讯过程
都会经过以下步骤：

1. 打开一个TCP连接:TCP连接用于发送一个或多个请求，并接收一个应答。客户机可以打开新的连接、
重用现有的连接或一次性打开到服务器的多个个TCP连接。
2. 发送HTTP消息(请求):HTTP消息(在HTTP/2版本之前)是人类可读的。在HTTP/2中，这些简单的消息
被封装在帧中，因此不可能直接读取它们，但原理是一样的。例如:
  ```ruby
  GET / HTTP/1.1
  Host: wordpress.suosuoli.cn
  Accept-Language: cn
  ```

3. 读取服务器返回的响应信息，包括响应头和响应体如：

  ```ruby
  HTTP/1.1 200 OK
  Date: Sat, 09 Aug 2019 12:28:02 CST
  Server: Apache
  Last-Modified: Tue, 01 Oct 2019 23:18:22 CST
  ETag: "5h149bc1-7849-47bb0n5r2891b"
  Accept-Ranges: bytes
  Content-Length: 43338
  Content-Type: text/html
  
  <!DOCTYPE html... (here comes the 43338 bytes of the requested web page)
  ```

4. 关闭该连接或者为了后面处理请求重用该连接

上面这四步为一次完整的访问过程，称为一次HTTP事务。下面图示了一次HTTP事务的执行过程。

![](http://suosuoli.cn/wp-content/uploads/2019/12/HTTP_Steps.png)
如果使用HTTP管道机制，可以在一个TCP连接连续发送多个请求，而不必等待第一个响应被完全接收。
事实证明，HTTP管道很难在现有网络中实现，因为某些地方老版本的软件与较新的版本共存。HTTP/2
中的HTTP管道已经被更健壮的多路复用请求技术所取代。

# 6. 六.HTTP 消息(请求和响应报文)

HTTP消息在HTTP/1.1版以前实现，是人类可读的格式。在HTTP/2中，消息被嵌入到一个二进制结构中，
称为帧，其允许头部压缩和多路复用等优化技术。在HTTP/2中的消息只有部分从服务器传给了客户端，
但是每个消息的语义相对于HTTP/1.1版本并没有改变，客户端收到消息后按HTTP/1.1的语义重组。
所以理解HTTP/1.1的格式对于理解HTTP/2的消息格式是很有帮助的。

HTTP协议有两种消息，**请求**和**响应**，各自有各自的格式约定。

## 6.1. 请求报文

一个HTTP请求报文例子：
![](http://suosuoli.cn/wp-content/uploads/2019/12/2019-12-18-15-03-33.png)

请求消息包含以下元素：
: - 首先是**HTTP方法**，通常是个动词，如:`GET`,`POST`或是名词如`OPTIONS`,`HEAD`用来定义客户
端想要发出的动作。一般，客户端使用`GET`方法来从服务器获取资源，使用`POST`方法来
提交HTML表单的值个服务器，其它操作可能需要使用特定的方法。
: - 接着是需要获取的**资源的连接**，该连接一般不包括协议名(http://)或者域名(wordpress.suosuoli.cn)
或TCP端口(80)。
: - HTTP协议的版本
: - 可选的头部信息，用于向服务器发送附加的信息
: - 也可能带有资源体，一般是涉及到`POST`方法时向服务器发送资源时会有

## 6.2. 响应报文

一个HTTP响应报文的例子：
![](http://suosuoli.cn/wp-content/uploads/2019/12/2019-12-18-15-25-43.png)

响应报文包括以下元素：
: HTTP协议版本
: 一个[状态码](https://developer.mozilla.org/en-US/docs/Web/HTTP/Status)，指明该响应对应的请求成功与否，或则指明为什么失败。
: 一句状态码消息，对该状态码的非权威的描述
: HTTP响应头部
: 可选的响应体，包含返回给客户端的资源


# 7. 七.基于 HTTP 的 API

基于HTTP的最常用API是[XMLHttpRequest API](https://developer.mozilla.org/en-US/docs/Web/API/XMLHttpRequest)，它可用于在用户代理和服务器之间交换数据。后出现的
[Fetch API](https://developer.mozilla.org/en-US/docs/Web/API/Fetch_API)提供了同样的功能，并且提供了更强大、更灵活的功能集。

# 8. 八.小结

HTTP是一种易于使用的并可扩展的应用层协议。典型的C/S(客户端-服务器)结构，简单地添加头信息的
功能，允许HTTP与Web的扩展功能一起发展。

虽然HTTP/2增加了一些复杂性，但是通过在帧中嵌入HTTP消息来提高性能，消息的基本结构自HTTP/1.0
以来一直保持不变。会话流保持简单，允许使用简单的HTTP消息监视器对其进行监控和调试。

- HTTP/0.9 HTTP/1.0 HTTP/1.1三个协议版本对比

| HTTP/0.9 | HTTP/1.0 | HTTP/1.1 |
| :------- | :------- | :------- |

- HTTP请求方法，表明客户端希望服务器对资源执行的动作，包括以下:
`GET`： 从服务器获取一个资源
`HEAD`： 只从服务器获取文档的响应首部
`POST`： 向服务器输入数据，通常会再由网关程序继续处理
`PUT`： 将请求的主体部分存储在服务器中，如上传文件
`GET`： 从服务器获取一个资源
`HEAD`： 只从服务器获取文档的响应首部
`POST`： 向服务器输入数据，通常会再由网关程序继续处理
`PUT`： 将请求的主体部分存储在服务器中，如上传文件

- http协议状态码[参考资料](https://developer.mozilla.org/zh-CN/docs/Web/HTTP/Status)
`100-101` 信息提示
`200-206` 成功
`300-307` 重定向
`400-415` 错误类信息，客户端错误
`500-505` 错误类信息，服务器端错误

- 常见HTTP状态码
`200`: OK 成功，请求数据通过响应报文的entity-body部分发送 
`301`: Moved Permanently 请求的URL指向的资源已经被删除；但在响应报文中通过首部Location指明了资源现在所处的新位置； 
`302`: Moved Temporarily 响应报文Location指明资源临时新位置  
`304`: Not Modified 客户端发出了条件式请求，但服务器上的资源未曾发生改变，则通过响应此响应状态码通知客户端；
`401`: Unauthorized  需要输入账号和密码认证方能访问资源；：
`403`: Forbidden 请求被禁止； 
`404`: Not Found服务器无法找到客户端请求的资源； 
`500`: Internal Server Error  服务器内部错误；
`502`: Bad Gateway 代理服务器从后端服务器收到了一条伪响应，如无法连接到网关； 
`503`: 服务不可用，临时服务器维护或过载，服务器无法处理请求 
`504`: 网关超时

- 首部的分类:
1. 通用首部:请求报文和响应报文两方都会使用的首部
2. 请求首部:从客户端向服务器端发送请求报文时使用的首部。补充了请求的附加内容、客户端信
息、请求内容相关优先级等信息
3. 响应首部：从服务器端向客户端返回响应报文时使用的首部。补充了响应的附加内容，也会要求客
户端附加额外的内容信息
4. 实体首部：针对请求报文和响应报文的实体部分使用的首部。补充了资源内容更新时间等与实体有
关的的信息
5. 扩展首部

- linux下常用的web工具

`links`
`wget`
`curl`

`httpie`[官方网站](https://httpie.org)
centos7的epel源安装htpie`yum install httpie -y`
使用：`$ http suosuoli.cn`
获取帮助:`$ http --help`
例：

```ruby
root@ubuntu1904:~#http -h suosuoli.cn
HTTP/1.1 200 OK
Connection: keep-alive
Content-Encoding: gzip
Content-Type: text/html; charset=UTF-8
Date: Wed, 18 Dec 2019 08:08:05 GMT
Server: nginx
Transfer-Encoding: chunked
Vary: Accept-Encoding
X-Powered-By: PHP/5.6.40
```

----
Refs:

1.[An overview of HTTP](https://developer.mozilla.org/en-US/docs/Web/HTTP/Overview#APIs_based_on_HTTP)
2.[Brief-intro-of-Internet](https://www.internetsociety.org/internet/history-internet/brief-history-internet/?gclid=Cj0KCQiA_rfvBRCPARIsANlV66MAmXyyAvvFVohe1b9LEtDxxUu3gHAS2kf_I803sAMkGYqf311zpHcaAvuOEALw_wcB)
3.[Evolution of HTTP(HTTP/0.9, HTTP/1.0, HTTP/1.1, Keep-Alive, Upgrade, and HTTPS)---
Thilina Ashen Gamage](https://medium.com/platform-engineer/evolution-of-http-69cfe6531ba0)