*******************************************************************************;
**************** 80-character banner for column width reference ***************;
* (set window width to banner width to calibrate line length to 80 characters *;
*******************************************************************************;
* 
 Dataset Name: Academic Performance Index(API)_analytic_file created in external
 file STAT6250-01_w17-team-3_project1_data_preparation.sas, which is assumed to 
 be in the same directory as this file
 

* Environmental setup;

* set relative file import path to current directory (using standard SAS trick);

* Environmental Variables ;
%let dataPrepFileName = STAT6250-01_w17-team-3_project1_data_preparation.sas;
%let sasUEFilePrefix = team-3_project1;

* load external file that generates analytic dataset "api_analytic_file" using
 a system path dependent on the host operating system, after setting the 
 relative file import path to the current directory, if using Windows;
  
%macro setup;
%if
	&SYSSCP. = WIN
%then
	%do;
		X "cd ""%substr(%sysget(SAS_EXECFILEPATH),1,%eval(%length(%sysget(SAS_EXECFILEPATH))-%length(%sysget(SAS_EXECFILENAME))))""";			
		%include ".\&dataPrepFileName.";
	%end;
%else
	%do;
		%include "~/&sasUEFilePrefix./&dataPrepFileName.";
	%end;
%mend;
%setup;

*Methodology - The sas code constructs Mean using Proc Mean for three years of 
AA_API data.I used noprint mean to avoid mean data to get printed in the screen.
I also filtered the output from this command to remove the _DROP_FREQ_
In the proc print the obs fields were removed using NOOBS option and  label
was used to customize the output;


title1 underlin =1 bcolor=aquamarine "Research Question - How does the 
         increase or decrease of African-American students affect the API score of the school ?";

title2 underlin =1 bcolor=aquamarine "Rationale- This analysis can be applied to any race by 
replace the variable by that race. This would help us to identify if increase or 
decrease of particular race will affect the API score .";

title3 underlin =2 bcolor=aquamarine "Effect of African-American students  in API score" ; 
 
footnote1 bcolor=aquamarine "This sas program uses a proc mean and proc print to produce
 the average api of the AmericanAfrican students grouped by county name";

proc means data=api_analytic_file noprint mean; 
    class CNAME;
    var  AA_API13 AA_API12 AA_API11;
    output 
    out =  AA_MEAN_OUTPUT (DROP = _TYPE_ _FREQ_ ); 
run;

proc print data=AA_MEAN_OUTPUT (obs = 10) NOOBS label ;
    WHERE _stat_ = 'MEAN' and AA_API13 is not null and CNAME is not null;   
    id CNAME;
    label CNAME = 'County Name'
    AA_API13 = 'Average API of African American 2013'
    AA_API12 = 'Average API of African American 2012'
    AA_API11 = 'Average API of African American 2011'
    _STAT_ = 'Average APIs';
    BY _STAT_;  
run; 
title;                                       
footnote;

*Methodology - The sas code constructs Mean using Proc Mean for three years of 
SD_API data.I used noprint mean to avoid mean data to get printed in the screen.
I also filtered the output from this command to remove the _DROP_FREQ_
In the proc print the obs fields were removed using NOOBS option and  label
was used to customize the output;


title1 underlin =1 bcolor=aquamarine "Research Question - How does the increase
  or decrease of Socioeconomically disadvantaged students affect the API score 
  of the school ?";

title2 underlin =1 bcolor=aquamarine "Rationale- This would help to see if the
 rating system should be modified based on the type of population of the school
 instead of using generic methodology for all schools.";

title3 underlin =2 bcolor=aquamarine "Effect of Socioeconomically disadvantaged
 students in API score" ; 
 
footnote1 bcolor=aquamarine "This sas program uses a proc mean to produce the average
 api of the Socioeconomically disadvantaged students grouped by county name";

proc means data=api_analytic_file noprint mean; 
    class CNAME;
    var  SD_NUM11 SD_NUM12 SD_NUM13;
    output 
    out =  SD_MEAN_OUTPUT (DROP = _TYPE_ _FREQ_ ); 
run;

proc print data=SD_MEAN_OUTPUT (obs = 10) NOOBS label ;
    WHERE _stat_ = 'MEAN' and (SD_NUM11 is not null or SD_NUM12 is
    not null or SD_NUM13 is not null) and CNAME is not null;   
    id CNAME;
    label CNAME = 'County Name'
    SD_NUM11 = 'Average API of SocioEconomics in 2013'
    SD_NUM12 = 'Average API of SocioEconomics in 2013'
    SD_NUM13 = 'Average API of SocioEconomics in 2013'
    _STAT_ = 'Average APIs';
    BY _STAT_;  
run; 
title;                                        
footnote;

*Methodology : This sas code uses proc means using API of 2013.Then the output
data is sorted using proc sort based on mean. Then the top 10 schools are printed 
to the output;

title1 underlin =1  bcolor= aquamarine "Research Question - What factors have 
 contributed to increase of API of the school ?";

title2 underlin =1 bcolor= aquamarine "Rationale - This would help new schools
 to know what has worked so they can accomplish the same result using similar 
 modelling of school.";


title3 underlin =2 bcolor= aquamarine "Highest ranked API schools" ; 

footnote1 bcolor=aquamarine "This sas program uses a proc mean and sort to
 produce the average api of the Top 10 schools ";

proc means data= api_analytic_file noprint mean;        
    var  API13;
    class DNAME;                                        
    output 
    out = api_output (DROP = _TYPE_ _FREQ_ )
    mean = api_mean;
run;

proc sort data= api_output out= api_sort;
    by descending api_mean;                       
run;
                                   
proc print data=  api_sort (obs=10);
run;

title;
footnote;

