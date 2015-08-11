# YahooWeather

雅虎天气，OC实现，根据版本1.69，代码比较杂乱，以后有时间会重构。

## API接口

由Yahoo Developer Network提供

## 主界面

-本地随机选取图像，替换主界面背景

-使用runloop，提高背景切换与滑动操作冲突时的流畅度

-上拉可以刷新天气信息

-使用KVO开启结束风扇和太阳升起动画

-使用广播传递不同界面的模型对象

------

## ![main](https://github.com/robbie23/YahooWeather/raw/master/ReadMeImage/main.gif)

## 侧栏界面

-使用控制器层次结构搭建侧栏界面

-延时和隐藏配合动画

------

## ![sub](https://github.com/robbie23/YahooWeather/raw/master/ReadMeImage/sub.gif)

## 查询界面

-发起网络请求

-解析数据

## ![querry](https://github.com/robbie23/YahooWeather/raw/master/ReadMeImage/querry.png)

## 编辑界面

可置换位置、可删除城市

## ![edit](https://github.com/robbie23/YahooWeather/raw/master/ReadMeImage/edit.png)

## 使用的第三方库

[Gdata数据解析](https://github.com/graetzer/GDataXML-HTML)

[ASIHTTPRequest网络请求](http://allseeing-i.com/ASIHTTPRequest)

[下拉刷新](https://github.com/cyndibaby905/GIFRefreshControl)

## 已知问题

CLGeocoder解码有时会出现问题，可能会报网络错误。（原因排除多次调用和网络问题）

## 联系我

github: [robbie23](https://github.com/robbie23)

邮箱：robbieless21@outlook.com