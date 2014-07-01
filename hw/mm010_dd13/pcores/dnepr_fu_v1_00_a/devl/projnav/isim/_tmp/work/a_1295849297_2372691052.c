/**********************************************************************/
/*   ____  ____                                                       */
/*  /   /\/   /                                                       */
/* /___/  \  /                                                        */
/* \   \   \/                                                         */
/*  \   \        Copyright (c) 2003-2007 Xilinx, Inc.                 */
/*  /   /        All Right Reserved.                                  */
/* /---/   /\                                                         */
/* \   \  /  \                                                        */
/*  \___\/\___\                                                       */
/**********************************************************************/

/* This file is designed for use with ISim build 0x9330dbfa */

#include "xsi.h"
#include <memory.h>
#ifdef __GNUC__
#include <stdlib.h>
#else
#include <malloc.h>
#define alloca _alloca
#endif
static const char *ng0 = "/home/atana/RTI/dnepr/hw/mm010_dd13/pcores/dnepr_fu_v1_00_a/devl/projnav/tb_fsm.vhd";
extern char *IEEE_P_3499444699;
extern char *IEEE_P_3620187407;

char *ieee_p_3499444699_sub_2213602152_3499444699(char *, char *, int , int );
char *ieee_p_3620187407_sub_4188545914_3620187407(char *, char *, char *, char *, unsigned char );


static void work_a_1295849297_2372691052_p_0(char *t0)
{
    char *t1;
    char *t2;
    char *t3;
    char *t4;
    char *t5;
    char *t6;
    int64 t7;
    int64 t8;

LAB0:    t1 = (t0 + 2416U);
    t2 = *((char **)t1);
    if (t2 == 0)
        goto LAB2;

LAB3:    goto *t2;

LAB2:    xsi_set_current_line(80, ng0);
    t2 = (t0 + 3096);
    t3 = (t2 + 32U);
    t4 = *((char **)t3);
    t5 = (t4 + 32U);
    t6 = *((char **)t5);
    *((unsigned char *)t6) = (unsigned char)2;
    xsi_driver_first_trans_fast(t2);
    xsi_set_current_line(81, ng0);
    t2 = (t0 + 1856U);
    t3 = *((char **)t2);
    t7 = *((int64 *)t3);
    t8 = (t7 / 2);
    t2 = (t0 + 2332);
    xsi_process_wait(t2, t8);

LAB6:    *((char **)t1) = &&LAB7;

LAB1:    return;
LAB4:    xsi_set_current_line(82, ng0);
    t2 = (t0 + 3096);
    t3 = (t2 + 32U);
    t4 = *((char **)t3);
    t5 = (t4 + 32U);
    t6 = *((char **)t5);
    *((unsigned char *)t6) = (unsigned char)3;
    xsi_driver_first_trans_fast(t2);
    xsi_set_current_line(83, ng0);
    t2 = (t0 + 1856U);
    t3 = *((char **)t2);
    t7 = *((int64 *)t3);
    t8 = (t7 / 2);
    t2 = (t0 + 2332);
    xsi_process_wait(t2, t8);

LAB10:    *((char **)t1) = &&LAB11;
    goto LAB1;

LAB5:    goto LAB4;

LAB7:    goto LAB5;

LAB8:    goto LAB2;

LAB9:    goto LAB8;

LAB11:    goto LAB9;

}

static void work_a_1295849297_2372691052_p_1(char *t0)
{
    char t3[16];
    char *t1;
    char *t2;
    char *t4;
    char *t5;
    char *t6;
    char *t7;
    char *t8;
    int t9;
    int t10;
    int64 t11;
    char *t12;
    char *t13;
    int t14;

LAB0:    t1 = (t0 + 2536U);
    t2 = *((char **)t1);
    if (t2 == 0)
        goto LAB2;

LAB3:    goto *t2;

LAB2:    xsi_set_current_line(88, ng0);
    t2 = ieee_p_3499444699_sub_2213602152_3499444699(IEEE_P_3499444699, t3, 65520, 16);
    t4 = (t0 + 3132);
    t5 = (t4 + 32U);
    t6 = *((char **)t5);
    t7 = (t6 + 32U);
    t8 = *((char **)t7);
    memcpy(t8, t2, 16U);
    xsi_driver_first_trans_fast(t4);
    xsi_set_current_line(89, ng0);
    t2 = (t0 + 5072);
    *((int *)t2) = 1;
    t4 = (t0 + 5076);
    *((int *)t4) = 100;
    t9 = 1;
    t10 = 100;

LAB4:    if (t9 <= t10)
        goto LAB5;

LAB7:    goto LAB2;

LAB5:    xsi_set_current_line(90, ng0);
    t5 = (t0 + 1920U);
    t6 = *((char **)t5);
    t11 = *((int64 *)t6);
    t5 = (t0 + 2452);
    xsi_process_wait(t5, t11);

LAB10:    *((char **)t1) = &&LAB11;

LAB1:    return;
LAB6:    t2 = (t0 + 5072);
    t9 = *((int *)t2);
    t4 = (t0 + 5076);
    t10 = *((int *)t4);
    t14 = (t9 + 1);
    t9 = t14;
    t5 = (t0 + 5072);
    *((int *)t5) = t9;
    goto LAB4;

LAB8:    xsi_set_current_line(91, ng0);
    t2 = (t0 + 812U);
    t4 = *((char **)t2);
    t2 = (t0 + 4800U);
    t5 = ieee_p_3620187407_sub_4188545914_3620187407(IEEE_P_3620187407, t3, t4, t2, (unsigned char)3);
    t6 = (t0 + 3132);
    t7 = (t6 + 32U);
    t8 = *((char **)t7);
    t12 = (t8 + 32U);
    t13 = *((char **)t12);
    memcpy(t13, t5, 16U);
    xsi_driver_first_trans_fast(t6);
    goto LAB6;

LAB9:    goto LAB8;

LAB11:    goto LAB9;

}

static void work_a_1295849297_2372691052_p_2(char *t0)
{
    char t3[16];
    char *t1;
    char *t2;
    char *t4;
    char *t5;
    char *t6;
    char *t7;
    char *t8;
    int64 t9;

LAB0:    t1 = (t0 + 2656U);
    t2 = *((char **)t1);
    if (t2 == 0)
        goto LAB2;

LAB3:    goto *t2;

LAB2:    xsi_set_current_line(97, ng0);
    t2 = ieee_p_3499444699_sub_2213602152_3499444699(IEEE_P_3499444699, t3, 65535, 16);
    t4 = (t0 + 3168);
    t5 = (t4 + 32U);
    t6 = *((char **)t5);
    t7 = (t6 + 32U);
    t8 = *((char **)t7);
    memcpy(t8, t2, 16U);
    xsi_driver_first_trans_fast(t4);
    xsi_set_current_line(98, ng0);
    t9 = (1600 * 1000000LL);
    t2 = (t0 + 2572);
    xsi_process_wait(t2, t9);

LAB6:    *((char **)t1) = &&LAB7;

LAB1:    return;
LAB4:    xsi_set_current_line(99, ng0);
    t2 = ieee_p_3499444699_sub_2213602152_3499444699(IEEE_P_3499444699, t3, 0, 16);
    t4 = (t0 + 3168);
    t5 = (t4 + 32U);
    t6 = *((char **)t5);
    t7 = (t6 + 32U);
    t8 = *((char **)t7);
    memcpy(t8, t2, 16U);
    xsi_driver_first_trans_fast(t4);
    xsi_set_current_line(100, ng0);

LAB10:    *((char **)t1) = &&LAB11;
    goto LAB1;

LAB5:    goto LAB4;

LAB7:    goto LAB5;

LAB8:    goto LAB2;

LAB9:    goto LAB8;

LAB11:    goto LAB9;

}

static void work_a_1295849297_2372691052_p_3(char *t0)
{
    char t3[16];
    char *t1;
    char *t2;
    char *t4;
    char *t5;
    char *t6;
    char *t7;
    char *t8;

LAB0:    t1 = (t0 + 2776U);
    t2 = *((char **)t1);
    if (t2 == 0)
        goto LAB2;

LAB3:    goto *t2;

LAB2:    xsi_set_current_line(105, ng0);
    t2 = ieee_p_3499444699_sub_2213602152_3499444699(IEEE_P_3499444699, t3, 65535, 16);
    t4 = (t0 + 3204);
    t5 = (t4 + 32U);
    t6 = *((char **)t5);
    t7 = (t6 + 32U);
    t8 = *((char **)t7);
    memcpy(t8, t2, 16U);
    xsi_driver_first_trans_fast(t4);
    xsi_set_current_line(106, ng0);
    t2 = ieee_p_3499444699_sub_2213602152_3499444699(IEEE_P_3499444699, t3, 65534, 16);
    t4 = (t0 + 3240);
    t5 = (t4 + 32U);
    t6 = *((char **)t5);
    t7 = (t6 + 32U);
    t8 = *((char **)t7);
    memcpy(t8, t2, 16U);
    xsi_driver_first_trans_fast(t4);
    xsi_set_current_line(107, ng0);
    t2 = ieee_p_3499444699_sub_2213602152_3499444699(IEEE_P_3499444699, t3, 0, 16);
    t4 = (t0 + 3276);
    t5 = (t4 + 32U);
    t6 = *((char **)t5);
    t7 = (t6 + 32U);
    t8 = *((char **)t7);
    memcpy(t8, t2, 16U);
    xsi_driver_first_trans_fast(t4);
    xsi_set_current_line(108, ng0);
    t2 = ieee_p_3499444699_sub_2213602152_3499444699(IEEE_P_3499444699, t3, 2, 16);
    t4 = (t0 + 3312);
    t5 = (t4 + 32U);
    t6 = *((char **)t5);
    t7 = (t6 + 32U);
    t8 = *((char **)t7);
    memcpy(t8, t2, 16U);
    xsi_driver_first_trans_fast(t4);
    xsi_set_current_line(109, ng0);

LAB6:    *((char **)t1) = &&LAB7;

LAB1:    return;
LAB4:    goto LAB2;

LAB5:    goto LAB4;

LAB7:    goto LAB5;

}

static void work_a_1295849297_2372691052_p_4(char *t0)
{
    char *t1;
    char *t2;
    char *t3;
    char *t4;
    char *t5;
    char *t6;
    int64 t7;

LAB0:    t1 = (t0 + 2896U);
    t2 = *((char **)t1);
    if (t2 == 0)
        goto LAB2;

LAB3:    goto *t2;

LAB2:    xsi_set_current_line(116, ng0);
    t2 = (t0 + 3348);
    t3 = (t2 + 32U);
    t4 = *((char **)t3);
    t5 = (t4 + 32U);
    t6 = *((char **)t5);
    *((unsigned char *)t6) = (unsigned char)3;
    xsi_driver_first_trans_fast(t2);
    xsi_set_current_line(117, ng0);
    t7 = (100 * 1000000LL);
    t2 = (t0 + 2812);
    xsi_process_wait(t2, t7);

LAB6:    *((char **)t1) = &&LAB7;

LAB1:    return;
LAB4:    xsi_set_current_line(118, ng0);
    t2 = (t0 + 3348);
    t3 = (t2 + 32U);
    t4 = *((char **)t3);
    t5 = (t4 + 32U);
    t6 = *((char **)t5);
    *((unsigned char *)t6) = (unsigned char)2;
    xsi_driver_first_trans_fast(t2);
    xsi_set_current_line(121, ng0);

LAB10:    *((char **)t1) = &&LAB11;
    goto LAB1;

LAB5:    goto LAB4;

LAB7:    goto LAB5;

LAB8:    goto LAB2;

LAB9:    goto LAB8;

LAB11:    goto LAB9;

}


extern void work_a_1295849297_2372691052_init()
{
	static char *pe[] = {(void *)work_a_1295849297_2372691052_p_0,(void *)work_a_1295849297_2372691052_p_1,(void *)work_a_1295849297_2372691052_p_2,(void *)work_a_1295849297_2372691052_p_3,(void *)work_a_1295849297_2372691052_p_4};
	xsi_register_didat("work_a_1295849297_2372691052", "isim/_tmp/work/a_1295849297_2372691052.didat");
	xsi_register_executes(pe);
}
