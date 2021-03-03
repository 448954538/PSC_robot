
'自由采集任务
GLOBAL SUB task_view()
	'CAM_START(1)

	while(1)
		if (0 = grap_switch) then
			exit while
		endif
		
		CAM_GRAB(image)       '自由采集模式下，采集一帧图像
		CAM_GRAB(image)       '自由采集模式下，采集一帧图像
		'CAM_SETPARAM("TriggerSoftware", 0)		
		'CAM_GET(image,0)
		ZV_LATCH(image,0)     '将采集图像显示到图片元件中
	wend
	
	'CAM_STOP()
END

	
'HMI界面按下扫描相机按钮响应的函数
GLOBAL SUB scan_all_cams()

	
	'扫描相机
	CAM_SCAN("mvision")     '扫描海康相机，
	                         '扫描类型包括"mvision","basler","mindvision","huaray","aravis"“tis”等多种类型
	
	cam_num = CAM_COUNT()
	                         '打印扫描相机状态结果
	if (0 = cam_num) then
		? "未找到相机"	
		return
	endif
	
	    ?"相机数量：" cam_num
		'*************初始化相机操作*********************
	    CAM_SEL(0)              '选择第一个相机
		
		
	'*************结束初始化相机*********************

END SUB

'HMI界面按下自由采集按钮响应的函数
GLOBAL SUB btn_con_grap()
  if(grap_switch=1) then   '如果已经在自由采集状态，打印提示信息
    ?"正在自由采集中，请勿重复操作"
    return     
  endif
  
  if (cam_num=0) then        '如果没有扫描相机，提示先扫描相机
     ?"请先扫描相机"
     return
  endif
    
  '*************初始化相机操作*********************
	
    CAM_SEL(0)           '选择第一个相机
   ?"选择第一个相机"
   
    CAM_SETMODE(-1)      '选择相机为自由采集模式
	'CAM_SETMODE(0)      '选择相机为软触发采集模式
	?"自由采集模式"
   CAM_SETEXPOSURE(d_cam_expostime)				 '设置曝光时间
   CAM_SETPARAM("Width", "1920")
   CAM_SETPARAM("Height", "1080")
   ?"设置曝光时间"
   
  '*************结束初始化相机*********************
    
    grap_switch=1          '自由采集状态置1，开启循环采集任务
    
    if (1 = grap_switch) then
	  
      if (0 = PROC_STATUS(grab_task_id)) then
        RUNTASK grab_task_id,task_view		'启动接受任务
      endif
    endif    
END SUB


'HMI界面按下停止采集按钮时响应的函数
GLOBAL SUB btn_stop_grab()

     if(grap_switch = 0)then 
	 ?"未开启连续采集"
	 return 
	 endif
	 
	 grap_switch = 0
	 
END SUB

'HMI界面按下软件触发按钮时响应的函数
GLOBAL SUB btn_softtrigger()

   
	
	if (0 = cam_num) then
		? "未找到相机"
		return
	endif
	
	CAM_SEL(0)				             '选择相机id，在实际使用中只需要初始化一次 
	
    CAM_SETMODE(0)				         '设置相机为软触发采集模式，在实际使用中只需要初始化一次
    CAM_START(0)				         '开启相机，在实际使用中只需要初始化一次
	
    CAM_SETPARAM("TriggerSoftware", 0)	 '发送软触发信号
    CAM_GET(image, 0)			         '获取相机缓存中指定 id 序号为 0 的图像
    ZV_LATCH(image, 0)			         '显示图像

END SUB

'HMI界面按下硬件触发按钮时响应的函数
GLOBAL SUB btn_line0trigger()
    
	
	if (0 = cam_num) then
		? "未找到相机"
		return
	endif
	
	CAM_SEL(0)				               '选择相机id ，在实际使用中只需要初始化一次
    CAM_SETMODE(1)				           '设置相机为硬件触发采集模式，在实际使用中只需要初始化一次
	CAM_SETPARAM("TriggerActivation",1)   '设置相机接收下降沿触发信号有效，在实际使用中只需要初始化一次
    CAM_START(0)				           '开启相机，在实际使用中只需要初始化一次
    

    MOVE_OP(0,ON)   
    MOVE_OP(0,OFF)                        '控制器OUT0输出下降沿信号

    CAM_GET(image, 0)			           '获取相机缓存中指定 id 序号为 0 的图像
    ZV_LATCH(image, 0)			           '显示图像

END SUB

'HMI界面按下相机设置按钮时响应的函数
GLOBAL SUB btn_set_expostime()

   if (grap_switch=1) then               '设置相机参数前需要停止相机采集
        ?"请先停止相机采集"
		return 
	endif
	
   HMI_SHOWWINDOW(11)                     '弹出设置曝光时间窗口
   
END SUB

'设置曝光时间界面按下确定按钮
GLOBAL SUB btn_confirm()

   CAM_SETEXPOSURE(d_cam_expostime)        '设置曝光值
   HMI_CLOSEWINDOW(11)                     '关闭设置窗口
   
   ?"曝光时间"d_cam_expostime
   
   '***********显示设置后的效果************************
  btn_con_grap
  
   
END SUB