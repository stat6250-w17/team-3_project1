*******************************************************************************;
**************** 80-character banner for column width reference ***************;
* (set window width to banner width to calibrate line length to 80 characters *;
*******************************************************************************;
** 
 Dataset Name: Academic Performance Index(API)_analytic_file created in external
 file STAT6250-01_w17-team-3_project1_data_preparation.sas.  Place this file
 in same directory as this file.
;

%let dataPrepFileName = STAT6250-01_w17-team-3_project1_data_preparation.sas;
%let sasUEFilePrefix = team-3_project1;



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



*******************************************************************************
******************************************************************************;

title1 underlin=2 bcolor=lightgreen "Research Question: What are the enrollment numb"
    "ers by county of students participating in the 2012 Academic Performance "
    "Index survey?";
title2;
title3 underlin=2 bcolor=lightgreen "Rationale: Summary statistics for counties are "
    "directly correlated to funding dollars.  This is a useful statistic to tr"
    "ack.";
title4 underlin=1 bcolor=lightgreen "First 30 Observations";
footnote1 underlin=2 bcolor=lightgreen "The SAS step output addresses the question/o"
    "bjective by dropping type, and statistic information, and outputting just"
    " raw counts.";
footnote2 underlin=2 bcolor=lightgreen "Additionally, we state the variable of inter"
    "est is specifically 'num12', the number of students enrolled in 2012, and"
    " classified our output by county name.";
footnote3 underlin=2 bcolor=lightgreen " classified our output by county name.";
proc means data=work.api_analytic_file maxdec=0 noprint mean;
    var num12;
    class cname;
    output out=rrt (drop=_type_ _freq_ _stat_);
run;
proc print data=rrt (firstobs=6 obs=36) noobs label;
    label num12='# Students Participated: 2012'
          cname='County Name';
run;
title; 
footnote;

*
Methodology: We use proc means to gather and compile stats on enrolment numbers
for 2012.  We classify by county.  Then we output rrt data set, and use label
keyword/statement to make human friendly cryptic variables names cname & num12.
We specify the options noobs to rid outselves of the observation count field
from being printed.
;


*******************************************************************************
******************************************************************************;

title1 underlin=2 bcolor=lightgreen "Research Question: What are the middle values w"
    "ith respect to enrolment across the years 2011-13, classified by school d"
    "istrict?";
title2;
title3 underlin=2 bcolor=lightgreen "Rationale: Looking at middle values as opposed "
    "to averages is important when one doesn't want to let outliers influence";
title4 underlin=2 bcolor=lightgreen " the high probability of finding a central tend"
    "ency, like an average.";
title5 underlin=1 bcolor=lightgreen "First 30 Observations";
footnote1 underlin=2 bcolor=lightgreen "The output addresses the question/objective "
    "by classifying on district name, and summarizing on counts of student enr"
    "ollments across the years 2011-13.";
proc means data=work.api_analytic_file noprint median maxdec=0;
    class dname;
    var num11 num12 num13;
    output out=rrt (drop=_type_ _freq_ _stat_);
run;

proc print data=rrt (firstobs=6 obs=36) noobs label;
    label dname='District Name' num11='Median 2011' num12='Median 2012' 
          num13='Median 2013';
run;
title;
footnote;

*
Methodology: Use the proc means with the median option.  We want the median
for all students recorded in years 2011, 2012, and 2013 by district.  Therefore
we classify by dist name, then specify the variables of interest, total number-
s enrolled for the three years, num11, num12, and num13.  We output data type
rrt without type, freq, and stat info.  Then we print this data object, conver-
ting cryptic variable name with label keyword/statement in the proc print
procedure.
;



*******************************************************************************
******************************************************************************;

title1 underlin=1 bcolor=lightgreen "Research Question: What are the 2012 quartiles "
    "of socioeconomically disadvantaged students included in the 2012 Growth A"
    "PI, by District?";
title2;
title3 underlin=1 bcolor=lightgreen "Rationale: When talking about groups it is impo"
    "rtant to know what quartile breakdown is all about.  Most specifically: b"
    "enchmarking.";
title4 underlin=1 bcolor=lightgreen "Setting up benchmarks in the plannaing and subs"
    "equent resolving of poverty issues";
title5 underlin=1 bcolor=lightgreen "is often super important in order to gauge succ"
    "ess or failure of social scholastic programs.";
title6 underlin=1 bcolor=lightgreen "First 30 Observations";
footnote1 underlin=1 bcolor=lightgreen "First we classify by district name, then lim"
    "it by sd_num12 (Socially Disadvantaged 2012) - using the means procedure,"
    " output percentiles.";
proc means data=work.api_analytic_file noprint; 
    class dname;
    var sd_num12;
    output out=pctls (drop=_type_ _freq_) P25= P50= P75= / autoname;
run;
 
proc print data=pctls (firstobs=6 obs=36) noobs label;
run;
title;
footnote;

*
Methodology: Using the proc means to run analysis on the disadvantaged students
classified by district.  We then specify the variable of interest, sd_num12.
sd_num12 is the number of disadvantaged students in 2012.  We then output
a data object called pctls, dropping the type and frequency counts in lieu of
specified quartiles.
;