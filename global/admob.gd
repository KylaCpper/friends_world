extends Node
var admob = null
var is_real = false
var child_directed = false
var is_personalized = true
var max_ad_content_rate = "G"
var banner_on_top = true
var banner_id = "ca-app-pub-3940256099942544/6300978111"
var interstitial_id = "ca-app-pub-3940256099942544/1033173712"
var rewarded_id = "ca-app-pub-3940256099942544/5224354917" 
var call_obj = null
#ca-app-pub-3940256099942544/6300978111  banner
#ca-app-pub-3940256099942544/1033173712  插页式
#ca-app-pub-3940256099942544/8691691433	 插页式视频
#ca-app-pub-3940256099942544/5224354917  激励视频
#ca-app-pub-3940256099942544/2247696110  原生高级
#ca-app-pub-3940256099942544/1044960115  原生高级视频
var _is_interstitial_loaded = false 
var _is_rewarded_video_loaded = false
var _is_banner_loaded = false

func _ready():
	if(Engine.has_singleton("AdMob")):
		admob = Engine.get_singleton("AdMob")
		admob.initWithContentRating(
			is_real,
			get_instance_id(),
			child_directed,
			is_personalized,
			max_ad_content_rate
		)
		load_banner()
		load_interstitial()
		load_rewarded_video()
		get_tree().connect("screen_resized", self, "banner_resize")

# Loaders
func load_banner() -> void:
	if admob != null:
		admob.loadBanner(banner_id, banner_on_top)
		hide_banner()
func load_interstitial() -> void:
	if admob != null:
		admob.loadInterstitial(interstitial_id)
func load_rewarded_video() -> void:
	if admob != null:
		admob.loadRewardedVideo(rewarded_id)
# is load ?
func is_interstitial_loaded() -> bool:
	if admob != null:
		return _is_interstitial_loaded
	return false
func is_rewarded_video_loaded() -> bool:
	if admob != null:
		return _is_rewarded_video_loaded
	return false

# show / hide
func show_banner() -> void:
	if admob != null:
		admob.showBanner()
		
func hide_banner() -> void:
	if admob != null:
		admob.hideBanner()

func show_interstitial() -> void:
	if admob != null:
		if _is_interstitial_loaded:
			admob.showInterstitial()
			_is_interstitial_loaded = false
		
func show_rewarded_video() -> void:
	if admob != null:
		if _is_rewarded_video_loaded:
			admob.showRewardedVideo()
			_is_rewarded_video_loaded = false

# 调整横幅大小（例如在方向更改时很有用）
func banner_resize() -> void:
	if admob != null:
		admob.resize()

#获取当前横幅尺寸
# @return Vector2（宽度，高度）
func get_banner_dimension() -> Vector2:
	if admob != null:
		return Vector2(admob.getBannerWidth(), admob.getBannerHeight())
	return Vector2()

# callbacks
#banner加载ok
func _on_admob_ad_loaded() -> void:
	_is_banner_loaded = true
	
#banner加载失败
func _on_admob_banner_failed_to_load(error_code:int) -> void:
	_is_banner_loaded = false
	
#插屏广告加载ok
func _on_interstitial_loaded() -> void:
	_is_interstitial_loaded = true
#插屏广告加载失败
func _on_insterstitial_failed_to_load(error_code:int) -> void:
	_is_interstitial_loaded = false
#插屏广告关闭
func _on_interstitial_close() -> void:
	self.load_interstitial()
#激励视频加载ok
func _on_rewarded_video_ad_loaded() -> void:
	_is_rewarded_video_loaded = true
#激励视频广告加载失败
func _on_rewarded_video_ad_failed_to_load(error_code:int) -> void:
	_is_rewarded_video_loaded = false
#激励视频打开
func _on_rewarded_video_ad_opened() -> void:
	pass
#奖励视频开始播放
func _on_rewarded_video_started() -> void:
	pass
#激励视频关闭
func _on_rewarded_video_ad_closed() -> void:
	self.load_rewarded_video()
#观看了奖励视频广告并将奖励用户
# param字符串货币奖励项目描述，例如：硬币
#@ param int数量奖励项目数量
func _on_rewarded(currency:String, amount:int) -> void:
	if call_obj:
		call_obj._on_rewarded(currency,amount)
#用户已从奖励视频广告中退出了应用
func _on_rewarded_video_ad_left_application() -> void:
	pass

