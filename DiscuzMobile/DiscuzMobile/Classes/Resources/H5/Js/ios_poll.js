var HOST="http://bbs.rednet.cn/";
var isMultiSelected=true;
var maxChoices=2;
var isLoadReplyOver=false;//是否所有评论已加载完毕
var	is2GOr3GLoadImgs=true;//2/3G网络是否加载图片
var BRIDGE;

$(document).ready(function(){
	$("div.box03").bind("click",function(){threadOptionsClick();});
	$(".P_submit").bind("click",function(){sendPoll();});
	$(".thread_details .P_share div a:eq(1)").bind("click",function(){praise();});
    $(".thread_details .P_share div a:eq(2)").bind("click",function(){discussUser();});
	$(".thread_details .P_share div a:eq(3)").bind("click",function(){share();});
//	test();
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


/*@hidden*/var setThread=function(JSON){
	isMultiSelected=(parseInt(JSON.Variables.special_poll.multiple)==1);
	maxChoices=parseInt(JSON.Variables.special_poll.maxchoices);
    
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
    
    $("div.detailTit").html((typeName?typeName:"") + JSON.Variables.thread.subject + (isMultiSelected?"    <span>多选</span>":"") + (verifystatus?verifystatus:""));
    
    $("div.box02 label:first").html(JSON.Variables.postlist[0].author);
    $("div.box03 label.p_date").html(JSON.Variables.postlist[0].dateline);
    $(".scannedInfo .scannedInfo-l span:eq(0)").html(numberFormat(JSON.Variables.thread.views));
    $(".scannedInfo .scannedInfo-l span:eq(1)").html(JSON.Variables.thread.replies);
    var fourmname = JSON.Variables.thread.forumnames;
    if(!textIsNull(fourmname) && fourmname.length > 20) {
        fourmname = fourmname.substring(0,25) + "...";
    }
    $(".scannedInfo .sectionName").html(fourmname + ">");
    $(".hostInfo-l .avatar img:first").attr(is2GOr3GLoadImgs?"src":"hidden",is2GOr3GLoadImgs?JSON.Variables.postlist[0].avatar:"hidden");
    $(".hostInfo-l .userName").html(JSON.Variables.postlist[0].author);
    $(".hostInfo .time").html(JSON.Variables.postlist[0].dateline);
    $(".hostInfo-l").click(function(){userInfo(JSON.Variables.thread.authorid)});

    
	$(".P_figure .box01").click(function(){userInfo(JSON.Variables.thread.authorid)});
	$(".P_figure .box02").click(function(){userInfo(JSON.Variables.thread.authorid)});
    
    var timestamp = new Date().getTime().toString();
    timestamp = timestamp.substr(0,10);
    
    var selctNum = "单选投票:";
    if (JSON.Variables.special_poll.maxchoices > 1) {
        selctNum = "多选投票:(最多可选" + JSON.Variables.special_poll.maxchoices + "项),";
        
    }
    
    var voteStatus = selctNum + "共有";
    if (timestamp > JSON.Variables.special_poll.expirations) {
        var voteStatus = selctNum + "投票已结束,共有";
    }
    
	$(".vote_tips").html(voteStatus+JSON.Variables.special_poll.voterscount+"人参加");
    
    if (!textIsNull(JSON.Variables.special_poll.expirations) && !textIsNull(JSON.Variables.special_poll.remaintime)) {
        $(".vote_expirations").removeAttr("hidden");
        $(".vote_expirations").html("投票截止时间：" + formatDate(JSON.Variables.special_poll.expirations));
    }
    
	$(".thread_details .P_share div a:eq(0)").click(function(){complain(null);});
//    $(".thread_details .P_share div a:eq(2)").click(function(){discussUser(null);});
    // 给文字添加点击
    $(".thread_details .P_share div span:eq(0)").click(function(){complain(null);});
    $(".thread_details .P_share div span:eq(1)").click(function(){praise();});
    $(".thread_details .P_share div span:eq(2)").click(function(){discussUser();});
    $(".thread_details .P_share div span:eq(3)").click(function(){share();});
    
	$(".thread_details .P_share div span:eq(1)").html(JSON.Variables.thread.recommend_add);
	$(".thread_details .P_share div span:eq(2)").html(JSON.Variables.thread.replies);
    
    if(JSON.Variables.thread.recommend == 1) {
        $(".thread_details .P_share div a:eq(1) img").attr("src","praises.png");
    }

	if (!textIsNull(JSON.Variables.postlist)){
        
        var dateline = JSON.Variables.postlist[0].dateline;
        
        $(".P_figure .box01 img").attr(is2GOr3GLoadImgs?"src":"hidden",is2GOr3GLoadImgs?JSON.Variables.postlist[0].avatar:"hidden");
        $(".P_figure .box03 label.p_date").html(dateline);
		$("p#thread_content img").css({"width":"0px","height":"0px"});
        $("p#thread_content").html(JSON.Variables.postlist[0].message);
		$("p#thread_content img").click(is2GOr3GLoadImgs?function(){threadThumbsClick($(this).attr("src"));}:null)
		.attr(is2GOr3GLoadImgs?"src":"hidden",is2GOr3GLoadImgs?$(this).attr("src"):"hidden")
		.css({"width":"auto","height":"auto"})
        .error(function(){$(this).attr('src', "load_error.png");});
        
	}

	if(!textIsNull(JSON.Variables.postlist[0].attachlist)){
		$(".thread_details .attachlist img").css({"width":"0px","height":"0px"})
        .attr(is2GOr3GLoadImgs?"src":"hidden",is2GOr3GLoadImgs?$(this).attr("src"):"hidden");
		$(".thread_details .attachlist").removeAttr("hidden");
		var attachlist=JSON.Variables.postlist[0].attachlist;
		for(var i=0;i<attachlist.length;i++){
			if(!textIsNull(attachlist[i].attachurl)){
				$(".thread_details .attachlist ul").append("<li><img aid='"+attachlist[i].aid+"' src='"+attachlist[i].attachurl+"'/></li>");
			}				
		}
		$(".thread_details .attachlist img").click(is2GOr3GLoadImgs?function(){threadThumbsClick($(this).attr("src"));}:null)
		.attr("src",is2GOr3GLoadImgs?$(this).attr("src"):"load_error.png")
		.css({"width":"auto","height":"auto"})
        .error(function(){$(this).attr('src', "load_error.png");});
	}

	var pollList=$("ul.poll_list");
	for(option in JSON.Variables.special_poll.polloptions){
		var pollOption=JSON.Variables.special_poll.polloptions[option];
		var imgPid=pollOption.imginfo.pid;
		var item=isMultiSelected?pollList.find("li:eq(0)").clone():pollList.find("li:eq(1)").clone();
		if(imgPid!==undefined&&imgPid.length>0){
			item.find(".ui-type-poll-img-txt").removeAttr("hidden");
			item.find(".ui-type-poll-img-txt p img").attr("src",pollOption.imginfo.small).attr("zoomfile",pollOption.imginfo.big)
            .attr(is2GOr3GLoadImgs?"src":"hidden",is2GOr3GLoadImgs?$(this).attr("src"):"hidden");
            item.find(".ui-type-poll-img-txt p img").click(is2GOr3GLoadImgs?function(){threadThumbsClick($(this).attr("zoomfile"));}:null)
            .error(function(){$(this).attr('src', "load_error.png");});
			item.find(".ui-type-poll-img-txt input").attr("id","poll_item"+option).attr("value",pollOption.polloptionid);
//			item.find(".ui-type-poll-img-txt label").attr("for","poll_item"+option).html(option+". "+decodeURI(pollOption.polloption));
            item.find(".ui-type-poll-img-txt label").attr("for","poll_item"+option);
            item.find(".ui-type-poll-img-txt div:eq(0)").append(option+". "+decodeURI(pollOption.polloption));
		}else{
			item.find(".ui-type-poll-txt-only").removeAttr("hidden");
			item.find(".ui-type-poll-txt-only input").attr("id","poll_item"+option).attr("value",JSON.Variables.special_poll.polloptions[option].polloptionid);
            item.find(".ui-type-poll-txt-only label").attr("for","poll_item"+option);
//            .html(option+". "+decodeURI(JSON.Variables.special_poll.polloptions[option].polloption));
            item.find(".ui-type-poll-txt-only").append(option+". "+decodeURI(pollOption.polloption));
		}
		item.removeAttr("hidden");
		pollList.append(item);
	}
	pollList.buttonset();


	if(isMultiSelected){
		pollList.find(":checkbox").bind("change",function(){
			var size=$("ul.poll_list li:not(:hidden) div:not(:hidden) :checked").size();
			if(size==maxChoices){
				var uncheckeds=$(".poll_list li:not(:hidden) div:not(:hidden) input:not(:checked)");
				for(var i=0,size=uncheckeds.size();i<size;i++){
					uncheckeds.eq(i).attr("disabled","disabled");
				}
			}else{
				var uncheckeds=$(".poll_list li:not(:hidden) div:not(:hidden) input[disabled='disabled']");
				for(var i=0,size=uncheckeds.size();i<size;i++){
					uncheckeds.eq(i).removeAttr("disabled");
				}
			}
		});
	}
};


/**
 * 加载用户评论
 * @param JSON 评论JSON数据
 * @param isAppend 是否为分页评论
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

//刷新页面 回调android客户端中 @JavascriptInterface OnRefresh()方法
function onRefresh(JSON,joined,is2GOr3GLoadImgs){
	this.is2GOr3GLoadImgs=is2GOr3GLoadImgs;
	this.isLoadReplyOver=false;
	setThread(JSON);
	onLoadReply(JSON,false);
    var postlist=JSON.Variables.postlist;
    if(textIsNull(postlist)||postlist.length<2){
        $("div.p_vote.bg").attr("hidden","hidden");
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

/*@hidden*/function loadMore(){
	if(BRIDGE!==undefined){
		BRIDGE.callHandler("onLoadMore",null,null);
	}
}

/*@hidden*/function share(){
	if(BRIDGE!==undefined){
		BRIDGE.callHandler("onShare",null,null);
	}
}

/*@hidden*/function praise(){
	if(BRIDGE!==undefined){
		BRIDGE.callHandler("onPraise",null,null);
	}
}

/*@hidden*/function userInfo(authorid){
	if(BRIDGE!==undefined){
		BRIDGE.callHandler("onUserInfo",authorid,null);
	}
}

/**帖子点赞成功刷新赞的个数*/
function onPraiseSuccess(){
	var el=$(".content_box .P_share div span:eq(1)");
	el.html(parseInt(el.html())+1);
     $(".thread_details .P_share div a:eq(1) img").attr("src","praises.png");
}


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
 *回复用户评论成功刷新页面
 *@param JSON 页面最新数据
 *@param pid 回复id(锚点页面会自动滚动到最新的回复处)
 */

// 有修改 joined  这个参数闲置

function onDiscussSuccess(JSON,joined,is2GOr3GLoadImgs,pid){
	if (!textIsNull(JSON)){
        onRefresh(JSON,joined,is2GOr3GLoadImgs)
		if(!textIsNull(pid)){
			window.location.href="#rednet_anchor_id_"+pid;
		}
	}
}

/*@hidden*/function sendPoll(){
	var checks=$(".poll_list :checked");
	if(checks!==undefined){
		var values="";
		if(isMultiSelected){
			for(var i=0;i<checks.length;i++){
				values+=checks.eq(i).attr("value");
				if(i!=checks.length-1){
					values+="|";
				}
			}
		}else{
			values=checks.attr("value");
		}
		if(BRIDGE!==undefined){
			BRIDGE.callHandler("onSendPoll",values,null);
		}
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

//帖子其他操作事件
/*@hidden*/function threadOptionsClick(){
	if(BRIDGE!==undefined){
		BRIDGE.callHandler("onThreadOptionsClick",null,null);
	}
}

/*@hidden*/function textIsNull(strings){
	return strings===undefined||strings.length==0;
}

function test(){
	onRefresh(TEST_JSON,false);
}

var TEST_JSON={
    "Version": "4",
    "Charset": "UTF-8",
    "Variables": {
        "cookiepre": "31Iy_2132_",
        "auth": null,
        "saltkey": "a71EEGZ9",
        "member_uid": "0",
        "member_username": "",
        "member_avatar": "http://iwechat.pm.comsenz-service.com/uc_server/avatar.php?uid=0&size=small",
        "groupid": "7",
        "formhash": "83a2b85c",
        "ismoderator": "0",
        "readaccess": "1",
        "notice": {
            "newpush": "0",
            "newpm": "0",
            "newprompt": "0",
            "newmypost": "0"
        },
        "allowperm": {
            "allowpost": "0",
            "allowreply": "0",
            "uploadhash": "1f2f0af15dc975adf709295d0a563158"
        },
        "thread": {
            "tid": "46",
            "fid": "41",
            "posttableid": "0",
            "typeid": "2",
            "sortid": "0",
            "readperm": "0",
            "price": "0",
            "author": "国文",
            "authorid": "31",
            "subject": "我想投票",
            "dateline": "2015-5-18 18:43",
            "lastpost": "1438851727",
            "lastposter": "",
            "views": "3",
            "replies": "0",
            "displayorder": "0",
            "highlight": "0",
            "digest": "0",
            "rate": "0",
            "special": "1",
            "attachment": "0",
            "moderated": "0",
            "closed": "0",
            "stickreply": "0",
            "recommends": "1",
            "recommend_add": "1",
            "recommend_sub": "0",
            "heats": "1",
            "status": "0",
            "isgroup": "0",
            "favtimes": "0",
            "sharetimes": "0",
            "stamp": "-1",
            "icon": "-1",
            "pushedaid": "0",
            "cover": "0",
            "replycredit": "0",
            "relatebytag": "0",
            "maxposition": "0",
            "bgcolor": "",
            "comments": "0",
            "hidden": "0",
            "threadtable": "forum_thread",
            "threadtableid": "0",
            "posttable": "forum_post",
            "allreplies": "0",
            "is_archived": "",
            "archiveid": "0",
            "subjectenc": "%E6%88%91%E6%83%B3%E6%8A%95%E7%A5%A8",
            "short_subject": "我想投票",
            "starttime": "1431945819",
            "remaintime": "",
            "recommendlevel": "0",
            "heatlevel": "0",
            "relay": "0",
            "avatar": "http://iwechat.pm.comsenz-service.com/uc_server/avatar.php?uid=31&size=small",
            "ordertype": "0",
            "recommend": "0"
        },
        "fid": "41",
        "postlist": [
            {
                "pid": "91",
                "tid": "46",
                "first": "1",
                "author": "国文",
                "authorid": "31",
                "dateline": "2015-5-18 18:43:39",
                "message": "&amp;nbsp;",
                "anonymous": "0",
                "attachment": "0",
                "status": "0",
                "replycredit": "0",
                "position": "1",
                "username": "国文",
                "adminid": "1",
                "groupid": "1",
                "memberstatus": "0",
                "number": "1",
                "dbdateline": "1431945819",
                "avatar": "http://iwechat.pm.comsenz-service.com/uc_server/avatar.php?uid=31&size=small",
                "groupiconid": "admin",
				"attachlist": [
                    {
                        "attachurl": "http://iwechat.pm.comsenz-service.com/uc_server/avatar.php?uid=55&size=small",
                        "aid": "123"
                    },
					{
                        "attachurl": "http://iwechat.pm.comsenz-service.com/uc_server/avatar.php?uid=55&size=small",
                        "aid": "123"
                    }
                ]
            },
		 {
                "pid": "91",
                "tid": "46",
                "first": "1",
                "author": "国文",
                "authorid": "31",
                "dateline": "2015-5-18 18:43:39",
                "message": "motherfuckers",
                "anonymous": "0",
                "attachment": "0",
                "status": "0",
                "replycredit": "0",
                "position": "1",
                "username": "国文",
                "adminid": "1",
                "groupid": "1",
                "memberstatus": "0",
                "number": "1",
                "dbdateline": "1431945819",
                "avatar": "http://iwechat.pm.comsenz-service.com/uc_server/avatar.php?uid=31&size=small",
                "groupiconid": "admin",
				"attachlist": [
                    {
                        "attachurl": "http://iwechat.pm.comsenz-service.com/uc_server/avatar.php?uid=55&size=small",
                        "aid": "123"
                    },
					{
                        "attachurl": "http://iwechat.pm.comsenz-service.com/uc_server/avatar.php?uid=55&size=small",
                        "aid": "123"
                    }
                ]
            }
        ],
        "allowpostcomment": [
            "1",
            "2"
        ],
        "comments": [],
        "commentcount": [],
        "ppp": "10",
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
        "special_poll": {
            "polloptions": {
                "1": {
                    "polloptionid": "11",
                    "polloption": "我好想",
                    "votes": "1",
                    "width": "100%",
                    "percent": "100.00",
                    "color": "E92725",
                    "imginfo": []
                },
                "2": {
                    "polloptionid": "12",
                    "polloption": "我不想",
                    "votes": "0",
                    "width": "8px",
                    "percent": "0.00",
                    "color": "F27B21",
                    "imginfo": []
                },
                "3": {
                    "polloptionid": "13",
                    "polloption": "随便",
                    "votes": "0",
                    "width": "8px",
                    "percent": "0.00",
                    "color": "F2A61F",
                    "imginfo": []
                }
            },
            "expirations": "1432032219",
            "multiple": "0",
            "maxchoices": "1",
            "voterscount": "1",
            "visiblepoll": "0",
            "allowvote": "",
            "remaintime": "",
            "allowvotepolled": "1",
            "allowvotethread": "",
            "allwvoteusergroup": "0",
            "overt": "0"
        },
        "forum": {
            "password": "0"
        }
    }
};

var TEST_JSON_IMG={
    "Version": "4",
    "Charset": "UTF-8",
    "Variables": {
        "cookiepre": "31Iy_2132_",
        "auth": null,
        "saltkey": "tjA0BygX",
        "member_uid": "0",
        "member_username": "",
        "member_avatar": "http://iwechat.pm.comsenz-service.com/uc_server/avatar.php?uid=0&size=small",
        "groupid": "7",
        "formhash": "a879808d",
        "ismoderator": "0",
        "readaccess": "1",
        "notice": {
            "newpush": "0",
            "newpm": "0",
            "newprompt": "0",
            "newmypost": "0"
        },
        "allowperm": {
            "allowpost": "0",
            "allowreply": "0",
            "uploadhash": "1f2f0af15dc975adf709295d0a563158"
        },
        "thread": {
            "tid": "120",
            "fid": "41",
            "posttableid": "0",
            "typeid": "0",
            "sortid": "0",
            "readperm": "0",
            "price": "0",
            "author": "fuwei111",
            "authorid": "55",
            "subject": "再来一次！",
            "dateline": "2015-7-4 15:49",
            "lastpost": "1438851895",
            "lastposter": "fuwei111",
            "views": "10",
            "replies": "0",
            "displayorder": "0",
            "highlight": "0",
            "digest": "0",
            "rate": "0",
            "special": "1",
            "attachment": "0",
            "moderated": "0",
            "closed": "0",
            "stickreply": "0",
            "recommends": "1",
            "recommend_add": "1",
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
            "maxposition": "0",
            "bgcolor": "",
            "comments": "0",
            "hidden": "0",
            "threadtable": "forum_thread",
            "threadtableid": "0",
            "posttable": "forum_post",
            "allreplies": "0",
            "is_archived": "",
            "archiveid": "0",
            "subjectenc": "%E5%86%8D%E6%9D%A5%E4%B8%80%E6%AC%A1%EF%BC%81",
            "short_subject": "再来一次！",
            "starttime": "1435996144",
            "remaintime": "",
            "recommendlevel": "0",
            "heatlevel": "0",
            "relay": "0",
            "avatar": "http://iwechat.pm.comsenz-service.com/uc_server/avatar.php?uid=55&size=small",
            "ordertype": "0",
            "recommend": "0"
        },
        "fid": "41",
        "postlist": [
            {
                "pid": "255",
                "tid": "120",
                "first": "1",
                "author": "fuwei111",
                "authorid": "55",
                "dateline": "2015-7-4 15:49:04",
                "message": "11111111111111<br />\r\n",
                "anonymous": "0",
                "attachment": "0",
                "status": "0",
                "replycredit": "0",
                "position": "1",
                "username": "fuwei111",
                "adminid": "1",
                "groupid": "1",
                "memberstatus": "0",
                "number": "1",
                "dbdateline": "1435996144",
                "avatar": "http://iwechat.pm.comsenz-service.com/uc_server/avatar.php?uid=55&size=small",
                "groupiconid": "admin"
            }
        ],
        "allowpostcomment": [
            "1",
            "2"
        ],
        "comments": [],
        "commentcount": [],
        "ppp": "10",
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
        "special_poll": {
            "polloptions": {
                "1": {
                    "polloptionid": "46",
                    "polloption": "aaaaaa",
                    "votes": "0",
                    "width": "8px",
                    "percent": "0.00",
                    "color": "E92725",
                    "imginfo": {
                        "aid": "4",
                        "poid": "46",
                        "tid": "120",
                        "pid": "255",
                        "uid": "55",
                        "filename": "鲨鱼.jpg",
                        "filesize": "136386",
                        "attachment": "201507/04/154844u20r2ogh4rfuuud2.jpg",
                        "remote": "0",
                        "width": "794",
                        "thumb": "1",
                        "dateline": "1435996124",
                        "small": "data/attachment/forum/201507/04/154844u20r2ogh4rfuuud2.jpg.thumb.jpg",
                        "big": "data/attachment/forum/201507/04/154844u20r2ogh4rfuuud2.jpg"
                    }
                },
                "2": {
                    "polloptionid": "47",
                    "polloption": "bbbbbbb",
                    "votes": "0",
                    "width": "8px",
                    "percent": "0.00",
                    "color": "F27B21",
                    "imginfo": {
                        "aid": "5",
                        "poid": "47",
                        "tid": "120",
                        "pid": "255",
                        "uid": "55",
                        "filename": "鲨鱼.jpg",
                        "filesize": "136386",
                        "attachment": "201507/04/154848qc77077277zdg21f.jpg",
                        "remote": "0",
                        "width": "794",
                        "thumb": "1",
                        "dateline": "1435996128",
                        "small": "data/attachment/forum/201507/04/154848qc77077277zdg21f.jpg.thumb.jpg",
                        "big": "data/attachment/forum/201507/04/154848qc77077277zdg21f.jpg"
                    }
                },
                "3": {
                    "polloptionid": "48",
                    "polloption": "ccccccc",
                    "votes": "0",
                    "width": "8px",
                    "percent": "0.00",
                    "color": "F2A61F",
                    "imginfo": {
                        "aid": "6",
                        "poid": "48",
                        "tid": "120",
                        "pid": "255",
                        "uid": "55",
                        "filename": "鲨鱼.jpg",
                        "filesize": "136386",
                        "attachment": "201507/04/154852c1uws23cws5uwzwc.jpg",
                        "remote": "0",
                        "width": "794",
                        "thumb": "1",
                        "dateline": "1435996132",
                        "small": "data/attachment/forum/201507/04/154852c1uws23cws5uwzwc.jpg.thumb.jpg",
                        "big": "data/attachment/forum/201507/04/154852c1uws23cws5uwzwc.jpg"
                    }
                }
            },
            "expirations": "1436168944",
            "multiple": "0",
            "maxchoices": "1",
            "voterscount": "0",
            "visiblepoll": "0",
            "allowvote": "",
            "remaintime": "",
            "allowvotepolled": "1",
            "allowvotethread": "",
            "allwvoteusergroup": "0",
            "overt": "1"
        },
        "forum": {
            "password": "0"
        }
    }
};
