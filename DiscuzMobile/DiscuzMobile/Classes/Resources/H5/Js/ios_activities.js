var isLoadReplyOver=false;//是否所有评论已加载完毕
var	is2GOr3GLoadImgs=true;//2/3G网络是否加载图片
var HOST="http://iwechat.pm.comsenz-service.com/";
var BRIDGE;

$(document).ready(function(){
	$("div.box03").bind("click",function(){onThreadOptionsClick();});
	$(".thread_details .P_share div a:eq(1)").bind("click",function(){praise();});
    $(".thread_details .P_share div a:eq(2)").bind("click",function(){discussUser();});
	$(".thread_details .P_share div a:eq(3)").bind("click",function(){share();});
	$(".reply_botton_j a").bind("click",function(){loadMore();});
	$(".senbtto button").bind("click",function(){submit();});
	setupWebViewJavascriptBridge(function(bridge){
		BRIDGE=bridge;
		BRIDGE.init(function(message,responseCallback){});
	});
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

/*@hidden*/function setThread(JSON){
    
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
    
    $("div.detailTit").html((typeName?typeName:"") + JSON.Variables.thread.subject + "    <span>" + decodeURI(JSON.Variables.special_activity.class)+"</span>" + (verifystatus?verifystatus:""));
    
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

//	$(".activity_time_tip").html("报名进行中，还剩"+eval(JSON.Variables.special_activity.number-JSON.Variables.special_activity.applynumber)+"个名额，" +JSON.Variables.special_activity.expiration+"截止");
    
    
    
    var allNumber = JSON.Variables.special_activity.number;
    
    var tojoinStr = JSON.Variables.special_activity.expiration + "截止";
    if (textIsNull(JSON.Variables.special_activity.expiration) || JSON.Variables.special_activity.expiration == 0) {
        tojoinStr = "长期有效";
    }
    
    if (JSON.Variables.special_activity.closed == 1) {
        $(".activity_time_tip").html("报名截止：" + JSON.Variables.special_activity.expiration + "  还剩" + (JSON.Variables.special_activity.number-JSON.Variables.special_activity.applynumber) + "个名额");
    } else{
        
        if (allNumber == 0) {
            $(".activity_time_tip").html("报名进行中，" + tojoinStr);
        } else {
            $(".activity_time_tip").html("报名进行中，还剩"+eval(JSON.Variables.special_activity.number-JSON.Variables.special_activity.applynumber)+"个名额，" + tojoinStr);
        }
    }
    
    
    
    
    var gender = JSON.Variables.special_activity.gender;
    var cost = JSON.Variables.special_activity.cost;
    
    $(".content_box .activity_message span:eq(0)").html(JSON.Variables.special_activity.starttimefrom);
    $(".content_box .activity_message span:eq(1)").html(JSON.Variables.special_activity.starttimeto);
    if (JSON.Variables.special_activity.starttimeto == 0) {
        $(".content_box .activity_message div:eq(1)").attr("hidden","hidden");
    }
    $(".content_box .activity_message span:eq(2)").html(decodeURI(JSON.Variables.special_activity.place));
    $(".content_box .activity_message span:eq(3)").html(gender==1?"男":(gender==2?"女":"不限"));
    $(".content_box .activity_message span:eq(4)").html(cost + "元");
    $(".content_box .activity_message span:eq(5) span:eq(0)").html("<b style=\"color:red\">"+JSON.Variables.special_activity.allapplynum+"</b>"+"人" + "<a class=\"activity_manager\" hidden>报名管理</a>");
    
    
    if ((JSON.Variables.member_uid == JSON.Variables.thread.authorid || JSON.Variables.groupid == 1 ) && JSON.Variables.special_activity.allapplynum > 0 ) {
        $(".content_box .activity_message span:eq(5) a:eq(0)").removeAttr("hidden");
        
    }
    
    
    $(".content_box .activity_message span:eq(5) a:eq(0)").click(function(){manageActive(null);});
    
	$(".thread_details .P_share div a:eq(0)").click(function(){complain(null);});
    // 给文字添加点击
    $(".thread_details .P_share div span:eq(0)").click(function(){complain(null);});
    $(".thread_details .P_share div span:eq(1)").click(function(){praise();});
    $(".thread_details .P_share div span:eq(2)").click(function(){discussUser();});
    $(".thread_details .P_share div span:eq(3)").click(function(){share();});
    
	$(".thread_details .P_share div span:eq(1)").html(JSON.Variables.thread.recommend_add);
//	$(".thread_details .P_share div span:eq(2)").html(JSON.Variables.thread.replies);
    if(JSON.Variables.thread.recommend == 1) {
        $(".thread_details .P_share div a:eq(1) img").attr("src","praises.png");
    }
    
    if (!textIsNull(JSON.Variables.special_activity.attachurl)) {
        $(".activity_message").append("<p><img aid='"+JSON.Variables.special_activity.aid+"' src='"+JSON.Variables.special_activity.attachurl+"'/></p>");
        $(".activity_message img").css({"width":"0px","height":"0px"});
        $(".activity_message img").attr(is2GOr3GLoadImgs?"src":"hidden",is2GOr3GLoadImgs?$(this).attr("src"):"hidden").css({"width":"auto","height":"auto"})
        $(".activity_message img").click(is2GOr3GLoadImgs?function(){threadThumbsClick($(this).attr("src"));}:null)
        .error(function(){$(this).attr('src', "load_error.png");});
        
    }

	if(!textIsNull(JSON.Variables.postlist)){
        
        var dateline = JSON.Variables.postlist[0].dateline;
        
        $(".p_header .P_figure .box01 img").attr(is2GOr3GLoadImgs?"src":"hidden",is2GOr3GLoadImgs?JSON.Variables.postlist[0].avatar:"hidden");
        $(".p_header .P_figure .box03 .p_date").html(dateline);
        
		$(".contentPictext img").css({"width":"0px","height":"0px"});
		$(".contentPictext").html(!textIsNull(JSON.Variables.postlist)?JSON.Variables.postlist[0].message:"");
		$(".contentPictext img").attr(is2GOr3GLoadImgs?"src":"hidden",is2GOr3GLoadImgs?$(this).attr("src"):"hidden")
		.css({"width":"auto","height":"auto"})
		.click(is2GOr3GLoadImgs?function(){threadThumbsClick($(this).attr("src"));}:null)
        .error(function(){$(this).attr('src', "load_error.png");});
        
		if(!textIsNull(JSON.Variables.postlist[0].attachlist)){
			$(".thread_details .attachlist img").css({"width":"0px","height":"0px"});
			$(".thread_details .attachlist").removeAttr("hidden");
			var attachlist=JSON.Variables.postlist[0].attachlist;
			for(var i=0;i<attachlist.length;i++){
				if(!textIsNull(attachlist[i].attachurl)){
					$(".thread_details .attachlist ul").append("<li><img aid='"+attachlist[i].aid+"' src='"+attachlist[i].attachurl+"'/></li>");
				}				
			}
			$(".thread_details .attachlist img").click(is2GOr3GLoadImgs?function(){threadThumbsClick($(this).attr("src"));}:null)
			.attr(is2GOr3GLoadImgs?"src":"hidden",is2GOr3GLoadImgs?$(this).attr("src"):"hidden")
			.css({"width":"auto","height":"auto"})
            .error(function(){$(this).attr('src', "load_error.png");});
		}	
	}
}

/**
 *加载用户评论
 *isAppend true json数据从0开始 false从1开始因为0是用户发表的帖子内容
 */
function onLoadReply(threadJSON,isAppend){
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
            li.find(".otherPostItem .otnerPostDetail .replyCon").html(postlistitem.message);
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
}

/**
 *刷新
 *@param joined 当前登录用户是否已参加该活动
 */
function onRefresh(JSON,joined,is2GOr3GLoadImgs){
	this.isLoadReplyOver=false;
	this.is2GOr3GLoadImgs=is2GOr3GLoadImgs;
    setThread(JSON);
	onUpdatePartyState(joined);
    onLoadReply(JSON,false);
    var postlist=JSON.Variables.postlist;
    var num = JSON.Variables.special_activity.number;
    var appnum = JSON.Variables.special_activity.applynumber;
    
    if(textIsNull(postlist)||postlist.length<2){
        $("div.p_vote.bg").attr("hidden","hidden");
    }
    
    if (num-appnum == 0 && num != 0 && !joined) {
        $("div.senbtto").attr("hidden","hidden");
    }else if (JSON.Variables.special_activity.closed == 1) {
        $("div.senbtto").attr("hidden","hidden");
    } else {
        $("div.actplaceholder").removeAttr("hidden");
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

//加载更多 成功后客户端调用onLoadReply(JSON,true)
/*@hidden*/function loadMore(){
	if(BRIDGE!==undefined){
		BRIDGE.callHandler("onLoadMore","",null);
	}
}

//帖子分享
/*@hidden*/function share(){
	if(BRIDGE!==undefined){
		BRIDGE.callHandler("onShare","",null);
	}
}

//支持(帖子)
/*@hidden*/function praise(){
	if(BRIDGE!==undefined){
		BRIDGE.callHandler("onPraise","",null);
	}
}

/**支持(帖子)成功更新支持者数量*/
function onPraiseSuccess(){
	var el=$(".P_share div span:eq(1)");
	el.html(parseInt(el.html())+1);
    $(".thread_details .P_share div a:eq(1) img").attr("src","praises.png");
}

//回复某评论
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

// 活动管理
function manageActive() {
    if(BRIDGE!==undefined){
        BRIDGE.callHandler("manageActive",null,null);
    }
    
}

/**
 *回复用户评论或写跟帖成功 客户端回调webview.loadUrl("javascript:onDiscussSuccess(JSON,pid);")
 *@param JSON 
 *@param pid 锚点值
 */
function onDiscussSuccess(JSON,joined,is2GOr3GLoadImgs,pid){
	if (!textIsNull(JSON)){
        onRefresh(JSON,joined,is2GOr3GLoadImgs);
		if(!textIsNull(pid)){
			window.location.href="#rednet_anchor_id_"+pid;
		}
	}
}

//点击用户头像或者用户名进入到其个人空间
/*@hidden*/function userInfo(authorid){
	if(BRIDGE!==undefined){
		BRIDGE.callHandler("onUserInfo",authorid,null);
	}
}

function onThreadOptionsClick(){
	if(BRIDGE!==undefined){
		BRIDGE.callHandler("onThreadOptionsClick",null,null);
	}
}

//查看大图
/*@hidden*/function threadThumbsClick(url){
    if (url.indexOf("smiley") != -1) {
        return;
    }
	if(BRIDGE!==undefined){
		BRIDGE.callHandler("onThreadThumbsClicked",url,null);
	}
}

/**更新(当前登录用户)活动参加状态按钮*/
function onUpdatePartyState(joined){
	$(".senbtto button").attr("joined",joined?"true":"false").html(joined?"取消报名":"我要参加");
}

/*@hidden*/function submit(){
	if(BRIDGE!==undefined){
		BRIDGE.callHandler("onSubmit",null,null);
	}
}

/*@hidden*/function textIsNull(strings){
	return strings===undefined||strings.length==0;
}

function test(){
	onRefresh(TEST_JSON,false,true);
}

var TEST_JSON={
    "Version": "4",
    "Charset": "UTF-8",
    "Variables": {
        "cookiepre": "QRDz_2132_",
        "auth": "1760sLCV4yXES2F6MbCKuCRz15o9a/Nwgu9GIfmbSHBjoMARlnE6k7OsYQQAFQVJuv/Ouxy2D9Q1nLunaw3YOA",
        "saltkey": "CaK7ALaG",
        "member_uid": "55",
        "member_username": "fuwei111",
        "member_avatar": "http://iwechat.pm.comsenz-service.com/uc_server/avatar.php?uid=55&size=small",
        "groupid": "11",
        "formhash": "cdea42a9",
        "ismoderator": "0",
        "readaccess": "20",
        "notice": {
            "newpush": "0",
            "newpm": "0",
            "newprompt": "1",
            "newmypost": "0"
        },
        "allowperm": {
            "allowpost": "1",
            "allowreply": "1",
            "allowupload": {
                "jpg": "-1",
                "jpeg": "-1",
                "gif": "-1",
                "png": "-1",
                "mp3": "0",
                "txt": "0",
                "zip": "-1",
                "rar": "-1",
                "pdf": "-1"
            },
            "attachremain": {
                "size": "-1",
                "count": "-1"
            },
            "uploadhash": "e4429fb27bf53a33076bf279abc77eff"
        },
        "thread": {
            "tid": "118",
            "fid": "42",
            "posttableid": "0",
            "typeid": "0",
            "sortid": "0",
            "readperm": "0",
            "price": "0",
            "author": "fuwei111",
            "authorid": "55",
            "subject": "大家一起来玩耍[北京]",
            "dateline": "2015-7-4 15:07",
            "lastpost": "1435994286",
            "lastposter": "fuwei111",
            "views": "8",
            "replies": "1",
            "displayorder": "0",
            "highlight": "0",
            "digest": "0",
            "rate": "0",
            "special": "4",
            "attachment": "2",
            "moderated": "0",
            "closed": "0",
            "stickreply": "0",
            "recommends": "0",
            "recommend_add": "0",
            "recommend_sub": "0",
            "heats": "1",
            "status": "32",
            "isgroup": "0",
            "favtimes": "0",
            "sharetimes": "0",
            "stamp": "-1",
            "icon": "-1",
            "pushedaid": "0",
            "cover": "0",
            "replycredit": "0",
            "relatebytag": "0",
            "maxposition": "2",
            "bgcolor": "",
            "comments": "0",
            "hidden": "0",
            "threadtable": "forum_thread",
            "threadtableid": "0",
            "posttable": "forum_post",
            "allreplies": "1",
            "is_archived": "",
            "archiveid": "0",
            "subjectenc": "%E5%A4%A7%E5%AE%B6%E4%B8%80%E8%B5%B7%E6%9D%A5%E7%8E%A9%E8%80%8D%5B%E5%8C%97%E4%BA%AC%5D",
            "short_subject": "大家一起来玩耍[北京]",
            "starttime": "1435993678",
            "remaintime": "",
            "recommendlevel": "0",
            "heatlevel": "0",
            "relay": "0",
            "avatar": "http://iwechat.pm.comsenz-service.com/uc_server/avatar.php?uid=55&size=small",
            "ordertype": "0",
            "recommend": "0"
        },
        "fid": "42",
        "postlist": [
            {
                "pid": "252",
                "tid": "118",
                "first": "1",
                "author": "fuwei111",
                "authorid": "55",
                "dateline": "17&nbsp;分钟前",
                "message": "吃饭！玩耍！哈哈哈！<br />\r\n",
                "anonymous": "0",
                "attachment": "0",
                "status": "0",
                "replycredit": "0",
                "position": "1",
                "username": "fuwei111",
                "adminid": "0",
                "groupid": "11",
                "memberstatus": "0",
                "number": "1",
                "dbdateline": "1435993678",
                "avatar": "http://iwechat.pm.comsenz-service.com/uc_server/avatar.php?uid=55&size=small",
                "groupiconid": "2",
				"attachlist":[
				{"attachurl":"http://iwechat.pm.comsenz-service.com/uc_server/avatar.php?uid=55&size=small","aid":"125"}
				]
            },
            {
                "pid": "253",
                "tid": "118",
                "first": "0",
                "author": "fuwei111",
                "authorid": "55",
                "dateline": "7&nbsp;分钟前",
                "message": "HAHAH !ZOUQI LA !",
                "anonymous": "0",
                "attachment": "0",
                "status": "1024",
                "replycredit": "0",
                "position": "2",
                "username": "fuwei111",
                "adminid": "0",
                "groupid": "11",
                "memberstatus": "0",
                "number": "2",
                "dbdateline": "1435994286",
                "avatar": "http://iwechat.pm.comsenz-service.com/uc_server/avatar.php?uid=55&size=small",
                "groupiconid": "2",
				"attachlist":[
				{"attachurl":"http://iwechat.pm.comsenz-service.com/uc_server/avatar.php?uid=55&size=small","aid":"125"}
				]
            }
        ],
        "allowpostcomment": null,
        "comments": [],
        "commentcount": [],
        "ppp": "5",
        "setting_rewriterule": null,
        "setting_rewritestatus": "",
        "forum_threadpay": "",
        "cache_custominfo_postno": [
            "<sup>#</sup>",
            "楼主",
            "沙发",
            "板凳",
            "地板"
        ],
        "special_activity": {
            "tid": "118",
            "uid": "55",
            "aid": "63",
            "cost": "40",
            "starttimefrom": "2015-7-5 15:06",
            "starttimeto": "0",
            "place": "西直门",
            "class": "朋友聚会",
            "gender": "1",
            "number": "10",
            "applynumber": "2",
            "expiration": "2015-7-4 15:06",
            "ufield": {
                "userfield": [
                    "realname",
                    "mobile",
                    "qq"
                ],
                "extfield": []
            },
            "credit": "2",
            "thumb": "data/attachment/forum/201507/04/150733ziz6zepzp61vvano.jpg",
            "attachurl": "data/attachment/forum/201507/04/150733ziz6zepzp61vvano.jpg",
            "width": "794",
            "allapplynum": "0",
            "creditcost": "2 威望",
            "joinfield": {
                "realname": {
                    "fieldid": "realname",
                    "available": "1",
                    "title": "真实姓名",
                    "formtype": "text"
                },
                "mobile": {
                    "fieldid": "mobile",
                    "available": "1",
                    "title": "手机",
                    "formtype": "text"
                },
                "qq": {
                    "fieldid": "qq",
                    "available": "1",
                    "title": "QQ",
                    "formtype": "text"
                }
            },
            "userfield": {
                "realname": "",
                "mobile": "",
                "qq": ""
            },
            "extfield": null,
            "basefield": [],
            "closed": "1",
            "is_ex": "1",
            "isverified": "0",
            "applied": "0"
        },
        "forum": {
            "password": "0"
        }
    }
};
