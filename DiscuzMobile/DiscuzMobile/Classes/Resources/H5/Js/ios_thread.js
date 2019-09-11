var isLoadReplyOver=false;//是否所有评论已加载完毕
var	is2GOr3GLoadImgs=true;//2/3G网络是否加载图片
var BRIDGE;

$(document).ready(function(){
                  $("div.box03").click(function(){onThreadOptionsClick();});
                  $(".reply_botton_j a").click(function(){loadMore();});
                  $(".thread_details .P_share div a:eq(1)").click(function(){praise();});
                  $(".thread_details .P_share div a:eq(2)").click(function(){discussUser();});
                  $(".thread_details .P_share div a:eq(3)").click(function(){share();});
                  //test();
                  setupWebViewJavascriptBridge(function(bridge){BRIDGE=bridge;BRIDGE.init(function(message,responseCallback){});});
                  });

function setupWebViewJavascriptBridge(callback) {
    if (window.WebViewJavascriptBridge) { return callback(WebViewJavascriptBridge); }
    if (window.WVJBCallbacks) { return window.WVJBCallbacks.push(callback); }
    window.WVJBCallbacks = [callback];
    var WVJBIframe = document.createElement('iframe');
    WVJBIframe.style.display = 'none';
    WVJBIframe.src = 'https://__bridge_loaded__';
    document.documentElement.appendChild(WVJBIframe);
    setTimeout(function() { document.documentElement.removeChild(WVJBIframe) }, 0)
}

//设置帖子详情 (回复列表中的0处)
/*@hidden*/var setThread=function(JSON){

    var typeName;
    if (!textIsNull(JSON.Variables.thread.typeid)) {
        if(!textIsNull(JSON.Variables.forum.threadtypes)) {
            if(!textIsNull(JSON.Variables.forum.threadtypes.types[JSON.Variables.thread.typeid])) {
                typeName = "<a>[" + JSON.Variables.forum.threadtypes.types[JSON.Variables.thread.typeid] + "]</a>";
            }
        }
    }
    
    var verifystatus;
    if(!textIsNull(JSON.Variables.thread.displayorder)) {
        if(JSON.Variables.thread.displayorder == -2) {
            verifystatus = "<span class='threadstatus'>(审核中)</span>"
        }
    }

    $("div.detailTit").html((typeName?typeName:"") + JSON.Variables.thread.subject + (verifystatus?verifystatus:""));
    
    $("div.box02 label:first").html(JSON.Variables.postlist[0].author);
    $("div.box03 label.p_date").html(JSON.Variables.postlist[0].dateline);
    $(".scannedInfo .scannedInfo-l span:eq(0)").html(numberFormat(JSON.Variables.thread.views));
    $(".scannedInfo .scannedInfo-l span:eq(1)").html(JSON.Variables.thread.replies);
    
    var fourmname = JSON.Variables.thread.forumnames;
    if(!textIsNull(fourmname) && fourmname.length > 20) {
        fourmname = fourmname.substring(0,20) + "...";
    }
    
    $(".scannedInfo .sectionName").html(fourmname + ">");
    $(".hostInfo-l .avatar img:first").attr(is2GOr3GLoadImgs?"src":"hidden",is2GOr3GLoadImgs?JSON.Variables.postlist[0].avatar:"hidden");
    $(".hostInfo-l .userName").html(JSON.Variables.postlist[0].author);
    $(".hostInfo .time").html(JSON.Variables.postlist[0].dateline);
    $(".hostInfo-l").click(function(){userInfo(JSON.Variables.thread.authorid)});
    
    
    $(".thread_details .P_share div a:eq(0)").click(function(){complain(null);});
    $(".thread_details .P_share div span:eq(0)").click(function(){complain(null);});
    $(".thread_details .P_share div span:eq(1)").click(function(){praise();});
    $(".thread_details .P_share div span:eq(2)").click(function(){discussUser();});
    $(".thread_details .P_share div span:eq(3)").click(function(){share();});
    $(".thread_details .P_share div span:eq(1)").html(JSON.Variables.thread.recommend_add);
    $(".thread_details .P_share div span:eq(2)").html(JSON.Variables.thread.replies);
    
    if(JSON.Variables.thread.recommend == 1) {
        $(".thread_details .P_share div a:eq(1) img").attr("src","praises.png");
    }
    
    if(!textIsNull(JSON.Variables.postlist)) {
        
        $("div#thread_content img").css({"width":"0px","height":"0px"});
        $("div#thread_content").html(JSON.Variables.postlist[0].message);
        $("div#thread_content img").click(is2GOr3GLoadImgs?function(){threadContentThumbsClick($(this).attr("src"));}:null)
        .attr(is2GOr3GLoadImgs?"src":"hidden",is2GOr3GLoadImgs?$(this).attr("src"):"hidden")
        .css({"width":"auto","height":"auto"})
        .error(function(){$(this).attr('src', "load_error.png");
                                                     });
    }
    
    if(!textIsNull(JSON.Variables.postlist[0].attachlist)){
        $(".thread_details .attachlist img").css({"width":"0px","height":"0px"});
        $(".thread_details .attachlist").removeAttr("hidden");
        var attachlist=JSON.Variables.postlist[0].attachlist;
        for(var i=0;i<attachlist.length;i++){
            if(!textIsNull(attachlist[i].attachurl)){
                $(".thread_details .attachlist ul").append("<li><img aid='"+attachlist[i].aid+"' src='"+attachlist[i].attachurl+"'/></li>");
            }
        }
        $(".thread_details .attachlist img").click(is2GOr3GLoadImgs?function(){threadContentThumbsClick($(this).attr("src"));}:null)
        .attr(is2GOr3GLoadImgs?"src":"hidden",is2GOr3GLoadImgs?$(this).attr("src"):"hidden")
        .css({"width":"auto","height":"auto"})
        .error(function(){$(this).attr('src', "load_error.png");});
    }
    
    getAudio(JSON.Variables.postlist[0]);
    audioAction();
};

/**
 *加载用户评论
 *isAppend true json数据从0开始 false从1开始因为0是用户发表的帖子内容
 */
var onLoadReply=function(threadJSON,isAppend){
    var postlist= threadJSON.Variables.postlist;
    var ul=$("ul.thread_reply");
    
    if(!textIsNull(postlist)){
        for(var i=isAppend?0:1;i<postlist.length;i++){
            var li=ul.find("li:first").clone();
            var postlistitem=postlist[i];
            li.attr("pid",postlistitem.pid).attr("authorid",postlistitem.authorid).attr("id","rednet_anchor_id_"+postlistitem.pid);//设置#锚点
            li.find(".otherPostItem .userAvatar img:first").attr(is2GOr3GLoadImgs?"src":"hidden",is2GOr3GLoadImgs?postlistitem.avatar:"hidden")
            .click(function(){userInfo($(this).parents("li").attr("authorid"));});
            li.find(".otherPostItem .otnerPostDetail").css("width",is2GOr3GLoadImgs?"88%":"98%");
            li.find(".otherPostItem .otnerPostDetail .nickName").html(postlistitem.author)
            .click(function(){userInfo($(this).parents("li").attr("authorid"));});
            
            var j = $("ul li.bor1").size()
            var floor = j + 1 + "楼";
            if (j < threadJSON.Variables.cache_custominfo_postno.length - 1) {
                floor = threadJSON.Variables.cache_custominfo_postno[j + 1];
            }
            li.find(".otherPostItem .otnerPostDetail .floor").html(floor);
            
            li.find(".replyCon img").css({"width":"0px","height":"0px"});
            li.find(".otherPostItem .otnerPostDetail .replyCon").html((postlistitem.message == "" &&textIsNull(postlistitem.attachlist)) ? "无效楼层，该帖已被删除" : postlistitem.message);
            li.find(".replyCon img")
            .attr(is2GOr3GLoadImgs?"src":"hidden",is2GOr3GLoadImgs?$(this).attr("src"):"hidden")
            .click(is2GOr3GLoadImgs?function(){threadThumbsClick($(this).attr("src"));}:null)
            .css({"width":"auto","height":"auto"})
            .error(function(){$(this).attr('src', "load_error.png");});
            li.find(".otherPostItem .otnerPostDetail .time").html(postlistitem.dateline);
            li.find(".otherPostItem .otnerPostDetail .complainIcon").click(function(){complain($(this).parents("li").attr("pid"));});
            li.find(".otherPostItem .dataInfo .plIcon").click(function(){discussUser($(this).parents("li").attr("pid"));});
            li.find(".otherPostItem .otnerPostDetail .complainBtn").click(function(){complain($(this).parents("li").attr("pid"));});
            li.find(".otherPostItem .dataInfo .replyBtn").click(function(){discussUser($(this).parents("li").attr("pid"));});
            
            //附件
            if(!textIsNull(postlistitem.attachlist)){
                li.find(".attachlist img").css({"width":"0px","height":"0px"});
                li.find(".attachlist").removeAttr("hidden");
                var attachlist=postlistitem.attachlist;
                for(var j=0;j<attachlist.length;j++){
                    if(!textIsNull(attachlist[j].attachurl)){
                        li.find(".attachlist ul").append("<li><img aid='"+attachlist[j].aid+"' src='"+attachlist[j].attachurl+"'/></li>");
                    }
                }
                li.find(".attachlist img").attr("src",is2GOr3GLoadImgs?$(this).attr("src"):"load_error.png")
                .click(is2GOr3GLoadImgs?function(){threadThumbsClick($(this).attr("src"));}:null)
                .attr(is2GOr3GLoadImgs?"src":"hidden",is2GOr3GLoadImgs?$(this).attr("src"):"hidden")
                .css({"width":"auto","height":"auto"})
                .error(function(){$(this).attr('src', "load_error.png");});
            }
            li.removeAttr("hidden");
            ul.append(li);
        }
    }
    
    if(!isLoadReplyOver){
        if(ul.find("li").size()>1){
            enableLoadMore(true);
        }else{
            if($("p.reply_botton_j").attr("hidden")!==undefined){
                enableLoadMore(false);
            }
        }
    }
};

/**如果客户端webview on loading不能执行改方法,由android客户端调用(“javascript:onRefresh(JSONString)”)*/
//function onRefresh(JSON,is2GOr3GLoadImgs){
function onRefresh(JSON,joined,is2GOr3GLoadImgs){
    this.is2GOr3GLoadImgs=is2GOr3GLoadImgs;
    this.isLoadReplyOver=false;
    setThread(JSON);
    onLoadReply(JSON,false);
    var postlist=JSON.Variables.postlist;
    if(textIsNull(postlist)||postlist.length<2){
        $("div.p_vote").attr("hidden","hidden");
    }
}

//回调android客户端中 @JavascriptInterface onLoadMore方法
/*@hidden*/function loadMore(){
    if(BRIDGE!==undefined){
        BRIDGE.callHandler("onLoadMore","",null);
    }
}

/**已加载玩所有评论*/
function onLoadOver(){
    isLoadReplyOver=true;
    enableLoadMore(false);
}

/*@hidden*/function enableLoadMore(enable){
    if(enable){
        $("p.reply_botton_j").removeAttr("hidden");
    }else{
        $("p.reply_botton_j").attr("hidden","hidden");
    }
}

/*@hidden*/function threadThumbsClick(url){
    if (url.indexOf("smiley") != -1) {
        return;
    }
    if(BRIDGE!==undefined){
        BRIDGE.callHandler("onThreadThumbsClicked",url,null);
    }
}

function threadContentThumbsClick(url){
    if(BRIDGE!==undefined){
        
        var imgs = document.getElementById("thread_content").getElementsByTagName("img");
        var atts = document.getElementById("attachlist_img").getElementsByTagName("img");
        if (url.indexOf("smiley") != -1) {
            return;
        }
        var images = [];
        for(var i=0;i<imgs.length;i++){
            if (imgs[i].src.indexOf("smiley") == -1) {
                images.push(imgs[i].src);
            }
        }
        for(var i=0;i<atts.length;i++){
            if (atts[i].src.indexOf("smiley") == -1) {
                images.push(atts[i].src);
            }
        }
        var param = {"url":url,"imgs":images};
        BRIDGE.callHandler("onthreadContentThumbsClick",param,null);
    }
}

/**/
function onThreadOptionsClick(){
    if(BRIDGE!==undefined){
        BRIDGE.callHandler("onThreadOptionsClick",null,null);
    }
}

/*@hidden*/function userInfo(authorid){
    if(BRIDGE!==undefined){
        BRIDGE.callHandler("onUserInfo",authorid,null);
    }
}

//回复用户评论
/*@hidden*/function discussUser(pid){
    if(BRIDGE!==undefined){
        BRIDGE.callHandler("onDiscussUser",pid,null);
    }
}

//举报回复
/*@hidden*/function complain(pid){
    if(BRIDGE!==undefined){
        BRIDGE.callHandler("onComplain",pid,null);
    }
}

/**
 *回复用户评论或帖子成功 客户端回调webview.loadUrl("javascript:onDiscussSuccess(JSON,pid);")
 *@param JSON 页面信息包含用户所有评论 如果为空则页面不会自动跳到用户回复的地方
 *@param pid 回复成功后返回的pid 用字符串形式传入
 */
function onDiscussSuccess(JSON,is2GOr3GLoadImgs,pid){
    if (!textIsNull(JSON)){
        //        onRefresh(JSON,is2GOr3GLoadImgs);
        onRefresh(JSON,joined,is2GOr3GLoadImgs)
        if(!textIsNull(pid)){
            window.location.href="#rednet_anchor_id_"+pid;
        }
    }
}

//支持帖子 回调android客户端中 @JavascriptInterface onPraise()方法
/*@hidden*/function praise(){
    if(BRIDGE!==undefined){
        BRIDGE.callHandler("onPraise",null,null);
    }
}

/**
 *支持帖子成功后更新支持者数量 (也可以在客户端的JSON数据里"recommend_add"加1 在执行onRefresh 这样两边的数据sychornized)
 *客户端回调webview.loadUrl("javascript:onPraiseSuccess();")
 */
function onPraiseSuccess(){
    var el= $(".content_box .P_share div span:eq(1)");
    el.html(parseInt(el.html())+1);
    $(".thread_details .P_share div a:eq(1) img").attr("src","praises.png");
}

//帖子分享 回调android客户端中 @JavascriptInterface onShare()方法
/*@hidden*/function share(){
    if(BRIDGE!==undefined){
        BRIDGE.callHandler("onShare",null,null);
    }
}

/*@hidden*/function textIsNull(strings){
    return strings==null||strings.length==0;
}

//测试js 页面样式
var test=function(){
    onRefresh(TEST_THREAD_JSON,false);
};

var TEST_THREAD_JSON={
    "Version": "4",
    "Charset": "GBK",
    "Variables": {
        "cookiepre": "FKPl_e1a1_",
        "auth": null,
        "saltkey": "YUBJ3z3g",
        "member_uid": "0",
        "member_username": "",
        "member_avatar": "http://u.rednet.cn/avatar.php?uid=0&size=small",
        "groupid": "7",
        "formhash": "4bb4987d",
        "ismoderator": "0",
        "readaccess": "20",
        "notice": {
            "newpush": "0",
            "newpm": "0",
            "newprompt": "0",
            "newmypost": "0"
        },
        "thread": {
            "tid": "44200342",
            "fid": "81",
            "posttableid": "0",
            "typeid": "0",
            "sortid": "0",
            "readperm": "0",
            "price": "0",
            "author": "敬爱偶然",
            "authorid": "3870259",
            "subject": "【周一见】第十一期：520来啦！你准备好了么？",
            "dateline": "1431944180",
            "lastpost": "2015-5-21 15:16",
            "lastposter": "tnine",
            "views": "9467",
            "replies": "18",
            "displayorder": "3",
            "highlight": "48",
            "digest": "0",
            "rate": "0",
            "special": "0",
            "attachment": "2",
            "moderated": "1",
            "closed": "0",
            "stickreply": "0",
            "recommends": "0",
            "recommend_add": "0",
            "recommend_sub": "0",
            "heats": "16",
            "status": "32",
            "isgroup": "0",
            "favtimes": "0",
            "sharetimes": "0",
            "stamp": "4",
            "icon": "-1",
            "pushedaid": "0",
            "cover": "0",
            "replycredit": "0",
            "relatebytag": "0",
            "maxposition": "19",
            "audit": "0",
            "send": "0",
            "threadtable": "forum_thread",
            "threadtableid": "0",
            "posttable": "forum_post",
            "addviews": "381",
            "is_archived": "",
            "archiveid": "0",
            "subjectenc": "%A1%BE%D6%DC%D2%BB%BC%FB%A1%BF%B5%DA%CA%AE%D2%BB%C6%DA%A3%BA520%C0%B4%C0%B2%A3%A1%C4%E3%D7%BC%B1%B8%BA%C3%C1%CB%C3%B4%A3%BF",
            "short_subject": "【周一见】第十一期：520来啦！你准备好了么？",
            "recommendlevel": "0",
            "heatlevel": "0",
            "relay": "0",
            "recommend": "0"
        },
        "fid": "81",
        "postlist": [
                     {
                     "pid": "83754925",
                     "tid": "44200342",
                     "first": "1",
                     "author": "敬爱偶然",
                     "authorid": "3870259",
                     "dateline": "2015-5-18 18:16",
                     "message": "<font color=\"#252525\"><font style=\"background-color:rgb(255,255,255)\">小编</font></font><font color=\"#252525\"><font style=\"background-color:rgb(255,255,255)\">今早一起来就感觉不舒服，不想动，一动就觉得累，一累就想睡觉，一想睡觉就觉得自己不长进，一觉得自己不长进就悲伤，一悲伤就不想动，一动就觉得累，一累就想睡觉……就像</font></font><font color=\"#252525\"><font style=\"background-color:rgb(255,255,255)\">酱紫<br />\r\n</font></font><div class=\"img\"><img src=\"http://f3.rednet.cn/data/attachment/forum/201505/18/133257jmrgvmzzdgzne22d.png\" /></div><br />\r\n<font color=\"#252525\"><font style=\"background-color:rgb(255,255,255)\">话说上个星期</font></font>小编可是度过了一个幸福而又劳累的周末，因为小编又结婚了（办回门酒），回来主编问了下有啥感触？小编只是笑了笑<br />\r\n<div class=\"img\"><img src=\"http://f3.rednet.cn/data/attachment/forum/201505/18/134409ry4ayh41y8h4lsn4.jpg\" /></div><br />\r\n说到感触，小编就是觉得没下雨的天气真是太好了！想我大弗兰上个星期的那天气不是迭样子<br />\r\n<div class=\"img\"><img src=\"http://f3.rednet.cn/data/attachment/forum/201505/18/144053x7szkuussf8um2xq.gif\" /></div><br />\r\n就是迭样子……<br />\r\n<div class=\"img\"><img src=\"http://f3.rednet.cn/data/attachment/forum/201505/18/141716nq1dcd10edd7cd1b.jpg\" /></div><br />\r\n不知道生活在大弗兰各位亲们在上个星期过的怎样？<br />\r\n<div class=\"img\"><img src=\"http://f3.rednet.cn/data/attachment/forum/201505/18/144941jloc3ltteolvzoq9.png\" /></div><br />\r\n虽说暴雨整整下了快一个星期，但有这么一群人一直坚守在狂风暴雨中，他们就是交警蜀黍们，<font color=\"#3e3e3e\">他们伫立在狂风暴风雨中，确保道路畅通</font><br />\r\n<div class=\"img\"><img src=\"http://f3.rednet.cn/data/attachment/forum/201505/18/145934addlcdd814fdl8c8.jpg\" /></div><br />\r\n看到这场景是不是感觉心里暖暖的？总想对敬爱的交警蜀黍们说点啥或者做点啥呢？这不有位美丽的邵阳女孩就付出了行动：那是16日下午6点多，邵阳城区下起大雨。财神路口路段因半封闭施工，车流量大，蜀黍正在冒雨指挥车辆分流时，一位美丽的女孩儿走过来给蜀黍撑伞，不让蜀黍被雨淋湿，并且陪着蜀黍执勤，直到雨停！<br />\r\n<div class=\"img\"><img src=\"http://f3.rednet.cn/data/attachment/forum/201505/18/150657cwq2rbkppfyr2dqr.png\" /></div><br />\r\n<font color=\"#000\">生活处处有温情，一位严守岗位，一位乐于助人，致敬！<br />\r\n<div class=\"img\"><img src=\"http://f3.rednet.cn/data/attachment/forum/201505/18/174834srz5ztcl21zxc19u.png\" /></div><br />\r\n</font><font color=\"#000\">近日，湖南大一女生佩佩与3名男同学出去吃宵夜喝醉，其中一名疑似在追佩佩的男同学王某让两男生协助，将佩佩抬入酒店开房，然后王某强奸了佩佩，到第二天佩佩竟不幸死亡！警方到现场后发现满床是血，佩佩当天还处在生理期！</font><br />\r\n<font color=\"#000\"><br />\r\n</font><div class=\"img\"><img src=\"http://f3.rednet.cn/data/attachment/forum/201505/18/152051jvv901v8simm78zu.jpg\" /></div><br />\r\n<p><font style=\"color:rgb(37,37,37)\"><font style=\"background-color:rgb(255,255,255)\">就是这么一场悲剧惨案，可有些人的评论真是让人三观震碎。。。说什么女生深夜和男人喝酒不自爱，自作自受，我就纳闷了，难道不是应该谴责男性不该强奸吗！喝酒犯法了吗，你就可以为所欲为了？强奸可是触刑触怒啊！不去责怪犯法的人，一个个倒是义愤填膺骂受害人，感觉自己生活在印度。。。<br />\r\n</font></font></p><div class=\"img\"><img src=\"http://f3.rednet.cn/data/attachment/forum/201505/18/153314kkmuii0z9000iu8q.jpg\" /></div><br />\r\n<font color=\"#252525\"><font style=\"background-color:rgb(255,255,255)\">唉不说了，大一，18岁花季，已离人间，愿走好。<br />\r\n<div class=\"img\"><img src=\"http://f3.rednet.cn/data/attachment/forum/201505/18/152051nxps7spefl44ezse.jpg\" /></div><br />\r\n</font></font><font color=\"#252525\"><font style=\"background-color:rgb(255,255,255)\">说到这，小编不得不提一件事，那就是上个星期是汶川七周年祭，</font></font><font color=\"#252525\"><font style=\"background-color:rgb(255,255,255)\">7年前，2008年5月12日，一场8.0级特大地震重创天府之国，69227位同胞不幸遇难。</font></font><br />\r\n<div class=\"img\"><img src=\"http://f3.rednet.cn/data/attachment/forum/201505/18/154057catiuh1hzaupxh1a.png\" /></div> 还记得常德最牛违章车湘J0ZX**“任性”比亚迪么？它终于落网了~~据悉截至目前，该车共有329次交通违法记录，驾驶证计分累计高达1000余分，罚款金额40000余元。目前，交警部门已对该车进行暂扣处理，并通过媒体、微博等多方面渠道通知车主前来接受调查处理。<br />\r\n<div class=\"img\"><img src=\"http://f3.rednet.cn/data/attachment/forum/201505/18/154712wu42gcskz4mckpmk.png\" /></div><br />\r\n小编只想对这位车主说“躲得过初一躲不过十五，赶紧自首吧！”<br />\r\n<div class=\"img\"><img src=\"http://f3.rednet.cn/data/attachment/forum/201505/18/155100stczvbccoc3l93og.jpg\" /></div><br />\r\n<font color=\"#252525\"><font style=\"background-color:rgb(255,255,255)\">这不最近何老师就躺枪了！</font></font><font color=\"#252525\"><font style=\"background-color:rgb(255,255,255)\">最近，北外有教师举报，何炅吃空饷！而且已经吃了好几年！</font></font><font color=\"#252525\"><font style=\"background-color:rgb(255,255,255)\">很多人都知道何炅是北京外国语大学的教师，但却少有人关注是否存在“吃空饷”的问题。</font></font><font color=\"#252525\"><font style=\"background-color:rgb(255,255,255)\">前两天和同事聊天还在说，何炅辞职算了，反正他也不差这么点工资。这不，昨天北外</font></font><font color=\"#252525\"><font style=\"background-color:rgb(255,255,255)\">在微博发布</font></font><font color=\"#252525\"><font style=\"background-color:rgb(255,255,255)\">“关于同意何炅辞职的声明”，称</font></font><font color=\"#252525\"><font style=\"background-color:rgb(255,255,255)\">尊重何炅辞职的选择已经同意了何炅辞职。</font></font><div class=\"img\"><img src=\"http://f3.rednet.cn/data/attachment/forum/201505/18/155831milu9p9iypwnz92l.jpg\" /></div><br />\r\n<font color=\"#252525\"><font style=\"background-color:rgb(255,255,255)\">随后何炅也转发此微博说到，07年调整岗位开始自己的工资都是返还学校的，没有再拿过一分钱。</font></font><font color=\"#252525\"><font style=\"background-color:rgb(255,255,255)\">并表示即使自己不在编也会为母校继续尽心尽责，“我永远是北外人！”</font></font><br />\r\n<font color=\"#252525\"><font style=\"background-color:rgb(255,255,255)\"><div class=\"img\"><img src=\"http://f3.rednet.cn/data/attachment/forum/201505/18/155831uokhkvxkccgg0033.jpg\" /></div><br />\r\n</font></font><font color=\"#252525\"><font style=\"background-color:rgb(255,255,255)\">其实教书育人不必非要站在讲台上，站在讲台上的也不一定做到了为人师表。但是接来下这位老师还真是不配为人师表，</font></font>5月14日，一张郴州市安仁县龙市中心小学“学生被跪操场”照片在网上流传。照片上，30名左右的学生模样的小孩双腿跪在操场，还有一名成年人在其中。<br />\r\n<div class=\"img\"><img src=\"http://f3.rednet.cn/data/attachment/forum/201505/18/161847cmkuq00th5buh5dq.png\" /></div><br />\r\n校长称事发13日午休期间，当时六年级的两个寝室有同学吵闹，值日生便将这些学生带到操场让他们跪着，副校长得到消息后出面解散。可最新的结果是，副校长已予以停职，接受进一步调查，并向学生道歉及在教职工大会上公开检讨<br />\r\n<div class=\"img\"><img src=\"http://f3.rednet.cn/data/attachment/forum/201505/18/163004eg8xl9w8x8wwb4bx.jpg\" /></div><br />\r\n<font color=\"#252525\"><font style=\"background-color:rgb(255,255,255)\">临时工不背锅了，值日生背了？可为什么处罚了副校长？</font></font><font style=\"color:rgb(37,37,37)\"><font style=\"background-color:rgb(255,255,255)\"><br />\r\n</font></font><div class=\"img\"><img src=\"http://f3.rednet.cn/data/attachment/forum/201505/18/163041pde4es4z719i74zi.jpg\" /></div><br />\r\n提到学生，突然想起马上就要高考了啊~~~一说到高考就不得不让人想到那些奇葩的高考口号……<br />\r\n<div class=\"img\"><img src=\"http://f3.rednet.cn/data/attachment/forum/201505/18/172141qyyfyee1g41cgbxg.jpg\" /></div><br />\r\n<div class=\"img\"><img src=\"http://f3.rednet.cn/data/attachment/forum/201505/18/172132gmm6mjooi0swqqmw.jpg\" /></div><br />\r\n5月14日，距离高考还有24天。为高三的毕业生们鼓劲加油，郴州市三中也喊起口号来，不过他们却不是是把口号给挂起来而是真真的喊起来！4000多名同学在团委的组织下喊着口号，场面热烈。“喊楼”活动的图片在网络上火了起来，<br />\r\n<div class=\"img\"><img src=\"http://f3.rednet.cn/data/attachment/forum/201505/18/172743ocjn8nq0rgkjc86x.jpg\" /></div><br />\r\n“喊楼”活动的震撼场面，也让大家有些担心。这不就有网友跟帖说“看场面学校的同学应该都参加了吧，基于安全方面的考虑，真替组织者捏一把汗，想想都恐怖”。<p><div class=\"img\"><img src=\"http://f3.rednet.cn/data/attachment/forum/201505/18/173542fvtkthrvxvqiirkc.jpg\" /></div><br />\r\n</p><p><font color=\"black\">上个星期</font>一则“长沙民警酒后打人”的新闻在朋友圈中疯传（<a href=\"http://bbs.rednet.cn/forum.php?mod=viewthread&amp;tid=44188122&amp;page=1#pid83674940&_wsq_\">详情请戳</a>）：称<font color=\"#333333\">湖南省长沙市岳麓区靳江村，一辆警车要进入小区，因为私车没有让路，结果警车两名警察从车上下来抓着私车上两个人打得全身是血！一边打一边还说要把人抓到派出所去继续打！现在警察跑了！！大家可以看看黑色那辆私车已经让到了什么位置！而且开车的警察喝了酒！</font></p><br />\r\n<div class=\"img\"><img src=\"http://f3.rednet.cn/data/attachment/forum/201505/18/174245a4nqu3umkqf3ornq.png\" /></div><br />\r\n<font color=\"#3e3e3e\">事件发生后，长沙警方以惊人的速度完成调查，并将认真调查的结果公布：经鉴定，吴某佳和吴某分别构成轻伤和轻微伤。交警抽血送检酒精含量，谢某东、谢某平血液酒精含量均为0mg／100ml，吴某佳血液酒精含量为130mg／100ml（达到醉驾标准）。两名打人巡防队员已被刑事拘留。</font><div class=\"img\"><img src=\"http://f3.rednet.cn/data/attachment/forum/201505/18/151921ue36ji306w0yul7j.jpg\" /></div>长沙警方在此次事件处理中表现得可圈可点，事件也给警方敲响警钟：不断提高相关人员的从业素质，提高为民服务、以人为本的理念，才能避免这样的悲剧再次发生，才能真正取信于民，谱写警民雨水情的和谐局面。<br />\r\n<div class=\"img\"><img src=\"http://f3.rednet.cn/data/attachment/forum/201505/18/175942j8l7egj55e9cq0l4.jpg\" /></div><br />\r\n最近不是流行三网提速降费么。“流量不清零，流量可转赠”成为此次三大运营资费调整标配<br />\r\n<div class=\"img\"><img src=\"http://f3.rednet.cn/data/attachment/forum/201505/18/163841r18l1zz8jkfkz8fr.png\" /></div><br />\r\n这不5月15日下午，三大运营商“提速降费”方案均已经出炉，<font style=\"color:rgb(37,37,37)\"><font style=\"background-color:rgb(255,255,255)\">国内三大电信运营商集体出招，纷纷推出“N大举措”推进提速，比如夜间低价流量包、流量跨月不清零等等。</font></font><a href=\"http://bbs.rednet.cn/thread-44191492-1-1.html?_wsq_\">&gt;&gt;&gt;具体方案猛戳此处</a><div class=\"img\"><img src=\"http://f3.rednet.cn/data/attachment/forum/201505/18/164009zwu7rd1sua6mmxw9.png\" /></div><br />\r\n看完简直是惊呆了！还真是上有对策下有政策<br />\r\n<div class=\"img\"><img src=\"http://f3.rednet.cn/data/attachment/forum/201505/18/171319ltx8cnyqnlv1elhh.jpg\" /></div><br />\r\n关于降费提速，咱们听听看看就好，希望越大失望越大，就像假期，小编越抱期望，越失望，反而不抱期望的时候，它来的是那么突然……<br />\r\n<div class=\"img\"><img src=\"http://img4.cache.netease.com/m/2015/5/13/2015051318083991c9b.gif\" width=\"437\" height=\"28\" /></div><br />\r\n这不上个星期国务院通知，中国人民抗日战争暨世界反法西斯战争胜利70周年纪念日调休放假！2015年9月3日全国放假1天!<br />\r\n<div class=\"img\"><img src=\"http://f3.rednet.cn/data/attachment/forum/201505/18/175345gqmj9450c01j7091.jpg\" /></div><br />\r\n据说假期是酱婶安排的。<br />\r\n<font style=\"background-color:rgb(255,255,255)\"><div class=\"img\"><img src=\"http://f3.rednet.cn/data/attachment/forum/201505/18/180115cqvoktk0dm4hqo1v.png\" /></div></font><br />\r\n这天假期可是前辈们的鲜血换来的啊。为了胜利，放假！终于有战胜国的优越感了。<br />\r\n<div class=\"img\"><img src=\"http://f3.rednet.cn/data/attachment/forum/201505/18/180115ohuum989usuymy8x.png\" /></div> <br />\r\n话说后天是520耶~~也就是网络情人节，小编又要出血了……<br />\r\n<div class=\"img\"><img src=\"http://f3.rednet.cn/data/attachment/forum/201505/18/180603a5rmwgdd44dbvlvs.jpg\" /></div><br />\r\n<font style=\"color:rgb(37,37,37)\"><font style=\"background-color:rgb(255,255,255)\">小编就真搞不懂了，为嘛那么多情人节！每个都还要过，人不到还一定得礼物到，就不能简简单单的看个星星，谈谈人生哲理么……</font></font><div class=\"img\"><img src=\"http://f3.rednet.cn/data/attachment/forum/201505/18/181150y4uu3vo66tolftzv.jpg\" /></div><br />\r\n真是说多了都是泪……小编还是慢慢去淘宝找礼物去了，<font color=\"DarkRed\"><strong>聚焦湖南，咱们下周一见！</strong></font><br />\r\n<p><font style=\"color:rgb(37,37,37)\"><font style=\"background-color:rgb(255,255,255)\"><br />\r\n</font></font></p><font style=\"color:rgb(37,37,37)\"><font style=\"background-color:rgb(255,255,255)\"><hr class=\"l\" /></font></font><font style=\"color:rgb(37,37,37)\"><font style=\"background-color:rgb(255,255,255)\"><strong><font color=\"white\"><font style=\"background-color:red\">上期回顾<br />\r\n</font></font></strong></font></font><a href=\"http://bbs.rednet.cn/thread-44173493-1-1.html?_wsq_\">【周一见】第十期：早上狂风暴雨下午艳阳高照，长沙这鬼天气我也是醉了……</a><br />\r\n",
                     "anonymous": "0",
                     "attachment": "0",
                     "status": "4",
                     "username": "敬爱偶然",
                     "adminid": "0",
                     "groupid": "13",
                     "memberstatus": "0",
                     "number": "1",
                     "dbdateline": "1431944180",
                     "attachments": [],
                     "imagelist": [],
                     "avatar": "http://u.rednet.cn/avatar.php?uid=3870259&size=small",
                     "groupiconid": "4",
                     "attachlist": [
                                    {
                                    "attachurl": "http://iwechat.pm.comsenz-service.com/uc_server/avatar.php?uid=55&size=small",
                                    "aid": "123"
                                    }
                                    ]
                     },
                     {
                     "pid": "83766242",
                     "tid": "44200342",
                     "first": "0",
                     "author": "春夏秋冬01",
                     "authorid": "5035144",
                     "dateline": "2015-5-19 10:05",
                     "message": "何炅辞职了，还是中枪了……",
                     "anonymous": "0",
                     "attachment": "0",
                     "status": "4",
                     "username": "春夏秋冬01",
                     "adminid": "0",
                     "groupid": "11",
                     "memberstatus": "0",
                     "number": "2",
                     "dbdateline": "1432001105",
                     "avatar": "http://u.rednet.cn/avatar.php?uid=5035144&size=small",
                     "groupiconid": "2",
                     "attachlist": [
                                    {
                                    "attachurl": "http://iwechat.pm.comsenz-service.com/uc_server/avatar.php?uid=55&size=small",
                                    "aid": "123"
                                    }
                                    ],
                     "attachlist": [
                                    {
                                    "attachurl": "http://iwechat.pm.comsenz-service.com/uc_server/avatar.php?uid=55&size=small",
                                    "aid": "123"
                                    }
                                    ]
                     },
                     {
                     "pid": "83779743",
                     "tid": "44200342",
                     "first": "0",
                     "author": "sanmiliu",
                     "authorid": "4494199",
                     "dateline": "2015-5-19 19:03",
                     "message": "顶了！",
                     "anonymous": "0",
                     "attachment": "0",
                     "status": "4",
                     "username": "sanmiliu",
                     "adminid": "0",
                     "groupid": "23",
                     "memberstatus": "0",
                     "number": "3",
                     "dbdateline": "1432033407",
                     "avatar": "http://u.rednet.cn/avatar.php?uid=4494199&size=small",
                     "groupiconid": "10"
                     },
                     {
                     "pid": "83792491",
                     "tid": "44200342",
                     "first": "0",
                     "author": "cckekcc",
                     "authorid": "5028136",
                     "dateline": "2015-5-20 11:39",
                     "message": "<img src=\"http://bbs.rednet.cn/static/image/smiley/default/biggrin.gif\" />",
                     "anonymous": "0",
                     "attachment": "0",
                     "status": "4",
                     "username": "cckekcc",
                     "adminid": "0",
                     "groupid": "23",
                     "memberstatus": "0",
                     "number": "4",
                     "dbdateline": "1432093170",
                     "avatar": "http://u.rednet.cn/avatar.php?uid=5028136&size=small",
                     "groupiconid": "10"
                     },
                     {
                     "pid": "83792513",
                     "tid": "44200342",
                     "first": "0",
                     "author": "dmzz",
                     "authorid": "4912593",
                     "dateline": "2015-5-20 11:40",
                     "message": "天天过节~~~~都烦死了~~",
                     "anonymous": "0",
                     "attachment": "0",
                     "status": "4",
                     "username": "dmzz",
                     "adminid": "0",
                     "groupid": "11",
                     "memberstatus": "0",
                     "number": "5",
                     "dbdateline": "1432093220",
                     "avatar": "http://u.rednet.cn/avatar.php?uid=4912593&size=small",
                     "groupiconid": "2"
                     },
                     {
                     "pid": "83792564",
                     "tid": "44200342",
                     "first": "0",
                     "author": "冰心如雪",
                     "authorid": "4973555",
                     "dateline": "2015-5-20 11:42",
                     "message": "移不动联不通 电信就是个大坑！！！",
                     "anonymous": "0",
                     "attachment": "0",
                     "status": "4",
                     "username": "冰心如雪",
                     "adminid": "0",
                     "groupid": "10",
                     "memberstatus": "0",
                     "number": "6",
                     "dbdateline": "1432093325",
                     "avatar": "http://u.rednet.cn/avatar.php?uid=4973555&size=small",
                     "groupiconid": "1"
                     },
                     {
                     "pid": "83792761",
                     "tid": "44200342",
                     "first": "0",
                     "author": "到底有人管没",
                     "authorid": "5035356",
                     "dateline": "2015-5-20 11:47",
                     "message": "放假是牺牲了中秋一天假换来的……",
                     "anonymous": "0",
                     "attachment": "0",
                     "status": "4",
                     "username": "到底有人管没",
                     "adminid": "0",
                     "groupid": "10",
                     "memberstatus": "0",
                     "number": "7",
                     "dbdateline": "1432093656",
                     "avatar": "http://u.rednet.cn/avatar.php?uid=5035356&size=small",
                     "groupiconid": "1"
                     },
                     {
                     "pid": "83793819",
                     "tid": "44200342",
                     "first": "0",
                     "author": "cckekcc",
                     "authorid": "5028136",
                     "dateline": "2015-5-20 12:39",
                     "message": "<img src=\"http://bbs.rednet.cn/static/image/smiley/default/lol.gif\" />",
                     "anonymous": "0",
                     "attachment": "0",
                     "status": "4",
                     "username": "cckekcc",
                     "adminid": "0",
                     "groupid": "23",
                     "memberstatus": "0",
                     "number": "8",
                     "dbdateline": "1432096767",
                     "avatar": "http://u.rednet.cn/avatar.php?uid=5028136&size=small",
                     "groupiconid": "10"
                     },
                     {
                     "pid": "83796824",
                     "tid": "44200342",
                     "first": "0",
                     "author": "patli",
                     "authorid": "5052550",
                     "dateline": "2015-5-20 15:01",
                     "message": "我老妈很喜欢李宇春呢。。。。。。",
                     "anonymous": "0",
                     "attachment": "0",
                     "status": "4",
                     "username": "patli",
                     "adminid": "0",
                     "groupid": "12",
                     "memberstatus": "0",
                     "number": "9",
                     "dbdateline": "1432105293",
                     "avatar": "http://u.rednet.cn/avatar.php?uid=5052550&size=small",
                     "groupiconid": "3"
                     },
                     {
                     "pid": "83810878",
                     "tid": "44200342",
                     "first": "0",
                     "author": "仇日主义者",
                     "authorid": "1094758",
                     "dateline": "2015-5-21 02:27",
                     "message": "太好了！对楼主赞一个 ！！！！！！！",
                     "anonymous": "0",
                     "attachment": "0",
                     "status": "4",
                     "username": "仇日主义者",
                     "adminid": "0",
                     "groupid": "12",
                     "memberstatus": "0",
                     "number": "10",
                     "dbdateline": "1432146464",
                     "avatar": "http://u.rednet.cn/avatar.php?uid=1094758&size=small",
                     "groupiconid": "3"
                     },
                     {
                     "pid": "83811988",
                     "tid": "44200342",
                     "first": "0",
                     "author": "xaubbin",
                     "authorid": "5051654",
                     "dateline": "2015-5-21 07:27",
                     "message": "这是什么情况，我来围观了呵呵",
                     "anonymous": "0",
                     "attachment": "0",
                     "status": "4",
                     "username": "xaubbin",
                     "adminid": "0",
                     "groupid": "11",
                     "memberstatus": "0",
                     "number": "11",
                     "dbdateline": "1432164451",
                     "avatar": "http://u.rednet.cn/avatar.php?uid=5051654&size=small",
                     "groupiconid": "2"
                     },
                     {
                     "pid": "83813688",
                     "tid": "44200342",
                     "first": "0",
                     "author": "ttorange",
                     "authorid": "5050535",
                     "dateline": "2015-5-21 09:15",
                     "message": "挺有意思的啊 ",
                     "anonymous": "0",
                     "attachment": "0",
                     "status": "4",
                     "username": "ttorange",
                     "adminid": "0",
                     "groupid": "11",
                     "memberstatus": "0",
                     "number": "12",
                     "dbdateline": "1432170942",
                     "avatar": "http://u.rednet.cn/avatar.php?uid=5050535&size=small",
                     "groupiconid": "2"
                     },
                     {
                     "pid": "83813714",
                     "tid": "44200342",
                     "first": "0",
                     "author": "ziviacourlge",
                     "authorid": "5050992",
                     "dateline": "2015-5-21 09:16",
                     "message": "过来学习下，亲，你提供的东西真好！！",
                     "anonymous": "0",
                     "attachment": "0",
                     "status": "4",
                     "username": "ziviacourlge",
                     "adminid": "0",
                     "groupid": "11",
                     "memberstatus": "0",
                     "number": "13",
                     "dbdateline": "1432170998",
                     "avatar": "http://u.rednet.cn/avatar.php?uid=5050992&size=small",
                     "groupiconid": "2"
                     },
                     {
                     "pid": "83816324",
                     "tid": "44200342",
                     "first": "0",
                     "author": "danmy624",
                     "authorid": "5052513",
                     "dateline": "2015-5-21 10:49",
                     "message": "留个脚印，日安，傻木们?★,:*:?\\(￣▽￣)/?:*?°★*",
                     "anonymous": "0",
                     "attachment": "0",
                     "status": "4",
                     "username": "danmy624",
                     "adminid": "0",
                     "groupid": "12",
                     "memberstatus": "0",
                     "number": "14",
                     "dbdateline": "1432176567",
                     "avatar": "http://u.rednet.cn/avatar.php?uid=5052513&size=small",
                     "groupiconid": "3"
                     },
                     {
                     "pid": "83818348",
                     "tid": "44200342",
                     "first": "0",
                     "author": "chzuijun",
                     "authorid": "5051178",
                     "dateline": "2015-5-21 12:03",
                     "message": "闲的无聊不知道干什么",
                     "anonymous": "0",
                     "attachment": "0",
                     "status": "4",
                     "username": "chzuijun",
                     "adminid": "0",
                     "groupid": "12",
                     "memberstatus": "0",
                     "number": "15",
                     "dbdateline": "1432181036",
                     "avatar": "http://u.rednet.cn/avatar.php?uid=5051178&size=small",
                     "groupiconid": "3"
                     },
                     {
                     "pid": "83821685",
                     "tid": "44200342",
                     "first": "0",
                     "author": "danmy624",
                     "authorid": "5052513",
                     "dateline": "2015-5-21 14:28",
                     "message": "打酱油的路过了呵呵，飘了",
                     "anonymous": "0",
                     "attachment": "0",
                     "status": "4",
                     "username": "danmy624",
                     "adminid": "0",
                     "groupid": "12",
                     "memberstatus": "0",
                     "number": "16",
                     "dbdateline": "1432189727",
                     "avatar": "http://u.rednet.cn/avatar.php?uid=5052513&size=small",
                     "groupiconid": "3"
                     },
                     {
                     "pid": "83821932",
                     "tid": "44200342",
                     "first": "0",
                     "author": "gnngn",
                     "authorid": "5050960",
                     "dateline": "2015-5-21 14:36",
                     "message": "我是火星籍的。前来地球参观",
                     "anonymous": "0",
                     "attachment": "0",
                     "status": "4",
                     "username": "gnngn",
                     "adminid": "0",
                     "groupid": "11",
                     "memberstatus": "0",
                     "number": "17",
                     "dbdateline": "1432190219",
                     "avatar": "http://u.rednet.cn/avatar.php?uid=5050960&size=small",
                     "groupiconid": "2"
                     },
                     {
                     "pid": "83822041",
                     "tid": "44200342",
                     "first": "0",
                     "author": "最笨的那",
                     "authorid": "1083792",
                     "dateline": "2015-5-21 14:41",
                     "message": "我们已经错过了",
                     "anonymous": "0",
                     "attachment": "0",
                     "status": "4",
                     "username": "最笨的那",
                     "adminid": "0",
                     "groupid": "12",
                     "memberstatus": "0",
                     "number": "18",
                     "dbdateline": "1432190471",
                     "avatar": "http://u.rednet.cn/avatar.php?uid=1083792&size=small",
                     "groupiconid": "3"
                     },
                     {
                     "pid": "83823205",
                     "tid": "44200342",
                     "first": "0",
                     "author": "tnine",
                     "authorid": "5052485",
                     "dateline": "2015-5-21 15:16",
                     "message": "太强大了，支持！ ",
                     "anonymous": "0",
                     "attachment": "0",
                     "status": "4",
                     "username": "tnine",
                     "adminid": "0",
                     "groupid": "12",
                     "memberstatus": "0",
                     "number": "19",
                     "dbdateline": "1432192578",
                     "avatar": "http://u.rednet.cn/avatar.php?uid=5052485&size=small",
                     "groupiconid": "3"
                     }
                     ],
        "ppp": "20",
        "setting_rewriterule": {
            "portal_topic": "topic-{name}.html",
            "portal_article": "article-{id}-{page}.html",
            "forum_forumdisplay": "forum-{fid}-{page}.html",
            "forum_viewthread": "thread-{tid}-{page}-{prevpage}.html",
            "group_group": "group-{fid}-{page}.html",
            "home_space": "space-{user}-{value}.html",
            "home_blog": "blog-{uid}-{blogid}.html",
            "forum_archiver": "{action}-{value}.html",
            "plugin": "{pluginid}-{module}.html"
        },
        "setting_rewritestatus": [
                                  "forum_forumdisplay",
                                  "forum_viewthread",
                                  "home_blog"
                                  ],
        "forum_threadpay": "",
        "cache_custominfo_postno": [
                                    "楼",
                                    ""
                                    ],
        "forum": {
            "password": "0"
        }
    }
};
