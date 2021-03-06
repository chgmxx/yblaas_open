<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>QQ绑定</title>
    <link rel="stylesheet" href="/weui/css/weui.min.css">
    <link rel="stylesheet" href="/weui/css/jquery-weui.min.css">
    <meta name="viewport" content="initial-scale=1, maximum-scale=1">
    <meta name="apple-mobile-web-app-capable" content="yes">
    <meta name="apple-mobile-web-app-status-bar-style" content="black">
</head>
<body>
    <form id="my_qq">
        <div class="weui-cells weui-cells_form">
            <div class="weui-cell weui-cell_vcode">
                <div class="weui-cell__hd">
                    <label class="weui-label">学生QQ</label>
                </div>
                <div class="weui-cell__bd">
                    <input class="weui-input" type="tel" placeholder="请输入您的QQ号码" id="studentQq" name="studentQq" value="${(studentQq)!}">
                </div>
                <div class="weui-cell__ft">
                    <button class="weui-vcode-btn" onclick="sendQq();return false;" id="verification_button">获取验证码</button>
                </div>
            </div>
            <div class="weui-cell">
                <div class="weui-cell__hd"><label for="name" class="weui-label">验证码</label></div>
                <div class="weui-cell__bd">
                    <input class="weui-input" type="text" name="verification" placeholder="请输入4位验证码">
                </div>
            </div>
            <div class="weui-cells__tips">请绑定前先添加QQ:9999999</div>
            <div class="weui-cell">
                <img src="图片链接" alt="QQ-1二维码" width="200" height="240" align="bottom" />
            </div>
            <div class="weui-cells__tips">此QQ将用作与本系统的消息通知，请务必先加QQ再进行绑定操作。</div>
        </div>
        <div class="weui-btn-area">
            <button class="weui-btn weui-btn_primary">提交修改</button>
            <a href="/student/my_index" class="weui-btn weui-btn_default">取消</a>
        </div>
    </form>
    <script type="text/javascript" src="/weui/js/jquery.min.js"></script>
    <script type="text/javascript" src="/weui/js/jquery-weui.min.js"></script>
    <!-- 如果使用了某些拓展插件还需要额外的JS -->
    <script type="text/javascript" src="/weui/js/jquery-form.min.js"></script>

    <!--表单验证-->
    <script type="text/javascript" src="/hui/lib/jquery.validation/1.14.0/jquery.validate.js"></script>
    <script type="text/javascript" src="/hui/lib/jquery.validation/1.14.0/validate-methods.js"></script>
    <script type="text/javascript" src="/hui/lib/jquery.validation/1.14.0/messages_zh.js"></script>

    <script>
        var studentQq = "${(studentQq)!0}";
        //表单校验和提交
        $("#my_qq").validate({
            rules:{
                studentQq:{
                    required:true,
                    digits:true
                },
                verification:{
                    required:true,
                    range:[1000,9999]
                }
            },
            submitHandler:function(form){
                var sendstudentQq = $("#studentQq").val();
                if(sendstudentQq == studentQq){
                    $.toast("QQ没有更改", "forbidden");
                }else{
                    $.confirm("您确定要提交吗?", "确认提交", function() {
                        $(form).ajaxSubmit({
                            type: 'post',
                            url: "/student/my_data_qq_ajax",
                            dataTyep:"text",
                            success: function(data){
                                if(data=="success"){
                                    $.toast("修改成功", function() {
                                        window.location.replace("/student/my_index");
                                    });
                                }else{
                                    $.toast("验证码错误", "forbidden");
                                }
                            },
                            error: function(){
                                $.toast("服务器错误，请刷新尝试", "forbidden");
                            }
                        });
                    });
                }

            }
        });


        //验证码处理
        var InterValObj; //timer变量，控制时间
        var count = 60; //间隔函数，1秒执行
        var curCount;//当前剩余秒数
        function sendQq() {
            var sendstudentQq = $("#studentQq").val();
            if(sendstudentQq==""||sendstudentQq==null||sendstudentQq == studentQq){
                $.toast("QQ号码有误或者未变化", "forbidden");
            }else{
                curCount= count;
                //设置button效果，开始计时
                $("#verification_button").attr("disabled", "true");
                $("#verification_button").text("重新发送(" + curCount + ")");
                InterValObj = window.setInterval(SetRemainTime, 1000); //启动计时器，1秒执行一次
                //向后台发送处理数据
                $.ajax({
                    type: "POST",
                    url: "/public/user_send_qq",
                    data: {userQq:sendstudentQq},
                    dataType: "text",
                    success: function(data){
                        if(data=="success"){
                            $.toast("发送成功，半小时内有效");
                        }else{
                            $.toast("发送频率过快，请稍后", "forbidden");
                        }
                    },
                    error:function() { $.toast("服务器错误", "forbidden");}
                });
            }
        }

        //timer处理函数
        function SetRemainTime() {
            if (curCount == 0) {
                window.clearInterval(InterValObj);//停止计时器
                $("#verification_button").removeAttr("disabled");//启用按钮
                $("#verification_button").text("重新发送验证码");
            }
            else {
                curCount--;
                $("#verification_button").text("重新发送(" + curCount + ")");
            }
        }

    </script>
</body>
</html>