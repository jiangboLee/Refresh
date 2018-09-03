# JRefresh
### 介绍
这是MJRefresh的swift版本，先OC原版奉上[MJRefresh](https://github.com/CoderMJLee/MJRefresh),JRefresh为纯Swift版本，支持swift3.2以上，iOS8.0以上版本。代码逻辑和MJRefresh基本一模一样，本来一开始打算用swift的面向协议思想改写的，发现行不通只好用原作者一模一样的继承思想翻译成Swift。JRefresh剔除了原有的过期方法，也没有Selector调用方法（不想再混入OC文件，swift不支持objc_msgSend）,只剩下闭包调用。
### 为何写这个
- 由于项目使用swift语言开发原来越多。但OC和swift混编要桥接文件，编译慢，无法达到纯正的swift第三方效果。(个人洁癖哈，使用pod还好，假如拖入项目的那一大堆.h.m文件实在难受)。可以让只会swift语言的孩子查看源代码哈（虽然这样的孩子不多~）
- 项目中一直在用MJRefresh,但没有翻译一遍来的理解透彻。
- 自己学习提高咯。后期可以丰富更多个性化功能~
### 使用方法
支持swift3.2 以上， iOS版本8.0以上
- 使用cocoapods

```pod 'JRefresh'```

- 下载demo，直接将`JRefresh`文件夹拖到项目中使用
### 具体方法
![总架构.png](https://upload-images.jianshu.io/upload_images/2868618-13729e531f2e93dc.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

没错，比MJRefresh少了`backFooter`,主要是一直没有用到过（一次都没啊~），所以暂时给取消了，假如反应的人多，下个版本就给加上

![文件目录.png](https://upload-images.jianshu.io/upload_images/2868618-d18ed2fa367f683f.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

这些反正和MJRefresh一模一样（就是照着他翻译过来的哈）
### 效果展示
- 默认下拉(只有刷新时间、状态)
```
tableView.header = JRefreshStateHeader.headerWithRefreshingBlock({[weak self] in
                guard let `self` = self else {return}
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 3, execute: {
                    self.count += 2
                    self.tableView.reloadData()
                    self.tableView.header?.endRefreshing()
                })
            })
tableView.header?.beginRefreshing()
```
![默认下拉(只有刷新时间、状态).gif](https://upload-images.jianshu.io/upload_images/2868618-38e5ac90e71167a1.gif?imageMogr2/auto-orient/strip)
- 默认下拉带⭕️动画
```
tableView.header = JRefreshNormalHeader.headerWithRefreshingBlock({[weak self] in
                    guard let `self` = self else {return}
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 3, execute: {
                        self.count += 2
                        self.tableView.reloadData()
                        self.tableView.header?.endRefreshing()
                    })
                })
                (tableView.header as? JRefreshNormalHeader)?.arrowViewNeedCircle = true
                tableView.header?.beginRefreshing()
```
![1.gif](https://upload-images.jianshu.io/upload_images/2868618-aa9aae69085db642.gif?imageMogr2/auto-orient/strip)
- 下拉带菊花、箭头
```
tableView.header = JRefreshNormalHeader.headerWithRefreshingBlock({[weak self] in
                guard let `self` = self else {return}
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 3, execute: {
                    self.count += 2
                    self.tableView.reloadData()
                    self.tableView.header?.endRefreshing()
                })
            })
tableView.header?.beginRefreshing()
```
![下拉带菊花、箭头.gif](https://upload-images.jianshu.io/upload_images/2868618-a2c40551db816066.gif?imageMogr2/auto-orient/strip)
- GIF 刷新
```
tableView.header = JChiBaoZiHeader.headerWithRefreshingBlock({[weak self] in
                guard let `self` = self else {return}
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 3, execute: {
                    self.count += 2
                    self.tableView.reloadData()
                    self.tableView.header?.endRefreshing()
                })
            })
tableView.header?.beginRefreshing()
```
![GIF 刷新.gif](https://upload-images.jianshu.io/upload_images/2868618-c32a0c89b27761e2.gif?imageMogr2/auto-orient/strip)
- 下拉刷新 自定义文字
```
let header = JRefreshNormalHeader.headerWithRefreshingBlock({[weak self] in
                guard let `self` = self else {return}
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 3, execute: {
                    self.count += 2
                    self.tableView.reloadData()
                    self.tableView.header?.endRefreshing()
                })
            })
            // 设置文字
            (header as! JRefreshNormalHeader).setTitle("lee", .Idle)
            (header as! JRefreshNormalHeader).setTitle("jiang", .Pulling)
            (header as! JRefreshNormalHeader).setTitle("bo", .Refreshing)
            // 设置字体
            (header as! JRefreshNormalHeader).stateLabel.font = UIFont.systemFont(ofSize: 16)
            (header as! JRefreshNormalHeader).lastUpdatedTimeLabel.font = UIFont.systemFont(ofSize: 14)
            // 设置颜色
            (header as! JRefreshNormalHeader).stateLabel.textColor = UIColor.red
            (header as! JRefreshNormalHeader).lastUpdatedTimeLabel.textColor = UIColor.blue
            header.beginRefreshing()
            tableView.header = header
```
![下拉刷新 自定义文字.gif](https://upload-images.jianshu.io/upload_images/2868618-f5b346e60947af27.gif?imageMogr2/auto-orient/strip)
- 上拉带loading
```
tableView.footer = JRefreshAutoNormalFooter.footerWithRefreshingBlock({[weak self] in
                guard let `self` = self else {return}
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 3, execute: {
                    self.count += 2
                    self.tableView.reloadData()
                    self.tableView.footer?.endRefreshing()
                })
            })
```
![上拉带loading.gif](https://upload-images.jianshu.io/upload_images/2868618-baa2d2b557124922.gif?imageMogr2/auto-orient/strip)
- 上拉Gif(无文字状态)
```
tableView.footer = JChiBaoZiFooter.footerWithRefreshingBlock({[weak self] in
                guard let `self` = self else {return}
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 3, execute: {
                    self.count += 5
                    self.tableView.reloadData()
                    self.tableView.footer?.endRefreshing()
                    if self.count >= 40 {
                        self.tableView.footer?.endRefreshingWithNoMoreData()
                    }
                })
            })
            (tableView.footer as? JRefreshAutoGifFooter)?.refreshingTitleHidden = true
```
![上拉Gif(无文字状态).gif](https://upload-images.jianshu.io/upload_images/2868618-c837a3b14466a440.gif?imageMogr2/auto-orient/strip)
- 自定义上拉视图
```
tableView.footer = JDIYAutoFooter.footerWithRefreshingBlock({[weak self] in
                guard let `self` = self else {return}
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 3, execute: {
                    self.count += 5
                    self.tableView.reloadData()
                    self.tableView.footer?.endRefreshing()
                    if self.count >= 40 {
                        self.tableView.footer?.endRefreshingWithNoMoreData()
                    }
                })
            })
```
![自定义上拉视图.gif](https://upload-images.jianshu.io/upload_images/2868618-7913859ddb1346fb.gif?imageMogr2/auto-orient/strip)
- 更多demo
![更多demo.png](https://upload-images.jianshu.io/upload_images/2868618-b6d340d525505e30.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

### 欢迎使用,有任何bug，希望给我提Issues~


