
'���ɲɼ�����
GLOBAL SUB task_view()
	'CAM_START(1)

	while(1)
		if (0 = grap_switch) then
			exit while
		endif
		
		CAM_GRAB(image)       '���ɲɼ�ģʽ�£��ɼ�һ֡ͼ��
		CAM_GRAB(image)       '���ɲɼ�ģʽ�£��ɼ�һ֡ͼ��
		'CAM_SETPARAM("TriggerSoftware", 0)		
		'CAM_GET(image,0)
		ZV_LATCH(image,0)     '���ɼ�ͼ����ʾ��ͼƬԪ����
	wend
	
	'CAM_STOP()
END

	
'HMI���水��ɨ�������ť��Ӧ�ĺ���
GLOBAL SUB scan_all_cams()

	
	'ɨ�����
	CAM_SCAN("mvision")     'ɨ�躣�������
	                         'ɨ�����Ͱ���"mvision","basler","mindvision","huaray","aravis"��tis���ȶ�������
	
	cam_num = CAM_COUNT()
	                         '��ӡɨ�����״̬���
	if (0 = cam_num) then
		? "δ�ҵ����"	
		return
	endif
	
	    ?"���������" cam_num
		'*************��ʼ���������*********************
	    CAM_SEL(0)              'ѡ���һ�����
		
		
	'*************������ʼ�����*********************

END SUB

'HMI���水�����ɲɼ���ť��Ӧ�ĺ���
GLOBAL SUB btn_con_grap()
  if(grap_switch=1) then   '����Ѿ������ɲɼ�״̬����ӡ��ʾ��Ϣ
    ?"�������ɲɼ��У������ظ�����"
    return     
  endif
  
  if (cam_num=0) then        '���û��ɨ���������ʾ��ɨ�����
     ?"����ɨ�����"
     return
  endif
    
  '*************��ʼ���������*********************
	
    CAM_SEL(0)           'ѡ���һ�����
   ?"ѡ���һ�����"
   
    CAM_SETMODE(-1)      'ѡ�����Ϊ���ɲɼ�ģʽ
	'CAM_SETMODE(0)      'ѡ�����Ϊ�����ɼ�ģʽ
	?"���ɲɼ�ģʽ"
   CAM_SETEXPOSURE(d_cam_expostime)				 '�����ع�ʱ��
   CAM_SETPARAM("Width", "1920")
   CAM_SETPARAM("Height", "1080")
   ?"�����ع�ʱ��"
   
  '*************������ʼ�����*********************
    
    grap_switch=1          '���ɲɼ�״̬��1������ѭ���ɼ�����
    
    if (1 = grap_switch) then
	  
      if (0 = PROC_STATUS(grab_task_id)) then
        RUNTASK grab_task_id,task_view		'������������
      endif
    endif    
END SUB


'HMI���水��ֹͣ�ɼ���ťʱ��Ӧ�ĺ���
GLOBAL SUB btn_stop_grab()

     if(grap_switch = 0)then 
	 ?"δ���������ɼ�"
	 return 
	 endif
	 
	 grap_switch = 0
	 
END SUB

'HMI���水�����������ťʱ��Ӧ�ĺ���
GLOBAL SUB btn_softtrigger()

   
	
	if (0 = cam_num) then
		? "δ�ҵ����"
		return
	endif
	
	CAM_SEL(0)				             'ѡ�����id����ʵ��ʹ����ֻ��Ҫ��ʼ��һ�� 
	
    CAM_SETMODE(0)				         '�������Ϊ�����ɼ�ģʽ����ʵ��ʹ����ֻ��Ҫ��ʼ��һ��
    CAM_START(0)				         '�����������ʵ��ʹ����ֻ��Ҫ��ʼ��һ��
	
    CAM_SETPARAM("TriggerSoftware", 0)	 '���������ź�
    CAM_GET(image, 0)			         '��ȡ���������ָ�� id ���Ϊ 0 ��ͼ��
    ZV_LATCH(image, 0)			         '��ʾͼ��

END SUB

'HMI���水��Ӳ��������ťʱ��Ӧ�ĺ���
GLOBAL SUB btn_line0trigger()
    
	
	if (0 = cam_num) then
		? "δ�ҵ����"
		return
	endif
	
	CAM_SEL(0)				               'ѡ�����id ����ʵ��ʹ����ֻ��Ҫ��ʼ��һ��
    CAM_SETMODE(1)				           '�������ΪӲ�������ɼ�ģʽ����ʵ��ʹ����ֻ��Ҫ��ʼ��һ��
	CAM_SETPARAM("TriggerActivation",1)   '������������½��ش����ź���Ч����ʵ��ʹ����ֻ��Ҫ��ʼ��һ��
    CAM_START(0)				           '�����������ʵ��ʹ����ֻ��Ҫ��ʼ��һ��
    

    MOVE_OP(0,ON)   
    MOVE_OP(0,OFF)                        '������OUT0����½����ź�

    CAM_GET(image, 0)			           '��ȡ���������ָ�� id ���Ϊ 0 ��ͼ��
    ZV_LATCH(image, 0)			           '��ʾͼ��

END SUB

'HMI���水��������ð�ťʱ��Ӧ�ĺ���
GLOBAL SUB btn_set_expostime()

   if (grap_switch=1) then               '�����������ǰ��Ҫֹͣ����ɼ�
        ?"����ֹͣ����ɼ�"
		return 
	endif
	
   HMI_SHOWWINDOW(11)                     '���������ع�ʱ�䴰��
   
END SUB

'�����ع�ʱ����水��ȷ����ť
GLOBAL SUB btn_confirm()

   CAM_SETEXPOSURE(d_cam_expostime)        '�����ع�ֵ
   HMI_CLOSEWINDOW(11)                     '�ر����ô���
   
   ?"�ع�ʱ��"d_cam_expostime
   
   '***********��ʾ���ú��Ч��************************
  btn_con_grap
  
   
END SUB