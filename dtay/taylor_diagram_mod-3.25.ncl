function taylor_diagram (wks:graphic ,RATIO[*][*]:numeric, CC[*][*]:numeric \
                                     ,rOpts:logical)
local dimR, nCase, nVar, X, Y, nc, angle, xyMin, xyOne, ceil_max_val, xyMax, xyMax_Panel, \
      FontHeightF, rxy, tempo_values, tempo_values1, temp_string, temp1_string, temp_string_y, \
      temp_string_y1, npts, xx, yy, sLabels, cLabels, rad, angC, taylor, rsrRes, dum0, dum1, \
      dum2, nStnRad, rr, radC, xC, yC, txRes, dum4, plRes, tmEnd, radTM, xTM, yTM, dum5, dum6, \
      i, mTM, angmTM, radmTM, dum7, angRL, rlRes, dum8, xRL, yRL, respl, dx, ncon, npts, ang, dum9, \
      dist_n, Markers, Colors, gsRes, ptRes, markerTxYOffset, dum10, dum11,n, lgres, nModel, lbid, \
      amres, annoid1, nVar, varLabelsFontHeightF, txres, delta_y, ys, dum12 

; ==================================================================
begin
  dimR                  = dimsizes(RATIO)
  nCase                 = dimR(0)    ; # of cases [models] 
  nVar                  = dimR(1)    ; # of variables

                                     ; x/y coordinates for plotting
  X    = new ( (/nCase,nVar/) , typeof(RATIO) )
  Y    = new ( (/nCase,nVar/) , typeof(RATIO) )

  do nc=0,nCase-1
     angle      = acos( CC(nc,:) )   ; array operation                                    
     X(nc,:)    = RATIO(nc,:)*cos( angle )     
     Y(nc,:)    = RATIO(nc,:)*sin( angle )    
  end do

  xyMin                 = 0.
  xyOne                 = 1.00
  ;xyMax                 = 1.65
  xyMax                 = 2.50;1.65
  xyMax_Panel           = xyMax+ 0.10            ; paneling purposes

  if (rOpts .and. isatt(rOpts,"txFontHeightF"))  then
      FontHeightF       = rOpts@txFontHeightF    ; user wants to specify size
  else
      FontHeightF       = 0.0145;0.0175
  end if
 
; ----------------------------------------------------------------
; Part 1:
; base plot: Based upon request of Mark Stevens
; basic x-y and draw the 1.0 observed and the outer curve at 1.65
; ----------------------------------------------------------------
  
  rxy                   = True       
  rxy@gsnDraw           = False
  rxy@gsnFrame          = False
  rxy@vpHeightF         = 0.65
  rxy@vpWidthF          = 0.65
  rxy@tmYLBorderOn      = False
  rxy@tmXBBorderOn      = False

  rxy@tiYAxisString     = "Standardized Deviations(Normalized)"
  rxy@tiYAxisFontHeightF= FontHeightF                        ; default=0.025 
 
  ;rxy@tiXAxisString     = "Standardized Deviations*~C~     b) NORTHEAST(B4)"; (Normalized)"
  rxy@tiXAxisString     = "Standardized Deviations(Normalized)"
  rxy@tiXAxisFontHeightF= FontHeightF                        ; default=0.025
 
  rxy@tmXBMode          = "Explicit" 

  rxy@tmXBValues        = (/0.0,0.25,0.50,0.75,1.00,1.25,1.5,1.75,2.00,2.25/)
  rxy@tmXBLabels        = (/"    ","0.25","0.50","0.75","REF" ,"1.25","1.50","1.75","2.00","2.25"/)
  if (rOpts .and. isatt(rOpts,"OneX") )  then                     ; eg: rOpts@OneX="1.00"
      rxy@tmXBLabels        = (/"    ","0.25","0.50","0.75",rOpts@OneX,"1.25","1.50","1.75","2.00","2.25"/)
  end if

  rxy@tmXBMajorLengthF  = 0.015      ; default=0.02 for a vpHeightF=0.6
  rxy@tmXBLabelFontHeightF = FontHeightF
  rxy@tmXBMinorOn       = False
  rxy@trXMaxF           = xyMax_Panel

  rxy@tmYLMode          = "Manual"
  rxy@tmYLMinorOn       = False
  rxy@tmYLMajorLengthF  = rxy@tmXBMajorLengthF
  rxy@tmYLLabelFontHeightF = FontHeightF
  rxy@tmYLMode          = "Explicit" 
  rxy@tmYLValues        = (/0.0, .25,0.50, 0.75, 1.00, 1.25, 1.5,1.75,2.00,2.25/);,2.5/);,2.75,3.0,3.25/);,3.50/) ; major tm
  rxy@tmYLLabels        = (/"0.00","0.25","0.50","0.75","1.00","1.25","1.50","1.75","2.00","2.25"/);,"2.5"/)

  rxy@trYMaxF           = xyMax_Panel

  rxy@tmYRBorderOn      = False
  rxy@tmYROn            = False      ; Turn off right tick marks.

  rxy@tmXTBorderOn      = False
  rxy@tmXTOn            = False      ; Turn off right tick marks.

  rxy@tmXBMajorThicknessF = 0.5 
  rxy@tmXBMinorThicknessF = 0.5 
  rxy@tmYLMajorThicknessF = 0.5
  rxy@tmYLMinorThicknessF = 0.5

  rxy@xyDashPatterns    = (/ 0 /)    ; line characteristics (dash,solid)
  rxy@xyLineThicknesses = (/ 0.5/)    ; choose line thickness

  rxy@gsnFrame          = False      ; Don't advance the frame.

                                            ; create outer 'correlation axis'
  npts    = 200                        ; arbitrary
  xx      = fspan(xyMin,xyMax,npts) 
  yy      = sqrt(xyMax^2 - xx^2    )   ; outer correlation line (xyMax)


  sLabels = (/"0.0","0.1","0.2","0.3","0.4","0.5","0.6" \ ; correlation labels
             ,"0.7","0.8","0.9","0.95","0.99","1.0"     /); also, major tm
  cLabels = stringtofloat(sLabels)
  rad     = 4.*atan(1.0)/180.
  angC    = acos(cLabels)/rad                     ; angles: correlation labels
                                                                       
  if (rOpts .and. isatt(rOpts,"tiMainString")) then
      rxy@tiMainString      = rOpts@tiMainString
     ;rxy@tiMainOffsetYF    = 0.015               ; default  0.0
      if (isatt(rOpts,"tiMainFontHeightF")) then
           rxy@tiMainFontHeightF = rOpts@tiMainFontHeightF
      else
           rxy@tiMainFontHeightF = 0.0225         ; default  0.025              
      end if
  end if
;;if (rOpts .and. isatt(rOpts,"gsnCenterString")) then
;;    rxy@gsnCenterString  = rOpts@gsnCenterString      ; only gsn_csm_xy
;;end if

  taylor  = gsn_xy(wks,xx,yy,rxy)                 ; Create and draw XY plot.

  rsrRes  = True
  rsrRes@gsLineThicknessF  = rxy@xyLineThicknesses(0)  ; line thickness
  rsrRes@gsLineDashPattern = 0                    ; solid line pattern
                                                  ; draw x and y to xyMax
  dum0 = gsn_add_polyline(wks,taylor,(/0.,  0. /),(/0.,xyMax/), rsrRes)
  dum1 = gsn_add_polyline(wks,taylor,(/0.,xyMax/),(/0.,  0. /), rsrRes)

  xx   = fspan(xyMin, xyOne ,npts)                ; draw 1.0 standard radius
  yy   = sqrt(xyOne - xx^2)   
  rsrRes@gsLineDashPattern = 1                    ; dashed line pattern
  rsrRes@gsLineThicknessF  = 2;rxy@xyLineThicknesses(0)  ; line thickness
  dum2 = gsn_add_polyline(wks,taylor,xx,yy, rsrRes)
  delete(xx)
  delete(yy)
                                                  
  if (rOpts .and. isatt(rOpts,"stnRad") ) then
      rsrRes@gsLineThicknessF  = 2.;0.5   ; rxy@xyLineThicknesses(0)  
      nStnRad = dimsizes(rOpts@stnRad)

      dum3  = new(nStnRad,graphic)
      do n=0,nStnRad-1
         rr = rOpts@stnRad(n)
         xx = fspan(xyMin, rr ,npts) 
         yy = sqrt(rr^2   - xx^2)   
         dum3(n) = gsn_add_polyline(wks,taylor,xx,yy, rsrRes)
      end do
      taylor@$unique_string("dum")$ = dum3

      delete(xx)
      delete(yy)
  end if

  getvalues taylor                                ; get style info from taylor
    "tmYLLabelFont"        : tmYLLabelFont        ; use for correlation axis
    "tmYLLabelFontHeightF" : tmYLLabelFontHeightF
  end getvalues

; ----------------------------------------------------------------
; Part 2:
; Correlation labels
; ----------------------------------------------------------------
  radC    = xyMax                                  ; for correlation labels
  xC      = radC*cos(angC*rad)
  yC      = radC*sin(angC*rad)
; added to get some separation
  xC      = xC + 0.020*cos(rad*angC)
  yC      = yC + 0.060*sin(rad*angC)

  txRes               = True                      ; text mods desired
  txRes@txFontHeightF = FontHeightF               ; match YL 
  txRes@tmYLLabelFont = tmYLLabelFont             ; match YL
  txRes@txAngleF      = -45.
  if (.not.isatt(rOpts,"drawCorLabel") .or. rOpts@drawCorLabel) then 
      dum4 = gsn_add_text(wks,taylor,"Correlation",1.95,1.95,txRes)
	 taylor@$unique_string("dum")$ = dum4
  end if

  xRes               = True                      ; text mods desired
  xRes@txFontHeightF = FontHeightF               ; match YL
  xRes@txFontColor   = "grey50"
  xRes@tmYLLabelFont = tmYLLabelFont             ; match YL
  xRes@txAngleF      = -55.;-45.

  dum41 = gsn_add_text(wks,taylor,"URMSE*",1.25,0.15,xRes)
  taylor@$unique_string("dum")$ = dum41

  txRes@txAngleF      = 0.0 
  txRes@txFontHeightF = FontHeightF*0.50          ; bit smaller

;;dum0 = gsn_add_text(wks,taylor,"OBSERVED",1.00,0.075,txRes)

  plRes               = True
  plRes@gsLineThicknessF = 2.
  
  txRes@txJust        = "CenterLeft"              ; Default="CenterCenter".
  txRes@txFontHeightF = FontHeightF               ; match YL 

  tmEnd = 0.975
  radTM = xyMax*tmEnd                             ; radius end: major TM 
  xTM   = new( 2 , "float")
  yTM   = new( 2 , "float")

  dum5 = new(dimsizes(sLabels),graphic)
  dum6 = dum5

  do i=0,dimsizes(sLabels)-1                      ; Loop to draw strings
    txRes@txAngleF = angC(i)
    dum5(i) = gsn_add_text(wks, taylor, sLabels(i),xC(i),yC(i),txRes) ; cor label
    xTM(0)   = xyMax*cos(angC(i)*rad)             ; major tickmarks at
    yTM(0)   = xyMax*sin(angC(i)*rad)             ; correlation labels
    xTM(1)   = radTM*cos(angC(i)*rad)             
    yTM(1)   = radTM*sin(angC(i)*rad)
    plRes@gsLineThicknessF = 0.5
    plRes@gsLineThicknessF = 0.5
    dum6(i) = gsn_add_polyline(wks,taylor,xTM,yTM,plRes)
  end do
                                                  ; minor tm locations
  mTM     = (/0.05,0.15,0.25,0.35,0.45,0.55,0.65 \ 
             ,0.75,0.85,0.91,0.92,0.93,0.94,0.96,0.97,0.98  /)
  angmTM  = acos(mTM)/rad                         ; angles: correlation labels
  radmTM  = xyMax*(1.-(1.-tmEnd)*0.5)             ; radius end: minor TM 

  dum7 = new(dimsizes(mTM),graphic)

  do i=0,dimsizes(mTM)-1                          ; manually add tm
    xTM(0)   = xyMax*cos(angmTM(i)*rad)           ; minor tickmarks
    yTM(0)   = xyMax*sin(angmTM(i)*rad)
    xTM(1)   = radmTM*cos(angmTM(i)*rad)          
    yTM(1)   = radmTM*sin(angmTM(i)*rad)

    dum7(i)  = gsn_add_polyline(wks,taylor,xTM,yTM,plRes)
  end do
                                                  ; added for Wanli
  if (rOpts .and. isatt(rOpts,"ccRays") ) then
      angRL = acos(rOpts@ccRays)/rad             ; angles: radial lines

      rlRes = True
      rlRes@gsLineDashPattern= 2  ; line pattern
      rlRes@gsLineThicknessF = 1  ; choose line thickness
      if (isatt(rOpts,"ccRays_color")) then
          rlRes@gsLineColor    =  "gray70";"LightGray"
      end if

      dum8 = new(dimsizes(angRL),graphic)
      do i=0,dimsizes(angRL)-1
         xRL     = xyMax*cos(angRL(i)*rad)
         yRL     = xyMax*sin(angRL(i)*rad)
         dum8(i) = gsn_add_polyline(wks,taylor,(/0, xRL /),(/0,  yRL  /),rlRes)
      end do
      taylor@$unique_string("dum")$ = dum8
  end if
  
; ----------------------------------------------------------------
; Part 3:
; Concentric about 1.0 on XB axis
; I think this is correct. Still test mode.
; ----------------------------------------------------------------
  if (rOpts .and. isatt(rOpts,"centerDiffRMS") \
            .and. rOpts@centerDiffRMS) then
      respl                    = True                ; polyline mods desired
      respl@xyLineThicknessF   = 1.0                 ; line thickness
      respl@xyLineDashPattern  = 2                   ; short dash lines
      respl@gsLineColor        = "gray50";"Black"             ; line color     
      if (isatt(rOpts,"centerDiffRMS_color")) then
          respl@gsLineColor    =  "gray50";"LightGray"
      end if
      
      dx   = 0.25
      ncon = 6;                                      ; 0.75, 0.50, 0.25, 0.0
      npts = 100                                     ; arbitrary
      ang  = fspan(180,360,npts)*rad

      dum9 = new(ncon,graphic)

      rms_labels = (/ 0.25, 0.50, 0.75, 1.00, 1.25, 1.50/);

      do n=1,ncon 
         respl@gsLineLabelString = rms_labels(n-1)  ;IF YOU DESIRE RMS LABELS
         respl@gsLineLabelFontColor    =  "gray50";
         respl@gsLineDashPattern  = 1;
         respl@gsLineLabelFontHeightF      = 0.008

         rr  = n*dx            ; radius from 1.0 [OBS] abscissa
         xx  = 1. + rr*cos(ang)
         yy  = fabs( rr*sin(ang) )

		 ;;;;;; Erik's Changes ;;;; May need to change accordingly
         if (n.le.9) then
                      dum9(n-1) = gsn_add_polyline(wks,taylor,xx,yy,respl)
         end if

         if (n.eq.9) then
             n9 = floattointeger( 0.71*npts ) 
             dum9(n-1) = gsn_add_polyline(wks,taylor,xx(0:n9),yy(0:n9),respl)
			 ;dum9(n-1) = gsn_add_polyline(wks,taylor,xx,yy,respl)
         end if
         if (n.eq.10) then
             n10 = floattointeger( 0.61*npts ) 
             dum9(n-1) = gsn_add_polyline(wks,taylor,xx(0:n10),yy(0:n10),respl)
			 ;dum9(n-1) = gsn_add_polyline(wks,taylor,xx,yy,respl)
         end if
         if (n.eq.11) then
             n11 = floattointeger( 0.53*npts ) 
             dum9(n-1) = gsn_add_polyline(wks,taylor,xx(0:n11),yy(0:n11),respl)
			 ;dum9(n-1) = gsn_add_polyline(wks,taylor,xx,yy,respl)
         end if

      end do
      delete(ang)
      delete(xx)
      delete(yy)
      taylor@$unique_string("dum")$ = dum9

  end if
; ---------------------------------------------------------------
; Part 4:
; generic resources that will be applied to all users data points
; of course, these can be changed 
; http://www.ncl.ucar.edu/Document/Graphics/Resources/gs.shtml
; ---------------------------------------------------------------
  if (rOpts .and. isatt(rOpts,"Markers")) then
      Markers = rOpts@Markers
  else
      Markers = (/ 4, 6, 8,  0, 9, 12, 7, 2, 11, 16/) ; Marker Indices
  end if

  if (rOpts .and. isatt(rOpts,"Colors")) then
      Colors  = rOpts@Colors
  else
;       Colors  = (/ "red", "blue", "forestgreen", "cyan", "orange" \
;                 ,"", "mediumpurple1", "brown", "yellow", "purple", "black"/)

;Colors  = (/ "red","forestgreen", "blue", "cyan", "black" \
;                 ,"", "mediumpurple1", "brown", "yellow", "purple", "black"/)

;Colors  = (/ "red","forestgreen", "blue","white"/)
;Colors  = (/ "red","forestgreen", "blue","orange"/)
; anterior 16/03  Colors  = (/ "blue","forestgreen", "red","orange"/)
Colors  = (/"purple","blue","forestgreen", "red","orange"/)



  end if

  if (rOpts .and. isatt(rOpts,"gsMarkerThicknessF")) then
      gsMarkerThicknessF = rOpts@gsMarkerThicknessF
  else
      gsMarkerThicknessF = 1.0
  end if

  if (rOpts .and. isatt(rOpts,"gsMarkerSizeF")) then
      gsMarkerSizeF      = rOpts@gsMarkerSizeF
  else
      gsMarkerSizeF      = 0.0085                  ; Default: 0.007
  end if

  gsRes = True
  gsRes@gsMarkerThicknessF = gsMarkerThicknessF      ; default=1.0
  gsRes@gsMarkerSizeF      = gsMarkerSizeF           ; Default: 0.007 

  ptRes = True                        ; text options for points
  ptRes@txJust             = "BottomCenter"; Default="CenterCenter".
  ptRes@txFontThicknessF   = 1.2      ; default=1.00
  ptRes@txFontHeightF      = 0.029;0.0225   ; default=0.05
  if (rOpts .and. isatt(rOpts,"txFontHeightF")) then
      ptRes@txFontHeightF  = rOpts@txFontHeightF  
  end if

  markerTxYOffset          = 0.0175   ; default
  if (rOpts .and. isatt(rOpts,"markerTxYOffset")) then
      markerTxYOffset = rOpts@markerTxYOffset             ; user defined offset
  end if

  dum10 = new((nCase*nVar),graphic)
  dum11 = dum10

;;; incluso 06022015		
 ; nCase=5 por causa que acrescentou o 2
;  nCase=4
;anterior 19/03/18 nCase=4
nCase=5

  do n=0,nCase-1
   ; ni=(/1,2,3,5,7/)  acrescentou o 2 = 48h
    ; ni=(/1,3,5,7/)
 ;    ni=(/1,2,3,3/)
     ni=(/1,2,3,4,5/)

     gsRes@gsMarkerIndex   = Markers(n)             ; marker style (+)
     gsRes@gsMarkerColor   = Colors(n)              ; marker color
     ptRes@txFontColor     = gsRes@gsMarkerColor
    do i=0,nVar-1
       dum11 = gsn_add_text(wks,taylor,(ni(i)),X(n,i),Y(n,i)+markerTxYOffset,ptRes)
    end do
  end do

; ---------------------------------------------------------------
; Part 5: ; add case legend and variable labels
; ---------------------------------------------------------------

  if (rOpts .and. isatt(rOpts,"caseLabels")) then 

      if (isatt(rOpts,"caseLabelsFontHeightF")) then
          caseLabelsFontHeightF = rOpts@caseLabelsFontHeightF
      else
          caseLabelsFontHeightF = 0.07;0.05  
      end if

      lgres                    = True
      lgres@lgMarkerColors     = Colors        ; colors of markers
      lgres@lgMarkerIndexes    = Markers       ; Markers
      lgres@lgMarkerIndexes    = (/16,16,16,16,16,12/)       ; Markers
      lgres@lgMarkerSizeF      = 08;gsMarkerSizeF ; Marker size
      lgres@lgItemType         = "Markers"     ; draw markers only
      lgres@lgLabelFontHeightF = caseLabelsFontHeightF  ; font height of legend case labels

      if (isatt(rOpts,"legendWidth")) then
          lgres@vpWidthF       = rOpts@legendWidth
      else
          lgres@vpWidthF       = 0.3;0.15           ; width of legend (NDC)
      end if

      if (isatt(rOpts,"legendHeight")) then
          lgres@vpHeightF      = rOpts@legendHeight
      else   
          lgres@vpHeightF      = 0.050*nCase ;0.030*nCase   ; height of legend (NDC)
      end if

      lgres@lgPerimOn          = False         ; turn off perimeter
      nModel                   = dimsizes( rOpts@caseLabels )
      lbid = gsn_create_legend(wks,nModel,rOpts@caseLabels,lgres)
	 
      amres = True
      amres@amJust                           = "CenterLeft" ;"CenterRight"
      amres@amParallelPosF     =  0.95;0.35           
      amres@amOrthogonalPosF   = -0.02             
      annoid1 = gsn_add_annotation(taylor,lbid,amres)	; add legend to plot
  end if

  if (rOpts .and. isatt(rOpts,"varLabels")) then 
      nVar    = dimsizes(rOpts@varLabels)

      if (isatt(rOpts,"varLabelsFontHeightF")) then
          varLabelsFontHeightF = rOpts@varLabelsFontHeightF
      else
          varLabelsFontHeightF = 0.013
      end if

      txres = True
      txres@txFontHeightF = varLabelsFontHeightF
      txres@txJust = "CenterLeft"              ; justify to the center left

      delta_y = 0.06   
      if (rOpts .and. isatt(rOpts,"varLabelsYloc")) then
          ys  = rOpts@varLabelsYloc            ; user specified
      else
          ys  = max( (/nVar*delta_y , 0.30/) )
      end if

      
      do i = 1,nVar     
         if (i.eq.1) then
             dum12 = new(nVar,graphic)
	 end if

         dum12(i-1) = gsn_add_text(wks,taylor,i+" - "+rOpts@varLabels(i-1), .125,ys,txres)
         ys = ys- delta_y
      end do

      taylor@$unique_string("dum")$ = dum12
  end if

  taylor@$unique_string("dum")$ = dum0   ; x-axis
  taylor@$unique_string("dum")$ = dum1   ; y-axis
  taylor@$unique_string("dum")$ = dum2   ; 1.0 std curve
  taylor@$unique_string("dum")$ = dum5   ; labels [COR]
  taylor@$unique_string("dum")$ = dum6   ; major tm [COR]
  taylor@$unique_string("dum")$ = dum7   ; minor tm
  taylor@$unique_string("dum")$ = dum10  ; markers
  taylor@$unique_string("dum")$ = dum11  ; text


      ptres                    = True
      ptres@gsMarkerSizeF                = 18
      ptres@gsMarkerThicknessF          = 3
      ptres@gsMarkerIndex    = 12     ; Markers
      ;ptres@gsItemType         = "Markers"     ; draw markers only

  dum17 = gsn_add_polymarker(wks,taylor,1.00,0.01,ptres)  ; draw star ref
  
  if (.not.isatt(rOpts,"taylorDraw") .or. \
     (isatt(rOpts,"taylorDraw") .and. rOpts@taylorDraw)) then 
	draw(taylor)
  end if
  if (.not.isatt(rOpts,"taylorFrame") .or. \
     (isatt(rOpts,"taylorFrame") .and. rOpts@taylorFrame)) then 
	frame(wks)
  end if
  return(taylor)
end

