%let inputDatasetURL =
https://github.com/stat6250/team-3_project1/blob/Jeff_step_2/14avgtx.txt
;

filename APItemp TEMP;
proc http
    method="get" 
    url="&inputDatasetURL." 
    out=APItemp
    ;
run;
proc import
    file=APItemp
    out=API_raw
    dbms=txt
    ;
run;
filename APItemp clear;

/*****************************************************************************/
/*****************************************************************************/
/***** Failed to load from github.  Now loading from local file system. ******/
/*****************************************************************************/
/*****************************************************************************/

libname d_src '/folders/myfolders/proj1/team-3_project1';

/*
Question 1. What is the percent change in the total number of high school stud-
ents included in this Academic Performance Index from year 2011 to 2012, and f-
rom 2012 to 2013?
Fields 3, 11, 13, and 15.
*/
data d_src.api;
	infile '/folders/myfolders/proj1/team-3_project1/14avgtx.txt';
	input s_type $ 16-16 s_name $ 20-59 cheat $ 105-109 num_stu_11 110-116 
	    num_stu_12 122-128 num_stu_13 134-140 poor_13 548-554 eng_stu_13 594-600;
run;

data myapi;
    set d_src.api;
    z = num_stu_12;
run;

proc print data=myapi;
run;

/*
Question 2. What percentage of elementary school english learner students in 2-
013 were socioeconomically disadvantaged students?
Fields 3, 95 and 87.

Question 3. In 2013 what are the top 3 schools that have the highest level of 
security breachs involving social media exposure of test material for the Sta-
ndardized Testing and Reporting (STAR) Program and/or the California High Sch-
ool Exit Examination (CAHSEE)?
Fields 10 & 7.
*/


