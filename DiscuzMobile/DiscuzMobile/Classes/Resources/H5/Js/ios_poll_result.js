var HOST="http://iwechat.pm.comsenz-service.com/";
var isLoadReplyOver=false;//是否所有评论已加载完毕
var	is2GOr3GLoadImgs=true;//2/3G网络是否加载图片
var BRIDGE;

$(document).ready(function(){
	$("div.box03").bind("click",function(){threadOptionsClick();});
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
    
    var typeName;
    if (!textIsNull(JSON.Variables.thread.typeid)) {
        if(!textIsNull(JSON.Variables.forum.threadtypes)) {
            if(!textIsNull(JSON.Variables.forum.threadtypes.types[JSON.Variables.thread.typeid])) {
                typeName = "<a>[" + JSON.Variables.forum.threadtypes.types[JSON.Variables.thread.typeid] + "]</a>";
            }
        }
        
    }
    $("div.detailTit").html((typeName?typeName:"") + JSON.Variables.thread.subject);
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
    
    var timestamp = new Date().getTime().toString();
    timestamp = timestamp.substr(0,10);
    
    var selctNum = "单选投票:";
    if (JSON.Variables.special_poll.maxchoices > 1) {
        selctNum = "多选投票:(最多可选" + JSON.Variables.special_poll.maxchoices + "项),";
    }
    
    var voteStatus = selctNum + "共有";
    if (timestamp > JSON.Variables.special_poll.expirations) {
        var voteStatus = selctNum + "投票已结束,共有";
        
    } else {
        if (JSON.Variables.special_poll.allowvote != 1 && JSON.Variables.member_uid != 0) {
            $(".haveVote").removeAttr("hidden");
        }
        if (!textIsNull(JSON.Variables.special_poll.expirations) && !textIsNull(JSON.Variables.special_poll.remaintime)) {
            $(".vote_expirations").removeAttr("hidden");
            $(".vote_expirations").html("投票截止时间：" + formatDate(JSON.Variables.special_poll.expirations));
        }
    }
    
    if (JSON.Variables.special_poll.voterscount > 0 ) {
        $(".vote_tips").html(voteStatus+JSON.Variables.special_poll.voterscount+"人参加"
                             +"<a href='javascript:void(0)' onclick='voterDetails()' id='voters' style='color:#3278E6'>  查看参与投票的人</a>");
    } else {
        $(".vote_tips").html(voteStatus+JSON.Variables.special_poll.voterscount+"人参加");
    }
    
	
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
	
	if (!textIsNull(JSON.Variables.postlist)){
        
        var dateline = JSON.Variables.postlist[0].dateline;
        $(".P_figure .box03 label.p_date").html(dateline);
		$("p#thread_content img").css({"width":"0px","height":"0px"});
        $("p#thread_content").html(JSON.Variables.postlist[0].message);
		$("p#thread_content img").click(is2GOr3GLoadImgs?function(){threadThumbsClick($(this).attr("src"));}:null)
		.attr(is2GOr3GLoadImgs?"src":"hidden",is2GOr3GLoadImgs?$(this).attr("src"):"hidden")
		.css({"width":"auto","height":"auto"})
        .error(function(){$(this).attr('src', "load_error.png");});
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
		$(".thread_details .attachlist img").click(is2GOr3GLoadImgs?function(){threadThumbsClick($(this).attr("src"));}:null)
		.attr(is2GOr3GLoadImgs?"src":"hidden",is2GOr3GLoadImgs?$(this).attr("src"):"hidden")
		.css({"width":"auto","height":"auto"})
        .error(function(){$(this).attr('src', "load_error.png");});
	}
	var pollResultList=$("ul.poll_result");
	for(option in JSON.Variables.special_poll.polloptions){
		var pollOption=JSON.Variables.special_poll.polloptions[option];
		var imgPid=pollOption.imginfo.pid;
		var item=pollResultList.find("li:first").clone();
		if(imgPid!==undefined&&imgPid.length>0){
			item.find(".ui-poll-img").removeAttr("hidden");
            item.find(".ui-poll-img img").attr("src",pollOption.imginfo.small).attr("zoomfile",pollOption.imginfo.big)
            .attr(is2GOr3GLoadImgs?"src":"hidden",is2GOr3GLoadImgs?$(this).attr("src"):"hidden")
            .error(function(){$(this).attr('src', "load_error.png");});
            item.find(".ui-poll-img img").click(is2GOr3GLoadImgs?function(){threadThumbsClick($(this).attr("zoomfile"));}:null);
		}
		item.find("label").html(option+". "+decodeURI(pollOption.polloption));
		item.find(".ui-poll-progressbar").css("width",parseInt(pollOption.width)*2)//
			.progressbar({max:100,value:100});
		item.find("span").html(pollOption.percent+"%")
			.css("left",parseInt(pollOption.width)*2)
			.css("top",-17)
			.css("color","#"+pollOption.color);
		item.find(".ui-progressbar-value").css("background-color","#"+pollOption.color);
		item.removeAttr("hidden");
		pollResultList.append(item);
	}
}


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

function onRefresh(JSON,joined,is2GOr3GLoadImgs){
	this.is2GOr3GLoadImgs=is2GOr3GLoadImgs;
	this.isLoadReplyOver=false;
	setThread(JSON);
	onLoadReply(JSON,false);
    var postlist=JSON.Variables.postlist;
    if(textIsNull(postlist)||postlist.length<2){
        $("div.bg").attr("hidden","hidden");
    }
}

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

//查看大图
/*@hidden*/function threadThumbsClick(url){
    if (url.indexOf("smiley") != -1) {
        return;
    }
	if(BRIDGE!==undefined){
		BRIDGE.callHandler("onThreadThumbsClicked",url,null);
	}
}

/*@hidden*/function threadOptionsClick(){
	if(BRIDGE!==undefined){
		BRIDGE.callHandler("onThreadOptionsClick",null,null);
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

function onPraiseSuccess(){
	var el=$(".content_box .P_share div span:eq(1)");
	el.html(parseInt(el.html())+1);
    $(".thread_details .P_share div a:eq(1) img").attr("src","praises.png");
}

/*@hidden*/function share(){
	if(BRIDGE!==undefined){
		BRIDGE.callHandler("onShare",null,null);
	}
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

function onDiscussSuccess(JSON,joined,is2GOr3GLoadImgs,pid){
	if (!textIsNull(JSON)){
         onRefresh(JSON,joined,is2GOr3GLoadImgs);
		if(!textIsNull(pid)){
			window.location.href="#rednet_anchor_id_"+pid;
		}
	}
}

//产看参与投票的人
/*@hidden*/function voterDetails(){
	if(BRIDGE!==undefined){
		BRIDGE.callHandler("onVisitVoters",null,null);
	}
}

/*@hidden*/function textIsNull(strings){
	return strings===undefined||strings.length==0;
}

function test(){
	//onRefresh(TEST_JSON_IMG);
	onRefresh(TEST_JSON_TXT,false);
}

var TEST_JSON_TXT={
    "Version": "4",
    "Charset": "UTF-8",
    "Variables": {
        "cookiepre": "31Iy_2132_",
        "auth": "0430Xs3qnMekTvY7NpYavLV7N2IK1Y9lZObldo/+LhIsz2VWvVHmcQIg7LTg7xI/cnLWLB70s30m+naL8h2BOg",
        "saltkey": "pB5rBR5O",
        "member_uid": "55",
        "member_username": "fuwei111",
        "member_avatar": "http://iwechat.pm.comsenz-service.com/uc_server/avatar.php?uid=55&size=small",
        "groupid": "1",
        "formhash": "c4b9e36f",
        "ismoderator": "1",
        "readaccess": "200",
        "notice": {
            "newpush": "0",
            "newpm": "0",
            "newprompt": "0",
            "newmypost": "1"
        },
        "allowperm": {
            "allowpost": "1",
            "allowreply": "1",
            "allowupload": {
                "jpg": "-1",
                "jpeg": "-1",
                "gif": "-1",
                "png": "-1",
                "mp3": "-1",
                "txt": "-1",
                "zip": "-1",
                "rar": "-1",
                "pdf": "-1"
            },
            "attachremain": {
                "size": "-1",
                "count": "-1"
            },
            "uploadhash": "6cf911c08819d4377925e2c30a99accb"
        },
        "thread": {
            "tid": "162",
            "fid": "41",
            "posttableid": "0",
            "typeid": "0",
            "sortid": "0",
            "readperm": "0",
            "price": "0",
            "author": "fuwei111",
            "authorid": "55",
            "subject": "不在家这",
            "dateline": "2015-7-23 16:30",
            "lastpost": "1438245012",
            "lastposter": "fuwei111",
            "views": "127",
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
            "status": "1024",
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
            "subjectenc": "%E4%B8%8D%E5%9C%A8%E5%AE%B6%E8%BF%99",
            "short_subject": "不在家这",
            "starttime": "1437640203",
            "remaintime": [
                "33058",
                "3",
                "48",
                "14"
            ],
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
                "pid": "309",
                "tid": "162",
                "first": "1",
                "author": "fuwei111",
                "authorid": "55",
                "dateline": "2015-7-23 16:30:03",
                "anonymous": "0",
                "attachment": "0",
                "status": "8",
                "replycredit": "0",
                "position": "1",
                "username": "fuwei111",
                "adminid": "1",
                "groupid": "1",
                "memberstatus": "0",
                "number": "1",
                "dbdateline": "1437640203",
                "message": "Ti5 我想所有人都在期盼着东方神秘的力量 奶起来！！！",
                "avatar": "http://iwechat.pm.comsenz-service.com/uc_server/avatar.php?uid=55&size=small",
                "groupiconid": "admin",
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
                "groupiconid": "2"
            }
        ],
        "allowpostcomment": [
            "1",
            "2"
        ],
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
        "special_poll": {
            "polloptions": {
                "1": {
                    "polloptionid": "55",
                    "polloption": "患得患失姐姐",
                    "votes": "1",
                    "width": "33%",
                    "percent": "33.33",
                    "color": "E92725",
                    "imginfo": []
                },
                "2": {
                    "polloptionid": "56",
                    "polloption": "或者主持词",
                    "votes": "2",
                    "width": "67%",
                    "percent": "66.67",
                    "color": "F27B21",
                    "imginfo": []
                }
            },
            "expirations": "4294967295",
            "multiple": "1",
            "maxchoices": "2",
            "voterscount": "2",
            "visiblepoll": "0",
            "allowvote": "",
            "remaintime": [
                "33058",
                "3",
                "48",
                "14"
            ],
            "allowvotepolled": "",
            "allowvotethread": "1",
            "allwvoteusergroup": "1",
            "overt": "1",
            "isrunnig": "running"
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
        "auth": "0430Xs3qnMekTvY7NpYavLV7N2IK1Y9lZObldo/+LhIsz2VWvVHmcQIg7LTg7xI/cnLWLB70s30m+naL8h2BOg",
        "saltkey": "pB5rBR5O",
        "member_uid": "55",
        "member_username": "fuwei111",
        "member_avatar": "http://iwechat.pm.comsenz-service.com/uc_server/avatar.php?uid=55&size=small",
        "groupid": "1",
        "formhash": "c4b9e36f",
        "ismoderator": "1",
        "readaccess": "200",
        "notice": {
            "newpush": "0",
            "newpm": "0",
            "newprompt": "0",
            "newmypost": "1"
        },
        "allowperm": {
            "allowpost": "1",
            "allowreply": "1",
            "allowupload": {
                "jpg": "-1",
                "jpeg": "-1",
                "gif": "-1",
                "png": "-1",
                "mp3": "-1",
                "txt": "-1",
                "zip": "-1",
                "rar": "-1",
                "pdf": "-1"
            },
            "attachremain": {
                "size": "-1",
                "count": "-1"
            },
            "uploadhash": "6cf911c08819d4377925e2c30a99accb"
        },
        "thread": {
            "tid": "173",
            "fid": "41",
            "posttableid": "0",
            "typeid": "0",
            "sortid": "0",
            "readperm": "0",
            "price": "0",
            "author": "fuwei111",
            "authorid": "55",
            "subject": "1111111",
            "dateline": "2015-7-30 16:21",
            "lastpost": "1438742479",
            "lastposter": "fuwei111",
            "views": "4",
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
            "recommends": "0",
            "recommend_add": "0",
            "recommend_sub": "0",
            "heats": "0",
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
            "subjectenc": "1111111",
            "short_subject": "1111111",
            "starttime": "1438244465",
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
                "pid": "328",
                "tid": "173",
                "first": "1",
                "author": "fuwei111",
                "authorid": "55",
                "dateline": "6&nbsp;天前",
                "message": "111111111111<br />\r\n",
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
                "dbdateline": "1438244465",
                "avatar": "http://iwechat.pm.comsenz-service.com/uc_server/avatar.php?uid=55&size=small",
                "groupiconid": "admin"
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
                "groupiconid": "2"
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
                "groupiconid": "2"
            }
        ],
        "allowpostcomment": [
            "1",
            "2"
        ],
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
        "special_poll": {
            "polloptions": {
                "1": {
                    "polloptionid": "57",
                    "polloption": "1111111",
                    "votes": "1",
                    "width": "100%",
                    "percent": "100.00",
                    "color": "E92725",
                    "imginfo": {
                        "aid": "9",
                        "poid": "57",
                        "tid": "173",
                        "pid": "328",
                        "uid": "55",
                        "filename": "鲨鱼.jpg",
                        "filesize": "136386",
                        "attachment": "201507/30/162047oyvubv1vfj7vmtd7.jpg",
                        "remote": "0",
                        "width": "794",
                        "thumb": "1",
                        "dateline": "1438244447",
                        "small": "data/attachment/forum/201507/30/162047oyvubv1vfj7vmtd7.jpg.thumb.jpg",
                        "big": "data/attachment/forum/201507/30/162047oyvubv1vfj7vmtd7.jpg"
                    }
                },
                "2": {
                    "polloptionid": "58",
                    "polloption": "22222222",
                    "votes": "0",
                    "width": "8px",
                    "percent": "0.00",
                    "color": "F27B21",
                    "imginfo": {
                        "aid": "10",
                        "poid": "58",
                        "tid": "173",
                        "pid": "328",
                        "uid": "55",
                        "filename": "2012-11-04 124224.jpg",
                        "filesize": "1170882",
                        "attachment": "201507/30/162059agu5sn70nvc4cczq.jpg",
                        "remote": "0",
                        "width": "1536",
                        "thumb": "1",
                        "dateline": "1438244459",
                        "small": "data/attachment/forum/201507/30/162059agu5sn70nvc4cczq.jpg.thumb.jpg",
                        "big": "data/attachment/forum/201507/30/162059agu5sn70nvc4cczq.jpg"
                    }
                }
            },
            "expirations": "1438828887",
            "multiple": "0",
            "maxchoices": "1",
            "voterscount": "1",
            "visiblepoll": "0",
            "allowvote": "",
            "remaintime": "",
            "allowvotepolled": "",
            "allowvotethread": "1",
            "allwvoteusergroup": "1",
            "overt": "0",
            "isrunnig": "running"
        },
        "forum": {
            "password": "0"
        }
    }
};
