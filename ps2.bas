
global sub task_Ps2read()			'读取手柄参数
	PS2_init() '初始化手柄参数
	while 1	
		PS2_Read()
		task_Ps2read_flag = 1
		delay 2	
	wend
end sub


global sub PS2_init()

	setcom(115200,8,1,0,0,0,0,1000)	'设置串口0为RAW数据模式
	
	DIM tmp
	'配置SPI模式 03  速度100K(200K会出错)
	FOR i=0 TO 1                      '
		putchar #0,PS2_SPI(i)		 
	NEXT
	get #0, tmp
	'?tmp
	DELAY 10
	FOR i=2 TO 4                      '
		putchar #0,PS2_SPI(i)		 
	NEXT
	get #0, tmp
	'?tmp
	DELAY 10
	
	putchar #0,$43
	get #0, tmp
	'?tmp
	get #0, tmp
	'?tmp
	DELAY 10
		
	'扫描
	FOR i=0 TO 9  
		putchar #0, PS2_scan(i)
	NEXT
	FOR i=0 TO 8
		get #0, tmp		
		RS232_rx(i) = tmp
		? "rec",i,RS232_rx(i)
	NEXT
	DELAY 10
	
	'FOR i=0 TO 5  
	'	putchar #0,PS2_lx1(i)'进入配置模式
	'NEXT
	'DELAY 10
	'FOR i=0 TO 9
	'	putchar #0,PS2_lx2(i)' 设置模式
	'NEXT
	'DELAY 10
	'FOR i=0 TO 9
	'	putchar #0,PS2_lx3(i)' 设置字节长度
	'NEXT
	'DELAY 10
	'FOR i=0 TO 9
	'	putchar #0,PS2_lx4(i)'退出配置模式
	'NEXT
	'DELAY 10
	

end sub

global sub PS2_Read()
	DIM funbtn
	
	setcom(115200,8,1,0,0,0,0,1000)	'设置串口0为RAW数据模式
	
	'配置SPI 速度100K(200K会出错)
	FOR i=2 TO 4                      '
		putchar #0,PS2_SPI(i)		 
	NEXT
	get #0, tmp
	'?tmp
	DELAY 2
	
	'扫描 
	FOR i=0 TO 9  
		putchar #0, PS2_scan(i)
	NEXT
	FOR i=0 TO 8
		get #0, tmp
		RS232_rx(i) = tmp
	NEXT
	
	DIM tmp
	FOR i=0 TO 7                      '高低位互换
		if((RS232_rx(3) AND (1 << i)) = 0) THEN
			tmp = tmp AND NOT(1 << (7-i))
		ELSE 
			tmp = tmp   OR (1 << (7-i))			
		end if
		 
	NEXT
	RS232_rx(3) = tmp
	
	FOR i=0 TO 7                      '高低位互换
		if((RS232_rx(4) AND (1 << i)) = 0) THEN
			tmp = tmp AND NOT(1 << (7-i))
		ELSE 
			tmp = tmp   OR (1 << (7-i))			
		end if
		 
	NEXT
	RS232_rx(4) = tmp
	
	FOR i=0 TO 7                      '高低位互换
		if((RS232_rx(5) AND (1 << i)) = 0) THEN
			tmp = tmp AND NOT(1 << (7-i))
		ELSE 
			tmp = tmp   OR (1 << (7-i))			
		end if
		 
	NEXT
	RS232_rx(5) = tmp
	
	FOR i=0 TO 7                      '高低位互换
		if((RS232_rx(6) AND (1 << i)) = 0) THEN
			tmp = tmp AND NOT(1 << (7-i))
		ELSE 
			tmp = tmp   OR (1 << (7-i))			
		end if
		 
	NEXT
	RS232_rx(6) = tmp
	
	FOR i=0 TO 7                      '高低位互换
		if((RS232_rx(7) AND (1 << i)) = 0) THEN
			tmp = tmp AND NOT(1 << (7-i))
		ELSE 
			tmp = tmp   OR (1 << (7-i))			
		end if
		 
	NEXT
	RS232_rx(7) = tmp
	
	FOR i=0 TO 7                      '高低位互换
		if((RS232_rx(8) AND (1 << i)) = 0) THEN
			tmp = tmp AND NOT(1 << (7-i))
		ELSE 
			tmp = tmp   OR (1 << (7-i))			
		end if
		 
	NEXT
	RS232_rx(8) = tmp
	
	
	funbtn = (RS232_rx(4) << 8) | RS232_rx(3)
	if(RS232_rx(1) <> 206) THEN
		PS2_ems = 0
		PS2_run = 0
		M_stop()
		B_stop()
		? "请检查手柄连接和配置:" RS232_rx(1),RS232_rx(2)
		RETURN
	ELSE
		? "mode head206:" RS232_rx(1),RS232_rx(2)
	endif
	
	
	PS2_FunBtn = funbtn
	PS2_X1 = RS232_rx(7)
	PS2_Y1 = RS232_rx(8)
	PS2_X2 = RS232_rx(5)
	PS2_Y2 = RS232_rx(6)
	
	? "摇杆L:" PS2_X1,PS2_Y1,"摇杆R:" PS2_X2,PS2_Y2
			
	'?"遥控按键：" PS2_FunBtn
	
	'解析遥控指令
	if (PS2_FunBtn AND PSB_RED) = 0 THEN ' 急停
		PS2_ems = 1
		? "遥控指令：EMS!!!!"
	end if
	
	if (PS2_FunBtn AND PSB_GREEN) = 0 THEN ' 钢刷速度切换
		sw_speed_cnt_b = sw_speed_cnt_b + 1
		if sw_speed_cnt_b = Sw_speed_time_b then
			? "钢刷速度切换"
			if brush_speed = brush_speed_f THEN
				brush_speed = brush_speed_s
			ELSE
				brush_speed = brush_speed_f
			end if
		end if
	ELSE
		sw_speed_cnt_b = 0
	end if
	
	if (PS2_FunBtn AND PSB_PINK) = 0 THEN ' 运动速度切换
		sw_speed_cnt_m = sw_speed_cnt_m + 1
		if sw_speed_cnt_m = Sw_speed_time_m then
			? "运动速度切换"
			if MOVE_speed_ratio = MOVE_speed_f_r THEN
				MOVE_speed_ratio = MOVE_speed_s_r
			ELSE
				MOVE_speed_ratio = MOVE_speed_f_r
			end if
		end if
	ELSE
		sw_speed_cnt_m = 0
	end if
	
	if (PS2_FunBtn AND PSB_BLUE) = 0 THEN ' 钢刷启动/停止
		PS2_run = 1	
		? "遥控指令：RUN"
	ELSE
		PS2_run = 0
		'B_stop()
	end if
			
	if (PS2_Y1 < 5 ) AND (PS2_X1 > 80) AND (PS2_X1 < 180) THEN	  '前
		? "front"
	elseif (PS2_Y1 > 230) AND (PS2_X1 > 80) AND (PS2_X1 < 180) THEN  '后													  
			 ? "back" 
	elseif (PS2_X1 < 5) AND (PS2_Y1 > 80) AND (PS2_Y1 < 180)  THEN  '左转
			 ? "left"
	elseif (PS2_X1 > 230) AND (PS2_Y1 > 80) AND (PS2_Y1 < 180) THEN '右转
			 ? "right"
	end if
	
	if (PS2_Y1 < 100 ) OR (PS2_Y1 > 148 ) or (PS2_X1 < 100 ) or (PS2_X1 > 148 ) then
		wheel_speed_l =  ((PS2_Y1-128) + (PS2_X1-128)*50/128)/MOVE_speed_ratio'
		wheel_speed_r = ((PS2_Y1-128) - (PS2_X1-128)*50/128)/MOVE_speed_ratio	'轮毂控制速度
		'wheel_speed_l =  ((PS2_Y1-128) - ABS(PS2_X1-128)*50/128  +(PS2_X1-128)*30/128)/MOVE_speed_ratio'
		'wheel_speed_r = ((PS2_Y1-128) - ABS(PS2_X1-128)*50/128 -(PS2_X1-128)*30/128)/MOVE_speed_ratio	'轮毂控制速度
		if distance_f =  1  then
			if  wheel_speed_l < 0 then   
				wheel_speed_l = 0 
			end if			
			if  wheel_speed_r < 0 then   
				wheel_speed_r = 0 
			end if
		end if	
		if distance_b  =  1 then		
			if  wheel_speed_l > 0 then  			 
				wheel_speed_l = 0 
			end if
			if  wheel_speed_r > 0 then   
				wheel_speed_r = 0 
			end if
		end if
		if distance_l  =  1 then
		'	wheel_speed_l = 0
		'	wheel_speed_r = 0
		end if
		
		if distance_r  =  1 then
		'	wheel_speed_l = 0
		'	wheel_speed_r = 0
		end if	
		'wheel_speed_l =30
		'wheel_speed_r =30
		? "实时速度rpm"wheel_speed_l,wheel_speed_r
		M_start_B_stop()
		? "遥控指令：Move"
	else
		wheel_speed_l=0
		wheel_speed_r=0
		M_stop()		
	end if
	
	if PS2_run = 1 then
			B_start_M_stop()
			'? "遥控指令：b start"
		else 
			B_stop()
		end if	
		
	delay 2
end sub


global sub B_start_M_stop()	 '		
		delay 1
		if global_ems = 0 THEN
			'wheel_cmd = 0	'move  stop	
			brush_cmd = 1  	'brush  start
			''? "遥控指令：b start2"
			
		end if
		delay 1
		
end sub

global sub M_start_B_stop()	 '				
		delay 1
		if global_ems = 0 THEN
			'brush_cmd = 0 	'brush stop	
			wheel_cmd = 1 	'move start
			
		end if
		delay 1
end sub

global sub M_stop()	 '				
		delay 1
		wheel_cmd = 0 	'move stop
		delay 1
end sub

global sub B_stop()	 '				
		delay 1
		brush_cmd = 0 	'brush stop
		delay 1
end sub