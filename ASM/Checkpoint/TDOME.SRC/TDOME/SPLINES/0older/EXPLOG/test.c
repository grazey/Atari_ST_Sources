
// EXP&LOG tables init
// (w)201x lsl&defjam/checkpoint 

#include <conio.h>

#include <stdio.h>
#include <math.h>


//#define _32BIT_LOG
//#define _32BIT_EXP


#define u8 unsigned char
#define u16 unsigned short int
#define u32 unsigned int


#define LOGS 4096
//1024

#define EXPS 4096


double EXP_DESCALE = 256.f; //256.f;


double log_result_descale = 1.f;

double log_result_scale = 1.f;


double exp_result_descale = 256.f; //256.f;	//512.f;

double exp_result_scale = 1.f; //4.f;


u32 log_int[LOGS];
u32 exp_int[EXPS];



void log_test()
{
	double a,b,c;
	double la,lb;
	double log_start = 1;
	int i;

	log_int[0] = log_start;		// ln(0) not defined, needs table-adjustment on the 68k side

	for(i=1;i<LOGS;i++)
	{
		a = (double)(i+log_start);
		//a = a*EXP_DESCALE;


		la = log(a);

		la = la*EXP_DESCALE;

		la = la/log_result_descale;

		la = la*log_result_scale;


		//printf("\n%i  %f",i,la);
		//getch();


#ifdef _32BIT_LOG		
la = la*65536.f;
#endif

		log_int[i] = la;
	}

	printf("\n%i  %f",i-1,la);

	printf("\n\nLOGS END\n\n");
	getch();

}


void exp_test()
{
	double a,b,c;
	double la,lb;
	int i;

	for(i=0;i<EXPS;i++)
	{
		a = (double)(i);

		a = a/(EXP_DESCALE);


		la = exp(a);

		//printf("\n%i  %f",i,la);
		//getch();

		la = la/exp_result_descale;

		la = la*exp_result_scale;


#ifdef _32BIT_EXP
la = la*65536.f;
#endif
		
		exp_int[i] = la;
	}

	printf("\n%i  %f",i-1,la);

	printf("\n\nEXPS END\n\n");
	getch();

}


void int_test()
{
	int a,b,la,lb, c;
	a = 256;
	b = 123;

	la = log_int[a];
	lb = log_int[b];

	c = exp_int[la+lb];

	printf("\n\nint_test:\n");
	printf("%i",c);
	
	getch();
}




u16 swap_end16(u16 v)
{
	return ( (v>>8) | (v<<8) );
}

void save_table(char *fname, u32 *table, int len)
{
	u16 buffer[65536];
	int i;
	u16 v;

	FILE *f=fopen(fname,"wb");
	
	for(i=0;i<len;i++)
	{
		v = *table++;
		v = swap_end16(v);
		buffer[i] = v;
	}

	fwrite(buffer,len,2,f);
	fclose(f);

}

void save_table32(char *fname, u32 *table, int len)
{
	u8 buffer[65536];
	u8 *psrc,*pdest;
	int i;
	u16 v;

	FILE *f=fopen(fname,"wb");

	psrc  = (u8*)(table);
	pdest = buffer;

	for(i=0;i<len;i++)
	{
		*pdest++=psrc[3];
		*pdest++=psrc[2];
		*pdest++=psrc[1];
		*pdest++=psrc[0];
		psrc+=4;
	}

	fwrite(buffer,len,4,f);
	fclose(f);
}



int main()
{
	double a,b,c;
	double la,lb;
	a = 4;
	b = 9;

	log_test();
	exp_test();

#ifdef _32BIT_LOG
	save_table32("LOG32.TAB", log_int, LOGS);
#else
	save_table("LOG.TAB", log_int, LOGS);
#endif

#ifdef _32BIT_EXP
	save_table32("EXP32.TAB", exp_int, EXPS);
#else
	save_table("EXP.TAB", exp_int, EXPS);
#endif

//	int_test();
	
/*
	//c = exp( log(a);

	la = log(a);
	lb = log(b);

	c = exp(la+lb);

	//printf("\n%f",c);

	//printf("\n%f   %f",la, c);

	getch();
*/
}
