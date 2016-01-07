options nocenter ls=85 ps=55;

data column;

INFILE 'C:\Users\lennonj\Desktop\20140613_Biofilms_Columns_RMANOVA.csv' lrecl = 500 dlm=',' firstobs=2 missover;
INPUT Column$ Strain$ day0 day2 day3 day6 day8 day13 day14 day15 day16 day17 day20 day21 day22 day23 day24 day27 day28 day29 day30 day31 
day34 day35 day36 day37 day38 day41 day42 day43 day44 day45 day46 day47 day48 day49 day50 day53 day54 day55 day56 day57 
day61 day62 day63 day64 day67 day68 day69 day70 day71 day74 day75 day76 day77 day78 day81 day82 day83 day84 day85 day88;

Proc print data = column;
run;

data column1; 
set column;
time=0; WP=day0; output;
time=2; WP=day2; output;
time=3; WP=day3; output;
time=6; WP=day6; output;
time=8; WP=day8; output;
time=13; WP=day13; output;
time=14; WP=day14; output;
time=15; WP=day15; output;
time=16; WP=day16; output;
time=17; WP=day17; output;
time=20; WP=day20; output;
time=21; WP=day21; output;
time=22; WP=day22; output;
time=23; WP=day23; output;
time=24; WP=day24; output;
time=27; WP=day27; output;
time=28; WP=day28; output;
time=29; WP=day29; output;
time=30; WP=day30; output;
time=31; WP=day31; output;
time=34; WP=day34; output;
time=35; WP=day35; output;
time=36; WP=day36; output;
time=37; WP=day37; output;
time=38; WP=day38; output;
time=41; WP=day41; output;
time=42; WP=day42; output;
time=43; WP=day43; output;
time=44; WP=day44; output;
time=45; WP=day45; output;
time=46; WP=day46; output;
time=47; WP=day47; output;
time=48; WP=day48; output;
time=49; WP=day49; output;
time=50; WP=day50; output;
time=53; WP=day53; output;
time=54; WP=day54; output;
time=55; WP=day55; output;
time=56; WP=day56; output;
time=57; WP=day57; output;
time=61; WP=day61; output;
time=62; WP=day62; output;
time=63; WP=day63; output;
time=64; WP=day64; output;
time=67; WP=day67; output;
time=68; WP=day68; output;
time=69; WP=day69; output;
time=70; WP=day70; output;
time=71; WP=day71; output;
time=74; WP=day74; output;
time=75; WP=day75; output;
time=76; WP=day76; output;
time=77; WP=day77; output;
time=78; WP=day78; output;
time=81; WP=day81; output;
time=82; WP=day82; output;
time=83; WP=day83; output;
time=84; WP=day84; output;
time=85; WP=day85; output;
time=88; WP=day88; output;


	keep Column WP Strain time;
	run;
	
PROC SORT data=column1;
	by Strain time Column;
	run; 

PROC PRINT data= column1;
    title2 'output cells in univariate form'
    run;

PROC MIXED data= column1 IC;
    Title2 'Compound Symmetry';
    class Column Strain time;
    model WP = time Strain time*Strain / outp=CSpred;
    repeated / type =cs sub=Column(strain) rcorr;
    ODS output infocrit=CS;
    ODS listing close;
    run;

PROC MIXED data= column1 IC;
    TITLE2 'HF';
    class Column Strain time;
    model WP = time Strain time*Strain / outp=HFpred;
    repeated / type =hf sub=Column(strain) rcorr;
    ODS output infocrit=HF;
    ODS listing close;
    run;
	
PROC MIXED data= column1 IC;
    TITLE2 'Unstructured';
    class Column Strain time;
    model WP = time Strain time*Strain / outp=UNpred;
    repeated / type =un sub=Column(strain) rcorr;
    ODS output infocrit=UN;
    ODS listing close;
    run;
PROC MIXED data= column1 IC;
    TITLE2 'AR(1)';
    class Column Strain time;
    model WP = time Strain time*Strain / outp=ARpred;
    repeated / type =ar(1) sub=Column(Strain) rcorr;
    ODS output infocrit=AR1;
    ODS listing close;
    run;
DATA a;
     SET CS;
     identifier='CS';
 DATA b;
     SET HF;
     identifier='HF';
DATA c;
     SET UN;
     identifier='UN';
DATA d;
     SET AR1;
     identifier='AR1';
DATA compare;
     SET a b c d;
PROC SORT data=compare;
     BY BIC;
ODS listing;
PROC PRINT;
     TITLE2 'Information criteria';
     VAR identifier parms bic aic aicc neg2loglike;
RUN;




	/*PROC PRINT data=column1;*/

/*PROC MIXED data= column1;
	class Column Strain time; /* "class" delares qualitative variable*/
	/*model WP = time Strain time*Strain;*/
	/*random Column(Strain);*/
	/*LSMEANS Strain time*Strain;*/
	/*run;*/
PROC MIXED data= column1 method=ml;
	class Column Strain time;
	model WP = time Strain time*Strain;/*s*/
	repeated / type =ar(1) sub=Column(Strain); /*rcorr*/

/*Multiple comparisons in balanced design*/
	/*lsmeans Strain /cl adjust=tukey;
	lsmeans Strain /pdiff=control ("het") cl adjust=dunnett;*/
/*Multiple comparisons for all pairwise comparisons*/
	lsmeans Strain /pdiff cl adjust=simulate(seed=18713 nsamp=200000);
/*Multiple comparisons with a defined control level
	lsmeans Strain /pdiff=control("het") cl
                                  adjust=dunnett;
      lsmeans Strain /pdiff=control("het") cl
                          adjust=simulate(seed=121211 nsamp=200000);*/
	run;


/* Different Covariance Structures

PROC MIXED data= column1;
	class Column Strain time;
	model WP = time Strain time*Strain;
	repeated / type =hf sub=Column(Strain) rcorr;
	run;
PROC MIXED data= column1;
	class Column Strain time;
	model WP = time Strain time*Strain;
	repeated / type =un sub=Column(Strain)  rcorr;
	run;
PROC MIXED data= column1;
	class Column Strain time;
	model WP = time Strain time*Strain;
	repeated / type =ar(1) sub=Column(Strain) rcorr;
	run;
