/**
 * [设置页面rem基准值] 使用此功能后，只用关注设计稿宽度时页面的情况，1rem = 100px，例如：width: 50px 等同于 width: 0.5rem;
 * @param {[type]} originalWidth [设计稿宽度]
 */
function setRem(originalWidth) {
	if(document.getElementById("setRem") === null) {
		var setRemStyle = document.createElement("style");
	    setRemStyle.id = "setRem";
	    setRemStyle.innerHTML = 'html{-webkit-text-size-adjust:none;-ms-text-size-adjust:none;-moz-text-size-adjust:none;text-size-adjust:none;font-size:'+ (100 / originalWidth) * document.documentElement.clientWidth +'px;}';
	    document.head.appendChild(setRemStyle);
	}
	 
	//浏览器尺寸变化时，修改rem基础值和重载css动画
	window.onresize = function() {
		document.getElementById("setRem").innerHTML = 'html{-webkit-text-size-adjust:none;-ms-text-size-adjust:none;-moz-text-size-adjust:none;text-size-adjust:none;font-size:'+ (100 / originalWidth) * document.documentElement.clientWidth +'px;}';
	}
}
setRem(750);

// 设置语音
function getAudio(data) {
    var audiolist = data.audiolist;
    for (var i in audiolist) {
        
        var audioUrl = audiolist[i].attachurl;;
        var description = audiolist[i].description;
        var audioStr = "<li>"+
        "<audio controls='controls' class='audio' src='"+audioUrl+"'></audio>"+
        "<div class='box'>"+
        "<span id='audioImg' class='audioPause'></span></span></div>"+
        "<span class='audioTxt'>" + description + "s'</span>"+
        "</div><li>";
        $(".thread_details .attachlist ul").append(audioStr);
        $(".thread_details .attachlist").removeAttr("hidden");
    }
}

// 语音点击事件
function audioAction() {
    
    var audioDom = $('.audio');
    var boxDom = $('.box');
    var audioObj = $('.audioPause');
    boxDom.each(function(index, item) {
                
                setInterval(function(){
                            if(audioDom[index].ended){
                            audioObj.eq(index).removeClass('audioPlay');
                            }
                            },500);
                
                $(this).click(index, function() {
                              
                              if(audioDom[index].paused) {
                              audioDom[index].play();
                              for(var i = 0; i < audioDom.length; i++){
                              if(i != index){
                              audioDom[i].pause();
                              audioDom[i].currentTime = 0;
                              audioObj.eq(i).removeClass('audioPlay');
                              }
                              }
                              $(this).find(".audioPause").addClass('audioPlay');
                              }else {
                              audioDom[index].pause();
                              $(this).find(".audioPause").removeClass('audioPlay');
                              //初始化音频文件
                              audioDom[index].currentTime = 0;
                              }
                              })
                })
}

/**
 *用户浏览数处理
 *num就是帖子里面的views
 */
function numberFormat(num) {
    var i = num;
    if (i >= 10000) {
        i = formatDecimal(num / 10000, 1) + '万';
//        i = toDecimal(parseFloat(num / 10000)) + '万'
    }
    return i
}

// 不四舍五入
function formatDecimal(num, decimal) {
    num = num.toString()
    let index = num.indexOf('.')
    if (index !== -1) {
        num = num.substring(0, decimal + index + 1)
    } else {
        num = num.substring(0)
    }
    return parseFloat(num).toFixed(decimal)
}

// 四舍五入
function toDecimal(x) {
    var f = parseFloat(x);
    if (isNaN(f)) {
        return;
    }
    f = Math.round(x*10)/10;
    return f;
}

// 格式化时间
function formatDate(nS) {
    return  new Date(parseInt(nS) * 1000).toLocaleString().replace(/:\d{1,2}$/,' ');
}
