#!/usr/bin/env perl
use Mojo::Webqq;
my $qq = 1370829148;    #修改为你自己的实际QQ号码


my $client = Mojo::Webqq->new(
	ua_debug => 0,
	log_level => "info",
	qq=>$qq,
);

$client->on(
	input_qrcode=>sub{    
		my($client,$qrcode_path) = @_;  
		qx#/bin/viewqr $qrcode_path;#});


$client->load("ShowMsg", data =>
	ban_group => ["579616959"],
);


#定时检查知识库变动，自动实时加载，插件中的check_time参数可以设置定时检测间隔
#$client->load("KnowledgeBase2", data=>{
#    # allow_group => ["225048267","Linux交流"],  #可选，允许插件的群，可以是群名称或群号码
#    #ban_group   => ["私人群",123456], #可选，禁用该插件的群，可以是群名称或群号码
#    # file => '~/.mojo/KnowledgeBase2.txt', #数据库保存路径，纯文本形式，可以编辑
#    file => '/home/Gabirel/.mojo/KnowledgeBase2.txt', #数据库保存路径，纯文本形式，可以编辑
#    learn_command  => 'learn',     #可选，自定义学习指令关键字
#    delete_command =>'del',      #可选，自定义删除指令关键字
#    learn_operator => ["1370829148"], #允许学习权限的操作人qq号
#    delete_operator => ["1370829148"], #允许删除权限的操作人qq号
#    mode => 'fuzzy', # fuzzy|regex|exact 分别表示模糊|正则|精确, 默认模糊
#    check_time => 10, #默认10秒检查一次文件变更
#    show_keyword => 1, #消息是否包含触发关键字信息，默认开启
#});


#对qq消息中出现的"大神"关键词进行鄙视
# $client->load("FuckDaShen");


$client->load("MobileInfo");


$client->load("Translation");

#群管理
#$client->load("GroupManage",data=>{ 
#    allow_group => ["PERL学习交流"],  #可选，允许插件的群，可以是群名称或群号码
#    ban_group   => ["498880156",123456], #可选，禁用该插件的群，可以是群名称或群号码
#    new_group_member => '嘛，有人加群了～～冷漠脸', #新成员入群欢迎语，%s会被替换成群成员名称
#    lose_group_member => '嘛，有人退群了，挺好', #成员离群提醒
#    speak_limit => {#发送消息频率限制
#        period          => 10, #统计周期，单位是秒
#        warn_limit      => 8, #统计周期内达到该次数，发送警告信息
#        warn_message    => '@%s 警告, 您发言过于频繁，可能会被禁言或踢出本群', #警告内容
#        shutup_limit    => 10, #统计周期内达到该次数，成员会被禁言
#        shutup_time     => 600, #禁言时长
#        #kick_limit      => 15,   #统计周期内达到该次数，成员会被踢出本群
#    },
#    pic_limit => {#发图频率限制
#        period          => 600,
#        warn_limit      => 6,
#        warn_message   => '@%s 警告, 您发图过多，可能会被禁言或踢出本群',
#        shutup_limit    => 8,
#        kick_limit      => 10,
#    },
#    keyword_limit => {
#        period=> 600,
#        keyword=>[qw(fuck 傻逼 你妹 滚)],
#        warn_limit=>3,
#        shutup_limit=>5,
#        #kick_limit=>undef,
#    },
#});

#$client->load("SmartReply",data=>{
#    apikey          => 'aed880dc9ce24942adc31d108ba0845d', #可选，参考http://www.tuling123.com/html/doc/apikey.html
#    #allow_group     => ["PERL学习交流"],  #可选，允许插件的群，可以是群名称或群号码
#    #ban_group       => ["私人群",123456], #可选，禁用该插件的群，可以是群名称或群号码
#    #ban_user        => ["坏蛋",123456], #可选，禁用该插件的用户，可以是用户的显示名称或qq号码
#    notice_reply    => ["放放酱现在不在家！sorry啦","放放酱粗去玩儿啦，拒绝被打扰哦～"], #可选，提醒时用语 notice_limit    => 8 ,  #可选，达到该次数提醒对话次数太多，提醒语来自默认或 notice_reply
#    warn_limit      => 10,  #可选,达到该次数，会被警告
#    #ban_limit       => 12,  #可选,达到该次数会被列入黑名单不再进行回复
#    period          => 600, #可选，限制周期，单位 秒
#    is_need_at      => 0,  #默认是1 是否需要艾特才触发回复
#    keyword         => [qw(人呢 放放酱 ai 1 a)], #触发智能回复的关键字，使用时请设置is_need_at=>0
#});


$client->load("ProgramCode");


#加载IRCShell插件
$client->load("IRCShell", data=>{
load_friend => 1,
master_irc_user => "1370829148",
image_api => "http://img.vim-cn.com",
auto_join_channel => 0,
}); 

$client->run();
