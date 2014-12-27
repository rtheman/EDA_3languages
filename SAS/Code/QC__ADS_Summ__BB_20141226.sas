/*
Exploratory Data Analysis (EDA) of ADS Summary file
	- Plot the cross-sectional view of ADS Summary for Building Block level [Input: ADS Summary]
	- Plot the panel view of ADS-BB [Input: ADS-BB dataset]

Input:
	- ADS_Summary (xlsx) - Building Block level, which contains summraized measures across 21-mo. for each Building Block.  [cross-sectional].
	- ADS-BB [ADS_WMT__n_BldBlk_update01.SAS7BDAT], which contains measures (Image Track survey's response) by Year-Month (21) by Building Block (41). [panel data].

Code Workflow:
	1.) Create cross-sectional plot for relationship between Price Perception and Sales Index / Trips Index / Market Share Index for all Building Blocks (41).
		a. Scatter plot of Price perception vs. Sales-/Trips-/Market Share index
		b. Scatter plot of Experience perception vs. Trips-Labor index
	2.) Create cross-sectional plot for relationship between Price Perception and Sales Index / Trips Index / Market Share Index for Building Blocks with 1-DMA (28).
		a. Scatter plot of Price perception vs. Sales-/Trips-/Market Share index
		b. Scatter plot of Experience perception vs. Trips-Labor index
	3.) Create panel plot for relationship between Price Perception and and Sales Index / Trips Index / Market Share Index for all Building Blocks (41).
		a. Calculate trends of data (Sales) using variation of PROC MIXED method.
		b. Calculate trends of data (Trips) using variation of PROC MIXED method.
		c. Calculate trends of data (Market Share Index) using variation of PROC MIXED method.
	4.) Create panel plot for relationship between Price Perception and and Sales Index / Trips Index / Market Share Index for Building Blocks with 1-DMA (28).
		a. Calculate trends of data (Sales) using variation of PROC MIXED method.
		b. Calculate trends of data (Trips) using variation of PROC MIXED method.
		c. Calculate trends of data (Market Share Index) using variation of PROC MIXED method.

last modified by Rich Leung on Mon, 15Dec2014
*/

libname ADS_Summ	'C:\Users\rich.leung.000\Documents\Clients\Walmart\Customers Analytics\Price Perception vs Market Share (SEM)\Data\ADS\g. ADS_Summary\Input';
libname ADS_BB 		'C:\Users\rich.leung.000\Documents\Clients\Walmart\Customers Analytics\Price Perception vs Market Share (SEM)\Data\ADS\a. by Building Blocks';
Run;



/* 1.) Create cross-sectional plot for relationship between Price Perception and Sales Index / Trips Index / Market Share Index for all Building Blocks. */
/* Input: ADS_Summary (xlsx) - Building Block level */
%macro mco__xSec_BBall;
/* -- parse for all Bldg Blks (41) */
Proc SQL Number;
	Create Table WORK.tmp as
	Select 
		BldBlk, 
		C2_110_wgt_avg_21mo, 
		Sales_Index_YrMon_strtyp_21mo, 
		Trips_Index_YrMon_strtyp_21mo, 
		Mkt_Share_Nielsen_21Mo as Mkt_Share, 
		Mkt_Share_StrTyp as Mkt_Share_index, 
		C3_116_wgt_avg_21mo, 
		(Trips_YrMon_strtyp_21mo / (Labor_Hours_Back + Labor_Hours_Mid + Labor_Hours_Front)) as TripLabor_index, 
		Case
			When BldBlk < 100 Then 'Standalone'
			When (BldBlk > 100) and (BldBlk < 900) Then 'Combined'
			When BldBlk > 900 Then 'Low Combined'
			Else ''
		End as BldBlk_type
	From ADS_Summ.SUMMARY_BB
;
Run;
/* 1a.) -- Scatter plot of Price perception vs. Sales-/Trips-/Market Share index */
proc sgscatter data=WORK.tmp;
	compare y=(Sales_Index_YrMon_strtyp_21mo Trips_Index_YrMon_strtyp_21mo Mkt_Share_index)
			x=C2_110_wgt_avg_21mo
			/ group = BldBlk_type 
			  reg = (degree=1 clm nogroup);
	title 'Sales/Trips/Mkt_Shr vs. Price perception by Bldg_Blk (all 41 BldgBlks)';
Run;
/* Regression */
proc reg
	data=work.tmp;
	model Sales_Index_YrMon_strtyp_21mo = C2_110_wgt_avg_21mo;
Run;
proc reg
	data=work.tmp;
	model Trips_Index_YrMon_strtyp_21mo = C2_110_wgt_avg_21mo;
Run;
proc reg
	data=work.tmp;
	model Mkt_Share_index = C2_110_wgt_avg_21mo;
Run;

/* 1b.) -- Scatter plot of Experience perception vs. Trips-Labor index */
proc sgscatter data=WORK.tmp;
	compare y=TripLabor_index
			x=C3_116_wgt_avg_21mo 
			/ reg = (degree=1 clm nogroup);
	title 'Traffic-Labor index vs. Experience perception by Bldg_Blk (all 41 BldgBlks)';
/* Regression */
proc reg
	data=WORK.tmp;
	model TripLabor_index = C3_116_wgt_avg_21mo;
run;

%MEND mco__xSec_BBall;



/* 2.) Create cross-sectional plot for relationship between Price Perception and Sales Index / Trips Index / Market Share Index for Building Blocks with 1-DMA (28). */
/* Input: ADS_Summary (xlsx) - Building Block level */
%macro mco__xSec_BB28;
/* -- parse for Standalone BldgBlk (28) where BB already has resp cnt >= 30 */
Proc SQL Number;
	Create Table WORK.tmp as
	Select 
		BldBlk, 
		C2_110_wgt_avg_21mo, 
		Sales_Index_YrMon_strtyp_21mo, 
		Trips_Index_YrMon_strtyp_21mo, 
		Mkt_Share_Nielsen_21Mo as Mkt_Share, 
		Mkt_Share_StrTyp as Mkt_Share_index, 
		C3_116_wgt_avg_21mo, 
		(Trips_YrMon_strtyp_21mo / (Labor_Hours_Back + Labor_Hours_Mid + Labor_Hours_Front)) as TripLabor_index, 
		Case
			When BldBlk < 100 Then 'Standalone'
			When (BldBlk > 100) and (BldBlk < 900) Then 'Combined'
			When BldBlk > 900 Then 'Low Combined'
			Else ''
		End as BldBlk_type
	From ADS_Summ.SUMMARY_BB
	Where (BldBlk < 100)
;
Run;
/* 2a.) Scatter plot of Price perception vs. Sales-/Trips-/Market Share index */
proc sgscatter data=WORK.tmp;
	compare y=(Sales_Index_YrMon_strtyp_21mo Trips_Index_YrMon_strtyp_21mo Mkt_Share_index)
			x=C2_110_wgt_avg_21mo
			/ reg = (degree=1 clm nogroup);
	title 'Sales/Trips/Mkt_Shr vs. Price perception by Bldg_Blk (Standalone BldgBlk (28))';
Run;
/* Regression */
proc reg
	data=work.tmp;
	model Sales_Index_YrMon_strtyp_21mo = C2_110_wgt_avg_21mo;
Run;
proc reg
	data=work.tmp;
	model Trips_Index_YrMon_strtyp_21mo = C2_110_wgt_avg_21mo;
Run;
proc reg
	data=work.tmp;
	model Mkt_Share_index = C2_110_wgt_avg_21mo;
Run;

/* 2b.) Scatter plot of Experience perception vs. Trips-Labor index */
proc sgscatter data=WORK.tmp;
	compare y=TripLabor_index
			x=C3_116_wgt_avg_21mo 
			/ reg = (degree=1 clm nogroup);
	title 'Traffic-Labor index vs. Experience perception by Bldg_Blk (Standalone BldgBlk (28))';
/* Regression */
proc reg
	data=WORK.tmp;
	model TripLabor_index = C3_116_wgt_avg_21mo;
run;

%MEND mco__xSec_BB28;





/* ========================================================== */
%macro mco__panel_BBall;
/* 3.) Create panel plot for relationship between Price Perception and and Sales Index / Trips Index / Market Share Index for all Building Blocks (41). */
/* -- parse for all clusters (41) */
Proc SQL Number;
	Create Table WORK.tmp as
	Select 
		BldBlk, 
		C2_110_wgt, 
		Sales_index_YrMon_strtyp, 
		Trips_index_YrMon_strtyp, 
		Mkt_Share_Nielsen as Mkt_Share, 
		Mkt_Share_strtyp as Mkt_Share_index, 
		C3_116_wgt, 
		(Trips_strtyp_3 / (Labor_Hours_Back + Labor_Hours_Mid + Labor_Hours_Front)) as TripLabor_index, 
		Case
			When BldBlk < 100 Then 'Standalone'
			When (BldBlk >= 100) and (BldBlk < 900) Then 'Combined'
			When BldBlk >= 900 Then 'Low Combined'
			Else ''
		End as BldBlk_type
	From ADS_BB.ADS_WMT__n_bldblk_updated07
;
Run;
/* -- Scatter plot of Price perception vs. Sales-/Trips-/Market Share index -- */
proc sgscatter data=WORK.tmp;
	compare y=(Sales_index_YrMon_strtyp Trips_index_YrMon_strtyp Mkt_Share_index)
			x=C2_110_wgt
			/ group = BldBlk_type 
			  reg = (degree=1 clm nogroup);
	title '[Panel] Sales/Trips/Mkt Share Index vs. Price Perception (Lowest Price) by Bldg_Blk by Month (All Bldg_Blk)';
Run;
/* -- Scatter plot of Experience perception vs. Trips-Labor index -- */
proc sgscatter data=WORK.tmp;
	compare y=TripLabor_index
			x=C3_116_wgt
			/ group = BldBlk_type 
			  reg = (degree=1 clm nogroup);
	title '[Panel] Trips-Labor Index vs. Experience Perception (Assoc Easy to Find) by Bldg_Blk by Month (All Bldg_Blk)';
Run;
/* quick regression for scatter plot above (Experience perception vs. Trips-Labor index) */
proc Mixed
	data=WORK.tmp;
	model TripLabor_index = C3_116_wgt /solutionF;
	ODS output solutionF = soluF_TripLabor_AllBB;
Run;

/* 3a. Calculate trends of data (Sales) using variation of PROC MIXED method.		*/
/* -- SALES -- 																		*/
/* 1.) model with single panel trend variable 										*/
proc Mixed
	data=WORK.tmp;
	model Sales_index_YrMon_strtyp = C2_110_wgt /solutionF;
	ODS output solutionF = soluF_Sales01_AllBB;
Run;
/* 2.) model with single panel trend variable and fixed building block intercepts 	*/
proc Mixed
	data=WORK.tmp;
	class BldBlk;
	model Sales_index_YrMon_strtyp = C2_110_wgt BldBlk /solutionF;
	ODS output solutionF = soluF_Sales02_AllBB;
Run;
/* 3.) model with single panel trend variable and random building block intercepts	*/
proc Mixed
	data=WORK.tmp;
	class BldBlk;
	model Sales_index_YrMon_strtyp = C2_110_wgt /solutionF;
	random BldBlk /solutionR;
	ODS output solutionF = soluF_Sales03_AllBB;
	ODS output solutionR = soluR_Sales03_AllBB;
Run;
/* 4.) model with single panel trend variable, random building block intercepts, and random fixed building block level trend */
proc Mixed
	data=WORK.tmp;
	class BldBlk;
	model Sales_index_YrMon_strtyp = C2_110_wgt /solutionF;
	random BldBlk C2_110_wgt*BldBlk /solutionR;
	ODS output solutionF = soluF_Sales04_AllBB;
	ODS output solutionR = soluR_Sales04_AllBB;
Run;
/* 5.) model with single panel trend variable, random building block intercepts, and random fixed building block level trends */
/*proc Mixed
	data=WORK.tmp;
	class BldBlk;
	model Sales_index_YrMon_strtyp = C2_110_wgt /solutionF;
	random C2_110_wgt BldBlk C2_110_wgt*BldBlk /solutionR;
	ODS output solutionF = soluF_Sales05_AllBB;
	ODS output solutionR = soluR_Sales05_AllBB;
Run;*/
/* 6.) model with single panel trend variable and fixed building block level trends */
proc Mixed
	data=WORK.tmp;
	class BldBlk;
	model Sales_index_YrMon_strtyp = C2_110_wgt C2_110_wgt*BldBlk /solutionF;
	ODS output solutionF = soluF_Sales06_AllBB;
Run;
/* 7.) model with single panel trend variable and random building block level trends */
proc Mixed
	data=WORK.tmp;
	class BldBlk;
	model Sales_index_YrMon_strtyp = C2_110_wgt /solutionF;
	random C2_110_wgt*BldBlk /solutionR;
	ODS output solutionF = soluF_Sales07_AllBB;
	ODS output solutionR = soluR_Sales07_AllBB;
Run;
/* 8.) model with single random panel trend variable and random building block level trends */
/*proc Mixed
	data=WORK.tmp;
	class BldBlk;
	model Sales_index_YrMon_strtyp = C2_110_wgt /solutionF;
	random C2_110_wgt C2_110_wgt*BldBlk /solutionR;
	ODS output solutionF = soluF_Sales08_AllBB;
	ODS output solutionR = soluR_Sales08_AllBB;
Run;*/

/* 3b. Calculate trends of data (Trips) using variation of PROC MIXED method.		*/
/* -- TRIPS -- 																		*/
/* 1.) model with single panel trend variable 										*/
proc Mixed
	data=WORK.tmp;
	model Trips_index_YrMon_strtyp = C2_110_wgt /solutionF;
	ODS output solutionF = soluF_Trip01_AllBB;
Run;
/* 2.) model with single panel trend variable and fixed building block intercepts 	*/
proc Mixed
	data=WORK.tmp;
	class BldBlk;
	model Trips_index_YrMon_strtyp = C2_110_wgt BldBlk /solutionF;
	ODS output solutionF = soluF_Trip02_AllBB;
Run;
/* 3.) model with single panel trend variable and random building block intercepts	*/
proc Mixed
	data=WORK.tmp;
	class BldBlk;
	model Trips_index_YrMon_strtyp = C2_110_wgt /solutionF;
	random BldBlk /solutionR;
	ODS output solutionF = soluF_Trip03_AllBB;
	ODS output solutionR = soluR_Trip03_AllBB;
Run;
/* 4.) model with single panel trend variable, random building block intercepts, and random fixed building block level trend */
proc Mixed
	data=WORK.tmp;
	class BldBlk;
	model Trips_index_YrMon_strtyp = C2_110_wgt /solutionF;
	random BldBlk C2_110_wgt*BldBlk /solutionR;
	ODS output solutionF = soluF_Trip04_AllBB;
	ODS output solutionR = soluR_Trip04_AllBB;
Run;
/* 5.) model with single panel trend variable, random building block intercepts, and random fixed building block level trends */
/*proc Mixed
	data=WORK.tmp;
	class BldBlk;
	model Trips_index_YrMon_strtyp = C2_110_wgt /solutionF;
	random C2_110_wgt BldBlk C2_110_wgt*BldBlk /solutionR;
	ODS output solutionF = soluF_Trip05_AllBB;
	ODS output solutionR = soluR_Trip05_AllBB;
Run;*/
/* 6.) model with single panel trend variable and fixed building block level trends */
proc Mixed
	data=WORK.tmp;
	class BldBlk;
	model Trips_index_YrMon_strtyp = C2_110_wgt C2_110_wgt*BldBlk /solutionF;
	ODS output solutionF = soluF_Trip06_AllBB;
Run;
/* 7.) model with single panel trend variable and random building block level trends */
proc Mixed
	data=WORK.tmp;
	class BldBlk;
	model Trips_index_YrMon_strtyp = C2_110_wgt /solutionF;
	random C2_110_wgt*BldBlk /solutionR;
	ODS output solutionF = soluF_Trip07_AllBB;
	ODS output solutionR = soluR_Trip07_AllBB;
Run;
/* 8.) model with single random panel trend variable and random building block level trends */
/*proc Mixed
	data=WORK.tmp;
	class BldBlk;
	model Trips_index_YrMon_strtyp = C2_110_wgt /solutionF;
	random C2_110_wgt C2_110_wgt*BldBlk /solutionR;
	ODS output solutionF = soluF_Trip07_AllBB;
	ODS output solutionR = soluR_Trip07_AllBB;
Run;*/

/* 3c. Calculate trends of data (Market Share) using variation of PROC MIXED method. */
/* -- MKT SHARE -- 																	*/
/* 1.) model with single panel trend variable 										*/
proc Mixed
	data=WORK.tmp;
	model Mkt_Share_index = C2_110_wgt /solutionF;
	ODS output solutionF = soluF_MS01_AllBB;
Run;
/* 2.) model with single panel trend variable and fixed building block intercepts 	*/
proc Mixed
	data=WORK.tmp;
	class BldBlk;
	model Mkt_Share_index = C2_110_wgt BldBlk /solutionF;
	ODS output solutionF = soluF_MS02_AllBB;
Run;
/* 3.) model with single panel trend variable and random building block intercepts	*/
proc Mixed
	data=WORK.tmp;
	class BldBlk;
	model Mkt_Share_index = C2_110_wgt /solutionF;
	random BldBlk /solutionR;
	ODS output solutionF = soluF_MS03_AllBB;
	ODS output solutionR = soluR_MS03_AllBB;
Run;
/* 4.) model with single panel trend variable, random building block intercepts, and random fixed building block level trend */
proc Mixed
	data=WORK.tmp;
	class BldBlk;
	model Mkt_Share_index = C2_110_wgt /solutionF;
	random BldBlk C2_110_wgt*BldBlk /solutionR;
	ODS output solutionF = soluF_MS04_AllBB;
	ODS output solutionR = soluR_MS04_AllBB;
Run;
/* 5.) model with single panel trend variable, random building block intercepts, and random fixed building block level trends */
/*proc Mixed
	data=WORK.tmp;
	class BldBlk;
	model Mkt_Share_index = C2_110_wgt /solutionF;
	random C2_110_wgt BldBlk C2_110_wgt*BldBlk /solutionR;
	ODS output solutionF = soluF_MS05_AllBB;
	ODS output solutionR = soluR_MS05_AllBB;
Run;*/
/* 6.) model with single panel trend variable and fixed building block level trends */
proc Mixed
	data=WORK.tmp;
	class BldBlk;
	model Mkt_Share_index = C2_110_wgt C2_110_wgt*BldBlk /solutionF;
	ODS output solutionF = soluF_MS06_AllBB;
Run;
/* 7.) model with single panel trend variable and random building block level trends */
proc Mixed
	data=WORK.tmp;
	class BldBlk;
	model Mkt_Share_index = C2_110_wgt /solutionF;
	random C2_110_wgt*BldBlk /solutionR;
	ODS output solutionF = soluF_MS07_AllBB;
	ODS output solutionR = soluR_MS07_AllBB;
Run;
/* 8.) model with single random panel trend variable and random building block level trends */
/*proc Mixed
	data=WORK.tmp;
	class BldBlk;
	model Mkt_Share_index = C2_110_wgt /solutionF;
	random C2_110_wgt C2_110_wgt*BldBlk /solutionR;
	ODS output solutionF = soluF_MS08_AllBB;
	ODS output solutionR = soluR_MS08_AllBB;
Run;*/

%MEND mco__panel_BBall;



%macro mco__panel_BB28;
/* 4.) Create panel plot for relationship between Price Perception and and Sales Index / Trips Index / Market Share Index for Building Blocks with 1-DMA (28). */
/* -- parse for all Standalone BldgBlk (28) */
Proc SQL Number;
	Create Table WORK.tmp as
	Select 
		BldBlk, 
		C2_110_wgt, 
		Sales_index_YrMon_strtyp, 
		Trips_index_YrMon_strtyp, 
		Mkt_Share_Nielsen as Mkt_Share, 
		Mkt_Share_strtyp as Mkt_Share_index, 
		C3_116_wgt, 
		(Trips_strtyp_3 / (Labor_Hours_Back + Labor_Hours_Mid + Labor_Hours_Front)) as TripLabor_index, 
		Case
			When BldBlk < 100 Then 'Standalone'
			When (BldBlk >= 100) and (BldBlk < 900) Then 'Combined'
			When BldBlk >= 900 Then 'Low Combined'
			Else ''
		End as BldBlk_type
	From ADS_BB.ADS_WMT__n_bldblk_updated07
	Where (BldBlk < 100)
;
Run;
/* -- create scatter plot */
proc sgscatter data=WORK.tmp;
	compare y=(Sales_index_YrMon_strtyp Trips_index_YrMon_strtyp Mkt_Share_index)
			x=C2_110_wgt
			/ reg = (degree=1 clm nogroup);
	title '[Panel] Sales/Trips/Mkt Share vs. Price Perception (Lowest Price) by BldgBlk by Month (Standalone BldgBlk (28))';
Run;
/* -- Scatter plot of Experience perception vs. Trips-Labor index -- */
proc sgscatter data=WORK.tmp;
	compare y=TripLabor_index
			x=C3_116_wgt
			/ group = BldBlk_type 
			  reg = (degree=1 clm nogroup);
	title '[Panel] Trips-Labor Index vs. Experience Perception (Assoc Easy to Find) by Bldg_Blk by Month (Standalone BldgBlk (28))';
Run;
/* quick regression for scatter plot above (Experience perception vs. Trips-Labor index) */
proc Mixed
	data=WORK.tmp;
	model TripLabor_index = C3_116_wgt /solutionF;
	ODS output solutionF = soluF_TripLabor_BB28;
Run;

/* 4a. Calculate trends of data (Sales) using variation of PROC MIXED method.		*/
/* -- SALES -- 																		*/
/* 1.) model with single panel trend variable 										*/
proc Mixed
	data=WORK.tmp;
	model Sales_index_YrMon_strtyp = C2_110_wgt /solutionF;
	ODS output solutionF = soluF_Sales01_BB28;
Run;
/* 2.) model with single panel trend variable and fixed building block intercepts 	*/
proc Mixed
	data=WORK.tmp;
	class BldBlk;
	model Sales_index_YrMon_strtyp = C2_110_wgt BldBlk /solutionF;
	ODS output solutionF = soluF_Sales02_BB28;
Run;
/* 3.) model with single panel trend variable and random building block intercepts	*/
proc Mixed
	data=WORK.tmp;
	class BldBlk;
	model Sales_index_YrMon_strtyp = C2_110_wgt /solutionF;
	random BldBlk /solutionR;
	ODS output solutionF = soluF_Sales03_BB28;
	ODS output solutionR = soluR_Sales03_BB28;
Run;
/* 4.) model with single panel trend variable, random building block intercepts, and random fixed building block level trend */
proc Mixed
	data=WORK.tmp;
	class BldBlk;
	model Sales_index_YrMon_strtyp = C2_110_wgt /solutionF;
	random BldBlk C2_110_wgt*BldBlk /solutionR;
	ODS output solutionF = soluF_Sales04_BB28;
	ODS output solutionR = soluR_Sales04_BB28;
Run;
/* 5.) model with single panel trend variable, random building block intercepts, and random fixed building block level trends */
/*proc Mixed
	data=WORK.tmp;
	class BldBlk;
	model Sales_index_YrMon_strtyp = C2_110_wgt /solutionF;
	random C2_110_wgt BldBlk C2_110_wgt*BldBlk /solutionR;
	ODS output solutionF = soluF_Sales05_BB28;
	ODS output solutionR = soluR_Sales05_BB28;
Run;*/
/* 6.) model with single panel trend variable and fixed building block level trends */
proc Mixed
	data=WORK.tmp;
	class BldBlk;
	model Sales_index_YrMon_strtyp = C2_110_wgt C2_110_wgt*BldBlk /solutionF;
	ODS output solutionF = soluF_Sales06_BB28;
Run;
/* 7.) model with single panel trend variable and random building block level trends */
proc Mixed
	data=WORK.tmp;
	class BldBlk;
	model Sales_index_YrMon_strtyp = C2_110_wgt /solutionF;
	random C2_110_wgt*BldBlk /solutionR;
	ODS output solutionF = soluF_Sales07_BB28;
	ODS output solutionR = soluR_Sales07_BB28;
Run;
/* 8.) model with single random panel trend variable and random building block level trends */
/*proc Mixed
	data=WORK.tmp;
	class BldBlk;
	model Sales_index_YrMon_strtyp = C2_110_wgt /solutionF;
	random C2_110_wgt C2_110_wgt*BldBlk /solutionR;
	ODS output solutionF = soluF_Sales08_BB28;
	ODS output solutionR = soluR_Sales08_BB28;
Run;*/

/* 4b. Calculate trends of data (Trips) using variation of PROC MIXED method.		*/
/* -- TRIPS -- 																		*/
/* 1.) model with single panel trend variable 										*/
proc Mixed
	data=WORK.tmp;
	model Trips_index_YrMon_strtyp = C2_110_wgt /solutionF;
	ODS output solutionF = soluF_Trip01_BB28;
Run;
/* 2.) model with single panel trend variable and fixed building block intercepts 	*/
proc Mixed
	data=WORK.tmp;
	class BldBlk;
	model Trips_index_YrMon_strtyp = C2_110_wgt BldBlk /solutionF;
	ODS output solutionF = soluF_Trip02_BB28;
Run;
/* 3.) model with single panel trend variable and random building block intercepts	*/
proc Mixed
	data=WORK.tmp;
	class BldBlk;
	model Trips_index_YrMon_strtyp = C2_110_wgt /solutionF;
	random BldBlk /solutionR;
	ODS output solutionF = soluF_Trip03_BB28;
	ODS output solutionR = soluR_Trip03_BB28;
Run;
/* 4.) model with single panel trend variable, random building block intercepts, and random fixed building block level trend */
proc Mixed
	data=WORK.tmp;
	class BldBlk;
	model Trips_index_YrMon_strtyp = C2_110_wgt /solutionF;
	random BldBlk C2_110_wgt*BldBlk /solutionR;
	ODS output solutionF = soluF_Trip04_BB28;
	ODS output solutionR = soluR_Trip04_BB28;
Run;
/* 5.) model with single panel trend variable, random building block intercepts, and random fixed building block level trends */
/*proc Mixed
	data=WORK.tmp;
	class BldBlk;
	model Trips_index_YrMon_strtyp = C2_110_wgt /solutionF;
	random C2_110_wgt BldBlk C2_110_wgt*BldBlk /solutionR;
	ODS output solutionF = soluF_Trip05_BB28;
	ODS output solutionR = soluR_Trip05_BB28;
Run;*/
/* 6.) model with single panel trend variable and fixed building block level trends */
proc Mixed
	data=WORK.tmp;
	class BldBlk;
	model Trips_index_YrMon_strtyp = C2_110_wgt C2_110_wgt*BldBlk /solutionF;
	ODS output solutionF = soluF_Trip06_BB28;
Run;
/* 7.) model with single panel trend variable and random building block level trends */
proc Mixed
	data=WORK.tmp;
	class BldBlk;
	model Trips_index_YrMon_strtyp = C2_110_wgt /solutionF;
	random C2_110_wgt*BldBlk /solutionR;
	ODS output solutionF = soluF_Trip07_BB28;
	ODS output solutionR = soluR_Trip07_BB28;
Run;
/* 8.) model with single random panel trend variable and random building block level trends */
/*proc Mixed
	data=WORK.tmp;
	class BldBlk;
	model Trips_index_YrMon_strtyp = C2_110_wgt /solutionF;
	random C2_110_wgt C2_110_wgt*BldBlk /solutionR;
	ODS output solutionF = soluF_Trip08_BB28;
	ODS output solutionR = soluR_Trip08_BB28;
Run;*/

/* 4c. Calculate trends of data (Market Share) using variation of PROC MIXED method.*/
/* -- MKT SHARE -- 																	*/
/* 1.) model with single panel trend variable 										*/
proc Mixed
	data=WORK.tmp;
	model Mkt_Share_index = C2_110_wgt /solutionF;
	ODS output solutionF = soluF_MS01_BB28;
Run;
/* 2.) model with single panel trend variable and fixed building block intercepts 	*/
proc Mixed
	data=WORK.tmp;
	class BldBlk;
	model Mkt_Share_index = C2_110_wgt BldBlk /solutionF;
	ODS output solutionF = soluF_MS02_BB28;
Run;
/* 3.) model with single panel trend variable and random building block intercepts	*/
proc Mixed
	data=WORK.tmp;
	class BldBlk;
	model Mkt_Share_index = C2_110_wgt /solutionF;
	random BldBlk /solutionR;
	ODS output solutionF = soluF_MS03_BB28;
	ODS output solutionR = soluR_MS03_BB28;
Run;
/* 4.) model with single panel trend variable, random building block intercepts, and random fixed building block level trend */
proc Mixed
	data=WORK.tmp;
	class BldBlk;
	model Mkt_Share_index = C2_110_wgt /solutionF;
	random BldBlk C2_110_wgt*BldBlk /solutionR;
	ODS output solutionF = soluF_MS04_BB28;
	ODS output solutionR = soluR_MS04_BB28;
Run;
/* 5.) model with single panel trend variable, random building block intercepts, and random fixed building block level trends */
/*proc Mixed
	data=WORK.tmp;
	class BldBlk;
	model Mkt_Share_index = C2_110_wgt /solutionF;
	random C2_110_wgt BldBlk C2_110_wgt*BldBlk /solutionR;
	ODS output solutionF = soluF_MS05_BB28;
	ODS output solutionR = soluR_MS05_BB28;
Run;*/
/* 6.) model with single panel trend variable and fixed building block level trends */
proc Mixed
	data=WORK.tmp;
	class BldBlk;
	model Mkt_Share_index = C2_110_wgt C2_110_wgt*BldBlk /solutionF;
	ODS output solutionF = soluF_MS06_BB28;
Run;
/* 7.) model with single panel trend variable and random building block level trends */
proc Mixed
	data=WORK.tmp;
	class BldBlk;
	model Mkt_Share_index = C2_110_wgt /solutionF;
	random C2_110_wgt*BldBlk /solutionR;
	ODS output solutionF = soluF_MS07_BB28;
	ODS output solutionR = soluR_MS07_BB28;
Run;
/* 8.) model with single random panel trend variable and random building block level trends */
/*proc Mixed
	data=WORK.tmp;
	class BldBlk;
	model Mkt_Share_index = C2_110_wgt /solutionF;
	random C2_110_wgt C2_110_wgt*BldBlk /solutionR;
	ODS output solutionF = soluF_MS08_BB28;
	ODS output solutionR = soluR_MS08_BB28;
Run;*/

%MEND mco__panel_BB28;





/* Cross-Section plot: Price vs. Sales/Trips/M.S @BldgBlk level (all BldgBlk) */
%mco__xSec_BBall;
/* Cross-Section plot: Price vs. Sales/Trips/M.S @BldgBlk level (Standalone BldgBlk - 28) */
%mco__xSec_BB28;

/* Panel plot: Price vs. Sales/Trips/M.S @BldgBlk level (all observations) */
%mco__panel_BBall;
/* Panel plot: Price vs. Sales/Trips/M.S @BldgBlk level (Standalone BldgBlk - 28) */
%mco__panel_BB28;