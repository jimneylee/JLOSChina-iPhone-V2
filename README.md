##JLOSChina-iPhone
开源中国客户端V2版本，参考[新的OpenAPI接口](http://www.oschina.net/openapi)，目前已兼容主要的接口，还有一些需要继续完善，希望感兴趣的童鞋一起参与。


## 开发环境
XCode5 iOS6+

## 下载安装使用，无须越狱

蒲公英下载地址：http://www.pgyer.com/jhrA

二维码扫描

![](http://www.pgyer.com/app/qrcode/54708615384f436c1f25e190d3ddffec)

## 编译安装
1、直接编译即可安装。下载附件[beta测试版本](http://git.oschina.net/jimneylee/JLOSChina-iPhone-V2/attach_files)，直接编译即可安装。

2、手工添加依赖库安装方法，fork后clone到本地

* 1、submodule依赖

``` bash
$ git submodule init
$ git submodule update
```

* 2、[CocoaPods](http://cocoapods.org)更新

``` bash   
$ pod update
```

# ERROR解决方法参考
[JLRubyChina-iPhone](https://github.com/jimneylee/JLRubyChina-iPhone)

####BUG
1、用户页面，由于user标签内嵌user，导致解析出错，已联系@oscfox修改

####TODO

1、我的动弹列表显示，需要后台增加id数据。已联系@oscfox修改

2、我的主页显示

3、发送失败保存草稿箱

####DONE
1、oauth2登录，token过期自动弹出登录界面重新登录

2、综合资讯中最新资讯、最新博客和推荐博客列表显示，及详细html显示

3、社区问答中问答互动、技术分享、灌水综合、职业规划、站务反馈列表显示

4、支持资讯、博客、社区帖子的评论列表查看和~~回复功能~~

5、社区动弹中最新动弹、热门动弹、~我的动弹列表显示~

6、~~发布动弹，支持拍照、@好友、表情选择功能，异步发帖功能~~

7、~~动弹的回复列表查看和回复功能~~

8、~~回复他人的评论~~

## LICENSE
本项目基于MIT协议发布
MIT: [http://rem.mit-license.org](http://rem.mit-license.org)

# Screenshots
![](http://git.oschina.net/jimneylee/JLOSChina-iPhone/raw/master/Resource/Screenshots/0116_1.png)
![](http://git.oschina.net/jimneylee/JLOSChina-iPhone/raw/master/Resource/Screenshots/0116_2.png)
![](http://git.oschina.net/jimneylee/JLOSChina-iPhone/raw/master/Resource/Screenshots/0116_3.png)
![](http://git.oschina.net/jimneylee/JLOSChina-iPhone/raw/master/Resource/Screenshots/0116_4.png)
![](http://git.oschina.net/jimneylee/JLOSChina-iPhone/raw/master/Resource/Screenshots/0116_5.png)
![](http://git.oschina.net/jimneylee/JLOSChina-iPhone/raw/master/Resource/Screenshots/0116_6.png)
![](http://git.oschina.net/jimneylee/JLOSChina-iPhone/raw/master/Resource/Screenshots/0116_7.png)
![](http://git.oschina.net/jimneylee/JLOSChina-iPhone/raw/master/Resource/Screenshots/0116_8.png)
![](http://git.oschina.net/jimneylee/JLOSChina-iPhone/raw/master/Resource/Screenshots/0116_9.png)
